package com.vimal.utils;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.sql.Connection;
import java.sql.SQLException;

public class DatabaseManager {

    private static HikariDataSource dataSource;

    static {
        try {
            // Load PostgreSQL JDBC driver
            Class.forName("org.postgresql.Driver");
            
            HikariConfig config = new HikariConfig();
            
            String jdbcUrl = getEnvOrDefault("SUPABASE_JDBC_URL", "");
            if (jdbcUrl.isEmpty()) {
                String dbHost = getEnvOrDefault("SUPABASE_DB_HOST", "localhost");
                String dbPort = getEnvOrDefault("SUPABASE_DB_PORT", "5432");
                String dbName = getEnvOrDefault("SUPABASE_DB_NAME", "postgres");
                String sslMode = getEnvOrDefault("SUPABASE_DB_SSL", "require");
                jdbcUrl = String.format("jdbc:postgresql://%s:%s/%s?sslmode=%s", dbHost, dbPort, dbName, sslMode);
            }
            
            String dbUser = getEnvOrDefault("SUPABASE_DB_USER", "postgres");
            String dbPassword = getEnvOrDefault("SUPABASE_DB_PASSWORD", "");
            
            config.setJdbcUrl(jdbcUrl);
            config.setUsername(dbUser);
            config.setPassword(dbPassword);
            
            // Connection Pool settings
            config.setMaximumPoolSize(10);
            config.setMinimumIdle(2);
            config.setIdleTimeout(30000);
            config.setMaxLifetime(1800000);
            config.setConnectionTimeout(30000);
            
            dataSource = new HikariDataSource(config);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error initializing HikariCP connection pool.", e);
        }
    }

    private static String getEnvOrDefault(String key, String defaultValue) {
        String value = System.getenv(key);
        return (value != null && !value.trim().isEmpty()) ? value : defaultValue;
    }

    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }
}
