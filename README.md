# Microservices with Kafka.js

This repository demonstrates the evolution of a monolithic application to a microservices architecture using Apache Kafka for event-driven communication.

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture Variants](#architecture-variants)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Quick Start](#quick-start)
- [Running Each Architecture](#running-each-architecture)
- [Services Overview](#services-overview)
- [Kafka Topics](#kafka-topics)
- [Troubleshooting](#troubleshooting)

## 🎯 Overview

This project showcases three different architectural approaches for building an e-commerce order processing system:

1. **Monolithic Architecture** - Traditional single-server application
2. **Microservices with Single Kafka Server** - Distributed services with one Kafka broker
3. **Microservices with Kafka Cluster** - Distributed services with high-availability Kafka cluster (3 brokers)

## 🏗️ Architecture Variants

### 1. Without Microservices (Monolithic)
- Single backend server handling all operations
- Direct function calls for payment, order, email, and analytics
- Frontend communicates directly with one backend

### 2. Microservices with Single Kafka Server
- Services: Order, Payment, Email, Analytics
- Single Kafka broker for message distribution
- Event-driven communication between services
- Kafka UI for monitoring

### 3. Microservices with Kafka Cluster
- Same services as variant 2
- 3-node Kafka cluster for high availability
- Fault tolerance and better scalability
- Kafka UI for monitoring all brokers

## ✅ Prerequisites

Before running this application, ensure you have the following installed:

- **Node.js** (v18 or higher)
- **npm** or **yarn**
- **Docker** and **Docker Compose**
- **Git**

Check your installations:
```bash
node --version
npm --version
docker --version
docker-compose --version
```

## 📁 Project Structure

```
safak-microservice-kafka-js/
├── 1-without-microservices/
│   ├── backend/
│   │   ├── index.js              # Main server
│   │   ├── db.js                 # Database operations
│   │   ├── middleware/auth.js    # Authentication
│   │   └── package.json
│   └── frontend/
│       ├── src/
│       └── package.json
│
├── 2-microservices-single-kafka-server/
│   └── services/
│       ├── kafka/
│       │   ├── docker-compose.yml  # Single Kafka broker
│       │   └── admin.js            # Kafka admin setup
│       ├── order-service/
│       ├── payment-service/
│       ├── email-service/
│       ├── analytic-service/
│       └── client/                 # Frontend
│
└── 3-microservices-kafka-cluster/
    └── services/
        ├── kafka/
        │   ├── docker-compose.yml  # 3-broker cluster
        │   └── admin.js
        ├── order-service/
        ├── payment-service/
        ├── email-service/
        ├── analytic-service/
        └── client/                 # Frontend
```

## 🚀 Quick Start

Choose one of the three architectures to run:

### Option A: Monolithic (Fastest Setup)

```bash
# 1. Navigate to the monolithic backend
cd 1-without-microservices/backend

# 2. Install dependencies
npm install

# 3. Start backend server
node index.js

# 4. In a new terminal, start frontend
cd ../frontend
npm install
npm run dev
```

Access the application at `http://localhost:3000`

### Option B: Single Kafka Server (Recommended for Learning)

```bash
# 1. Start Kafka
cd 2-microservices-single-kafka-server/services/kafka
docker-compose up -d

# 2. Wait ~30 seconds for Kafka to be ready
# Then create topics
npm install
node admin.js

# 3. Start all services (each in a new terminal)
# Terminal 1 - Payment Service
cd ../payment-service
npm install
node index.js

# Terminal 2 - Order Service
cd ../order-service
npm install
node index.js

# Terminal 3 - Email Service
cd ../email-service
npm install
node index.js

# Terminal 4 - Analytics Service
cd ../analytic-service
npm install
node index.js

# Terminal 5 - Client/Frontend
cd ../client
npm install
npm run dev
```

Access:
- Application: `http://localhost:3000`
- Kafka UI: `http://localhost:8080`

### Option C: Kafka Cluster (Production-Ready)

```bash
# Same as Option B, but use 3-microservices-kafka-cluster directory
cd 3-microservices-kafka-cluster/services/kafka
docker-compose up -d

# Follow the same steps as Option B for services
```

## 📦 Running Each Architecture

### 1️⃣ Monolithic Architecture

**Backend (Port 8000):**
```bash
cd 1-without-microservices/backend
npm install
node index.js
```

**Frontend (Port 3000):**
```bash
cd 1-without-microservices/frontend
npm install
npm run dev
```

### 2️⃣ Single Kafka Server Architecture

**Step 1: Start Kafka Infrastructure**
```bash
cd 2-microservices-single-kafka-server/services/kafka
docker-compose up -d

# Verify Kafka is running
docker ps
```

**Step 2: Create Kafka Topics**
```bash
# Still in the kafka directory
npm install
node admin.js
```

**Step 3: Start Microservices**

Open 4 new terminal windows/tabs:

```bash
# Terminal 1 - Payment Service
cd 2-microservices-single-kafka-server/services/payment-service
npm install
node index.js

# Terminal 2 - Order Service
cd 2-microservices-single-kafka-server/services/order-service
npm install
node index.js

# Terminal 3 - Email Service
cd 2-microservices-single-kafka-server/services/email-service
npm install
node index.js

# Terminal 4 - Analytics Service
cd 2-microservices-single-kafka-server/services/analytic-service
npm install
node index.js
```

**Step 4: Start Frontend**
```bash
# Terminal 5
cd 2-microservices-single-kafka-server/services/client
npm install
npm run dev
```

### 3️⃣ Kafka Cluster Architecture

Same steps as Single Kafka Server, but use `3-microservices-kafka-cluster` directory:

```bash
cd 3-microservices-kafka-cluster/services/kafka
docker-compose up -d
npm install
node admin.js

# Then start all services as shown above
```

## 🔧 Services Overview

### Payment Service
- **Port**: N/A (Kafka consumer/producer)
- **Function**: Processes payments and publishes payment-successful events
- **Consumes**: `payment-request`
- **Produces**: `payment-successful`

### Order Service
- **Port**: N/A (Kafka consumer/producer)
- **Function**: Creates orders after successful payment
- **Consumes**: `payment-successful`
- **Produces**: `order-successful`

### Email Service
- **Port**: N/A (Kafka consumer/producer)
- **Function**: Sends confirmation emails to users
- **Consumes**: `order-successful`
- **Produces**: `email-sent`

### Analytics Service
- **Port**: N/A (Kafka consumer)
- **Function**: Logs analytics for all events
- **Consumes**: `payment-successful`, `order-successful`, `email-sent`

### Client (Frontend)
- **Port**: 3000
- **Tech**: Next.js, React, TailwindCSS
- **Function**: User interface for placing orders

## 📨 Kafka Topics

| Topic Name | Producer | Consumer |
|------------|----------|----------|
| `payment-request` | Client | Payment Service |
| `payment-successful` | Payment Service | Order Service, Analytics Service |
| `order-successful` | Order Service | Email Service, Analytics Service |
| `email-sent` | Email Service | Analytics Service |

## 🐛 Troubleshooting

### Kafka not starting
```bash
# Stop all containers
docker-compose down

# Remove volumes and restart
docker-compose down -v
docker-compose up -d

# Check logs
docker logs kafka
# or for cluster:
docker logs kafka-broker-1
```

### Services can't connect to Kafka
```bash
# Ensure Kafka is fully started (wait 30-60 seconds)
docker ps

# Verify Kafka is listening
docker exec -it kafka kafka-topics.sh --list --bootstrap-server localhost:9092
```

### Port already in use
```bash
# Find process using port (e.g., 8080)
lsof -i :8080

# Kill the process
kill -9 <PID>
```

### Reset everything
```bash
# Stop all services (Ctrl+C in each terminal)

# Stop Docker containers
cd services/kafka  # or appropriate kafka directory
docker-compose down -v

# Clean up
docker system prune -f
```

## 🔍 Monitoring

### Kafka UI
Access Kafka UI at `http://localhost:8080` to:
- View topics and messages
- Monitor consumer groups
- Check broker health
- Inspect message content

### Service Logs
Each service logs to console. Watch for:
- ✅ Connection successful messages
- ⚠️ Error messages
- 📊 Event processing confirmations

## 🎓 Learning Path

1. **Start with Monolithic** - Understand the business logic
2. **Move to Single Kafka** - Learn event-driven architecture
3. **Scale to Cluster** - Understand high availability

## 📝 API Endpoints

### Monolithic Backend
```
POST http://localhost:8000/order
Headers:
  Content-Type: application/json
  Authorization: Bearer <token>
Body:
  {
    "cart": [
      { "id": 1, "name": "Product", "price": 100 }
    ]
  }
```

### Microservices (via Frontend)
The frontend (localhost:3000) handles the order submission through Kafka events.

## 🛑 Stopping the Application

### Monolithic
- Press `Ctrl+C` in backend and frontend terminals

### Microservices
```bash
# Stop all service processes (Ctrl+C in each terminal)

# Stop Kafka
cd services/kafka
docker-compose down

# To remove volumes as well
docker-compose down -v
```

## 🤝 Contributing

This is a learning project. Feel free to experiment and modify!

## 📄 License

ISC

## 🙏 Credits

This project demonstrates microservices patterns with Apache Kafka and Node.js.
