# Hostinger Tomcat Deployment Guide

Guide for deploying Vimal Agency on a Hostinger Ubuntu VPS with Tomcat 9 and Supabase PostgreSQL.

## Steps to Deploy

1. **Get the VPS Ready**:
   - Provision a Hostinger Ubuntu VPS.
   - SSH into the server and install Java 8 and Tomcat 9:
     ```bash
     sudo apt update
     sudo apt install openjdk-8-jdk tomcat9 tomcat9-admin
     ```

2. **Configure Environment Variables**:
   - Open Tomcat's service configuration file:
     ```bash
     sudo nano /etc/systemd/system/multi-user.target.wants/tomcat9.service
     ```
   - Add the Supabase environment variables under `[Service]`:
     ```ini
     Environment="SUPABASE_DB_HOST=db.xxxxxxxxxxxx.supabase.co"
     Environment="SUPABASE_DB_PORT=5432"
     Environment="SUPABASE_DB_NAME=postgres"
     Environment="SUPABASE_DB_USER=postgres"
     Environment="SUPABASE_DB_PASSWORD=your_supabase_password"
     Environment="SUPABASE_DB_SSL=require"
     ```
   - Restart Tomcat: `sudo systemctl daemon-reload && sudo systemctl restart tomcat9`

3. **Deploy the WAR File**:
   - Build WAR: `mvn clean package`
   - Upload the generated `target/vimal-agency.war` file to the `/var/lib/tomcat9/webapps/` directory as `ROOT.war`.
   - Access at `http://your-vps-ip:8080/`.
