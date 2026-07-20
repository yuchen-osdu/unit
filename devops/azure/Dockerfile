FROM openjdk:8-jdk-alpine

EXPOSE 8080

COPY provider/unit-azure/unit-aks/target/unit-aks-1.0.0-SNAPSHOT.jar /app.jar
ENTRYPOINT ["java","-jar","/app.jar"]

