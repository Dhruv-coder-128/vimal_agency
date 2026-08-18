<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.vimal.utils.DatabaseManager" %>
<%@ page import="java.sql.*" %>

<%
String error="";

if(request.getMethod().equalsIgnoreCase("POST")){
    // 'email' input field mathi user email nakhshe ke username, e 'loginId' ma avshe
    String loginId = request.getParameter("email");
    String password = request.getParameter("password");

    try {
        boolean isValid = com.vimal.dao.UserDAO.validateLogin(loginId, password);

        if(isValid) {
            try (java.sql.Connection conn = com.vimal.utils.DatabaseManager.getConnection();
                 java.sql.PreparedStatement ps = conn.prepareStatement("SELECT * FROM users WHERE (email=? OR username=?) AND status=1")) {
                 ps.setString(1, loginId);
                 ps.setString(2, loginId);
                 try (java.sql.ResultSet rs = ps.executeQuery()) {
                     if (rs.next()) {
                        String role = rs.getString("role");
                        if("admin".equals(role)){
                            session.setAttribute("admin_id", rs.getInt("id"));
                            session.setAttribute("admin_email", rs.getString("email"));
                            session.setAttribute("username", rs.getString("username"));
                            session.setAttribute("role", "admin");

                            response.sendRedirect("admin_index.jsp");
                            return;
                        } else {
                            error = "Access Denied: Administrative privileges required.";
                        }
                     }
                 }
            }
        } else {
            error = "Invalid Username/Email or Password!";
        }
    } catch(Exception e) {
        error = "System Error: " + e.getMessage();
    }
}
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vimal Admin - Secure Login</title>
    <link rel='stylesheet' type='text/css' href='main.css'>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>

<body class="login-page">

<div class="login-container">
    <div class="logo-box">
        <img src="./Product/login/logo.jpeg" alt="Logo">
    </div>

    <p class="welcome-text" style="color: #1a242f; font-weight: 800; margin-bottom: 20px;">ADMIN SECURE LOGIN</p>

    <form method="post" style="width:100%;" autocomplete="off">
        <% if(!error.equals("")){ %>
            <div class="alert alert-danger py-2 small text-center" style="font-size: 13px; border-radius: 8px;">
                <%= error %>
            </div>
        <% } %>

        <input type="text" name="email" placeholder="Admin Email or Username" required autocomplete="off" class="form-control mb-3 shadow-none">
        <input type="password" name="password" placeholder="Secure Password" required autocomplete="new-password" class="form-control mb-3 shadow-none">

        <button type="submit" class="sign-in-btn w-100 mb-3" style="background: #1a242f; color: white; border: none; padding: 12px; border-radius: 8px; font-weight: 700; transition: 0.3s;">
            <i class="fa-solid fa-shield-halved me-2"></i> Authorize Login
        </button>
    </form>

    <div class="links-area mt-2 text-center">
        <a href="login.jsp" style="text-decoration: none; color: #7f8c8d; font-size: 14px; font-weight: 600;">
            <i class="fa-solid fa-arrow-left me-1"></i> Back to Customer Login
        </a>
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
            <div class="carousel-item active">
                <img src="./Product/login/1.jpeg" class="d-block w-100" alt="Slider 1">
            </div>
            <div class="carousel-item">
                <img src="./Product/login/2.jpeg" class="d-block w-100" alt="Slider 2">
            </div>
            <div class="carousel-item">
                <img src="./Product/login/3.jpeg" class="d-block w-100" alt="Slider 3">
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
