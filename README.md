# Vimal Agency Web Application

A Java JSP + Servlet Enterprise e-commerce web application migrated from MySQL to **Supabase PostgreSQL** and containerized for deployment on **Render**.

---

## 🌟 Architecture & Features

- **Database**: PostgreSQL (Supabase) with connection pooling via HikariCP (`DatabaseManager.java`).
- **Authentication**: `UserDAO` with dual-mode password support (BCrypt hashing for new accounts & seamless legacy password upgrade).
- **Email Notifications**: JavaMail (`MailSender.java`) driven entirely by environment variables.
- **Packaging & Build**: Maven WAR build with `webResources` asset inclusion.
- **Containerization**: Multi-stage Docker build with Tomcat 9 and dynamic port binding for Render (`$PORT`).
- **Database Preserved**: All 10 tables, 76 products, historical orders, cart, promos, contact queries, and user accounts migrated to PostgreSQL syntax with sequence synchronization (`setval`).

---

## 🚀 Environment Variables

Configure the following variables in your `.env` file or in your Render environment dashboard:

### Supabase Database
| Variable | Description | Example / Default |
|---|---|---|
| `SUPABASE_DB_HOST` | Database Host | `aws-0-eu-central-1.pooler.supabase.com` |
| `SUPABASE_DB_PORT` | PostgreSQL Port | `5432` or `6543` |
| `SUPABASE_DB_NAME` | Database Name | `postgres` |
| `SUPABASE_DB_USER` | Database User | `postgres.[ref]` or `postgres` |
| `SUPABASE_DB_PASSWORD` | Database Password | *(Your Supabase Password)* |
| `SUPABASE_DB_SSL` | SSL Mode | `require` |
| `SUPABASE_JDBC_URL` | Complete JDBC URL *(optional)* | `jdbc:postgresql://host:port/postgres?sslmode=require` |

### SMTP Email Notifications
| Variable | Description | Example / Default |
|---|---|---|
| `SMTP_HOST` | SMTP Server | `smtp.gmail.com` |
| `SMTP_PORT` | SMTP Port | `587` |
| `SMTP_USER` | SMTP Username / Email | `your_email@gmail.com` |
| `SMTP_PASSWORD` | SMTP App Password | *(16-character App Password)* |
| `SMTP_AUTH` | Enable SMTP Authentication | `true` |
| `SMTP_STARTTLS` | Enable STARTTLS | `true` |

---

## 🛠️ Database Setup (Supabase)

1. Open **Supabase SQL Editor**.
2. Run [`Vimal_Agency/supabase_schema.sql`](Vimal_Agency/supabase_schema.sql) to create all 10 tables with primary keys and indexes.
3. Run [`Vimal_Agency/supabase_seed.sql`](Vimal_Agency/supabase_seed.sql) to import existing catalog products, users, orders, and synchronize sequences.

---

## 💻 Local Development

### 1. Build WAR Package with Maven
```bash
cd Vimal_Agency
mvn clean package -DskipTests
```
The output WAR will be generated at `Vimal_Agency/target/vimal-agency.war`.

### 2. Run with Docker Compose
```bash
cd Vimal_Agency
docker compose up -d --build
```
Access the application at `http://localhost:8080`.

---

## ☁️ Deployment on Render

1. Create a **Blueprint** on Render linked to this repository.
2. Render reads [`render.yaml`](render.yaml) and automatically builds the Dockerfile.
3. Fill in the Supabase and SMTP environment variables when prompted.
4. Tomcat dynamically binds to the `$PORT` environment variable and launches automatically.

See [`Vimal_Agency/docs/Supabase_Deployment.md`](Vimal_Agency/docs/Supabase_Deployment.md) and [`Vimal_Agency/docs/Render_Deployment.md`](Vimal_Agency/docs/Render_Deployment.md) for full deployment guides.
