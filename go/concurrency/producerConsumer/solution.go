package main

import (
	"fmt"
	"math/rand/v2"
	"time"

	"github.com/fatih/color"
)

const NumberOfPizzas int = 10
var pizzasMade, pizzasFailed, total int 

type Producer struct {
	data chan PizzaOrder
	quit chan chan error
}

type PizzaOrder struct {
	pizzaNumber int
	message     string
	success     bool
}

func (p *Producer) Close() error {
	ch := make(chan error)
	p.quit <-ch
	
	return <-ch
}

func makePizza(pizzaNumber int) *PizzaOrder {
	pizzaNumber++
	if pizzaNumber <= NumberOfPizzas {
		randomSeconds := rand.IntN(5) + 1
		delay := time.Duration(randomSeconds) * time.Second
		fmt.Printf("Received order #%d\n", pizzaNumber)
		
		rnd := rand.IntN(12) + 1
		var msg string
		var success bool
		
		if rnd < 5 {
			pizzasFailed++
		} else {
			pizzasMade++
		}
		total++
		
		fmt.Printf("Making pizza #%d it will take %d seconds...\n", pizzaNumber, randomSeconds)
		time.Sleep(delay)
		
		if rnd <= 2 {
			msg = fmt.Sprintf("*** We ran out of ingredients for pizza #%d!", pizzaNumber)
		} else if rnd <= 4 {
			msg = fmt.Sprintf("*** We ran out of ingredients for pizza #%d!", pizzaNumber)
		} else {
			success = true
			msg = fmt.Sprintf("Pizza order #%d is ready!", pizzaNumber)
		}
		
		return &PizzaOrder{
			pizzaNumber: pizzaNumber,
			message: msg,
			success: success,
		}	
	}
	return &PizzaOrder{
		pizzaNumber: pizzaNumber,
	}
}

func pizzeria(pizzaMaker *Producer) {
	var i int
	
	for {
		currentPizza := makePizza(i)
		if currentPizza != nil {
			i = currentPizza.pizzaNumber
			select {
			// data is a channel that handles pizza orders
			case pizzaMaker.data <- *currentPizza:
			
			case quitChan := <-pizzaMaker.quit:
				close(pizzaMaker.data)
				close(quitChan)
				return
			}
		}
	}
}

func main() {
	color.Cyan("The Pizzeria is open for business")
	color.Cyan("=================================")
	
	pizzaJob := &Producer{
		data: make(chan PizzaOrder),
		quit: make(chan chan error),
	}
	
	go pizzeria(pizzaJob)
	
	for i := range pizzaJob.data {
		if i.pizzaNumber <= NumberOfPizzas {
			if i.success {
				color.Green(i.message)
				color.Green("Order #%d is out for delivery!", i.pizzaNumber)
			} else {
				color.Red(i.message)
				color.Red("The customer is really mad!")
			}
		} else {
			color.Cyan("Done making pizzas, chief!")
			err := pizzaJob.Close()
			if err != nil {
				color.Red("*** Error closing channel!", err)
			}
		}
	}
	color.Cyan("================")
	color.Cyan("Done for the day")
	color.Cyan("================")
	color.Cyan("We made %d pizzas but failed to make %d with %d attempts in total", pizzasMade, pizzasFailed, total)
	
	switch {
		case pizzasFailed > 9:
			color.Red("It was an awful day...")
		case pizzasFailed >= 6:
			color.Red("It was not a very good day...")
		case pizzasFailed >= 4:
			color.Yellow("It was an okay day...")
		case pizzasFailed >= 2:
			color.Yellow("It was a pretty good day!")
		default:
			color.Green("It was a great day!")
	}
}