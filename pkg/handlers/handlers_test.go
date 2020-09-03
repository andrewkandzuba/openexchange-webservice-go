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

func TestLivenessProbeHandler(t *testing.T) {
	handler := http.HandlerFunc(LivenessProbeHandler)
	ts := httptest.NewServer(handler)
	defer ts.Close()

	req := httptest.NewRequest("GET", "/live", nil)
	w := httptest.NewRecorder()
	handler.ServeHTTP(w, req)

	assert.EqualValues(t, http.StatusOK, w.Code)
	assert.EqualValues(t, `{"alive": true}`, w.Body.String())
}

func TestLivenessProbeHandlerBeforeAndAfterStop(t *testing.T) {
	Alive.Set(false)
	assert.False(t, Alive.Get())

	live := http.HandlerFunc(LivenessProbeHandler)
	ts := httptest.NewServer(live)
	defer ts.Close()

	req := httptest.NewRequest("GET", "/live", nil)
	w := httptest.NewRecorder()
	live.ServeHTTP(w, req)

	assert.EqualValues(t, http.StatusInternalServerError, w.Code)
	assert.EqualValues(t, `{"alive": false}`, w.Body.String())
}

func TestStopHandler(t *testing.T) {
	Alive.Set(true)
	assert.True(t, Alive.Get())

	stop := http.HandlerFunc(StopHandler)
	ts := httptest.NewServer(stop)
	defer ts.Close()

	req := httptest.NewRequest("POST", "/stop", nil)
	w := httptest.NewRecorder()
	stop.ServeHTTP(w, req)

	assert.EqualValues(t, http.StatusOK, w.Code)
	assert.Empty(t, w.Body.String())

	assert.False(t, Alive.Get())
}

func TestReadinessProbeHandler(t *testing.T) {
	handler := http.HandlerFunc(ReadinessProbeHandler)
	ts := httptest.NewServer(handler)
	defer ts.Close()

	req := httptest.NewRequest("GET", "/ready", nil)
	w := httptest.NewRecorder()
	handler.ServeHTTP(w, req)

	assert.EqualValues(t, http.StatusInternalServerError, w.Code)
	assert.EqualValues(t, `{"ready": false}`, w.Body.String())

	Ready.Set(true)

	req = httptest.NewRequest("GET", "/ready", nil)
	w = httptest.NewRecorder()
	handler.ServeHTTP(w, req)

	assert.EqualValues(t, http.StatusOK, w.Code)
	assert.EqualValues(t, `{"ready": true}`, w.Body.String())
}

func TestReadinessProbeHandlerBeforeAndAfterStop(t *testing.T) {
	Ready.Set(false)
	assert.False(t, Alive.Get())

	ready := http.HandlerFunc(ReadinessProbeHandler)
	ts := httptest.NewServer(ready)
	defer ts.Close()

	req := httptest.NewRequest("GET", "/ready", nil)
	w := httptest.NewRecorder()
	ready.ServeHTTP(w, req)

	assert.EqualValues(t, http.StatusInternalServerError, w.Code)
	assert.EqualValues(t, `{"ready": false}`, w.Body.String())
}
