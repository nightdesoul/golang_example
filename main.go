package main

import "net/http"

func main() {
	http.HandleFunc("/", root)
	http.ListenAndServe(":8080", nil)

}

func root(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("Hello world!"))
}
