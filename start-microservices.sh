#!/bin/bash

# Microservices Kafka Quick Start Script
# This script helps you start all services for the microservices architecture

set -e

ARCHITECTURE=${1:-"2"}  # Default to architecture 2 (single kafka server)

if [ "$ARCHITECTURE" = "2" ]; then
    BASE_DIR="2-microservices-single-kafka-server"
    echo "🚀 Starting Single Kafka Server Architecture..."
elif [ "$ARCHITECTURE" = "3" ]; then
    BASE_DIR="3-microservices-kafka-cluster"
    echo "🚀 Starting Kafka Cluster Architecture..."
else
    echo "❌ Invalid architecture. Use: ./start.sh 2 (single kafka) or ./start.sh 3 (cluster)"
    exit 1
fi

echo ""
echo "📦 Step 1: Starting Kafka infrastructure..."
cd "$BASE_DIR/services/kafka"

# Start Docker Compose
docker-compose up -d

echo "⏳ Waiting for Kafka to be ready (30 seconds)..."
sleep 30

echo ""
echo "📝 Step 2: Creating Kafka topics..."
npm install --silent
node admin.js

echo ""
echo "✅ Kafka is ready!"
echo ""
echo "📌 Next Steps:"
echo ""
echo "Open 5 new terminal windows/tabs and run these commands:"
echo ""
echo "Terminal 1 - Payment Service:"
echo "  cd $BASE_DIR/services/payment-service && npm install && node index.js"
echo ""
echo "Terminal 2 - Order Service:"
echo "  cd $BASE_DIR/services/order-service && npm install && node index.js"
echo ""
echo "Terminal 3 - Email Service:"
echo "  cd $BASE_DIR/services/email-service && npm install && node index.js"
echo ""
echo "Terminal 4 - Analytics Service:"
echo "  cd $BASE_DIR/services/analytic-service && npm install && node index.js"
echo ""
echo "Terminal 5 - Client (Frontend):"
echo "  cd $BASE_DIR/services/client && npm install && npm run dev"
echo ""
echo "🌐 Access Points:"
echo "  - Application: http://localhost:3000"
echo "  - Kafka UI: http://localhost:8080"
echo ""
echo "🛑 To stop: docker-compose down (in the kafka directory)"
