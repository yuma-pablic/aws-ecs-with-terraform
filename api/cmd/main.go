package main

import (
	"database/sql"
	"ddd/cmd/router"
	"log"

	_ "github.com/go-sql-driver/mysql"
)

func main() {
	dsn := "user:password@tcp(localhost:3306)/sbcntrapp"
	sqldb, err := sql.Open("mysql", dsn)
	if err != nil {
		log.Println("mysql connection error %w", err)
		return
	}
	defer sqldb.Close()

	if err := sqldb.Ping(); err != nil {
		log.Println("ping error %w", err)
		return
	}
	router.Run()
}
