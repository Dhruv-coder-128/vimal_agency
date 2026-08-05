# Hostinger Tomcat Deployment Guide

Hostinger provides reliable VPS hosting, which is perfect for traditional Java applications running on Tomcat.

## Steps to Deploy

1. **Get the VPS Ready**:
   - Provision a Hostinger Ubuntu VPS.
   - SSH into the server and install Java 8 and Tomcat 9:
     ```bash
     sudo apt update
     sudo apt install openjdk-8-jdk tomcat9 tomcat9-admin
     ```
2. **Install MySQL**:
   - Install MySQL server on the VPS:
     ```bash
     sudo apt install mysql-server
     ```
   - Create the `vimal_agency` database and user.
3. **Configure Environment Variables**:
   - Open Tomcat's service configuration file:
     ```bash
     sudo nano /etc/systemd/system/multi-user.target.wants/tomcat9.service
     ```
   - Add the following environment variables under `[Service]`:
     ```ini
     Environment="DB_HOST=localhost"
     Environment="DB_PORT=3306"
     Environment="DB_NAME=vimal_agency"
     Environment="DB_USER=root"
     Environment="DB_PASSWORD=your_password"
     ```
   - Restart Tomcat: `sudo systemctl daemon-reload && sudo systemctl restart tomcat9`
4. **Deploy the WAR File**:
   - Upload the generated `target/vimal-agency.war` file to the `/var/lib/tomcat9/webapps/` directory on your Hostinger VPS.
   - You can rename it to `ROOT.war` so the application runs at the root domain (`http://your-vps-ip:8080/`).
