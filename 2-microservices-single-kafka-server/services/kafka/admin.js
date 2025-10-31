import { Kafka } from "kafkajs";

const kafka = new Kafka({
  clientId: "kafka-service",
  brokers: ["localhost:9094"],
});

const admin = kafka.admin();

const run = async () => {
  try {
    await admin.connect();
    console.log("Connected to Kafka");
    
    await admin.createTopics({
      topics: [
        { topic: "payment-successful", numPartitions: 1, replicationFactor: 1 },
        { topic: "order-successful", numPartitions: 1, replicationFactor: 1 },
        { topic: "email-successful", numPartitions: 1, replicationFactor: 1 },
      ],
    });
    
    console.log("Topics created successfully!");
    
    await admin.disconnect();
    console.log("Disconnected from Kafka");
  } catch (error) {
    console.error("Error:", error);
    process.exit(1);
  }
};

run();
