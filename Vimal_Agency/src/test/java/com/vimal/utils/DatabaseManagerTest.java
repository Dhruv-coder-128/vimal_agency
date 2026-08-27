package com.vimal.utils;

import org.junit.Test;
import java.sql.Connection;
import java.sql.SQLException;

import static org.junit.Assert.*;

public class DatabaseManagerTest {

    @Test
    public void testPostgreSqlDriverLoaded() {
        try {
            Class<?> driverClass = Class.forName("org.postgresql.Driver");
            assertNotNull("PostgreSQL driver class should be found", driverClass);
        } catch (ClassNotFoundException e) {
            fail("PostgreSQL JDBC driver not in classpath: " + e.getMessage());
        }
    }

    @Test
    public void testSanitizedErrorMessageOnConnectionFailure() {
        // Without real credentials in test environment, getConnection should fail gracefully
        // and NOT throw ClassNotFoundException for MySQL, nor expose raw secret passwords in exception message.
        try {
            Connection conn = DatabaseManager.getConnection();
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            String msg = e.getMessage();
            assertNotNull("Error message should not be null", msg);
            assertFalse("Error message must not contain password keyword with actual values", msg.toLowerCase().contains("password="));
            System.out.println("[Test Info] Handled expected connection failure gracefully: " + msg);
        }
    }
}
