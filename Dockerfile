#docker build -t kafka-consumer:1.0

FROM ubuntu:latest

ENV JAVA_VERSION=17
ENV APP_NAME=kafka-consumer-1.0-SNAPSHOT.jar

RUN apt-get update && \
    apt-get install -y wget && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:openjdk-r/ppa && \
    apt-get update && \
    apt-get install -y openjdk-17-jdk && \
    apt-get install -y maven && \
    rm -rf /var/lib/apt/lists/*
    
RUN java -version
RUN mvn -version

WORKDIR /app

COPY . /app/

RUN mvn clean install
RUN mvn dependency:copy-dependencies 

EXPOSE 8080 9092

CMD ["/bin/sh", "-c", "java -cp /app/target/$APP_NAME:$(mvn dependency:build-classpath -Dmdep.outputFile=/dev/stdout -q -B) com.alex.consumer.Consumer"]