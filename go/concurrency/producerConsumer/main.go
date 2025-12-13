package main

import (
	"fmt"
	"math/rand/v2"
	"time"

	"github.com/fatih/color"
)

// ---------------------------------------------------------
// GLOBAL VARIABLES
// ---------------------------------------------------------
const NumberOfPizzas int = 10
var pizzasMade, pizzasFailed, total int

// ---------------------------------------------------------
// DATA STRUCTURES
// ---------------------------------------------------------

// TODO: Define a struct named 'Producer'.
// ---------------------------------------------------------
// 🧪 THOUGHT LAB #1: THE "QUIT" CHANNEL TYPE
// ---------------------------------------------------------
// You are about to define the 'quit' channel. The solution uses 'chan chan error'.
//
// QUESTION: Why not just use 'chan bool'?
// HYPOTHESIS: If we just send a "true" boolean to tell the worker to stop,
// the main function will continue running immediately after sending it.
//
// EXPERIMENT (Try this later):
// If you used 'chan bool', the main function might print "Done for the day"
// and kill the program while the worker is still busy cleaning up.
// We use 'chan chan error' to create a TWO-WAY handshake:
// 1. Main says: "Here is a return address (channel), please stop."
// 2. Worker says: "Okay, I am done. sending confirmation to your return address."
// ---------------------------------------------------------
//
// Define the struct fields now:
// 1. 'data' (channel of PizzaOrder)
// 2. 'quit' (channel of channel of error)




// TODO: Define a struct named 'PizzaOrder'.
// Fields: pizzaNumber (int), message (string), success (bool)


// ---------------------------------------------------------
// METHODS
// ---------------------------------------------------------

// TODO: Write the 'Close' method for the Producer struct.
// ---------------------------------------------------------
// 🧪 THOUGHT LAB #2: THE BLOCKING HANDSHAKE
// ---------------------------------------------------------
// In this function, you will send the quit signal.
//
// QUESTION: What happens if you don't wait for the response?
//
// EXPERIMENT:
// When you write this, try writing it WITHOUT the line that receives the answer
// (the 'return <-ch' part). Just send the signal and return nil immediately.
//
// PREDICTION:
// You will see the program exit before the worker has printed "closing channel...".
// The synchronization will be broken.
// ---------------------------------------------------------
//
// Logic:
// 1. Make a channel (return address).
// 2. Send that channel into the producer's quit pipeline.
// 3. Receive the response from that channel (THIS IS THE BLOCKING CALL).
// 4. Return the received error.



// ---------------------------------------------------------
// WORKER FUNCTIONS
// ---------------------------------------------------------

// TODO: Write the 'makePizza' function.
// (Same instructions as before: simulate delay, random success/fail, update globals)
// Remember to return a *PizzaOrder.



// TODO: Write the 'pizzeria' worker function.
// ---------------------------------------------------------
// 🧪 THOUGHT LAB #3: THE SELECT STATEMENT
// ---------------------------------------------------------
// You are about to write the 'select' block inside the infinite loop.
//
// QUESTION: Why do we need 'select'? Why not just an 'if/else'?
//
// LOGIC CHECK:
// We need to listen to TWO things at once:
// 1. "Can I send a pizza?" (sending to 'data')
// 2. "Did the boss tell me to quit?" (receiving from 'quit')
//
// EXPERIMENT:
// Imagine if you wrote this:
//    msg := <-pizzaMaker.quit  (Wait for quit signal)
//    pizzaMaker.data <- pizza  (Send pizza)
//
// Result: The worker would stop making pizzas immediately because it would
// BLOCK on the first line waiting for a quit signal that hasn't come yet.
// 'select' allows us to proceed with whichever event happens FIRST.
// ---------------------------------------------------------
//
// Logic required:
// 1. Loop forever.
// 2. Make a pizza.
// 3. Use 'select':
//    - Case A: Send pizza to data channel.
//    - Case B: Receive from quit channel.
//      (If Case B happens: close data channel, close quit channel, return).


// ---------------------------------------------------------
// MAIN ENTRY POINT
// ---------------------------------------------------------

func main() {
	color.Cyan("The Pizzeria is open for business")
	color.Cyan("=================================")

	// TODO: Initialize the Producer struct.

	// TODO: Start the 'pizzeria' worker (goroutine).

	// TODO: Iterate over the data channel (Range loop).
	// ---------------------------------------------------------
	// 🧪 THOUGHT LAB #4: THE RANGE LOOP
	// ---------------------------------------------------------
	// You are writing 'for i := range pizzaJob.data'.
	//
	// QUESTION: How does this loop know when to stop?
	// We are not checking "i < 10".
	//
	// ANSWER:
	// It stops ONLY when the 'data' channel is closed.
	// This proves that the Worker (pizzeria) controls the flow.
	// If the worker forgets to close the channel (in the select statement above),
	// this loop will wait forever -> DEADLOCK.
	// ---------------------------------------------------------

	// Inside the loop:
	// 1. Handle success/fail printing.
	// 2. If pizzaNumber > NumberOfPizzas:
	//    - Print "Done making pizzas..."
	//    - Call the Close method. (This triggers the handshake).

	color.Cyan("================")
	color.Cyan("Done for the day")
	color.Cyan("================")
	color.Cyan("We made %d pizzas but failed to make %d with %d attempts in total", pizzasMade, pizzasFailed, total)

	// (Stats switch statement goes here)
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