<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vimal.dao.UserDAO" %>

<%
    String errorMsg = "";
    String successMsg = "";

    // Simple session-based attempt rate-limiting
    Integer failedAttempts = (Integer) session.getAttribute("recovery_failed_attempts");
    Long lastAttemptTime = (Long) session.getAttribute("recovery_last_attempt_time");
    long currentTime = System.currentTimeMillis();

    if (failedAttempts == null || lastAttemptTime == null || (currentTime - lastAttemptTime) > 15 * 60 * 1000) {
        failedAttempts = 0;
        session.setAttribute("recovery_failed_attempts", 0);
        session.setAttribute("recovery_last_attempt_time", currentTime);
    }

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        request.setCharacterEncoding("UTF-8");

        if (failedAttempts >= 5 && (currentTime - lastAttemptTime) < 15 * 60 * 1000) {
            long remainingMinutes = Math.max(1, (15 * 60 * 1000 - (currentTime - lastAttemptTime)) / (60 * 1000));
            errorMsg = "Too many failed recovery attempts. Please wait " + remainingMinutes + " minute(s) before trying again.";
        } else {
            String loginId = request.getParameter("login_id");
            String recoveryKey = request.getParameter("recovery_key");
            String newPassword = request.getParameter("new_password");
            String confirmPassword = request.getParameter("confirm_password");

            if (loginId == null || loginId.trim().isEmpty() ||
                recoveryKey == null || recoveryKey.trim().isEmpty() ||
                newPassword == null || newPassword.trim().isEmpty() ||
                confirmPassword == null || confirmPassword.trim().isEmpty()) {
                errorMsg = "All fields are required.";
            } else if (newPassword.length() < 6) {
                errorMsg = "New password must be at least 6 characters long.";
            } else if (!newPassword.equals(confirmPassword)) {
                errorMsg = "Passwords do not match. Please re-enter.";
            } else {
                try {
                    boolean resetSuccess = UserDAO.resetPasswordWithRecoveryKey(loginId.trim(), recoveryKey.trim(), newPassword);
                    if (resetSuccess) {
                        // Reset attempt counters
                        session.removeAttribute("recovery_failed_attempts");
                        session.removeAttribute("recovery_last_attempt_time");
                        session.invalidate();

                        response.sendRedirect("login.jsp?msg=password_reset_success");
                        return;
                    } else {
                        failedAttempts++;
                        session.setAttribute("recovery_failed_attempts", failedAttempts);
                        session.setAttribute("recovery_last_attempt_time", System.currentTimeMillis());
                        errorMsg = "Invalid account credentials or recovery key.";
                    }
                } catch (Exception e) {
                    errorMsg = "An error occurred during password recovery. Please try again.";
                }
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Account Recovery | Vimal Agency</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700;800&family=JetBrains+Mono:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <style>
        * { box-sizing: border-box; }

        body {
            margin: 0;
            font-family: 'Outfit', -apple-system, sans-serif;
            background: radial-gradient(circle at top right, #1e293b, #0f172a);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #f8fafc;
            padding: 30px 15px;
        }

        .glass-panel {
            background: rgba(255, 255, 255, 0.04);
            backdrop-filter: blur(16px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            padding: clamp(28px, 5vw, 45px) clamp(20px, 4vw, 36px);
            border-radius: 24px;
            width: 100%;
            max-width: 460px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.6);
            text-align: center;
        }

        .logo-area img {
            width: 65px;
            height: 65px;
            border-radius: 18px;
            margin-bottom: 15px;
            box-shadow: 0 4px 15px rgba(255, 200, 0, 0.25);
        }

        h2 {
            font-size: clamp(1.5rem, 4vw, 1.85rem);
            margin-bottom: 6px;
            font-weight: 800;
            letter-spacing: -0.5px;
        }

        p.subtitle {
            color: #94a3b8;
            margin-bottom: 22px;
            font-size: 0.9rem;
            line-height: 1.4;
        }

        .msg-box {
            background: rgba(239, 68, 68, 0.12);
            border: 1px solid rgba(239, 68, 68, 0.25);
            color: #fca5a5;
            padding: 12px;
            border-radius: 12px;
            margin-bottom: 20px;
            font-size: 0.85rem;
            font-weight: 500;
            text-align: left;
        }

        .input-group {
            position: relative;
            margin-bottom: 16px;
            text-align: left;
        }

        .input-group label {
            display: block;
            font-size: 0.8rem;
            font-weight: 700;
            color: #cbd5e1;
            margin-bottom: 6px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .input-group input {
            width: 100%;
            padding: 13px 16px;
            background: rgba(255, 255, 255, 0.05);
            border: 1.5px solid rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            color: white;
            font-size: 0.95rem;
            outline: none;
            transition: 0.25s;
        }

        .input-group input:focus {
            background: rgba(255, 255, 255, 0.08);
            border-color: #ffc800;
            box-shadow: 0 0 15px rgba(255, 200, 0, 0.2);
        }

        .input-recovery-key {
            font-family: 'JetBrains Mono', monospace !important;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            color: #ffc800 !important;
            font-weight: 700;
        }

        .btn-grad {
            width: 100%;
            min-height: 48px;
            padding: 14px;
            background: #ffc800;
            border: none;
            border-radius: 14px;
            color: #0f172a;
            font-weight: 800;
            font-size: 1rem;
            cursor: pointer;
            transition: 0.3s;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            margin-top: 10px;
        }

        .btn-grad:hover {
            background: #e6b400;
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(255, 200, 0, 0.3);
        }

        .footer {
            margin-top: 25px;
            font-size: 0.9rem;
            color: #94a3b8;
        }

        .footer a {
            color: #ffc800;
            text-decoration: none;
            font-weight: 600;
        }
        .footer a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="glass-panel">
    <div class="logo-area">
        <img src="./Product/login/logo.jpeg" alt="Vimal Agency Logo">
    </div>

    <h2>Password Recovery</h2>
    <p class="subtitle">Reset your account password using your offline Recovery Secret Key.</p>

    <form method="post" autocomplete="off">
        <% if (!errorMsg.isEmpty()) { %>
            <div class="msg-box">
                <i class="fa-solid fa-circle-exclamation me-1"></i> <%= errorMsg %>
            </div>
        <% } %>

        <div class="input-group">
            <label>Username or Email</label>
            <input type="text" name="login_id" placeholder="Enter username or registered email" required autocomplete="off">
        </div>

        <div class="input-group">
            <label>Recovery Secret Key</label>
            <input type="text" name="recovery_key" class="input-recovery-key" placeholder="VIMAL-XXXX-XXXX-XXXX-XXXX" required autocomplete="off">
        </div>

        <div class="input-group">
            <label>New Password</label>
            <input type="password" name="new_password" placeholder="Min 6 characters" minlength="6" required autocomplete="new-password">
        </div>

        <div class="input-group">
            <label>Confirm New Password</label>
            <input type="password" name="confirm_password" placeholder="Re-enter new password" minlength="6" required autocomplete="new-password">
        </div>

        <button type="submit" class="btn-grad">
            <i class="fa-solid fa-key"></i> Reset Password
        </button>
    </form>

    <div class="footer">
        Remembered your password? <a href="login.jsp">Back to Sign In</a>
    </div>
</div>

</body>
</html>
