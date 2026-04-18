#!/bin/bash
set -e

echo "🧹 Cleaning up Kubernetes resources..."

CLUSTER_NAME="muchtodo-cluster"
NAMESPACE="muchtodo"

read -p "Delete entire Kind cluster? (y/n): " DELETE_CLUSTER

if [ "$DELETE_CLUSTER" = "y" ]; then
  echo "💣 Deleting Kind cluster: $CLUSTER_NAME..."
  kind delete cluster --name "$CLUSTER_NAME"
  echo "✅ Kind cluster deleted."
else
  echo "🗑️  Removing Kubernetes manifests only..."
  kubectl delete -f kubernetes/ingress.yaml --ignore-not-found
  kubectl delete -f kubernetes/backend/ --ignore-not-found
  kubectl delete -f kubernetes/mongodb/ --ignore-not-found
  kubectl delete -f kubernetes/namespace.yaml --ignore-not-found
  echo "✅ Manifests removed."
fi

echo "✅ Cleanup complete!"
