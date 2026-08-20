package com.vimal.dao;

import com.vimal.utils.DatabaseManager;
import org.mindrot.jbcrypt.BCrypt;

import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class UserDAO {

    private static volatile boolean schemaEnsured = false;
    private static final String RECOVERY_CHARS = "23456789ABCDEFGHJKMNPQRSTUVWXYZ";

    /**
     * Ensures required recovery and preference columns exist in PostgreSQL without breaking existing data.
     */
    public static void ensureSchemaUpdated() {
        if (schemaEnsured) return;
        synchronized (UserDAO.class) {
            if (schemaEnsured) return;
            try (Connection cn = DatabaseManager.getConnection();
                 Statement st = cn.createStatement()) {
                st.execute("ALTER TABLE users ADD COLUMN IF NOT EXISTS recovery_key_hash VARCHAR(255) DEFAULT NULL");
                st.execute("ALTER TABLE users ADD COLUMN IF NOT EXISTS recovery_key_created_at TIMESTAMP DEFAULT NULL");
                st.execute("ALTER TABLE users ADD COLUMN IF NOT EXISTS notify_orders SMALLINT DEFAULT 1");
                st.execute("ALTER TABLE users ADD COLUMN IF NOT EXISTS notify_promos SMALLINT DEFAULT 1");
                schemaEnsured = true;
            } catch (Exception ignored) {
                // Table already updated or schema permissions
            }
        }
    }

    /**
     * Generates a cryptographically random, unpredictable recovery secret key.
     * Format: VIMAL-XXXX-XXXX-XXXX-XXXX (4 groups of 4 characters from unambiguous 30-char alphanumeric set)
     */
    public static String generateRecoveryKey() {
        SecureRandom random = new SecureRandom();
        StringBuilder sb = new StringBuilder("VIMAL-");
        for (int group = 0; group < 4; group++) {
            if (group > 0) sb.append("-");
            for (int i = 0; i < 4; i++) {
                int idx = random.nextInt(RECOVERY_CHARS.length());
                sb.append(RECOVERY_CHARS.charAt(idx));
            }
        }
        return sb.toString();
    }

    /**
     * Backward-compatible registration helper returning boolean.
     */
    public static boolean registerUser(String username, String email, String password) throws Exception {
        String key = registerUserWithRecovery(username, email, password);
        return key != null;
    }

    /**
     * Registers a new user, hashes the password and recovery secret key, and returns the one-time plaintext recovery key.
     */
    public static String registerUserWithRecovery(String username, String email, String password) throws Exception {
        ensureSchemaUpdated();
        try (Connection cn = DatabaseManager.getConnection()) {

            // Check username availability
            try (PreparedStatement st = cn.prepareStatement("SELECT 1 FROM users WHERE username=?")) {
                st.setString(1, username);
                try (ResultSet rs = st.executeQuery()) {
                    if (rs.next()) return null; // Username taken
                }
            }

            // Check email availability
            try (PreparedStatement st = cn.prepareStatement("SELECT 1 FROM users WHERE email=?")) {
                st.setString(1, email);
                try (ResultSet rs = st.executeQuery()) {
                    if (rs.next()) return null; // Email taken
                }
            }

            // Generate and hash recovery secret key
            String plainRecoveryKey = generateRecoveryKey();
            String recoveryHash = BCrypt.hashpw(plainRecoveryKey, BCrypt.gensalt(10));
            String passwordHash = BCrypt.hashpw(password, BCrypt.gensalt());

            String sql = "INSERT INTO users(username, email, password, role, status, created_at, recovery_key_hash, recovery_key_created_at, notify_orders, notify_promos) "
                       + "VALUES(?, ?, ?, 'user', 1, CURRENT_TIMESTAMP, ?, CURRENT_TIMESTAMP, 1, 1)";
            try (PreparedStatement ins = cn.prepareStatement(sql)) {
                ins.setString(1, username);
                ins.setString(2, email);
                ins.setString(3, passwordHash);
                ins.setString(4, recoveryHash);
                ins.executeUpdate();
                return plainRecoveryKey;
            }
        }
    }

    /**
     * Validates user authentication against stored BCrypt hash (or fallback legacy plaintext).
     */
    public static boolean validateLogin(String loginIdentifier, String password) throws Exception {
        try (Connection cn = DatabaseManager.getConnection();
             PreparedStatement st = cn.prepareStatement("SELECT password FROM users WHERE (email=? OR username=?) AND status=1")) {

            st.setString(1, loginIdentifier);
            st.setString(2, loginIdentifier);

            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    String storedHash = rs.getString("password");
                    if (storedHash == null || password == null) {
                        return false;
                    }
                    if (storedHash.startsWith("$2a$") || storedHash.startsWith("$2b$") || storedHash.startsWith("$2y$")) {
                        try {
                            return BCrypt.checkpw(password, storedHash);
                        } catch (Exception ex) {
                            return password.equals(storedHash);
                        }
                    } else {
                        // Plaintext comparison for pre-existing legacy seed data
                        return password.equals(storedHash);
                    }
                }
            }
        }
        return false;
    }

    /**
     * Generates or regenerates a recovery secret key for a logged-in user upon validating current password.
     */
    public static String generateOrRegenerateRecoveryKey(int userId, String currentPassword) throws Exception {
        ensureSchemaUpdated();
        try (Connection cn = DatabaseManager.getConnection()) {
            // Verify current password first
            try (PreparedStatement st = cn.prepareStatement("SELECT password FROM users WHERE id=? AND status=1")) {
                st.setInt(1, userId);
                try (ResultSet rs = st.executeQuery()) {
                    if (!rs.next()) return null;
                    String storedPass = rs.getString("password");
                    boolean valid = false;
                    if (storedPass != null) {
                        if (storedPass.startsWith("$2a$") || storedPass.startsWith("$2b$") || storedPass.startsWith("$2y$")) {
                            try {
                                valid = BCrypt.checkpw(currentPassword, storedPass);
                            } catch (Exception ignored) {
                                valid = currentPassword.equals(storedPass);
                            }
                        } else {
                            valid = currentPassword.equals(storedPass);
                        }
                    }
                    if (!valid) return null;
                }
            }

            // Generate new recovery key and hash
            String plainKey = generateRecoveryKey();
            String recoveryHash = BCrypt.hashpw(plainKey, BCrypt.gensalt(10));

            try (PreparedStatement up = cn.prepareStatement("UPDATE users SET recovery_key_hash=?, recovery_key_created_at=CURRENT_TIMESTAMP WHERE id=?")) {
                up.setString(1, recoveryHash);
                up.setInt(2, userId);
                int rows = up.executeUpdate();
                return rows > 0 ? plainKey : null;
            }
        }
    }

    /**
     * Updates user password upon validating current password.
     */
    public static boolean changePassword(int userId, String currentPassword, String newPassword) throws Exception {
        try (Connection cn = DatabaseManager.getConnection()) {
            // Verify current password
            try (PreparedStatement st = cn.prepareStatement("SELECT password FROM users WHERE id=? AND status=1")) {
                st.setInt(1, userId);
                try (ResultSet rs = st.executeQuery()) {
                    if (!rs.next()) return false;
                    String storedPass = rs.getString("password");
                    boolean valid = false;
                    if (storedPass != null) {
                        if (storedPass.startsWith("$2a$") || storedPass.startsWith("$2b$") || storedPass.startsWith("$2y$")) {
                            try {
                                valid = BCrypt.checkpw(currentPassword, storedPass);
                            } catch (Exception ignored) {
                                valid = currentPassword.equals(storedPass);
                            }
                        } else {
                            valid = currentPassword.equals(storedPass);
                        }
                    }
                    if (!valid) return false;
                }
            }

            // Hash new password and update
            String hashedNew = BCrypt.hashpw(newPassword, BCrypt.gensalt());
            try (PreparedStatement up = cn.prepareStatement("UPDATE users SET password=? WHERE id=?")) {
                up.setString(1, hashedNew);
                up.setInt(2, userId);
                return up.executeUpdate() > 0;
            }
        }
    }

    /**
     * Resets password using the Recovery Secret Key.
     * Invalidates the used recovery key upon successful reset.
     */
    public static boolean resetPasswordWithRecoveryKey(String loginIdentifier, String recoveryKey, String newPassword) throws Exception {
        ensureSchemaUpdated();
        if (loginIdentifier == null || recoveryKey == null || newPassword == null) return false;

        String normKey = recoveryKey.trim().toUpperCase();
        try (Connection cn = DatabaseManager.getConnection();
             PreparedStatement st = cn.prepareStatement("SELECT id, recovery_key_hash FROM users WHERE (email=? OR username=?) AND status=1")) {

            st.setString(1, loginIdentifier.trim());
            st.setString(2, loginIdentifier.trim());

            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    int userId = rs.getInt("id");
                    String storedRecoveryHash = rs.getString("recovery_key_hash");

                    if (storedRecoveryHash == null || storedRecoveryHash.isEmpty()) {
                        return false; // Recovery key not configured
                    }

                    boolean keyValid = false;
                    try {
                        keyValid = BCrypt.checkpw(normKey, storedRecoveryHash);
                    } catch (Exception ignored) {
                        keyValid = false;
                    }

                    if (keyValid) {
                        String hashedNewPass = BCrypt.hashpw(newPassword, BCrypt.gensalt());
                        // Invalidate the recovery key on successful reset
                        try (PreparedStatement up = cn.prepareStatement("UPDATE users SET password=?, recovery_key_hash=NULL, recovery_key_created_at=NULL WHERE id=?")) {
                            up.setString(1, hashedNewPass);
                            up.setInt(2, userId);
                            return up.executeUpdate() > 0;
                        }
                    }
                }
            }
        }
        return false;
    }

    /**
     * Updates notification preferences for the user.
     */
    public static boolean updateUserPreferences(int userId, int notifyOrders, int notifyPromos) throws Exception {
        ensureSchemaUpdated();
        try (Connection cn = DatabaseManager.getConnection();
             PreparedStatement up = cn.prepareStatement("UPDATE users SET notify_orders=?, notify_promos=? WHERE id=?")) {
            up.setInt(1, notifyOrders);
            up.setInt(2, notifyPromos);
            up.setInt(3, userId);
            return up.executeUpdate() > 0;
        }
    }
}
