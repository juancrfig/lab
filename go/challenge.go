package main

import (
	"fmt"
)


type DataStorer interface {
	Store(payload []byte) error
}

type DBClient struct {
	// conection details, etc...
}

func (c *DBClient) Insert(table string, data []byte) error {
	fmt.Printf("SUCCESS: Inserted data into table '%s'\n", table)
	return nil
}


