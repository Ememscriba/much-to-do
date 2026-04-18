#!/bin/bash
set -e

echo "🚀 Starting MuchToDo with Docker Compose..."

cd "$(dirname "$0")/.."

# Generate mongodb keyfile if it doesn't exist
if [ ! -f mongodb.key ]; then
  echo "🔑 Generating MongoDB keyfile..."
  openssl rand -base64 756 > mongodb.key
  chmod 400 mongodb.key
  echo "✅ MongoDB keyfile generated."
fi

# Copy .env.example to .env if .env doesn't exist
if [ ! -f .env ]; then
  echo "📋 Creating .env from .env.example..."
  cp .env.example .env
  echo "⚠️  Please update .env with your actual values before continuing."
fi

docker compose -f docker-compose.yml up -d --build

echo ""
echo "✅ All services started!"
echo ""
echo "📦 Services:"
echo "  Backend API  → http://localhost:8080"
echo "  Health Check → http://localhost:8080/health"
echo "  Swagger UI   → http://localhost:8080/swagger/index.html"
echo "  Mongo Express→ http://localhost:8081"
echo "  Redis Cmdr   → http://localhost:8082"
echo ""
echo "📋 Logs: docker compose logs -f backend"
