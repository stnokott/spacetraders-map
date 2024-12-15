package main

import (
	"io"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/stretchr/testify/assert"
)

// testRequest spins up a new httptest.Server, requests the provided path and runs assertion on the result.
func testRequest(t *testing.T, reqPath string, assertion func(t *testing.T, resp *http.Response)) {
	ts := httptest.NewServer(newServer())
	defer ts.Close()

	request, _ := http.NewRequest(http.MethodGet, ts.URL+reqPath, nil)
	resp, err := http.DefaultClient.Do(request)
	defer func() {
		_ = resp.Body.Close()
	}()
	if err != nil {
		t.Fatalf("request %s: %v", reqPath, err)
	}
	assertion(t, resp)
}

func TestHome(t *testing.T) {
	testRequest(t, "/", func(t *testing.T, resp *http.Response) {
		body, _ := io.ReadAll(resp.Body)
		_ = resp.Body.Close()

		assert.Equal(t, 200, resp.StatusCode, "should return HTTP 200")
		assert.NotEmpty(t, body, "should return non-empty body")
	})
}
