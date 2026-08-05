# Render Deployment Guide: Vimal Agency

This guide covers the steps required to deploy the **Vimal Agency** application to [Render](https://render.com).

## 1. Prerequisites
- A Render account.
- A GitHub repository containing this project.
- A MySQL database hosted externally (Render does not provide managed MySQL). You can use providers like **Aiven**, **PlanetScale**, or **Clever Cloud**.

## 2. Infrastructure Setup (MySQL Database)
Render natively provides PostgreSQL, but this application relies on **MySQL**.
You will need to set up a MySQL database via a third-party service and obtain its connection details:
- **Host** (e.g., `mysql.external-provider.com`)
- **Port** (usually `3306`)
- **Database Name**
- **User**
- **Password**

## 3. Deploying via `render.yaml` (Infrastructure as Code)
This repository includes a `render.yaml` file, meaning you can easily deploy the application as an **Infrastructure as Code** setup.

1. In your Render Dashboard, click **New +** and select **Blueprint**.
2. Connect your GitHub repository.
3. Render will automatically read the `render.yaml` file and prepare the web service.
4. During the setup wizard, Render will prompt you to enter the values for the following environment variables.

### Environment Variables
You MUST configure the following variables in the Render Dashboard before the application can start successfully:

| Variable Name   | Description | Example Value |
|-----------------|-------------|---------------|
| `DB_HOST`       | The hostname of your external MySQL database. | `mysql.provider.com` |
| `DB_PORT`       | The port for your MySQL database. | `3306` |
| `DB_NAME`       | The name of the MySQL database. | `vimal_agency` |
| `DB_USER`       | The username to connect to MySQL. | `admin` |
| `DB_PASSWORD`   | The password to connect to MySQL. | `secretpassword` |

*(Note: The `PORT` environment variable is automatically injected by Render and dynamically picked up by Tomcat via the custom Dockerfile. You do not need to set it manually.)*

## 4. Manual Deployment (Optional)
If you prefer not to use the Blueprint:
1. In your Render Dashboard, click **New +** and select **Web Service**.
2. Connect your GitHub repository.
3. For **Environment**, select **Docker**.
4. Render will automatically build the application using the `Dockerfile` in the root of the repository.
5. In the **Environment Variables** section, manually add the `DB_*` variables listed above.

## 5. Verifications Completed
The codebase has been automatically prepared for this deployment:
- **Maven & Docker:** The `Dockerfile` uses Maven to package the WAR file and deploys it on `tomcat:9.0-jre8`.
- **Dynamic Port Binding:** Tomcat has been configured to dynamically bind to the `$PORT` assigned by Render, preventing startup crashes.
- **Dependency Management:** All MySQL and HikariCP drivers are compatible.
- **Obsolete Configs:** Older Oracle Cloud and Railway configurations have been removed to prevent conflicts.

## 6. Post-Deployment
- Wait for Render to complete the Docker build process and the container to start.
- Once the deployment shows as **Live**, click the generated Render URL (e.g., `https://vimal-agency.onrender.com`) to access your application.
- All CRUD operations, email functionality, sessions, and database queries should work seamlessly as long as the MySQL credentials are correct.
