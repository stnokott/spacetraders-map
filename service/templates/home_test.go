package templates

import (
	"context"
	"io"
	"testing"

	"github.com/PuerkitoBio/goquery"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestHome(t *testing.T) {
	data := HomeData{
		Title:   "A title",
		Version: "A version",
		Commit:  "A commit",
	}

	r, w := io.Pipe()
	go func() {
		_ = Home(data).Render(context.Background(), w)
		_ = w.Close()
	}()
	doc, err := goquery.NewDocumentFromReader(r)
	if err != nil {
		t.Fatalf("reading template: %v", err)
	}

	// Expect title
	assert.Equal(t, data.Title, doc.Find(`title`).Text())
	// Expect version and commit
	buildInfo := doc.Find(`#build-info`)
	require.Equal(t, 1, buildInfo.Length())
	assert.Contains(t, buildInfo.Text(), data.Version)
	assert.Contains(t, buildInfo.Text(), data.Commit)
}
