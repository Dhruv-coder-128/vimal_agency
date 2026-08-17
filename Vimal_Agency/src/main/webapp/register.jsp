<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vimal.utils.DatabaseManager" %>
<%@ page import="java.sql.*" %>
<%
    // Variable for feedback messages
    String msg = "";

    // Check for POST request
    if(request.getMethod().equalsIgnoreCase("POST")){
        
        // Ensure UTF-8 encoding for data handling
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            boolean success = com.vimal.dao.UserDAO.registerUser(username, email, password);
            if (success) {
                response.sendRedirect("login.jsp");
                return; // Stop rendering
            } else {
                msg = "Username or Email is already registered!";
            }
        } catch(Exception e) {
            msg = "Something went wrong. Please try again.";
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Join Vimal Agency</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    
    <style>
        * { box-sizing: border-box; }
        
        body {
            margin: 0;
            font-family: 'Inter', sans-serif;
            /* New Dynamic Gradient */
            background: radial-gradient(circle at top right, #1e293b, #0f172a);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #f8fafc;
        }

        .glass-panel {
            background: rgba(255, 255, 255, 0.03);
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            padding: 50px 40px;
            border-radius: 40px;
            width: 200%;
            max-width: 420px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
            text-align: center;
        }

        .logo-area img {
            width: 70px;
            height: 70px;
            border-radius: 20px;
            margin-bottom: 20px;
            filter: drop-shadow(0 0 10px rgba(56, 189, 248, 0.5));
        }

        h2 {
            font-size: 2rem;
            margin-bottom: 10px;
            font-weight: 600;
            letter-spacing: -1px;
        }

        p.subtitle {
            color: #94a3b8;
            margin-bottom: 30px;
            font-size: 0.9rem;
        }

        .msg-box {
            background: rgba(239, 68, 68, 0.1);
            border: 1px solid rgba(239, 68, 68, 0.2);
            color: #fca5a5;
            padding: 12px;
            border-radius: 12px;
            margin-bottom: 20px;
            font-size: 0.85rem;
        }

        .input-group {
            position: relative;
            margin-bottom: 20px;
        }

        .input-group input {
            width: 100%;
            padding: 16px 20px;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            color: white;
            font-size: 1rem;
            outline: none;
            transition: 0.3s;
        }

        .input-group input:focus {
            background: rgba(255, 255, 255, 0.08);
            border-color: #38bdf8;
            box-shadow: 0 0 15px rgba(56, 189, 248, 0.2);
        }

        .btn-grad {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #38bdf8 0%, #0ea5e9 100%);
            border: none;
            border-radius: 15px;
            color: white;
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            transition: 0.4s;
            box-shadow: 0 10px 20px -5px rgba(14, 165, 233, 0.5);
        }

        .btn-grad:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 25px -5px rgba(14, 165, 233, 0.6);
        }

        .footer {
            margin-top: 30px;
            font-size: 0.9rem;
            color: #94a3b8;
        }

        .footer a {
            color: #38bdf8;
            text-decoration: none;
            font-weight: 600;
        }
    </style>
</head>
<body>

<div class="glass-panel">
    <div class="logo-area">
        <img src="./Product/login/logo.jpeg" alt="Logo">
    </div>

    <h2>Get Started</h2>
    <p class="subtitle">Register Your Account</p>

    <form method="post" autocomplete="off">
        <% if(!msg.equals("")){ %>
            <div class="msg-box"><%= msg %></div>
        <% } %>

        <div class="input-group">
            <input type="text" name="username" placeholder="Choose a username" required>
        </div>

        <div class="input-group">
            <input type="email" name="email" placeholder="Email address" required>
        </div>

        <div class="input-group">
            <input type="password" name="password" placeholder="Create a password" required>
        </div>

        <button type="submit" class="btn-grad">Create Account</button>
    </form>

    <div class="footer">
        Already a member? <a href="login.jsp">Sign In here</a>
    </div>
</div>

</body>
</html>