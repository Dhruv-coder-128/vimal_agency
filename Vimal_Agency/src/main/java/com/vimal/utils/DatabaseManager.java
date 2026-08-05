package com.vimal.utils;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.sql.Connection;
import java.sql.SQLException;

public class DatabaseManager {

    private static HikariDataSource dataSource;

    static {
        try {
            // Load MySQL JDBC driver (optional in newer JDBC but good for legacy safety)
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            HikariConfig config = new HikariConfig();
            
            String dbHost = getEnvOrDefault("DB_HOST", "localhost");
            String dbPort = getEnvOrDefault("DB_PORT", "3306");
            String dbName = getEnvOrDefault("DB_NAME", "vimal_agency");
            String dbUser = getEnvOrDefault("DB_USER", "root");
            String dbPassword = getEnvOrDefault("DB_PASSWORD", "");
            
            String jdbcUrl = String.format("jdbc:mysql://%s:%s/%s?useUnicode=yes&characterEncoding=UTF-8", dbHost, dbPort, dbName);
            
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
