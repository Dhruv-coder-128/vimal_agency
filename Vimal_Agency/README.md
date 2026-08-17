# Vimal Agency Web Application

Production-ready Java JSP + Servlet web application migrated to **Supabase PostgreSQL** and **Render** cloud deployment.

---

## 🌟 Features

* **Runtime**: Java 8 / Apache Tomcat 9
* **Database Engine**: Supabase PostgreSQL 15+ (PostgreSQL JDBC Driver + HikariCP Connection Pooling)
* **Security & Authentication**: BCrypt salted hashing (`jbcrypt`) with transparent legacy plaintext auto-upgrading
* **Build System**: Apache Maven with multi-stage Docker build
* **Cloud Ready**: Render Infrastructure-as-Code (`render.yaml`), dynamic `$PORT` Tomcat integration

---

## ⚙️ Environment Variables

| Variable | Description | Default / Example |
|---|---|---|
| `SUPABASE_DB_HOST` | Database Hostname | `db.xxxxxxxxxxxx.supabase.co` |
| `SUPABASE_DB_PORT` | Database Port | `5432` / `6543` |
| `SUPABASE_DB_NAME` | Database Name | `postgres` |
| `SUPABASE_DB_USER` | Database User | `postgres` |
| `SUPABASE_DB_PASSWORD` | Database Password | `your_db_password` |
| `SUPABASE_DB_SSL` | SSL Mode | `require` |
| `SUPABASE_JDBC_URL` | *(Optional direct URL)* | `jdbc:postgresql://...` |

---

## 🚀 Running Locally with Docker

1. Ensure Docker and Docker Compose are installed.
2. Copy `.env.example` to `.env` and adjust variables if needed.
3. Run the following command:
   ```bash
   docker-compose up -d --build
   ```
4. Access the application at `http://localhost:8080`.

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
