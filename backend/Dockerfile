# Build stage
FROM golang:1.26-alpine AS builder

WORKDIR /app

# Copy dependency files
COPY go.mod go.sum ./
RUN go mod download

# Copy source code
COPY . .

# Build the Go application binary
RUN CGO_ENABLED=0 GOOS=linux go build -o main ./cmd/api/main.go

# Run stage
FROM alpine:latest

WORKDIR /app

# Install certificates for HTTPS requests if needed
RUN apk --no-cache add ca-certificates

# Copy binary from builder
COPY --from=builder /app/main .

# Expose the API port
EXPOSE 8081

# Command to run the application
CMD ["./main"]