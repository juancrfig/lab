package main

import (
	"os"
	"log"
	"io"
)

func main() {
	if len(os.Args) != 2 {
		log.Fatal("Usage: readFile filename")
	}
	
	filename := os.Args[1]
	file, err := os.Open(filename)
	if err != nil {
		log.Fatal(err)
	}
	
	io.Copy(os.Stdout, file)
}