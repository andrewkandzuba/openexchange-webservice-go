package state

import "sync"

type State struct {
	v   bool
	mux sync.Mutex
}

func New() *State {
	return &State{true, sync.Mutex{}}
}

func (c *State) Set(v bool) {
	c.mux.Lock()
	c.v = v
	defer c.mux.Unlock()
}

func (c *State) Get() bool {
	c.mux.Lock()
	defer c.mux.Unlock()
	return c.v
}
