package handlers

import (
	"fmt"
	"github.com/andrewkandzuba/openexchange-webservice-go/pkg/state"
	"io"
	"log"
	"net/http"
	"os"
)

var alive = state.New()

func HitHandler(w http.ResponseWriter, r *http.Request) {
	log.Printf("Recieved request from %s", r.RemoteAddr)

	if hostname, err := os.Hostname(); err != nil {
		w.WriteHeader(500)
		_, _ = fmt.Fprintf(w, "Server error %s", err)
	} else {
		w.WriteHeader(200)
		_, _ = fmt.Fprintf(w, "You've hit %s", hostname)
	}
}

func HealthHandler(w http.ResponseWriter, r *http.Request) {
	log.Printf("You've hit liveness probe")

	w.Header().Set("Content-Type", "application/json")

	if !alive.Get() {
		w.WriteHeader(http.StatusInternalServerError)
		_, _ = io.WriteString(w, `{"alive": false}`)
	} else {
		w.WriteHeader(http.StatusOK)
		_, _ = io.WriteString(w, `{"alive": true}`)
	}
}

func StopHandler(w http.ResponseWriter, r *http.Request) {
	log.Printf("You've hit stop handler")

	alive.Set(false)

	w.WriteHeader(http.StatusOK)
}
