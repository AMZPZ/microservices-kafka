#!/bin/bash

# All-in-One Microservices Starter
# This script starts all services at once

set -e

ARCHITECTURE=${1:-"2"}
BASE_DIR=""

if [ "$ARCHITECTURE" = "2" ]; then
    BASE_DIR="2-microservices-single-kafka-server"
    echo "🚀 Starting Single Kafka Server Architecture..."
elif [ "$ARCHITECTURE" = "3" ]; then
    BASE_DIR="3-microservices-kafka-cluster"
    echo "🚀 Starting Kafka Cluster Architecture..."
else
    echo "❌ Invalid architecture. Use: ./start-all.sh 2 or ./start-all.sh 3"
    exit 1
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo ""
echo "📦 Step 1/6: Starting Kafka infrastructure..."
cd "$BASE_DIR/services/kafka"
docker-compose up -d

echo "⏳ Waiting for Kafka to be ready (30 seconds)..."
sleep 30

echo ""
echo "📝 Step 2/6: Installing Kafka dependencies and creating topics..."
npm install --silent
node admin.js

echo ""
echo "🔧 Step 3/6: Installing and starting Payment Service..."
cd "$SCRIPT_DIR/$BASE_DIR/services/payment-service"
npm install --silent
node index.js > /tmp/payment-service.log 2>&1 &
PAYMENT_PID=$!
echo "   ✓ Payment Service started (PID: $PAYMENT_PID)"

echo ""
echo "🔧 Step 4/6: Installing and starting Order Service..."
cd "$SCRIPT_DIR/$BASE_DIR/services/order-service"
npm install --silent
node index.js > /tmp/order-service.log 2>&1 &
ORDER_PID=$!
echo "   ✓ Order Service started (PID: $ORDER_PID)"

echo ""
echo "🔧 Step 5/6: Installing and starting Email Service..."
cd "$SCRIPT_DIR/$BASE_DIR/services/email-service"
npm install --silent
node index.js > /tmp/email-service.log 2>&1 &
EMAIL_PID=$!
echo "   ✓ Email Service started (PID: $EMAIL_PID)"

echo ""
echo "🔧 Step 6/6: Installing and starting Analytics Service..."
cd "$SCRIPT_DIR/$BASE_DIR/services/analytic-service"
npm install --silent
node index.js > /tmp/analytic-service.log 2>&1 &
ANALYTICS_PID=$!
echo "   ✓ Analytics Service started (PID: $ANALYTICS_PID)"

echo ""
echo "🌐 Step 7/6: Installing and starting Client (Frontend)..."
cd "$SCRIPT_DIR/$BASE_DIR/services/client"
npm install --silent
npm run dev > /tmp/client.log 2>&1 &
CLIENT_PID=$!
echo "   ✓ Client started (PID: $CLIENT_PID)"

# Save PIDs to a file for easy stopping
echo "$PAYMENT_PID" > /tmp/microservices.pids
echo "$ORDER_PID" >> /tmp/microservices.pids
echo "$EMAIL_PID" >> /tmp/microservices.pids
echo "$ANALYTICS_PID" >> /tmp/microservices.pids
echo "$CLIENT_PID" >> /tmp/microservices.pids

echo ""
echo "✅ All services started successfully!"
echo ""
echo "🌐 Access Points:"
echo "  - Application: http://localhost:3000"
echo "  - Kafka UI: http://localhost:8080"
echo ""
echo "📋 Service Logs:"
echo "  - Payment Service: tail -f /tmp/payment-service.log"
echo "  - Order Service: tail -f /tmp/order-service.log"
echo "  - Email Service: tail -f /tmp/email-service.log"
echo "  - Analytics Service: tail -f /tmp/analytic-service.log"
echo "  - Client: tail -f /tmp/client.log"
echo ""
echo "🛑 To stop all services, run: ./stop-all.sh"
echo ""
