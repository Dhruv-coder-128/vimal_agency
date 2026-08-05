# Railway Deployment Guide

Railway provides seamless Docker deployment with integrated MySQL databases.

## Steps to Deploy

1. **Create Project**:
   - Go to [Railway.app](https://railway.app).
   - Click **New Project** > **Deploy from GitHub repo**.
   - Select the `vimal-agency` repository.
2. **Add MySQL Database**:
   - Click **+ New** in your Railway project canvas.
   - Select **Database** > **Add MySQL**.
   - Railway will provision a MySQL instance.
3. **Link Database to Web Service**:
   - Click on your Web Service (the GitHub repo).
   - Go to the **Variables** tab.
   - Click **New Variable** and map them to the MySQL variables provided by Railway:
     - `DB_HOST` = `${{ MySQL.MYSQLHOST }}`
     - `DB_PORT` = `${{ MySQL.MYSQLPORT }}`
     - `DB_NAME` = `${{ MySQL.MYSQLDATABASE }}`
     - `DB_USER` = `${{ MySQL.MYSQLUSER }}`
     - `DB_PASSWORD` = `${{ MySQL.MYSQLPASSWORD }}`
4. **Deploy**:
   - Railway will automatically detect the `Dockerfile`, build the Java WAR file, and launch Tomcat.
   - Go to the **Settings** tab of the Web Service and click **Generate Domain** to get a public URL.
