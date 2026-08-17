# Build stage
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
# Download dependencies
RUN mvn dependency:go-offline
COPY src ./src
# Build WAR
RUN mvn clean package

# Run stage
FROM tomcat:9.0-jre17-temurin
# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*
# Copy the built WAR file to Tomcat webapps directory as ROOT.war
COPY --from=build /app/target/vimal-agency.war /usr/local/tomcat/webapps/ROOT.war

# Render provides the PORT environment variable
ENV PORT=8080

# Modify Tomcat server.xml to use the PORT environment variable before starting
CMD sed -i "s/port=\"8080\"/port=\"${PORT}\"/g" /usr/local/tomcat/conf/server.xml && catalina.sh run
