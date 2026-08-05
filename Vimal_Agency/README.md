# Vimal Agency Web Application

This repository contains the legacy Java JSP + Servlet + MySQL web application, fully transformed into a production-ready application.

## Features Added

* **Maven Build System**: Standard directory structure and dependency management.
* **Database Connection Pooling**: HikariCP handles MySQL connections efficiently.
* **Environment Variables**: No hardcoded credentials. All configuration is done via environment variables.
* **Docker Support**: Containerized web application and database.
* **CI/CD pipeline**: GitHub Actions workflow.

## Running Locally with Docker

1. Ensure Docker and Docker Compose are installed.
2. Copy `.env.example` to `.env` and adjust variables if needed.
3. Run the following command:
   ```bash
   docker-compose up -d --build
   ```
4. Access the application at `http://localhost:8080`.

## Environment Variables required

| Variable | Description | Default |
| -------- | ----------- | ------- |
| `DB_HOST` | Database Host | localhost |
| `DB_PORT` | Database Port | 3306 |
| `DB_NAME` | Database Name | vimal_agency |
| `DB_USER` | Database User | root |
| `DB_PASSWORD` | Database Password | (empty) |

## Deployment Instructions

### Platform as a Service (PaaS) - Railway / Render / Koyeb

1. **Database**: Provision a managed MySQL database on the platform.
2. **Web App**: Create a new Web Service and link this repository.
3. **Environment**: Add the environment variables listed above to the service settings.
4. **Build**: The platforms will automatically detect the Dockerfile and deploy the application.

### AWS / Google Cloud / Azure

Deploy using standard container orchestration like AWS ECS, Google Cloud Run, or Azure Container Apps by pushing the Docker image to ECR, GCR, or ACR, respectively.

### Ubuntu VPS

1. Clone the repository on the VPS.
2. Run `docker-compose up -d --build` (Make sure to update `.env`).

## Building Manually

To build the `WAR` file directly:
```bash
mvn clean package
```
The resulting `target/vimal-agency.war` can be deployed on any compatible Apache Tomcat 9+ server.
