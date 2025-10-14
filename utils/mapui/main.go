package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"

	_ "modernc.org/sqlite"
)

type Property struct {
	ID       int     `json:"id"`
	Type     int     `json:"type"`
	Name     string  `json:"name"`
	Occupied bool    `json:"occupied"`
	Owner    string  `json:"owner"`
	X        float64 `json:"x"`
	Y        float64 `json:"y"`
}

func main() {
	db, err := sql.Open("sqlite", "crl2_data.db")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	http.Handle("/", http.FileServer(http.Dir("./static")))

	http.HandleFunc("/data", func(w http.ResponseWriter, r *http.Request) {
		// Properties
		rows, err := db.Query(`SELECT p.id AS id, p.type AS type, p.name AS name, p.occupied AS occupied, u.nickname AS nickname, c.primary_x, c.primary_y FROM properties AS p JOIN property_coords AS c ON c.property_id = p.id JOIN users AS u ON u.id = p.user_id WHERE c.type = 8 ORDER BY p.id`)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		var props []Property
		for rows.Next() {
			var p Property
			if err := rows.Scan(&p.ID, &p.Type, &p.Name, &p.Occupied, &p.Owner, &p.X, &p.Y); err != nil {
				log.Println(err)
				continue
			}
			props = append(props, p)
		}

		rows.Close()

		// Trucking Points
		rows, err = db.Query("SELECT p.id AS id, p.type AS type, p.name AS name, c.x, c.y FROM trucking_points AS p JOIN trucking_coords AS c ON c.trucking_id = p.id WHERE c.type = 2")
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		for rows.Next() {
			var p Property
			if err := rows.Scan(&p.ID, &p.Type, &p.Name, &p.X, &p.Y); err != nil {
				log.Println(err)
				continue
			}

			if p.ID == 0 {
				continue
			}

			p.ID += 100
			p.Type = 3

			props = append(props, p)
		}

		rows.Close()

		// ATMs
		rows, err = db.Query("SELECT id, x, y, comment FROM atm_coords")
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		for rows.Next() {
			var p Property
			if err := rows.Scan(&p.ID, &p.X, &p.Y, &p.Name); err != nil {
				log.Println(err)
				continue
			}

			p.ID += 200
			p.Name = fmt.Sprint("ATM: ", p.Name)
			p.Type = 4

			props = append(props, p)
		}

		rows.Close()

		// Races
		rows, err = db.Query("SELECT id, name, start_x, start_y FROM races")
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		for rows.Next() {
			var p Property
			if err := rows.Scan(&p.ID, &p.Name, &p.X, &p.Y); err != nil {
				log.Println(err)
				continue
			}

			if p.ID == 0 {
				continue
			}

			p.ID += 300
			p.Name = fmt.Sprint("Race: ", p.Name)
			p.Type = 5

			props = append(props, p)
		}

		rows.Close()

		// Tiki prizes
		rows, err = db.Query("SELECT id, x, y FROM prize_coords WHERE type = 1")
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		for rows.Next() {
			var p Property
			if err := rows.Scan(&p.ID, &p.X, &p.Y); err != nil {
				log.Println(err)
				continue
			}

			if p.ID == 0 {
				continue
			}

			p.ID += 400
			p.Name = fmt.Sprint("Tiki: ", p.Name)
			p.Type = 6

			props = append(props, p)
		}

		rows.Close()

		// Drugz
		rows, err = db.Query("SELECT c.id AS id, p.name AS name, c.type AS type, c.x, c.y FROM drug_coords AS c JOIN drug_prices AS p ON p.id = c.type ")
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		for rows.Next() {
			var p Property
			if err := rows.Scan(&p.ID, &p.Name, &p.Type, &p.X, &p.Y); err != nil {
				log.Println(err)
				continue
			}

			if p.ID == 0 {
				continue
			}

			p.ID += 500
			p.Name = fmt.Sprint("Drugz: ", p.Name)
			p.Type = 7

			props = append(props, p)
		}

		rows.Close()

		// Teams
		rows, err = db.Query("SELECT c.id AS id, t.name AS name, c.X, c.Y FROM team_coords AS c JOIN teams AS t ON t.id = c.team_id")
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		for rows.Next() {
			var p Property
			if err := rows.Scan(&p.ID, &p.Name, &p.X, &p.Y); err != nil {
				log.Println(err)
				continue
			}

			if p.ID == 0 {
				continue
			}

			p.ID += 600
			p.Name = fmt.Sprint("Team: ", p.Name)
			p.Type = 8

			props = append(props, p)
		}

		rows.Close()

		// Pumpkin prizes
		rows, err = db.Query("SELECT id, x, y FROM prize_coords WHERE type = 2")
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		for rows.Next() {
			var p Property
			if err := rows.Scan(&p.ID, &p.X, &p.Y); err != nil {
				log.Println(err)
				continue
			}

			if p.ID == 0 {
				continue
			}

			p.ID += 700
			p.Name = fmt.Sprint("Pumpkin: ", p.Name)
			p.Type = 9

			props = append(props, p)
		}

		rows.Close()

		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(props)
	})

	port := os.Getenv("PORT")
	if port == "" {
		port = "3000"
	}

	log.Printf("Server started at http://localhost:%s", port)
	http.ListenAndServe(":"+port, nil)
}
