# =============================================================================
# Stage 1: Builder
# =============================================================================
FROM golang:1.25.1-alpine AS builder

RUN apk add --no-cache git curl
RUN go install github.com/swaggo/swag/cmd/swag@latest

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN swag init -g ./cmd/api/main.go -o ./docs
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /app/bin/much-to-do ./cmd/api/main.go

# =============================================================================
# Stage 2: Final image
# =============================================================================
FROM alpine:3.19

RUN apk add --no-cache ca-certificates tzdata curl

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

COPY --from=builder /app/bin/much-to-do .

# Copy entrypoint script
COPY docker-entrypoint.sh .
RUN chmod +x docker-entrypoint.sh

RUN chown -R appuser:appgroup /app

USER appuser

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=10s --start-period=15s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

ENTRYPOINT ["./docker-entrypoint.sh"]
