package router

import (
	"encoding/json"
	"log"
	"net/http"
)

func Run() {
	server := http.Server{
		Addr:    ":8080",
		Handler: nil,
	}
	http.HandleFunc("/hoge", UsersHandler)
	http.HandleFunc("/fuga", UsersHandler)
	server.ListenAndServe()
}

func UsersHandler(w http.ResponseWriter, r *http.Request) {
	handler := di.InitUser()
	user, err := handler.GetByUserID(r.Context(), r)
	if err != nil {
		log.Fatal(err)
	}
	json.NewEncoder(w).Encode(user)
}
