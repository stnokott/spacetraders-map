package main

import (
	"embed"
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

//go:embed static
var static embed.FS

func newServer() http.Handler {
	mux := http.NewServeMux()

	// Serve static files
	mux.Handle("/static/", http.FileServer(http.FS(static)))

	// Server homepage
	mux.Handle("/", templ.Handler(templates.Home(templates.HomeData{
		Title:   "Spacetraders Map",
		Version: Version,
		Commit:  Commit,
	})))

	return mux
}
