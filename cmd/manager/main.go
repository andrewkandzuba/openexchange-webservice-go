package main

import (
	"context"
	"github.com/andrewkandzuba/openexchange-webservice-go/pkg/handlers"
	"github.com/gorilla/mux"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"
)

var port = "8080"

func main() {
	log.Print("Server starting ...")

	var router = mux.NewRouter()

	router.HandleFunc("/", handlers.HitHandler)
	router.HandleFunc("/live", handlers.LivenessProbeHandler)
	router.HandleFunc("/stop", handlers.StopHandler)
	router.HandleFunc("/ready", handlers.ReadinessProbeHandler)

	srv := &http.Server{
		Addr:    ":" + port,
		Handler: router,
	}

	done := make(chan os.Signal, 1)
	signal.Notify(done, os.Interrupt, syscall.SIGINT, syscall.SIGTERM)

	go func() {
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			log.Fatalf("listen: %s\n", err)
		}
	}()
	handlers.Ready.Set(true)
	log.Print("Server Started")

	<-done
	log.Print("Server Stopped")

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer func() {
		handlers.Ready.Set(false)
		// Check is all current progresses are completed here
		handlers.Alive.Set(false)
		cancel()
	}()

	if err := srv.Shutdown(ctx); err != nil {
		log.Fatalf("Server Shutdown Failed:%+v", err)
	}
	log.Print("Server Exited Properly")
}