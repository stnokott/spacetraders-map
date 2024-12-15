package main

import (
	"log"
	"net/http"
	"os"
	"spacetraders-map/templates"

	"github.com/a-h/templ"
)

func main() {
	log.Println("starting server...")

	server := newServer()

	// Determine port for HTTP service.
	port := os.Getenv("PORT")
	if port == "" {
		log.Fatalln("require environment variable PORT for HTTP server")
	}

	// TODO: catch SIGINT
	// Start HTTP server.
	log.Printf("listening on port %s", port)
	if err := http.ListenAndServe(":"+port, server); err != nil {
		log.Fatalln(err)
	}
}

func newServer() http.Handler {
	mux := http.NewServeMux()

	mux.Handle("/", templ.Handler(templates.Home(templates.HomeData{
		Title:   "Spacetraders Map",
		Version: Version,
		Commit:  Commit,
	})))

	return mux
}
