package handlers

import (
	"github.com/stretchr/testify/assert"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

func TestHitHandler(t *testing.T) {
	handler := http.HandlerFunc(HitHandler)
	ts := httptest.NewServer(handler)
	defer ts.Close()

	req := httptest.NewRequest("GET", "/", nil)
	w := httptest.NewRecorder()
	handler(w, req)

	assert.EqualValues(t, http.StatusOK, w.Code)
	assert.True(t, strings.Contains(w.Body.String(), "You've hit"))
}

func TestHealthHandler(t *testing.T) {
	handler := http.HandlerFunc(HealthHandler)
	ts := httptest.NewServer(handler)
	defer ts.Close()

	req := httptest.NewRequest("GET", "/health", nil)
	w := httptest.NewRecorder()
	handler.ServeHTTP(w, req)

	assert.EqualValues(t, http.StatusOK, w.Code)
	assert.EqualValues(t, `{"alive": true}`, w.Body.String())
}

func TestStopHandler(t *testing.T) {
	alive.Set(true)
	assert.True(t, alive.Get())

	stop := http.HandlerFunc(StopHandler)
	ts := httptest.NewServer(stop)
	defer ts.Close()

	req := httptest.NewRequest("POST", "/stop", nil)
	w := httptest.NewRecorder()
	stop.ServeHTTP(w, req)

	assert.EqualValues(t, http.StatusOK, w.Code)
	assert.Empty(t, w.Body.String())

	assert.False(t, alive.Get())
}

func TestHealthHandlerBeforeAndAfterStop(t *testing.T) {
	alive.Set(false)
	assert.False(t, alive.Get())

	health := http.HandlerFunc(HealthHandler)
	ts := httptest.NewServer(health)
	defer ts.Close()

	req := httptest.NewRequest("GET", "/health", nil)
	w := httptest.NewRecorder()
	health.ServeHTTP(w, req)

	assert.EqualValues(t, http.StatusInternalServerError, w.Code)
	assert.EqualValues(t, `{"alive": false}`, w.Body.String())
}
