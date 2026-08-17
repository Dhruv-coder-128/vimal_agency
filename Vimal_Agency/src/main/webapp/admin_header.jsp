<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.vimal.utils.DatabaseManager" %>
<%
    String activePg = request.getServletPath();
    if (activePg != null) {
        activePg = activePg.substring(activePg.lastIndexOf("/") + 1);
    } else {
        activePg = "";
    }

    int pendingOrdersCount = 0;
    try (Connection hCon = DatabaseManager.getConnection()) {
        String hQuery = "SELECT COUNT(*) FROM orders WHERE status = 'Pending'";
        try (PreparedStatement hPs = hCon.prepareStatement(hQuery);
             ResultSet hRs = hPs.executeQuery()) {
            if (hRs.next()) {
                pendingOrdersCount = hRs.getInt(1);
            }
        }
    } catch (Exception ignored) {
    }
%>

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<style>
    :root {
        --sidebar-width: 260px;
        --primary-dark: #1a242f;
        --accent-yellow: #ffc800;
        --bg-light: #f4f7f6;
        --white: #ffffff;
    }

    body { 
        font-family: 'Poppins', sans-serif; 
        background: var(--bg-light); 
        margin: 0; 
        display: flex; 
    }

    .admin-sidebar {
        width: var(--sidebar-width);
        height: 100vh;
        background: var(--primary-dark);
        position: fixed;
        padding-top: 20px;
        color: var(--white);
        box-shadow: 4px 0 10px rgba(0,0,0,0.1);
        z-index: 1000;
    }

    .admin-logo {
        text-align: center;
        font-size: 22px;
        font-weight: 800;
        padding-bottom: 25px;
        margin-bottom: 10px;
        border-bottom: 1px solid rgba(255,255,255,0.1);
    }

    .sidebar-menu { 
        list-style: none; 
        padding: 0; 
        margin: 0; 
    }

    .sidebar-menu li a {
        display: flex;
        align-items: center;
        gap: 15px;
        color: #bdc3c7;
        padding: 14px 25px;
        text-decoration: none;
        font-size: 15px;
        transition: 0.3s ease;
    }

    .sidebar-menu li a:hover {
        background: rgba(255, 200, 0, 0.1);
        color: var(--accent-yellow);
        border-left: 4px solid var(--accent-yellow);
    }

    .sidebar-menu i { 
        font-size: 18px; 
        width: 25px; 
        text-align: center;
    }

    .admin-main { 
        margin-left: var(--sidebar-width); 
        padding: 40px; 
        width: calc(100% - var(--sidebar-width));
    }

    .stat-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
        gap: 25px;
        margin-top: 30px;
    }

    .stat-card {
        background: var(--white);
        padding: 30px;
        border-radius: 15px;
        box-shadow: 0 5px 20px rgba(0,0,0,0.05);
        border-top: 5px solid var(--accent-yellow);
        transition: 0.3s;
    }

    .stat-card:hover {
        transform: translateY(-5px);
    }

    .stat-card p { 
        color: #888; 
        text-transform: uppercase; 
        font-size: 11px; 
        letter-spacing: 1px;
        font-weight: 700; 
        margin: 0; 
    }

    .stat-card h3 { 
        font-size: 36px; 
        margin: 10px 0 0; 
        color: var(--primary-dark); 
        font-weight: 800;
    }

    .sidebar-menu li a.active {
        background: rgba(255, 200, 0, 0.15) !important;
        color: var(--accent-yellow) !important;
        border-left: 5px solid var(--accent-yellow);
        font-weight: 600;
    }

    .sidebar-menu li a.active i {
        color: var(--accent-yellow);
    }

    .cart-icon-wrapper {
        position: relative;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        width: 32px;  
        height: 32px;
    }

    .cart-icon-wrapper i {
        font-size: 18px;
        width: auto !important;
    }

    .cart-badge {
        position: absolute;
        top: -3px;      
        right: -2px;    
        background: #ff4757;
        color: white;
        font-size: 12px;
        font-weight: 800;
        min-width: 17px;
        height: 17px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        border: 2px solid #1a242f;
        box-shadow: 0 1px 3px rgba(0,0,0,0.3);
        z-index: 10;
        line-height: 1; 
    }

    .menu-text {
        font-family: 'Poppins', sans-serif;
    }
</style>

<div class="admin-sidebar">
    <div class="admin-logo" style="padding: 25px; font-weight: 800; font-size: 20px; color: white; letter-spacing: 1px;">
        <span style="color: #ffc800;">VIMAL AGENCY</span> ADMIN PANEL
    </div>

    <ul class="sidebar-menu">
        <li>
            <a href="admin_index.jsp" class="<%= "admin_index.jsp".equals(activePg) ? "active" : "" %>">
                <i class="fa-solid fa-gauge-high" style="width:30px;"></i> Dashboard
            </a>
        </li>

        <hr style="border-color: rgba(255,255,255,0.1); margin: 10px 0;">
        
        <li><a href="admin_products.jsp" class="<%= activePg.equals("admin_products.jsp") ? "active" : "" %>"><i class="fa-solid fa-box" style="width:30px;"></i> Products</a></li>

        <li>
            <a href="admin_orders.jsp" class="<%= activePg.equals("admin_orders.jsp") ? "active" : "" %>">
                <div class="cart-icon-wrapper">
                    <i class="fa-solid fa-cart-shopping"></i>
                    <% if (pendingOrdersCount > 0) { %>
                        <span class="cart-badge"><%= pendingOrdersCount %></span>
                    <% } %>
                </div>
                <span class="menu-text">Orders</span>
            </a>
        </li>

        <li><a href="admin_reports.jsp" class="<%= "admin_reports.jsp".equals(activePg) ? "active" : "" %>"><i class="fa-solid fa-chart-pie"></i> Reports</a></li>
        <li><a href="admin_offers.jsp" class="<%= activePg.equals("admin_offers.jsp") ? "active" : "" %>"><i class="fa-solid fa-tag" style="width:30px;"></i> Offers</a></li>
        <li><a href="admin_promos.jsp" class="<%= activePg.equals("admin_promos.jsp") ? "active" : "" %>"><i class="fa-solid fa-percent" style="width:30px;"></i> Promos</a></li>
        <li><a href="admin_users.jsp" class="<%= activePg.equals("admin_users.jsp") ? "active" : "" %>"><i class="fa-solid fa-users" style="width:30px;"></i> Users</a></li>
        <li><a href="admin_feedback.jsp" class="<%= activePg.equals("admin_feedback.jsp") ? "active" : "" %>"><i class="fa-solid fa-comment-dots" style="width:30px;"></i> Feedbacks</a></li>
        <li><a href="admin_contact.jsp" class="<%= activePg.equals("admin_contact.jsp") ? "active" : "" %>"><i class="fa-solid fa-address-book" style="width:30px;"></i> Contact Leads</a></li>

        <hr style="border-color: rgba(255,255,255,0.1); margin: 15px 0;">

        <li>
            <a href="admin_login.jsp" style="color: #ff4757;">
                <i class="fa-solid fa-house" style="width:30px;"></i> Exit Admin
            </a>
        </li>
    </ul>
</div>