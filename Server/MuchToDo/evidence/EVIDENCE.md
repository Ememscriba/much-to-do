# MuchToDo - Deployment Evidence

This document provides evidence of the successful containerization and Kubernetes deployment of the MuchToDo backend application as part of the Month 2 DevOps Assessment.

---

## Evidence 1: Mongo Express - MongoDB Connected and Accessible

**Description:**
This screenshot shows the Mongo Express web interface accessible at `http://localhost:8081`. Mongo Express is a lightweight web-based MongoDB admin interface configured as part of our Docker Compose setup. The interface confirms that MongoDB is running and accessible, displaying the default system databases (admin, config, local). This proves that the MongoDB container is healthy, the replica set is initialized, and the internal Docker network between containers is functioning correctly.

**How it was achieved:**
MongoDB was configured in `docker-compose.yml` with a replica set (`rs0`) and keyfile-based authentication. Mongo Express was connected to MongoDB using the internal Docker network via the connection string `mongodb://muchtodousr:Password!234@mongodb:27017/?authSource=admin&replicaSet=rs0&directConnection=true`.

![Mongo Express Dashboard](./screenshots/Screenshot_from_2026-04-17_09-08-52.png)

---

## Evidence 2: MongoDB Server Status - Active and Serving Requests

**Description:**
This screenshot shows the MongoDB Server Status page inside Mongo Express, confirming that MongoDB version 8.0.20 is running successfully inside a Docker container. Key metrics visible include:

- **Uptime:** 1200 seconds (20 minutes of stable operation)
- **MongoDB Version:** 8.0.20
- **Current Connections:** 10 (active connections from the backend and Mongo Express)
- **Total Queries:** 132 (confirming the backend API is actively querying the database)
- **Server Time:** Fri, 17 Apr 2026 08:08:20 GMT

This confirms that MongoDB is not just running but actively serving requests from the backend application.

**How it was achieved:**
The MongoDB container was started with persistent volume storage (`mongo_data`) ensuring data survives container restarts. The replica set was automatically initialized via the healthcheck command in `docker-compose.yml`. A dedicated keyfile (`mongodb.key`) was generated using OpenSSL for replica set security.

![MongoDB Server Status](./screenshots/Screenshot_from_2026-04-17_09-09-21.png)

---

## Evidence 3: Backend API Health Check via Docker Compose

**Description:**
This screenshot shows the browser accessing `http://localhost:8080/health` and receiving the JSON response `{"cache":"ok","database":"ok"}`. This is the health check endpoint of the MuchToDo Golang backend API running inside Docker Compose. The response confirms:

- **cache: ok** — Redis is connected and the caching layer is fully operational
- **database: ok** — MongoDB is connected and the database layer is fully operational

This is the most critical piece of evidence for a successful Docker deployment, proving all three services (backend, MongoDB, Redis) are running and communicating correctly through the internal Docker network.

**How it was achieved:**
The backend container was built using a multi-stage Dockerfile. Stage 1 used `golang:1.25.1-alpine` to compile the binary with `CGO_ENABLED=0` for a statically linked binary. Stage 2 used `alpine:3.19` with a non-root user (`appuser`) for security. A `docker-entrypoint.sh` script generates a `.env` file at container startup from environment variables, allowing the Golang application to read its configuration via the Viper library.

![Backend Health Check via Docker](./screenshots/Screenshot_from_2026-04-17_09-10-06.png)

---

## Evidence 4: Kubernetes Pods, Services, Ingress and Deployments

**Description:**
This screenshot shows the terminal output of multiple `kubectl` commands run against the `muchtodo` namespace in the local Kind (Kubernetes in Docker) cluster, confirming a fully successful Kubernetes deployment:

**Pods — all Running:**
- `mongodb-65b94fb4b6-trsvw` — 1/1 Running, 0 restarts
- `muchtodo-backend-759bbcfcc6-fkhbj` — 1/1 Running
- `muchtodo-backend-759bbcfcc6-pstrp` — 1/1 Running

**Services:**
- `backend-service` — NodePort type, exposing the API externally on port 30080
- `mongodb-service` — ClusterIP type, for secure internal MongoDB access only

**Ingress:**
- `muchtodo-ingress` — Nginx ingress controller configured for host `muchtodo.local` on port 80

**Deployments:**
- `mongodb` — 1/1 replica available and up-to-date
- `muchtodo-backend` — 2/2 replicas available (meeting the requirement of 2 replicas)

**API Responses via NodePort (port 30080):**
- `{"cache":"disabled","database":"ok"}` — database connectivity confirmed
- `{"message":"pong"}` — API is live and responding to requests

**How it was achieved:**
A Kind cluster was created using `kind-config.yaml` with custom port mappings. The Docker image `muchtodo-backend:latest` was built locally and loaded into the Kind cluster using `kind load docker-image`. All Kubernetes manifests were organized into `kubernetes/mongodb/` and `kubernetes/backend/` directories and applied using `kubectl apply -f`. Secrets were used for sensitive data (MongoDB credentials, JWT key) and ConfigMaps for non-sensitive configuration.

![Kubernetes Deployment Evidence](./screenshots/Screenshot_from_2026-04-18_00-52-12.png)

---

## Evidence 5: Full Stack Running — Docker Compose and Kubernetes

**Description:**
This screenshot shows the complete combined output confirming that both the Docker Compose environment and the Kubernetes cluster are simultaneously operational:

**Kubernetes cluster (`muchtodo` namespace):**
- MongoDB pod: Running for 6m24s
- 2 backend replicas: Both Running for 6m21s
- NodePort service: Exposing port 30080 to the host
- Ingress: Configured for muchtodo.local

**Docker Compose (all 5 services healthy):**
- `mongo-express` — Up 16 hours on port 8081
- `mongodb` — Up 16 hours **(healthy)** on port 27017
- `muchtodo-backend` — Up 16 hours **(healthy)** on port 8080
- `redis` — Up 16 hours **(healthy)** on port 6379
- `redis-commander` — Up 16 hours **(healthy)** on port 8082

The **(healthy)** status next to each container confirms all Docker healthchecks are passing continuously.

**How it was achieved:**
All services were orchestrated using `docker-compose.yml` with proper dependency ordering using `depends_on` with `condition: service_healthy`, ensuring MongoDB was fully initialized and healthy before the backend attempted to connect. Redis was configured with append-only file persistence (`--appendonly yes`) for data durability across restarts.

![All Services Running](./screenshots/Screenshot_from_2026-04-18_00-52-36.png)

---

## Summary

| Component | Status | Access URL |
|-----------|--------|------------|
| Docker Build | ✅ Success | — |
| Docker Compose (5 services) | ✅ All healthy | — |
| Backend API (Docker) | ✅ Running | http://localhost:8080 |
| Health Check (Docker) | ✅ cache:ok, database:ok | http://localhost:8080/health |
| MongoDB UI (Mongo Express) | ✅ Accessible | http://localhost:8081 |
| Redis UI (Redis Commander) | ✅ Accessible | http://localhost:8082 |
| Kind Kubernetes Cluster | ✅ Running | — |
| MongoDB Pod (K8s) | ✅ 1/1 Running | ClusterIP:27017 |
| Backend Pods (K8s) | ✅ 2/2 Running | http://localhost:30080 |
| Health Check (K8s) | ✅ database:ok | http://localhost:30080/health |
| Ingress | ✅ Configured | http://muchtodo.local |
