package state

import (
	"fmt"
	"github.com/stretchr/testify/assert"
	"sync"
	"testing"
	"time"
)

func TestStateConcurrency(t *testing.T)  {

	c := New(true)
	assert.EqualValues(t, true, c.Get());

	var wg sync.WaitGroup
	wg.Add(2)

	go func() {
		for c.Get() == true {
			time.Sleep(time.Second)
			fmt.Println("Waiting for container readiness ...")
		}
		fmt.Println("Container is ready")
		defer wg.Done()
	}()

	go func() {
		time.Sleep(10 * time.Second)
		fmt.Println("Set container state to ready")
		c.Set(false)
		defer wg.Done()
	}()

	wg.Wait()

	assert.EqualValues(t, false, c.Get());
}