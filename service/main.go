package main

import (
	"html/template"
	"log"
	"net/http"
	"os"
)

var tmpl *template.Template

func init() {
	tmpl = template.Must(template.ParseGlob("templates/*.html"))
}

func main() {
	// Configure endpoints
	log.Println("starting server...")
	http.HandleFunc("/", wrapTemplateHandler(handleHome, tmpl))

	// Determine port for HTTP service.
	port := os.Getenv("PORT")
	if port == "" {
		log.Fatalln("require environment variable PORT for HTTP server")
	}

	// TODO: catch SIGINT
	// Start HTTP server.
	log.Printf("listening on port %s", port)
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatalln(err)
	}
}

type templatedHandlerFunc func(http.ResponseWriter, *http.Request, *template.Template)

// wrapTemplateHandler wraps a templatedHandlerFunc to return a regular http.HandlerFunc accepted by regular HTTP routers.
func wrapTemplateHandler(fn templatedHandlerFunc, tmpl *template.Template) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		fn(w, r, tmpl)
	}
}

type homeData struct {
	Title string
	Build homeDataBuild
}

type homeDataBuild struct {
	Version string
	Commit  string
}

// handleHome renders the homepage.
func handleHome(w http.ResponseWriter, _ *http.Request, tmpl *template.Template) {
	data := homeData{
		Title: "Spacetraders Map",
		Build: homeDataBuild{
			Version: Version,
			Commit:  Commit,
		},
	}
	tmpl.ExecuteTemplate(w, "home.html", data)
}
