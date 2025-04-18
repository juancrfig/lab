package main

import "fmt"


type Book struct {
	Title  string
	Author string
}

// Attaching a method to the Book type
// (b Book) is the receiver. It links the function to the Book struct
// The variable b refers tothe specific Book instance
func (b Book) Summarize() string {
	return fmt.Sprintf("%s by %s", b.Title, b.Author)
}

func main() {
	book1 := Book{
		Title: "The Go Programming Language",
		Author: "Alan A. A. Donovan",
	}

	summary := book1.Summarize()
	fmt.Println(summary)
}
