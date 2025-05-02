
# Build stage
FROM golang:1.21 AS builder

WORKDIR /app

# Copy and download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy source code and build
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# Final stage (lightweight)
FROM alpine:latest

WORKDIR /root/

# Copy built binary from builder
COPY --from=builder /app/main .
COPY --from=builder /app/config/default.yaml config/default.yaml
COPY --from=builder /app/db ./db

# Expose port (adjust if needed)
EXPOSE 8080

# Run the binary
CMD ["./main"]