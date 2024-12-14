package main

import (
	"io"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestGETBasepath(t *testing.T) {
	t.Run("GET basepath", func(t *testing.T) {
		request, _ := http.NewRequest(http.MethodGet, "/", nil)
		response := httptest.NewRecorder()

		handler(response, request)

		resp := response.Result()
		body, _ := io.ReadAll(resp.Body)
		_ = resp.Body.Close()

		assert.Equal(t, 200, resp.StatusCode, "should return HTTP 200")
		assert.NotEmpty(t, body, "should return non-empty body")
	})
}
