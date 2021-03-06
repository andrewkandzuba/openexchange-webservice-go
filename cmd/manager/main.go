package main

import (
	"github.com/andrewkandzuba/openexchange-webservice-go/pkg/handlers"
	"log"
	"net/http"
)

var port = "8080"

func main() {
	log.Print("Http server starting ...")
	http.HandleFunc("/", handlers.HitHandler)
	http.HandleFunc("/health", handlers.HealthHandler)
	http.HandleFunc("/stop", handlers.StopHandler)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}