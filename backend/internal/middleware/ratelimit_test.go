package middleware

import (
	"net/http"
	"net/http/httptest"
	"sync"
	"testing"
	"time"

	"github.com/gin-gonic/gin"
)

func TestRateLimiterAllowsLimitAndRejectsNextRequest(t *testing.T) {
	gin.SetMode(gin.TestMode)
	limiter := NewRateLimiter(2, time.Minute)
	router := gin.New()
	router.GET("/otp", limiter.Middleware(), func(c *gin.Context) { c.Status(http.StatusNoContent) })

	for requestNumber, wantStatus := range []int{http.StatusNoContent, http.StatusNoContent, http.StatusTooManyRequests} {
		recorder := httptest.NewRecorder()
		request := httptest.NewRequest(http.MethodGet, "/otp", nil)
		router.ServeHTTP(recorder, request)
		if recorder.Code != wantStatus {
			t.Fatalf("request %d status = %d, want %d", requestNumber+1, recorder.Code, wantStatus)
		}
	}
}

func TestRateLimiterResetsAfterWindow(t *testing.T) {
	gin.SetMode(gin.TestMode)
	limiter := NewRateLimiter(1, 2*time.Millisecond)
	router := gin.New()
	router.GET("/otp", limiter.Middleware(), func(c *gin.Context) { c.Status(http.StatusNoContent) })

	request := httptest.NewRequest(http.MethodGet, "/otp", nil)
	first := httptest.NewRecorder()
	router.ServeHTTP(first, request)
	if first.Code != http.StatusNoContent {
		t.Fatalf("first request status = %d", first.Code)
	}

	time.Sleep(4 * time.Millisecond)
	second := httptest.NewRecorder()
	router.ServeHTTP(second, httptest.NewRequest(http.MethodGet, "/otp", nil))
	if second.Code != http.StatusNoContent {
		t.Fatalf("request after window status = %d, want %d", second.Code, http.StatusNoContent)
	}
}

func TestRateLimiterIsSafeUnderConcurrentRequests(t *testing.T) {
	gin.SetMode(gin.TestMode)
	limiter := NewRateLimiter(5, time.Minute)
	router := gin.New()
	router.GET("/otp", limiter.Middleware(), func(c *gin.Context) { c.Status(http.StatusNoContent) })

	var waitGroup sync.WaitGroup
	statuses := make(chan int, 20)
	for i := 0; i < 20; i++ {
		waitGroup.Add(1)
		go func() {
			defer waitGroup.Done()
			recorder := httptest.NewRecorder()
			router.ServeHTTP(recorder, httptest.NewRequest(http.MethodGet, "/otp", nil))
			statuses <- recorder.Code
		}()
	}
	waitGroup.Wait()
	close(statuses)

	allowed := 0
	for status := range statuses {
		if status == http.StatusNoContent {
			allowed++
		}
	}
	if allowed != 5 {
		t.Fatalf("allowed %d concurrent requests, want exactly 5", allowed)
	}
}
