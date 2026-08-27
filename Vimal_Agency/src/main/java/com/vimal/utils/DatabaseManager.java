package com.vimal.utils;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Centralized Database Connection Manager for PostgreSQL / Supabase.
 * Reads configuration from Environment Variables (Render/Docker)
 * with fallback to application.properties and direct DriverManager connection.
 */
public class DatabaseManager {

    private static volatile HikariDataSource dataSource = null;
    private static final Object LOCK = new Object();
    private static final Properties cachedProperties = new Properties();
    private static boolean propertiesLoaded = false;

    static {
        loadProperties();
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("[DatabaseManager] FATAL: PostgreSQL JDBC Driver (org.postgresql.Driver) not found in classpath!");
        }
    }

    /**
     * Loads application.properties from classpath or working directory.
     */
    private static synchronized void loadProperties() {
        if (propertiesLoaded) return;
        try (InputStream is = DatabaseManager.class.getClassLoader().getResourceAsStream("application.properties")) {
            if (is != null) {
                cachedProperties.load(is);
            } else {
                File file = new File("application.properties");
                if (file.exists()) {
                    try (FileInputStream fis = new FileInputStream(file)) {
                        cachedProperties.load(fis);
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("[DatabaseManager] Note: Could not load application.properties (" + e.getMessage() + "), using environment variables.");
        } finally {
            propertiesLoaded = true;
        }
    }

    /**
     * Resolves value from environment variables, system properties, or application.properties.
     * Also handles placeholder format like ${VAR_NAME:defaultValue}.
     */
    private static String resolveConfig(String envKey, String propKey, String defaultValue) {
        // 1. Check System Environment Variable
        String val = System.getenv(envKey);
        if (val != null && !val.trim().isEmpty()) {
            return val.trim();
        }

        // 2. Check Java System Property
        val = System.getProperty(envKey);
        if (val != null && !val.trim().isEmpty()) {
            return val.trim();
        }

        // 3. Check application.properties
        if (propKey != null) {
            val = cachedProperties.getProperty(propKey);
            if (val != null && !val.trim().isEmpty()) {
                val = val.trim();
                // Handle placeholder format: ${VAR:default}
                if (val.startsWith("${") && val.endsWith("}")) {
                    String inside = val.substring(2, val.length() - 1);
                    String vName = inside;
                    String vDefault = defaultValue;
                    if (inside.contains(":")) {
                        int colonIdx = inside.indexOf(":");
                        vName = inside.substring(0, colonIdx);
                        vDefault = inside.substring(colonIdx + 1);
                    }
                    String envVal = System.getenv(vName);
                    if (envVal != null && !envVal.trim().isEmpty()) {
                        return envVal.trim();
                    }
                    return vDefault;
                }
                return val;
            }
        }

        return defaultValue;
    }

    /**
     * Retrieves or initializes the HikariCP DataSource.
     */
    private static HikariDataSource getDataSource() {
        if (dataSource == null) {
            synchronized (LOCK) {
                if (dataSource == null) {
                    try {
                        Class.forName("org.postgresql.Driver");

                        HikariConfig config = new HikariConfig();
                        config.setDriverClassName("org.postgresql.Driver");

                        String jdbcUrl = System.getenv("SUPABASE_JDBC_URL");
                        if (jdbcUrl == null || jdbcUrl.trim().isEmpty()) {
                            jdbcUrl = System.getenv("DATABASE_URL");
                        }
                        if (jdbcUrl == null || jdbcUrl.trim().isEmpty()) {
                            jdbcUrl = System.getenv("JDBC_DATABASE_URL");
                        }

                        String sslMode = resolveConfig("SUPABASE_DB_SSL", "supabase.db.ssl", "require");
                        String dbUser = resolveConfig("SUPABASE_DB_USER", "supabase.db.user", "postgres");
                        String dbPassword = resolveConfig("SUPABASE_DB_PASSWORD", "supabase.db.password", "");

                        if (jdbcUrl != null && !jdbcUrl.trim().isEmpty()) {
                            jdbcUrl = jdbcUrl.trim();
                            if (jdbcUrl.startsWith("postgres://")) {
                                jdbcUrl = "jdbc:postgresql://" + jdbcUrl.substring("postgres://".length());
                            } else if (jdbcUrl.startsWith("postgresql://")) {
                                jdbcUrl = "jdbc:postgresql://" + jdbcUrl.substring("postgresql://".length());
                            }
                            if (!jdbcUrl.contains("sslmode=")) {
                                jdbcUrl += (jdbcUrl.contains("?") ? "&" : "?") + "sslmode=" + sslMode;
                            }
                            config.setJdbcUrl(jdbcUrl);
                        } else {
                            String dbHost = resolveConfig("SUPABASE_DB_HOST", "supabase.db.host", "localhost");
                            String dbPort = resolveConfig("SUPABASE_DB_PORT", "supabase.db.port", "5432");
                            String dbName = resolveConfig("SUPABASE_DB_NAME", "supabase.db.name", "postgres");

                            String constructedUrl = String.format(
                                "jdbc:postgresql://%s:%s/%s?sslmode=%s",
                                dbHost, dbPort, dbName, sslMode
                            );
                            config.setJdbcUrl(constructedUrl);
                        }

                        config.setUsername(dbUser);
                        config.setPassword(dbPassword);

                        // Connection Pool settings for cloud deployment (Render + Supabase)
                        config.setMaximumPoolSize(10);
                        config.setMinimumIdle(2);
                        config.setIdleTimeout(30000);
                        config.setMaxLifetime(1800000);
                        config.setConnectionTimeout(30000);
                        config.setInitializationFailTimeout(-1); // Do not crash app on startup if DB is temporarily unreachable

                        dataSource = new HikariDataSource(config);
                        System.out.println("[DatabaseManager] HikariCP PostgreSQL connection pool initialized successfully.");
                    } catch (Exception e) {
                        System.err.println("[DatabaseManager] Warning: Error initializing HikariCP pool: " + e.getMessage());
                        // Pool will be retried or fallback to DriverManager
                    }
                }
            }
        }
        return dataSource;
    }

    /**
     * Gets a connection from the pool, or falls back to direct DriverManager connection.
     * Guaranteed to produce useful, sanitized error messages without exposing passwords.
     *
     * @return Connection active JDBC connection to PostgreSQL/Supabase
     * @throws SQLException if connection cannot be established
     */
    public static Connection getConnection() throws SQLException {
        // 1. Try HikariCP Connection Pool
        try {
            HikariDataSource ds = getDataSource();
            if (ds != null && !ds.isClosed()) {
                return ds.getConnection();
            }
        } catch (Exception e) {
            System.err.println("[DatabaseManager] Pool getConnection() notice: " + e.getMessage() + ". Attempting direct connection fallback...");
        }

        // 2. Direct JDBC Driver Connection Fallback
        String host = resolveConfig("SUPABASE_DB_HOST", "supabase.db.host", "localhost");
        String port = resolveConfig("SUPABASE_DB_PORT", "supabase.db.port", "5432");
        String name = resolveConfig("SUPABASE_DB_NAME", "supabase.db.name", "postgres");
        String ssl = resolveConfig("SUPABASE_DB_SSL", "supabase.db.ssl", "require");
        String user = resolveConfig("SUPABASE_DB_USER", "supabase.db.user", "postgres");
        String pass = resolveConfig("SUPABASE_DB_PASSWORD", "supabase.db.password", "");

        String rawUrl = System.getenv("SUPABASE_JDBC_URL");
        if (rawUrl == null || rawUrl.trim().isEmpty()) {
            rawUrl = System.getenv("DATABASE_URL");
        }

        String finalUrl;
        if (rawUrl != null && !rawUrl.trim().isEmpty()) {
            finalUrl = rawUrl.trim();
            if (finalUrl.startsWith("postgres://")) {
                finalUrl = "jdbc:postgresql://" + finalUrl.substring("postgres://".length());
            } else if (finalUrl.startsWith("postgresql://")) {
                finalUrl = "jdbc:postgresql://" + finalUrl.substring("postgresql://".length());
            }
            if (!finalUrl.contains("sslmode=")) {
                finalUrl += (finalUrl.contains("?") ? "&" : "?") + "sslmode=" + ssl;
            }
        } else {
            finalUrl = String.format("jdbc:postgresql://%s:%s/%s?sslmode=%s", host, port, name, ssl);
        }

        try {
            Class.forName("org.postgresql.Driver");
            return DriverManager.getConnection(finalUrl, user, pass);
        } catch (ClassNotFoundException cfe) {
            throw new SQLException("PostgreSQL JDBC Driver class 'org.postgresql.Driver' not found in classpath.", cfe);
        } catch (SQLException sqle) {
            String sanitizedMsg = String.format(
                "Failed to connect to PostgreSQL database at %s:%s/%s (User: %s, SSL: %s). Details: %s",
                host, port, name, user, ssl, sqle.getMessage()
            );
            System.err.println("[DatabaseManager] " + sanitizedMsg);
            throw new SQLException(sanitizedMsg, sqle.getSQLState(), sqle.getErrorCode(), sqle);
        } catch (Exception ex) {
            String sanitizedMsg = String.format(
                "Unexpected error establishing database connection to %s:%s/%s. Details: %s",
                host, port, name, ex.getMessage()
            );
            System.err.println("[DatabaseManager] " + sanitizedMsg);
            throw new SQLException(sanitizedMsg, ex);
        }
    }
}
