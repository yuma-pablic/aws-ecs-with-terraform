package rdb

import (
	"database/sql"
	"log"
)

func NewDB() *sql.DB {
	dsn := "user:password@tcp(localhost:3306)/sbcntrapp"
	sqldb, err := sql.Open("postgres", dsn)
	if err != nil {
		log.Println("postgres connection error %w", err)
		return nil
	}
	defer sqldb.Close()

	if err := sqldb.Ping(); err != nil {
		log.Println("ping error %w", err)
		return nil
	}
	return sqldb
}
