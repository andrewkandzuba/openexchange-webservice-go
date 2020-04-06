package state

import "sync"

type State struct {
	v   bool
	mux sync.RWMutex
}

func New(init bool) *State {
	return &State{init, sync.RWMutex{}}
}

func (c *State) Set(v bool) {
	c.mux.RLock()
	defer c.mux.RUnlock()
	c.v = v
}

func (c *State) Get() bool {
	c.mux.Lock()
	defer c.mux.Unlock()
	return c.v
}
