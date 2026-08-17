# Render Deployment Guide: Vimal Agency

This guide covers deploying the **Vimal Agency** application to [Render](https://render.com) connected to **Supabase PostgreSQL**.

---

## 1. Architecture Overview
- **Runtime**: Tomcat 9 on Eclipse Temurin Java 8 container.
- **Database**: Supabase PostgreSQL 15+ (accessed via PostgreSQL JDBC & HikariCP pool).
- **Security**: BCrypt salted password hashing with legacy upgrade path.
- **Port Binding**: Dynamic `$PORT` injection into Tomcat `server.xml`.

---

## 2. Prerequisites
1. A [Render](https://render.com) account.
2. A [Supabase](https://supabase.com) project with schema and seed executed.
3. Your GitHub repository containing this codebase.

---

## 3. Deploying via `render.yaml` (Blueprint / Infrastructure as Code)

1. In Render Dashboard, click **New +** -> **Blueprint**.
2. Select your connected GitHub repository (`vimal_agency`).
3. Render reads `render.yaml` and provisions the Web Service `vimal-agency`.
4. Enter the required environment variables during the setup wizard:

### Environment Variables Reference

| Variable Name | Description | Example / Recommended |
|---|---|---|
| `SUPABASE_DB_HOST` | Supabase DB Host | `db.xxxxxxxxxxxx.supabase.co` |
| `SUPABASE_DB_PORT` | Supabase DB Port | `5432` (direct) or `6543` (pooler) |
| `SUPABASE_DB_NAME` | Database Name | `postgres` |
| `SUPABASE_DB_USER` | Database User | `postgres` (or `postgres.projectref`) |
| `SUPABASE_DB_PASSWORD` | Database Password | `your_db_password` |
| `SUPABASE_DB_SSL` | SSL Mode | `require` |
| `SUPABASE_JDBC_URL` | *(Optional direct URL)* | `jdbc:postgresql://...` |

---

## 4. Manual Deployment via Web Service (Alternative)

1. In Render Dashboard, click **New +** -> **Web Service**.
2. Select **Build and deploy from a Git repository**.
3. Set **Root Directory** to `Vimal_Agency` (or repository root).
4. Set **Environment** to `Docker`.
5. Under **Environment Variables**, add the `SUPABASE_*` variables listed above.
6. Click **Create Web Service**.

---

## 5. Post-Deployment Verification
1. Open the generated Render URL (e.g. `https://vimal-agency.onrender.com`).
2. Log in using test admin credentials:
   - **Admin**: `admin@vimal.com` / `admin123`
3. Verify customer catalog, cart additions, orders, admin console, and feedback forms.
