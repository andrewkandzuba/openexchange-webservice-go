package handlers

import (
	"github.com/stretchr/testify/assert"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

func TestHitHandler(t *testing.T)  {
	req, err := http.NewRequest("GET", "/", nil)
	assert.Nil(t, err)

	rr := httptest.NewRecorder()
	handler := http.HandlerFunc(HitHandler)
	handler.ServeHTTP(rr, req)

	assert.EqualValues(t, http.StatusOK, rr.Code)
	assert.True(t, strings.Contains(rr.Body.String(), "You've hit"))
}

func TestHealthHandler(t *testing.T) {
	req, err := http.NewRequest("GET", "/health", nil)
	assert.Nil(t, err)

	rr := httptest.NewRecorder()
	handler := http.HandlerFunc(HealthHandler)
	handler.ServeHTTP(rr, req)

	assert.EqualValues(t, http.StatusOK, rr.Code)
	assert.EqualValues(t, `{"alive": true}`, rr.Body.String())
}
