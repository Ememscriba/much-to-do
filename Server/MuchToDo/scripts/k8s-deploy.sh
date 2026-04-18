#!/bin/bash
set -e

echo "🚀 Deploying MuchToDo to Kubernetes (Kind)..."

cd "$(dirname "$0")/.."

CLUSTER_NAME="muchtodo-cluster"
NAMESPACE="muchtodo"

# Create Kind cluster if it doesn't exist
if ! kind get clusters | grep -q "$CLUSTER_NAME"; then
  echo "🔧 Creating Kind cluster: $CLUSTER_NAME..."
  kind create cluster --name "$CLUSTER_NAME" --config kubernetes/kind-config.yaml
  echo "✅ Kind cluster created."
else
  echo "✅ Kind cluster '$CLUSTER_NAME' already exists."
fi

# Set kubectl context
kubectl cluster-info --context "kind-$CLUSTER_NAME"

# Build and load image into Kind
echo "🔨 Building and loading Docker image into Kind..."
docker build -t muchtodo-backend:latest .
kind load docker-image muchtodo-backend:latest --name "$CLUSTER_NAME"
echo "✅ Image loaded into Kind."

# Apply manifests in order
echo "📦 Applying Kubernetes manifests..."
kubectl apply -f kubernetes/namespace.yaml

kubectl apply -f kubernetes/mongodb/mongodb-secret.yaml
kubectl apply -f kubernetes/mongodb/mongodb-configmap.yaml
kubectl apply -f kubernetes/mongodb/mongodb-pvc.yaml
kubectl apply -f kubernetes/mongodb/mongodb-deployment.yaml
kubectl apply -f kubernetes/mongodb/mongodb-service.yaml

kubectl apply -f kubernetes/backend/backend-secret.yaml
kubectl apply -f kubernetes/backend/backend-configmap.yaml
kubectl apply -f kubernetes/backend/backend-deployment.yaml
kubectl apply -f kubernetes/backend/backend-service.yaml

kubectl apply -f kubernetes/ingress.yaml

# Wait for deployments
echo "⏳ Waiting for MongoDB to be ready..."
kubectl rollout status deployment/mongodb -n "$NAMESPACE" --timeout=120s

echo "⏳ Waiting for backend to be ready..."
kubectl rollout status deployment/muchtodo-backend -n "$NAMESPACE" --timeout=120s

echo ""
echo "✅ Deployment complete!"
echo ""
echo "📋 Status:"
kubectl get all -n "$NAMESPACE"
echo ""
echo "🌐 Access via NodePort: http://localhost:30080"
