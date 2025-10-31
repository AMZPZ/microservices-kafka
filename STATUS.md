# 🚀 Application Status

## ✅ Currently Running: Microservices Architecture (Single Kafka Server)

### 📦 Infrastructure
- **Kafka Broker**: Running (Container: kafka)
- **Kafka UI**: Running (Container: kafka-ui)

### 🔧 Microservices
- **Payment Service**: ✅ Running on port 8000
- **Order Service**: ✅ Running (Kafka consumer)
- **Email Service**: ✅ Running (Kafka consumer)
- **Analytics Service**: ✅ Running (Kafka consumer)

### 🌐 Frontend
- **Client (Next.js)**: ✅ Running on port 3000

---

## 🌐 Access URLs

- **Application**: http://localhost:3000
- **Kafka UI**: http://localhost:8080

---

## 📊 Service Details

### Payment Service
- **Port**: 8000
- **Type**: HTTP API + Kafka Producer
- **Function**: Receives payment requests via HTTP, processes payment, publishes to Kafka
- **Produces**: `payment-successful`

### Order Service  
- **Type**: Kafka Consumer + Producer
- **Function**: Listens for successful payments, creates orders
- **Consumes**: `payment-successful`
- **Produces**: `order-successful`

### Email Service
- **Type**: Kafka Consumer + Producer
- **Function**: Listens for successful orders, sends emails
- **Consumes**: `order-successful`
- **Produces**: `email-successful`

### Analytics Service
- **Type**: Kafka Consumer
- **Function**: Logs analytics for all events
- **Consumes**: `payment-successful`, `order-successful`, `email-successful`

---

## 📨 Kafka Topics

| Topic Name | Partitions | Replication Factor |
|------------|------------|-------------------|
| `payment-successful` | 1 | 1 |
| `order-successful` | 1 | 1 |
| `email-successful` | 1 | 1 |

---

## 📋 Service Logs

View real-time logs:

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

---

## 🛑 Stop All Services

To stop all services:

```bash
# Stop Node.js services
pkill -f "node index.js"
pkill -f "next dev"

# Stop Kafka containers
cd 2-microservices-single-kafka-server/services/kafka
docker-compose down

# Clean up log files
rm /tmp/*-service.log /tmp/client.log
```

Or use the provided script:

```bash
./stop-all.sh
```

---

## 🔄 Restart Services

If you need to restart:

```bash
# Stop everything first
./stop-all.sh

# Start everything again
./start-all.sh 2
```

---

## 🧪 Test the Application

1. Open http://localhost:3000 in your browser
2. Add items to cart
3. Click "Pay Now"
4. Watch the logs to see the event flow:
   - Payment Service processes payment → publishes to `payment-successful`
   - Order Service receives event → creates order → publishes to `order-successful`
   - Email Service receives event → sends email → publishes to `email-successful`
   - Analytics Service logs all events

---

## 📊 Monitor with Kafka UI

Visit http://localhost:8080 to:
- View all topics and messages
- See consumer groups
- Monitor message flow
- Check broker health

---

## ⚠️ Known Warnings

You may see these warnings in the logs (they are safe to ignore):

- `TimeoutNegativeWarning`: Related to KafkaJS timeout calculation, doesn't affect functionality
- `KafkaJS v2.0.0 switched default partitioner`: Informational warning about partitioner changes

---

## 📚 Documentation

- **Full Documentation**: See [README.md](README.md)
- **Quick Start Guide**: See [QUICK_START.md](QUICK_START.md)

---

## 🎯 Next Steps

1. ✅ All services are running
2. Try the application at http://localhost:3000
3. Monitor events in Kafka UI at http://localhost:8080
4. Check the logs to see the microservices communication

Enjoy exploring the microservices architecture! 🎉
