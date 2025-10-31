# Quick Start Guide

## Choose Your Architecture

This project has 3 different architectures you can run:

### 🏃 Fastest Way to Run

#### Option 1: Monolithic (Simplest)
```bash
# Terminal 1 - Backend
cd 1-without-microservices/backend
npm install
node index.js

# Terminal 2 - Frontend
cd 1-without-microservices/frontend
npm install
npm run dev
```
Then visit: http://localhost:3000

---

#### Option 2: Microservices with Single Kafka (Recommended)
```bash
# Run this one command:
./start-all.sh 2

# Wait about 60 seconds for everything to start
# Then visit: http://localhost:3000
```

To stop:
```bash
./stop-all.sh
```

---

#### Option 3: Microservices with Kafka Cluster (Production-like)
```bash
# Run this one command:
./start-all.sh 3

# Wait about 60 seconds for everything to start
# Then visit: http://localhost:3000
```

To stop:
```bash
./stop-all.sh
```

---

## 🔍 View Logs

While services are running:
```bash
# Payment Service
tail -f /tmp/payment-service.log

# Order Service
tail -f /tmp/order-service.log

# Email Service
tail -f /tmp/email-service.log

# Analytics Service
tail -f /tmp/analytic-service.log

# Frontend
tail -f /tmp/client.log
```

## 🌐 URLs

- **Application**: http://localhost:3000
- **Kafka UI**: http://localhost:8080 (microservices only)

## 🐛 Troubleshooting

If something goes wrong:

```bash
# Stop everything
./stop-all.sh

# Remove all Docker volumes
cd 2-microservices-single-kafka-server/services/kafka
docker-compose down -v

# Try again
cd ../../..
./start-all.sh 2
```

## 📚 Full Documentation

See [README.md](README.md) for complete documentation.
