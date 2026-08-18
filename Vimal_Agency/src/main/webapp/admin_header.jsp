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
<link rel="stylesheet" href="admin_style.css">

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
    }

    /* Mobile Admin Top Bar */
    .admin-mobile-topbar {
        display: none;
        background: var(--primary-dark);
        color: white;
        padding: 12px 18px;
        position: sticky;
        top: 0;
        z-index: 1001;
        box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        justify-content: space-between;
        align-items: center;
    }

    @media (max-width: 991px) {
        .admin-mobile-topbar {
            display: flex;
        }
        .admin-sidebar {
            position: fixed !important;
            top: 0;
            left: -280px;
            width: 270px !important;
            height: 100vh !important;
            z-index: 10002 !important;
            transition: transform 0.35s cubic-bezier(0.16, 1, 0.3, 1) !important;
            box-shadow: 5px 0 25px rgba(0,0,0,0.5) !important;
            overflow-y: auto;
        }
        .admin-sidebar.active {
            transform: translateX(280px) !important;
        }
        .admin-mobile-backdrop {
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.6);
            backdrop-filter: blur(2px);
            z-index: 10001;
            display: none;
        }
        .admin-mobile-backdrop.active {
            display: block;
        }
    }

    @media (min-width: 992px) {
        .admin-sidebar {
            width: var(--sidebar-width);
            height: 100vh;
            background: var(--primary-dark);
            position: fixed;
            top: 0;
            left: 0;
            color: var(--white);
            box-shadow: 4px 0 10px rgba(0,0,0,0.1);
            z-index: 1000;
            overflow-y: auto;
        }
        .admin-mobile-backdrop {
            display: none !important;
        }
    }

    .admin-logo {
        text-align: center;
        font-size: 18px;
        font-weight: 800;
        padding: 20px 15px;
        border-bottom: 1px solid rgba(255,255,255,0.1);
        display: flex;
        align-items: center;
        justify-content: space-between;
    }

    .sidebar-menu {
        list-style: none;
        padding: 15px 0;
        margin: 0;
    }

    .sidebar-menu li a {
        display: flex;
        align-items: center;
        gap: 12px;
        color: #bdc3c7;
        padding: 12px 20px;
        text-decoration: none;
        font-size: 14.5px;
        font-weight: 500;
        transition: 0.25s ease;
    }

    .sidebar-menu li a:hover {
        background: rgba(255, 200, 0, 0.1);
        color: var(--accent-yellow);
        border-left: 4px solid var(--accent-yellow);
    }

    .sidebar-menu li a.active {
        background: rgba(255, 200, 0, 0.15) !important;
        color: var(--accent-yellow) !important;
        border-left: 5px solid var(--accent-yellow);
        font-weight: 700;
    }

    .sidebar-menu i {
        font-size: 17px;
        width: 24px;
        text-align: center;
    }

    .cart-icon-wrapper {
        position: relative;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        width: 24px;
        height: 24px;
    }

    .cart-badge {
        position: absolute;
        top: -6px;
        right: -8px;
        background: #e11d48;
        color: white;
        font-size: 10px;
        font-weight: 800;
        min-width: 16px;
        height: 16px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        border: 2px solid #1a242f;
        line-height: 1;
    }
</style>

<!-- Mobile Top Bar -->
<div class="admin-mobile-topbar">
    <button type="button" class="btn btn-sm text-white p-1" onclick="toggleAdminSidebar()" aria-label="Open Admin Menu" style="font-size:20px;">
        <i class="fa-solid fa-bars"></i>
    </button>
    <div style="font-weight:800; font-size:16px; color:#ffc800;">
        VIMAL AGENCY <span style="color:white; font-size:13px; font-weight:600;">ADMIN</span>
    </div>
    <a href="admin_orders.jsp" class="position-relative text-white" aria-label="Pending Orders">
        <i class="fa-solid fa-cart-shopping fs-5"></i>
        <% if (pendingOrdersCount > 0) { %>
            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size:10px;">
                <%= pendingOrdersCount %>
            </span>
        <% } %>
    </a>
</div>

<!-- Backdrop Overlay for Mobile Drawer -->
<div class="admin-mobile-backdrop" id="adminBackdrop" onclick="toggleAdminSidebar()"></div>

<!-- Admin Sidebar Drawer -->
<div class="admin-sidebar" id="adminSidebar">
    <div class="admin-logo">
        <div><span style="color: #ffc800;">VIMAL AGENCY</span> <br><small style="font-size:11px; color:#94a3b8; font-weight:600;">ADMINISTRATION</small></div>
        <button type="button" class="btn-close btn-close-white d-lg-none" onclick="toggleAdminSidebar()" aria-label="Close Sidebar"></button>
    </div>

    <ul class="sidebar-menu">
        <li>
            <a href="admin_index.jsp" class="<%= "admin_index.jsp".equals(activePg) ? "active" : "" %>">
                <i class="fa-solid fa-gauge-high"></i> <span>Dashboard</span>
            </a>
        </li>

        <li style="padding: 6px 20px; font-size: 11px; font-weight: 700; color: #64748b; text-transform: uppercase; letter-spacing: 1px;">Catalog & Sales</li>

        <li><a href="admin_products.jsp" class="<%= activePg.equals("admin_products.jsp") ? "active" : "" %>"><i class="fa-solid fa-box"></i> <span>Products</span></a></li>

        <li>
            <a href="admin_orders.jsp" class="<%= activePg.equals("admin_orders.jsp") ? "active" : "" %>">
                <div class="cart-icon-wrapper">
                    <i class="fa-solid fa-cart-shopping"></i>
                    <% if (pendingOrdersCount > 0) { %>
                        <span class="cart-badge"><%= pendingOrdersCount %></span>
                    <% } %>
                </div>
                <span>Orders</span>
            </a>
        </li>

        <li><a href="admin_reports.jsp" class="<%= "admin_reports.jsp".equals(activePg) ? "active" : "" %>"><i class="fa-solid fa-chart-pie"></i> <span>Reports</span></a></li>
        <li><a href="admin_offers.jsp" class="<%= activePg.equals("admin_offers.jsp") ? "active" : "" %>"><i class="fa-solid fa-tag"></i> <span>Offers</span></a></li>
        <li><a href="admin_promos.jsp" class="<%= activePg.equals("admin_promos.jsp") ? "active" : "" %>"><i class="fa-solid fa-percent"></i> <span>Promos</span></a></li>

        <li style="padding: 6px 20px; font-size: 11px; font-weight: 700; color: #64748b; text-transform: uppercase; letter-spacing: 1px;">Users & Engagement</li>

        <li><a href="admin_users.jsp" class="<%= activePg.equals("admin_users.jsp") ? "active" : "" %>"><i class="fa-solid fa-users"></i> <span>Users</span></a></li>
        <li><a href="admin_feedback.jsp" class="<%= activePg.equals("admin_feedback.jsp") ? "active" : "" %>"><i class="fa-solid fa-comment-dots"></i> <span>Feedbacks</span></a></li>
        <li><a href="admin_contact.jsp" class="<%= activePg.equals("admin_contact.jsp") ? "active" : "" %>"><i class="fa-solid fa-address-book"></i> <span>Contact Leads</span></a></li>

        <div style="height:1px; background:rgba(255,255,255,0.1); margin: 15px 20px;"></div>

        <li>
            <a href="admin_login.jsp" style="color: #f87171;">
                <i class="fa-solid fa-right-from-bracket"></i> <span>Exit Admin</span>
            </a>
        </li>
    </ul>
</div>

<script>
    function toggleAdminSidebar() {
        var sidebar = document.getElementById("adminSidebar");
        var backdrop = document.getElementById("adminBackdrop");
        if (sidebar && backdrop) {
            sidebar.classList.toggle("active");
            backdrop.classList.toggle("active");
        }
    }
</script>
