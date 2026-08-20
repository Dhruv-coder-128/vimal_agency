<%@ page import="java.sql.*" %>
<%@ page import="com.vimal.utils.DatabaseManager" %>

<%
    String error = "";
    String infoMsg = "";
    String msgParam = request.getParameter("msg");
    if ("password_reset_success".equals(msgParam)) {
        infoMsg = "Your password has been reset successfully! Please sign in with your new password.";
    } else if ("auth_required".equals(msgParam)) {
        error = "Please sign in to access your account.";
    }

    if (request.getMethod().equalsIgnoreCase("POST")) {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        try {
            boolean isValid = com.vimal.dao.UserDAO.validateLogin(email, password);
            if (isValid) {
                try (java.sql.Connection conn = com.vimal.utils.DatabaseManager.getConnection();
                     java.sql.PreparedStatement ps = conn.prepareStatement("SELECT * FROM users WHERE (email=? OR username=?) AND status=1")) {
                    ps.setString(1, email);
                    ps.setString(2, email);
                    try (java.sql.ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            session.setAttribute("user", rs.getString("username"));
                            session.setAttribute("username", rs.getString("username"));
                            session.setAttribute("role", rs.getString("role"));
                            session.setAttribute("uid", rs.getString("id"));
                            session.setAttribute("user_id", rs.getInt("id"));

                            if ("admin".equalsIgnoreCase(rs.getString("role"))) {
                                session.setAttribute("admin_id", rs.getInt("id"));
                                session.setAttribute("admin_email", rs.getString("email"));
                                response.sendRedirect("admin_index.jsp");
                            } else {
                                response.sendRedirect("index.jsp");
                            }
                            return;
                        }
                    }
                }
            } else {
                error = "Your login attempt has failed. Make sure the username and password are correct.";
            }
        } catch (Exception e) {
            error = "Database error occurred: " + e.getMessage();
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vimal Agency - Login</title>
    <link rel='stylesheet' type='text/css' href='main.css'>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="login-page">

    <div class="login-container">
        <div class="logo-box">
            <img src="./Product/login/logo.jpeg" alt="Vimal Agency Logo">
        </div>

        <p class="welcome-text">WELCOME TO VIMAL AGENCY</p>

        <form method="post" style="width:100%;" autocomplete="off">
            <% if(!infoMsg.isEmpty()){ %>
                <div class="alert alert-success p-2 text-center" style="font-size: 14px; font-weight: 600; border-radius: 8px;">
                    <i class="fa-solid fa-circle-check me-1"></i> <%= infoMsg %>
                </div>
            <% } %>

            <% if(!error.isEmpty()){ %>
                <div class="error" style="color: #dc2626; margin-bottom: 12px; font-weight: 600; font-size: 14px; text-align: center;">
                    <i class="fa-solid fa-circle-exclamation me-1"></i> <%= error %>
                </div>
            <% } %>

            <input type="text" name="email" placeholder="Email Or Username" required autocomplete="off">
            <input type="password" name="password" placeholder="Password" required autocomplete="new-password">

            <div class="d-flex justify-content-end mb-3">
                <a href="forgot_password.jsp" style="color: #4a2c7c; font-size: 13.5px; font-weight: 600; text-decoration: none;">
                    Forgot Password?
                </a>
            </div>

            <button type="submit" class="sign-in-btn">Sign in</button>
        </form>

        <div class="links-area mt-3 w-100">
            <a href="register.jsp" class="register-btn d-block mb-3" style="text-decoration: none;">
                Register Your Account
            </a>

            <div class="links-area mt-2 text-center">
                <a href="admin_login.jsp"
                    style="text-decoration: none; color: #7f8c8d; font-size: 14px; font-weight: 600;">
                    <i class="fa-solid fa-arrow-right me-1"></i> Admin Login
                </a>
            </div>
        </div>
    </div>

    <div class="carousel-box">
        <div id="loginCarousel" class="carousel slide carousel-fade" data-bs-ride="carousel">
            <div class="carousel-indicators">
                <button type="button" data-bs-target="#loginCarousel" data-bs-slide-to="0" class="active"></button>
                <button type="button" data-bs-target="#loginCarousel" data-bs-slide-to="1"></button>
                <button type="button" data-bs-target="#loginCarousel" data-bs-slide-to="2"></button>
            </div>
            <div class="carousel-inner">
                <div class="carousel-item active"><img src="./Product/login/1.jpeg" class="d-block w-100" alt="Snacks Slide 1"></div>
                <div class="carousel-item"><img src="./Product/login/2.jpeg" class="d-block w-100" alt="Snacks Slide 2"></div>
                <div class="carousel-item"><img src="./Product/login/3.jpeg" class="d-block w-100" alt="Snacks Slide 3"></div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
