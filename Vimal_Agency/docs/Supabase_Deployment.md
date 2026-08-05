# Supabase Deployment Guide

This document outlines the final steps to connect your migrated application to Supabase.

## 1. Supabase Project Setup
1. Log into your [Supabase Dashboard](https://supabase.com).
2. Create a new Project.
3. Retrieve your **Database Connection Details**:
   - Host
   - Database Name (`postgres`)
   - Port (`5432` or `6543` for connection pooling)
   - User
   - Password

## 2. Setting Up the Schema
1. Open the Supabase **SQL Editor**.
2. Copy the contents of the `schema.sql` file generated during this migration.
3. Run the SQL script to create all PostgreSQL-compatible tables.

## 3. Migrating Data
1. Use the `data_migration.md` guide to seed your database or use Supabase's `pgloader` integration for a fully automated migration.

## 4. Render Blueprint Configuration
The `render.yaml` file has been automatically updated. When you deploy or redeploy via Render, it will prompt you for the following environment variables:
- `SUPABASE_DB_HOST`
- `SUPABASE_DB_PORT`
- `SUPABASE_DB_NAME`
- `SUPABASE_DB_USER`
- `SUPABASE_DB_PASSWORD`
- `SUPABASE_DB_SSL` (Recommended: `require`)

Ensure these values accurately match your Supabase Database Settings.

Once you enter these details on Render, your web service will instantly connect to Supabase over PostgreSQL using HikariCP pooling. No further manual configuration is needed.
