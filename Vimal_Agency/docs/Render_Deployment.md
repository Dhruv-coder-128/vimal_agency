# Render Deployment Guide

Render is an excellent platform for deploying Dockerized applications. This project is configured to run flawlessly on Render.

## Steps to Deploy

1. **Push to GitHub**: Make sure this repository is pushed to a GitHub account connected to your Render account.
2. **Create Web Service**:
   - Go to the Render Dashboard.
   - Click **New +** > **Web Service**.
   - Select your GitHub repository.
3. **Configuration**:
   - **Name**: `vimal-agency`
   - **Environment**: `Docker` (Render will automatically detect the `Dockerfile`).
   - **Region**: Choose the closest region.
   - **Branch**: `main`
4. **Environment Variables**:
   Under the **Environment Variables** section, add the following (replace values with your managed database credentials):
   - `DB_HOST`: Your database host (e.g., provided by PlanetScale, Aiven, or Render PostgreSQL/MySQL).
   - `DB_PORT`: `3306`
   - `DB_NAME`: `vimal_agency`
   - `DB_USER`: your_db_user
   - `DB_PASSWORD`: your_db_password
5. **Deploy**:
   - Click **Create Web Service**.
   - Render will build the Maven project using the multi-stage Dockerfile and start Tomcat automatically.

Your application will be live at `https://vimal-agency.onrender.com`!
