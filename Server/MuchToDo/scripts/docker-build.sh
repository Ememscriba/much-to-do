#!/bin/bash
set -e

echo "🔨 Building MuchToDo Docker image..."

cd "$(dirname "$0")/.."

# Generate mongodb keyfile if it doesn't exist
if [ ! -f mongodb.key ]; then
  echo "🔑 Generating MongoDB keyfile..."
  openssl rand -base64 756 > mongodb.key
  chmod 400 mongodb.key
  echo "✅ MongoDB keyfile generated."
fi

docker build -t muchtodo-backend:latest .

echo "✅ Docker image built successfully: muchtodo-backend:latest"
docker images muchtodo-backend:latest
