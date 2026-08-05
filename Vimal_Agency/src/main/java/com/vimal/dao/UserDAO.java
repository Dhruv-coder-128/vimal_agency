package com.vimal.dao;

import com.vimal.utils.DatabaseManager;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {

    public static boolean registerUser(String username, String email, String password) throws Exception {
        try (Connection cn = DatabaseManager.getConnection()) {
            
            // Check username
            try (PreparedStatement st = cn.prepareStatement("SELECT 1 FROM users WHERE username=?")) {
                st.setString(1, username);
                try (ResultSet rs = st.executeQuery()) {
                    if (rs.next()) return false; // Username taken
                }
            }

            // Check email
            try (PreparedStatement st = cn.prepareStatement("SELECT 1 FROM users WHERE email=?")) {
                st.setString(1, email);
                try (ResultSet rs = st.executeQuery()) {
                    if (rs.next()) return false; // Email taken
                }
            }

            // Insert user
            String hashed = BCrypt.hashpw(password, BCrypt.gensalt());
            try (PreparedStatement ins = cn.prepareStatement(
                    "INSERT INTO users(username, email, password, role, status, created_at) VALUES(?, ?, ?, 'user', 1, CURRENT_TIMESTAMP)")) {
                ins.setString(1, username);
                ins.setString(2, email);
                ins.setString(3, hashed);
                ins.executeUpdate();
                return true;
            }
        }
    }

    public static boolean validateLogin(String loginIdentifier, String password) throws Exception {
        try (Connection cn = DatabaseManager.getConnection();
             PreparedStatement st = cn.prepareStatement("SELECT password FROM users WHERE (email=? OR username=?) AND status=1")) {
             
            st.setString(1, loginIdentifier);
            st.setString(2, loginIdentifier);
            
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    String storedHash = rs.getString("password");
                    return BCrypt.checkpw(password, storedHash);
                }
            }
        }
        return false;
    }
}
