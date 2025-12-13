package main

import (
	"fmt"
	"sync"
)

var wg sync.WaitGroup

type Income struct {
	Source string
	Amount int
}

func main() {
	var bankBalance int
	var balance sync.Mutex

	fmt.Printf("Initial account balance: $%d.00\n", bankBalance)

	incomes := []Income{
		{Source: "Main Job", Amount: 500},
		{Source: "Gifts", Amount: 10},
		{Source: "Investment", Amount: 100},
		{Source: "Part time job", Amount: 50},
	}

	wg.Add(len(incomes))

	for i, income := range incomes {
		go func(i int, income Income) {
			defer wg.Done()
			for week := 1; week <= 52; week++ {
				balance.Lock()
				bankBalance += income.Amount
				balance.Unlock()

				fmt.Printf("On week %d you earned %d.00 from %s\n", week, income.Amount, income.Source)
			}
		}(i, income)
	}
	wg.Wait()

	fmt.Printf("Final bank balance: $%d.00\n", bankBalance)
}
