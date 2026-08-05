# Build stage
FROM maven:3.9-eclipse-temurin-8 AS build
WORKDIR /app
COPY pom.xml .
# Download dependencies
RUN mvn dependency:go-offline
COPY src ./src
# Build WAR
RUN mvn clean package

# Run stage
FROM tomcat:9.0-jre8
# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*
# Copy the built WAR file to Tomcat webapps directory as ROOT.war
COPY --from=build /app/target/vimal-agency.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
