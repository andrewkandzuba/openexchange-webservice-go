package handlers

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
)

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
	w.WriteHeader(http.StatusOK)
	w.Header().Set("Content-Type", "application/json")
	_, _ = io.WriteString(w, `{"alive": true}`)
}
