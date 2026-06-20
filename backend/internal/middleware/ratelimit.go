package middleware
import (
	"net/http"
	"sync"
	"time"
	"github.com/gin-gonic/gin"
)
// visitor tracks request counts for a single IP
type visitor struct {
	count    int
	lastSeen time.Time
}
// RateLimiter holds the in-memory state for rate limiting
type RateLimiter struct {
	visitors map[string]*visitor
	mu       sync.Mutex
	limit    int           // max requests per window
	window   time.Duration // time window
}
// NewRateLimiter creates a new rate limiter with the specified limit per window
func NewRateLimiter(limit int, window time.Duration) *RateLimiter {
	rl := &RateLimiter{
		visitors: make(map[string]*visitor),
		limit:    limit,
		window:   window,
	}
	// Background goroutine to clean up stale entries every minute
	go func() {
		for {
			time.Sleep(1 * time.Minute)
			rl.cleanup()
		}
	}()
	return rl
}
// cleanup removes visitors whose last request was outside the current window
func (rl *RateLimiter) cleanup() {
	rl.mu.Lock()
	defer rl.mu.Unlock()
	cutoff := time.Now().Add(-rl.window)
	for ip, v := range rl.visitors {
		if v.lastSeen.Before(cutoff) {
			delete(rl.visitors, ip)
		}
	}
}
// Middleware returns a Gin middleware function that enforces rate limiting per client IP
func (rl *RateLimiter) Middleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		ip := c.ClientIP()
		rl.mu.Lock()
		v, exists := rl.visitors[ip]
		if !exists {
			rl.visitors[ip] = &visitor{count: 1, lastSeen: time.Now()}
			rl.mu.Unlock()
			c.Next()
			return
		}
		// If the window has passed, reset the counter
		if time.Since(v.lastSeen) > rl.window {
			v.count = 1
			v.lastSeen = time.Now()
			rl.mu.Unlock()
			c.Next()
			return
		}
		// Increment and check
		v.count++
		v.lastSeen = time.Now()
		if v.count > rl.limit {
			rl.mu.Unlock()
			c.AbortWithStatusJSON(http.StatusTooManyRequests, gin.H{
				"error": "too many requests — please try again later",
			})
			return
		}
		rl.mu.Unlock()
		c.Next()
	}
}
