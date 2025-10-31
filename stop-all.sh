#!/bin/bash

# Stop All Microservices Script

echo "🛑 Stopping all microservices..."

# Stop Node.js processes
if [ -f /tmp/microservices.pids ]; then
    echo "📌 Stopping services..."
    while read pid; do
        if ps -p $pid > /dev/null 2>&1; then
            kill $pid 2>/dev/null
            echo "   ✓ Stopped process $pid"
        fi
    done < /tmp/microservices.pids
    rm /tmp/microservices.pids
else
    echo "⚠️  No PID file found. Stopping by process name..."
    pkill -f "node index.js" 2>/dev/null || true
    pkill -f "npm run dev" 2>/dev/null || true
    pkill -f "next dev" 2>/dev/null || true
fi

# Stop Docker Compose
echo ""
echo "📦 Stopping Kafka containers..."
if [ -d "2-microservices-single-kafka-server/services/kafka" ]; then
    cd 2-microservices-single-kafka-server/services/kafka
    docker-compose down
    cd - > /dev/null
fi

if [ -d "3-microservices-kafka-cluster/services/kafka" ]; then
    cd 3-microservices-kafka-cluster/services/kafka
    docker-compose down
    cd - > /dev/null
fi

# Clean up log files
echo ""
echo "🧹 Cleaning up log files..."
rm -f /tmp/payment-service.log
rm -f /tmp/order-service.log
rm -f /tmp/email-service.log
rm -f /tmp/analytic-service.log
rm -f /tmp/client.log

echo ""
echo "✅ All services stopped!"
