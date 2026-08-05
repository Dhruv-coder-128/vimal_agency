# Oracle Cloud VPS Deployment Guide

Oracle Cloud offers an Always Free tier that provides a generous ARM/AMD VPS instance. 

## Steps to Deploy using Docker (Recommended)

1. **Launch a Compute Instance**:
   - In Oracle Cloud Infrastructure (OCI), launch a new Ubuntu 22.04 Compute instance.
   - Configure the VCN (Virtual Cloud Network) Security List to open Ingress Port `8080`.
2. **SSH into your VPS and install Docker**:
   ```bash
   sudo apt update
   sudo apt install docker.io docker-compose -y
   sudo systemctl enable --now docker
   sudo usermod -aG docker ubuntu
   ```
3. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-username/vimal-agency.git
   cd vimal-agency
   ```
4. **Configure Environment**:
   - Copy `.env.example` to `.env` and fill out your database password.
5. **Start the Application**:
   ```bash
   docker-compose up -d --build
   ```

Your application will be live at `http://your-oracle-cloud-ip:8080`. Docker Compose automatically sets up the network between the Tomcat container and the MySQL container.
