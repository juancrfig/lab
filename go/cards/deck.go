package main

import (
	"fmt"
	"strings"
	"os"
	"log"
	"math/rand"
)

type deck []string

func newDeck() deck {
	cardSuits := []string{"Spades", "Diamonds", "Hearts", "Clubs"}
	cardValues := []string{"Ace", "Two", "Three", "Four"}
	cards := make(deck, 0, len(cardSuits) * len(cardValues) )
	
	for _, s := range cardSuits {
		for _, v := range cardValues {
			cards = append(cards, fmt.Sprintf("%s of %s", v, s))
		}
	}
	return cards
}

func (d *deck) Print() {
	for i, card := range *d {
		fmt.Println(i, card)
	}
}

func deal(d deck, handSize int) (deck, deck) {
	return d[:handSize], d[handSize:]
}

func (d *deck) toString() string {
	return strings.Join([]string(*d), ",")
}

func (d *deck) saveToFile(filename string) error {
	return os.WriteFile(
		filename, 
		[]byte(d.toString()),
		0666,
	)
}

func newDeckFromFile(filename string) deck {
	bs, err := os.ReadFile(filename)
	if err != nil {
		log.Println("Error: ", err)
		os.Exit(1)
	}
	
	ss := strings.Split(string(bs), ",")
	return deck(ss)
}

func (d deck) shuffle() {
	for i := range d {
		newPosition :=rand.Intn(len(d) - 1)
		d[i], d[newPosition] = d[newPosition], d[i]
	}
}