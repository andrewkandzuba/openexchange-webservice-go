package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

var port = "8080"

func handler(w http.ResponseWriter, r *http.Request) {
	log.Printf("Recieved request from %s", r.RemoteAddr)

	if hostname, err := os.Hostname(); err != nil {
		w.WriteHeader(500)
		_, _ = fmt.Fprintf(w, "Server error %s", err)
	} else {
		w.WriteHeader(200)
		_, _ = fmt.Fprintf(w, "You've hit %s", hostname)
	}
}

func main() {
	log.Print("Kubia server starting ...")
	http.HandleFunc("/", handler)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}