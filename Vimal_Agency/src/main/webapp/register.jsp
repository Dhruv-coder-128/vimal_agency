<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vimal.dao.UserDAO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%
    String msg = "";
    String generatedKey = null;
    String registeredUsername = null;
    String currentDateStr = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        if (username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            msg = "All fields are required.";
        } else if (password.length() < 6) {
            msg = "Password must be at least 6 characters long.";
        } else if (confirmPassword != null && !password.equals(confirmPassword)) {
            msg = "Passwords do not match. Please try again.";
        } else {
            try {
                generatedKey = UserDAO.registerUserWithRecovery(username.trim(), email.trim(), password);
                if (generatedKey != null) {
                    registeredUsername = username.trim();
                } else {
                    msg = "Username or Email is already registered!";
                }
            } catch (Exception e) {
                msg = "An error occurred during registration. Please try again.";
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Join Vimal Agency | Register</title>
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
            font-size: clamp(1.6rem, 4vw, 1.9rem);
            margin-bottom: 6px;
            font-weight: 800;
            letter-spacing: -0.5px;
        }

        p.subtitle {
            color: #94a3b8;
            margin-bottom: 25px;
            font-size: 0.9rem;
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
        }

        .input-group input {
            width: 100%;
            padding: 14px 18px;
            background: rgba(255, 255, 255, 0.05);
            border: 1.5px solid rgba(255, 255, 255, 0.1);
            border-radius: 14px;
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
            margin-top: 5px;
        }

        .btn-grad:hover {
            background: #e6b400;
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(255, 200, 0, 0.3);
        }

        /* Recovery Key Card Styles */
        .recovery-box {
            background: rgba(15, 23, 42, 0.85);
            border: 1.5px dashed #ffc800;
            border-radius: 16px;
            padding: 18px;
            margin: 20px 0;
            text-align: center;
        }

        .recovery-key-display {
            font-family: 'JetBrains Mono', monospace;
            font-size: clamp(1rem, 3.5vw, 1.25rem);
            font-weight: 700;
            letter-spacing: 2px;
            color: #ffc800;
            background: rgba(255, 200, 0, 0.08);
            padding: 12px 10px;
            border-radius: 10px;
            margin: 12px 0;
            user-select: all;
            word-break: break-all;
            border: 1px solid rgba(255, 200, 0, 0.2);
        }

        .action-btns {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
            margin: 15px 0;
        }

        .btn-action-key {
            padding: 11px 14px;
            border-radius: 10px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            background: rgba(255, 255, 255, 0.08);
            color: #ffffff;
            font-weight: 600;
            font-size: 0.85rem;
            cursor: pointer;
            transition: 0.2s;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }

        .btn-action-key:hover {
            background: rgba(255, 200, 0, 0.15);
            border-color: #ffc800;
            color: #ffc800;
        }

        .btn-action-key.btn-download {
            background: #0284c7;
            border-color: #0284c7;
            color: white;
        }

        .btn-action-key.btn-download:hover {
            background: #0369a1;
            color: white;
        }

        .alert-warning-custom {
            background: rgba(251, 191, 36, 0.1);
            border-left: 4px solid #f59e0b;
            padding: 12px;
            border-radius: 8px;
            font-size: 0.8rem;
            color: #fef3c7;
            text-align: left;
            margin: 15px 0;
            line-height: 1.4;
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

    <% if (generatedKey != null) { %>
        <!-- ================= ONE-TIME RECOVERY KEY DISPLAY ================= -->
        <h2 style="color:#ffc800;"><i class="fa-solid fa-circle-check text-success me-1"></i> Account Created!</h2>
        <p class="subtitle">Your account is ready. Please save your offline recovery credential.</p>

        <div class="recovery-box">
            <span style="font-size: 0.75rem; font-weight: 700; color: #94a3b8; text-transform: uppercase; letter-spacing: 1px;">
                Your Recovery Secret Key
            </span>

            <div class="recovery-key-display" id="recoveryKeyText"><%= generatedKey %></div>

            <div class="action-btns">
                <button type="button" class="btn-action-key" id="copyBtn" onclick="copyRecoveryKey()">
                    <i class="fa-regular fa-copy"></i> <span id="copyText">Copy Key</span>
                </button>
                <button type="button" class="btn-action-key btn-download" onclick="downloadRecoveryKey()">
                    <i class="fa-solid fa-download"></i> Download Key
                </button>
            </div>
        </div>

        <div class="alert-warning-custom">
            <i class="fa-solid fa-triangle-exclamation text-warning me-1"></i>
            <strong>IMPORTANT:</strong> Save this key somewhere safe. It is required if you forget your password while email recovery is unavailable. This key will not be shown again.
        </div>

        <a href="login.jsp" class="btn-grad" style="text-decoration: none;">
            <i class="fa-solid fa-arrow-right-to-bracket"></i> Continue to Sign In
        </a>

        <script>
            function copyRecoveryKey() {
                var key = document.getElementById("recoveryKeyText").innerText.trim();
                navigator.clipboard.writeText(key).then(function() {
                    document.getElementById("copyText").innerText = "Copied!";
                    document.getElementById("copyBtn").style.borderColor = "#22c55e";
                    document.getElementById("copyBtn").style.color = "#22c55e";
                    setTimeout(function() {
                        document.getElementById("copyText").innerText = "Copy Key";
                        document.getElementById("copyBtn").style.borderColor = "";
                        document.getElementById("copyBtn").style.color = "";
                    }, 2500);
                });
            }

            function downloadRecoveryKey() {
                var username = "<%= registeredUsername %>";
                var key = "<%= generatedKey %>";
                var date = "<%= currentDateStr %>";

                var fileContent = "========================================\n"
                                + "VIMAL AGENCY\n"
                                + "Account Recovery Key\n"
                                + "========================================\n\n"
                                + "Username: " + username + "\n\n"
                                + "Recovery Key:\n"
                                + key + "\n\n"
                                + "IMPORTANT:\n"
                                + "Keep this file private.\n"
                                + "Anyone who has this recovery key may be able\n"
                                + "to reset the account password.\n\n"
                                + "Generated:\n"
                                + date + "\n"
                                + "========================================\n";

                var blob = new Blob([fileContent], { type: "text/plain;charset=utf-8" });
                var link = document.createElement("a");
                link.href = URL.createObjectURL(blob);
                link.download = "VimalAgency-Recovery-Key.txt";
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
            }
        </script>

    <% } else { %>
        <!-- ================= REGISTRATION FORM ================= -->
        <h2>Get Started</h2>
        <p class="subtitle">Create your Vimal Agency account</p>

        <form method="post" autocomplete="off">
            <% if (!msg.isEmpty()) { %>
                <div class="msg-box">
                    <i class="fa-solid fa-circle-exclamation me-1"></i> <%= msg %>
                </div>
            <% } %>

            <div class="input-group">
                <input type="text" name="username" placeholder="Choose a username" required autocomplete="off">
            </div>

            <div class="input-group">
                <input type="email" name="email" placeholder="Email address" required autocomplete="off">
            </div>

            <div class="input-group">
                <input type="password" name="password" placeholder="Create a password (min 6 chars)" minlength="6" required autocomplete="new-password">
            </div>

            <div class="input-group">
                <input type="password" name="confirm_password" placeholder="Confirm password" minlength="6" required autocomplete="new-password">
            </div>

            <button type="submit" class="btn-grad">
                <i class="fa-solid fa-user-plus"></i> Create Account
            </button>
        </form>

        <div class="footer">
            Already a member? <a href="login.jsp">Sign In here</a>
        </div>
    <% } %>
</div>

</body>
</html>
