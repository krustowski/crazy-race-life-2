package main

// mapui — a bare backend plotting gamemode points of interest on the San
// Andreas map (pois.go), with the numbers a map wants beside it (stats.go)
// and, given samp's live map, where everyone is right now (live.go).
//
// It carries no authentication: utils/gateway is the auth wall and the only
// intended ingress, so this must stay bound to loopback.
//
//	MAPUI_DB      path to crl2_data.db  (default ./crl2_data.db)
//	MAPUI_ADDR    listen address        (default 127.0.0.1:8082)
//	MAPUI_STATIC  directory of static assets, including the map image
//	              (default ./static)
//	MAPUI_LIVE    r2 samp's live map, for the live layer (live.go; default none)
//	MAPUI_LIVE_KEY  its map_key; also MAPUI_LIVE_KEY_FILE, naming a file

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"
	"os"
	"strings"
	"time"

	_ "modernc.org/sqlite"
)

var db *sql.DB

func main() {
	log.SetFlags(log.Ltime)

	dbPath := env("MAPUI_DB", "crl2_data.db")
	listen := env("MAPUI_ADDR", "127.0.0.1:8082")
	staticDir := env("MAPUI_STATIC", "./static")

	var err error
	// Read-only: this may be the file a live server is writing to.
	db, err = sql.Open("sqlite", "file:"+dbPath+"?mode=ro&_pragma=busy_timeout(5000)")
	if err != nil {
		log.Fatalf("open %s: %v", dbPath, err)
	}
	defer db.Close()

	if err := db.Ping(); err != nil {
		log.Fatalf("open %s: %v", dbPath, err)
	}

	live, err := newLiveHub(os.Getenv("MAPUI_LIVE"), envSecret("MAPUI_LIVE_KEY"))
	if err != nil {
		log.Fatal(err)
	}

	mux := http.NewServeMux()
	mux.Handle("GET /", http.FileServer(http.Dir(staticDir)))
	mux.HandleFunc("GET /healthz", handleHealth)
	mux.HandleFunc("GET /api/data", gameDataHandler)
	mux.HandleFunc("GET /api/prizes", prizesHandler)
	mux.HandleFunc("GET /api/stats", statsHandler)
	mux.HandleFunc("GET /api/viewer", viewerHandler)
	mux.HandleFunc("GET /api/live", live.handleEvents)
	mux.HandleFunc("GET /api/vehicles", live.handleVehicles)
	mux.HandleFunc("GET /api/models", handleModels)

	log.Printf("database %s (read-only)", dbPath)
	log.Printf("static   %s", staticDir)
	if live != nil {
		// The key's length, never the key: enough to see one that did not
		// arrive, or arrived cut short or with more to it.
		keyed := "no key"
		if live.key != "" {
			keyed = fmt.Sprintf("key of %d characters", len(live.key))
		}
		log.Printf("live     %s (%s)", live.base, keyed)
	} else {
		log.Printf("live     off (no MAPUI_LIVE)")
	}
	log.Printf("listening on http://%s — no auth, expose only via the gateway", listen)

	srv := &http.Server{
		Addr:              listen,
		Handler:           mux,
		ReadHeaderTimeout: 10 * time.Second,
	}
	log.Fatal(srv.ListenAndServe())
}

// handleHealth is the container healthcheck: serving, with a working database.
func handleHealth(w http.ResponseWriter, r *http.Request) {
	if err := db.PingContext(r.Context()); err != nil {
		http.Error(w, "database: "+err.Error(), http.StatusServiceUnavailable)
		return
	}
	w.Write([]byte("ok\n"))
}

func env(key, fallback string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return fallback
}

// envSecret reads a secret from KEY, or from the file named by KEY_FILE. The
// _FILE form is how Docker and Swarm hand secrets to a container.
func envSecret(key string) string {
	if path := os.Getenv(key + "_FILE"); path != "" {
		data, err := os.ReadFile(path)
		if err != nil {
			log.Fatalf("%s_FILE: %v", key, err)
		}
		return strings.TrimSpace(string(data))
	}
	return os.Getenv(key)
}
