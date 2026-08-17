package com.vimal.utils;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseManager {

    private static volatile HikariDataSource dataSource = null;
    private static final Object LOCK = new Object();

    private static HikariDataSource getDataSource() {
        if (dataSource == null) {
            synchronized (LOCK) {
                if (dataSource == null) {
                    try {
                        Class.forName("org.postgresql.Driver");

                        HikariConfig config = new HikariConfig();
                        config.setDriverClassName("org.postgresql.Driver");

                        String jdbcUrl = getEnv("SUPABASE_JDBC_URL", "DATABASE_URL", "JDBC_DATABASE_URL");
                        
                        if (jdbcUrl != null && !jdbcUrl.isEmpty()) {
                            if (jdbcUrl.startsWith("postgres://")) {
                                jdbcUrl = "jdbc:postgresql://" + jdbcUrl.substring("postgres://".length());
                            } else if (jdbcUrl.startsWith("postgresql://")) {
                                jdbcUrl = "jdbc:postgresql://" + jdbcUrl.substring("postgresql://".length());
                            }
                            if (!jdbcUrl.contains("sslmode=")) {
                                jdbcUrl += (jdbcUrl.contains("?") ? "&" : "?") + "sslmode=" + getEnvOrDefault("SUPABASE_DB_SSL", "require");
                            }
                            config.setJdbcUrl(jdbcUrl);
                        } else {
                            String dbHost = getEnvOrDefault("SUPABASE_DB_HOST", getEnvOrDefault("DB_HOST", "localhost"));
                            String dbPort = getEnvOrDefault("SUPABASE_DB_PORT", getEnvOrDefault("DB_PORT", "5432"));
                            String dbName = getEnvOrDefault("SUPABASE_DB_NAME", getEnvOrDefault("DB_NAME", "postgres"));
                            String sslMode = getEnvOrDefault("SUPABASE_DB_SSL", "require");
                            String constructedUrl = String.format("jdbc:postgresql://%s:%s/%s?sslmode=%s", dbHost, dbPort, dbName, sslMode);
                            config.setJdbcUrl(constructedUrl);
                        }

                        String dbUser = getEnvOrDefault("SUPABASE_DB_USER", getEnvOrDefault("DB_USER", "postgres"));
                        String dbPassword = getEnvOrDefault("SUPABASE_DB_PASSWORD", getEnvOrDefault("DB_PASSWORD", ""));

                        config.setUsername(dbUser);
                        config.setPassword(dbPassword);

                        // Connection Pool settings
                        config.setMaximumPoolSize(10);
                        config.setMinimumIdle(2);
                        config.setIdleTimeout(30000);
                        config.setMaxLifetime(1800000);
                        config.setConnectionTimeout(30000);
                        config.setInitializationFailTimeout(-1);

                        dataSource = new HikariDataSource(config);
                        System.out.println("[DatabaseManager] HikariCP PostgreSQL pool initialized successfully.");
                    } catch (Exception e) {
                        System.err.println("[DatabaseManager] Error initializing HikariCP connection pool: " + e.getMessage());
                        e.printStackTrace();
                        throw new RuntimeException("Database pool initialization error: " + e.getMessage(), e);
                    }
                }
            }
        }
        return dataSource;
    }

    private static String getEnv(String... keys) {
        for (String key : keys) {
            String val = System.getenv(key);
            if (val != null && !val.trim().isEmpty()) {
                return val.trim();
            }
        }
        return null;
    }

    private static String getEnvOrDefault(String key, String defaultValue) {
        String value = System.getenv(key);
        return (value != null && !value.trim().isEmpty()) ? value.trim() : defaultValue;
    }

    public static Connection getConnection() throws SQLException {
        try {
            HikariDataSource ds = getDataSource();
            if (ds != null) {
                return ds.getConnection();
            }
        } catch (Exception e) {
            System.err.println("[DatabaseManager] Pool getConnection() failed: " + e.getMessage() + ". Attempting direct DriverManager fallback...");
        }

        // Direct JDBC connection fallback
        try {
            Class.forName("org.postgresql.Driver");
            String host = getEnvOrDefault("SUPABASE_DB_HOST", getEnvOrDefault("DB_HOST", "localhost"));
            String port = getEnvOrDefault("SUPABASE_DB_PORT", getEnvOrDefault("DB_PORT", "5432"));
            String name = getEnvOrDefault("SUPABASE_DB_NAME", getEnvOrDefault("DB_NAME", "postgres"));
            String ssl = getEnvOrDefault("SUPABASE_DB_SSL", "require");
            String url = String.format("jdbc:postgresql://%s:%s/%s?sslmode=%s", host, port, name, ssl);
            String user = getEnvOrDefault("SUPABASE_DB_USER", getEnvOrDefault("DB_USER", "postgres"));
            String pass = getEnvOrDefault("SUPABASE_DB_PASSWORD", getEnvOrDefault("DB_PASSWORD", ""));
            return DriverManager.getConnection(url, user, pass);
        } catch (Exception directEx) {
            System.err.println("[DatabaseManager] Direct DriverManager connection failed: " + directEx.getMessage());
            if (directEx instanceof SQLException) {
                throw (SQLException) directEx;
            }
            throw new SQLException("Failed to establish database connection: " + directEx.getMessage(), directEx);
        }
    }
}
