package com.vimal.dao;

import org.junit.Test;
import org.mindrot.jbcrypt.BCrypt;

import java.util.HashSet;
import java.util.Set;

import static org.junit.Assert.*;

public class UserDAOTest {

    @Test
    public void testRecoveryKeyFormatAndEntropy() {
        Set<String> generatedKeys = new HashSet<>();
        for (int i = 0; i < 1000; i++) {
            String key = UserDAO.generateRecoveryKey();
            assertNotNull("Key should not be null", key);
            assertTrue("Key should start with VIMAL-", key.startsWith("VIMAL-"));

            // Check format: VIMAL-XXXX-XXXX-XXXX-XXXX (length 25)
            assertEquals("Key length should be exactly 25 characters", 25, key.length());
            String[] parts = key.split("-");
            assertEquals("Key should have 5 parts (VIMAL + 4 groups)", 5, parts.length);
            assertEquals("Prefix should be VIMAL", "VIMAL", parts[0]);
            for (int p = 1; p < 5; p++) {
                assertEquals("Each group should have 4 characters", 4, parts[p].length());
                for (char c : parts[p].toCharArray()) {
                    assertTrue("Character should be in unambiguous set: " + c,
                            "23456789ABCDEFGHJKMNPQRSTUVWXYZ".indexOf(c) >= 0);
                }
            }

            // Ensure uniqueness across 1000 generations
            assertTrue("Generated keys must be unique", generatedKeys.add(key));
        }
    }

    @Test
    public void testRecoveryKeyBCryptHashing() {
        String key = UserDAO.generateRecoveryKey();
        String hash = BCrypt.hashpw(key, BCrypt.gensalt(10));

        assertNotNull("Hash must not be null", hash);
        assertTrue("Hash should be valid BCrypt format", hash.startsWith("$2a$") || hash.startsWith("$2b$"));
        assertTrue("BCrypt check should pass for exact key", BCrypt.checkpw(key, hash));
        assertTrue("BCrypt check should pass for normalized uppercase key", BCrypt.checkpw(key.toUpperCase().trim(), hash));
        assertFalse("BCrypt check should fail for modified key", BCrypt.checkpw(key + "X", hash));
        assertFalse("BCrypt check should fail for wrong key", BCrypt.checkpw("VIMAL-0000-0000-0000-0000", hash));
    }

    @Test
    public void testPasswordBCryptHashingAndVerification() {
        String plainPassword = "MySecurePassword123!";
        String hash = BCrypt.hashpw(plainPassword, BCrypt.gensalt());

        assertTrue("Password verification should succeed with correct password",
                BCrypt.checkpw(plainPassword, hash));
        assertFalse("Password verification should fail with incorrect password",
                BCrypt.checkpw("WrongPassword", hash));
        assertFalse("Password verification should fail with empty password",
                BCrypt.checkpw("", hash));
    }
}
