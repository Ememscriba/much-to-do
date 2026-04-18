# MuchToDo - Container Assessment

A Golang REST API containerized with Docker and deployed to Kubernetes using Kind.

## Prerequisites
- Docker v20+
- Docker Compose v2+
- Kind v0.23+
- kubectl v1.30+
- Go 1.25+
- OpenSSL

## Quick Start - Docker
Generate MongoDB keyfile then run:
  ./scripts/docker-run.sh

## Quick Start - Kubernetes
  ./scripts/k8s-deploy.sh

## Services
| Service         | URL                                      |
|-----------------|------------------------------------------|
| Backend API     | http://localhost:8080                    |
| Health Check    | http://localhost:8080/health             |
| Swagger UI      | http://localhost:8080/swagger/index.html |
| Mongo Express   | http://localhost:8081                    |
| Redis Commander | http://localhost:8082                    |
| K8s NodePort    | http://localhost:30080                   |

## API Endpoints
| Method | Endpoint       | Auth |
|--------|----------------|------|
| GET    | /health        | No   |
| POST   | /auth/register | No   |
| POST   | /auth/login    | No   |
| GET    | /tasks         | Yes  |
| POST   | /tasks         | Yes  |
| DELETE | /tasks/:id     | Yes  |
| GET    | /users/me      | Yes  |
| DELETE | /users/me      | Yes  |

## kubectl Commands
  kubectl get all -n muchtodo
  kubectl get pods -n muchtodo
  kubectl get services -n muchtodo
  kubectl logs -f deployment/muchtodo-backend -n muchtodo
