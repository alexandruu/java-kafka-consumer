package com.alex.kafkaconsumer;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.common.serialization.StringDeserializer;

import java.util.Properties;
import java.util.Collections;

public class KafkaConsumerApplication {

    private static final String IP = "192.168.247.131";
    private static final int PORT = 9092;
    private static final Logger logger = LogManager.getLogger(KafkaConsumerApplication.class);

    public static void main(String[] args) {
        logger.info("Consumer is connecting to: " + generateKafkaEndpoint());
        // Consumer configuration
        Properties properties = new Properties();
        properties.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, generateKafkaEndpoint()); // Kafka broker
        properties.put(ConsumerConfig.GROUP_ID_CONFIG, "my-consumer-group"); // Consumer group
        properties.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
        properties.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());

        // Create a consumer instance
        KafkaConsumer<String, String> consumer = new KafkaConsumer<>(properties);

        // Subscribe to a topic
        consumer.subscribe(Collections.singletonList("my-topic"));

        // Consume messages
        while (true) {
            consumer.poll(1000).forEach(record -> {
                // Process the record
                System.out.println("Consumed message: " + record.value());
            });
        }
    }

    private static String generateKafkaEndpoint() {
        return IP + ":" + PORT;
    }
}
