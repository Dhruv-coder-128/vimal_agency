<%@ page import="java.sql.*" %>
<%@ page import="com.vimal.utils.DatabaseManager" %>

<%
    String pageName = request.getRequestURI();
    if (pageName != null) {
        pageName = pageName.substring(pageName.lastIndexOf("/") + 1);
    } else {
        pageName = "";
    }
    String headerUname = (String) session.getAttribute("username");
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vimal Agency</title>

    <link rel="shortcut icon" href="Product/balaji_logo.png?v=5">
    <link rel='stylesheet' type='text/css' href='main.css'>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <style>
        .nav-div {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 clamp(15px, 3vw, 30px);
            background-color: #1a242f;
            height: 65px;
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: 0 2px 10px rgba(0,0,0,0.15);
        }

        #logo {
            font-size: clamp(20px, 4vw, 26px);
            font-weight: bold;
            text-decoration: none;
            color: #ffffff;
            display: inline-flex;
            align-items: center;
        }

        #logo span { color: #ffc800; }

        /* Desktop Nav List */
        .desktop-nav {
            display: none;
            align-items: center;
            margin: 0;
            padding: 0;
            list-style: none;
        }

        @media (min-width: 992px) {
            .desktop-nav {
                display: flex;
            }
            .mobile-nav-toggle {
                display: none !important;
            }
        }

        .desktop-nav .nav-link-item {
            margin: 0 6px;
            list-style: none;
        }

        .desktop-nav .nav-link-item a,
        .desktop-nav .dropbtn {
            color: #ffffff;
            font-size: 16px;
            font-weight: 600;
            padding: 8px 12px;
            border-radius: 8px;
            text-decoration: none;
            transition: 0.25s;
            display: inline-flex;
            align-items: center;
            background: transparent;
            border: none;
        }

        .desktop-nav .nav-link-item a:hover,
        .desktop-nav .dropbtn:hover,
        .desktop-nav .nav-active {
            color: #ffc800 !important;
            background: rgba(255, 200, 0, 0.1);
        }

        /* Cart Container */
        .cart-container {
            position: relative;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            font-size: 18px;
            padding: 8px 12px;
            border-radius: 8px;
            text-decoration: none;
            transition: 0.25s;
        }
        .cart-container:hover {
            color: #ffc800;
            background: rgba(255, 200, 0, 0.1);
        }

        .cart-badge {
            position: absolute;
            top: -2px;
            right: 0px;
            background: #e11d48;
            color: white;
            font-size: 11px;
            font-weight: 800;
            padding: 2px 6px;
            border-radius: 50px;
            min-width: 18px;
            text-align: center;
            line-height: 1.2;
            border: 2px solid #1a242f;
        }

        /* User Dropdown Desktop */
        .user-dropdown {
            position: relative;
            display: inline-block;
            margin-left: 10px;
        }

        .user-trigger {
            display: flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            padding: 4px 10px;
            border-radius: 50px;
            transition: 0.3s;
            background: rgba(255,255,255,0.05);
        }

        .user-trigger:hover {
            background: rgba(255, 200, 0, 0.15);
        }

        .user-avatar {
            width: 32px;
            height: 32px;
            background: #ffc800;
            color: #1a242f;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
            font-size: 0.9em;
        }

        .user-dropdown-content {
            display: none;
            position: absolute;
            right: 0;
            top: calc(100% + 8px);
            background-color: #ffffff;
            min-width: 200px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
            border-radius: 12px;
            padding: 8px 0;
            z-index: 1050;
            border: 1px solid #e2e8f0;
        }

        .user-dropdown-content a {
            color: #1e293b !important;
            padding: 10px 18px !important;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            transition: 0.2s;
        }

        .user-dropdown-content a:hover {
            background-color: #f8fafc;
            color: #d97706 !important;
        }

        .dropdown-logout-btn {
            color: #e11d48 !important;
        }
        .dropdown-logout-btn:hover {
            background-color: #fff1f2 !important;
        }

        .show-user-menu {
            display: block !important;
        }

        /* Category Dropdown Menu */
        .dropdown {
            position: relative;
            display: inline-block;
        }

        .dropdown-content {
            display: none;
            position: absolute;
            background-color: #1a242f;
            min-width: 190px;
            box-shadow: 0px 8px 20px rgba(0, 0, 0, 0.3);
            z-index: 1050;
            border-radius: 8px;
            top: 100%;
            border: 1px solid rgba(255,255,255,0.1);
            overflow: hidden;
        }

        .dropdown-content a {
            color: #ffffff !important;
            padding: 10px 16px !important;
            text-decoration: none;
            display: block;
            font-size: 14px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            transition: 0.2s;
        }

        .dropdown-content a:hover {
            background: #ffc800;
            color: #1a242f !important;
        }

        .dropdown:hover .dropdown-content {
            display: block;
        }

        /* Mobile Hamburger & Controls */
        .mobile-nav-toggle {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .mobile-toggle-btn {
            background: transparent;
            border: none;
            color: #ffffff;
            font-size: 22px;
            cursor: pointer;
            padding: 8px;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: 0.2s;
        }
        .mobile-toggle-btn:hover, .mobile-toggle-btn:focus {
            background: rgba(255,255,255,0.1);
            color: #ffc800;
            outline: none;
        }

        /* Mobile Offcanvas Drawer */
        .mobile-drawer {
            position: fixed;
            top: 0;
            right: -310px;
            width: 290px;
            max-width: 85vw;
            height: 100vh;
            background: #1a242f;
            z-index: 10002;
            transition: transform 0.35s cubic-bezier(0.16, 1, 0.3, 1);
            display: flex;
            flex-direction: column;
            box-shadow: -5px 0 30px rgba(0,0,0,0.5);
            overflow-y: auto;
        }

        .mobile-drawer.active {
            transform: translateX(-310px);
        }

        .mobile-drawer-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 18px 20px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .mobile-drawer-close {
            background: rgba(255,255,255,0.08);
            border: none;
            color: #ffffff;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
            cursor: pointer;
            transition: 0.2s;
        }
        .mobile-drawer-close:hover {
            background: #e11d48;
            color: #ffffff;
        }

        .mobile-drawer-body {
            padding: 20px 15px;
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .mobile-nav-link {
            color: #ffffff;
            padding: 12px 16px;
            border-radius: 10px;
            text-decoration: none;
            font-size: 15px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 12px;
            transition: 0.2s;
        }

        .mobile-nav-link:hover, .mobile-nav-link.active {
            background: rgba(255, 200, 0, 0.12);
            color: #ffc800;
        }

        .mobile-categories-accordion {
            background: rgba(0,0,0,0.2);
            border-radius: 10px;
            padding: 6px 12px;
            margin-top: 4px;
            display: none;
        }

        .mobile-categories-accordion.show {
            display: block;
        }

        .mobile-categories-accordion a {
            display: block;
            color: #cbd5e1;
            padding: 8px 10px;
            font-size: 14px;
            text-decoration: none;
            border-radius: 6px;
            transition: 0.2s;
        }
        .mobile-categories-accordion a:hover {
            color: #ffc800;
            background: rgba(255,255,255,0.05);
        }

        .mobile-backdrop {
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.6);
            backdrop-filter: blur(2px);
            z-index: 10001;
            display: none;
            opacity: 0;
            transition: opacity 0.3s;
        }

        .mobile-backdrop.active {
            display: block;
            opacity: 1;
        }
    </style>
</head>

<body>

    <%
        int headerCartCount = 0;
        try {
            Integer headerUserId = null;
            Object headerUserObj = session.getAttribute("user_id");
            if (headerUserObj == null) {
                headerUserObj = session.getAttribute("uid");
            }
            if (headerUserObj != null) {
                if (headerUserObj instanceof Integer) {
                    headerUserId = (Integer) headerUserObj;
                } else {
                    headerUserId = Integer.valueOf(headerUserObj.toString());
                }
                try (Connection conCount = DatabaseManager.getConnection();
                     PreparedStatement psCount = conCount.prepareStatement("SELECT SUM(qty) FROM cart WHERE user_id=?")) {
                    psCount.setInt(1, headerUserId);
                    try (ResultSet rsCount = psCount.executeQuery()) {
                        if (rsCount.next()) {
                            headerCartCount = rsCount.getInt(1);
                        }
                    }
                }
            }
        } catch (Exception ignored) {}
    %>

    <div class="nav-div">
        <div>
            <a href="index.jsp" id="logo" aria-label="Vimal Agency Home">
                <span>V</span>imal <span>A</span>gency
            </a>
        </div>

        <!-- Desktop Navigation Bar -->
        <ul class="desktop-nav">
            <li class="nav-link-item">
                <a class="<%= pageName.equals("index.jsp") ? "nav-active" : "" %>" href="index.jsp">Home</a>
            </li>
            <li class="nav-link-item">
                <div class="dropdown">
                    <a href="products.jsp" class="dropbtn <%= pageName.equals("products.jsp") ? "nav-active" : "" %>">
                        Products <i class="fa-solid fa-chevron-down ms-1" style="font-size: 0.75em;"></i>
                    </a>
                    <div class="dropdown-content">
                        <a href="products.jsp#Wafers">Wafers</a>
                        <a href="products.jsp#Western_Snacks">Western Snacks</a>
                        <a href="products.jsp#Snack_Pellets">Snack Pellets</a>
                        <a href="products.jsp#Namkeen">Namkeen</a>
                        <a href="products.jsp#Peantus">Peanuts</a>
                        <a href="products.jsp#Khakhra">Khakhra</a>
                        <a href="products.jsp#Wafer_Biscuit">Wafer Biscuit</a>
                        <a href="products.jsp#Confectionary">Confectionary</a>
                        <a href="products.jsp#Gippi">Gippi Noodles</a>
                        <a href="products.jsp#Olee">Olee</a>
                    </div>
                </div>
            </li>

            <li class="nav-link-item"><a class="<%= pageName.equals("feedback.jsp") ? "nav-active" : "" %>" href="feedback.jsp">Feedback</a></li>
            <li class="nav-link-item"><a class="<%= pageName.equals("about-us.jsp") ? "nav-active" : "" %>" href="about-us.jsp">About Us</a></li>
            <li class="nav-link-item"><a class="<%= pageName.equals("contactus.jsp") ? "nav-active" : "" %>" href="contactus.jsp">Contact Us</a></li>

            <li class="nav-link-item">
                <a href="cart.jsp" class="cart-container" aria-label="View Shopping Cart">
                    <i class="fa-solid fa-cart-shopping"></i>
                    <% if(headerCartCount > 0) { %>
                        <span class="cart-badge"><%= headerCartCount %></span>
                    <% } %>
                </a>
            </li>

            <% if(headerUname != null){ %>
                <li class="nav-link-item">
                    <div class="user-dropdown">
                        <div class="user-trigger" onclick="toggleUserMenu()" role="button" aria-expanded="false" aria-label="User Account Menu">
                            <div class="user-avatar">
                                <%= headerUname.substring(0,1).toUpperCase() %>
                            </div>
                            <span style="color:#ffc800; font-weight:700; font-size:14px;">
                                <%= headerUname %> <i class="fa-solid fa-chevron-down ms-1" style="font-size: 0.75em;"></i>
                            </span>
                        </div>

                        <div id="userMenu" class="user-dropdown-content">
                            <a href="my_orders.jsp"><i class="fa-solid fa-box-open text-primary"></i> My Orders</a>
                            <div style="height:1px; background:#e2e8f0; margin:4px 0;"></div>
                            <a href="logout.jsp" class="dropdown-logout-btn">
                                <i class="fa-solid fa-right-from-bracket"></i> Logout
                            </a>
                        </div>
                    </div>
                </li>
            <% } else { %>
                <li class="nav-link-item">
                    <a href="login.jsp" style="background:#ffc800; color:#1a242f !important; font-weight:700; border-radius:8px;">Sign In</a>
                </li>
            <% } %>
        </ul>

        <!-- Mobile Controls (Cart + Hamburger) -->
        <div class="mobile-nav-toggle">
            <a href="cart.jsp" class="cart-container" aria-label="View Cart">
                <i class="fa-solid fa-cart-shopping"></i>
                <% if(headerCartCount > 0) { %>
                    <span class="cart-badge"><%= headerCartCount %></span>
                <% } %>
            </a>

            <button class="mobile-toggle-btn" id="mobileNavBtn" onclick="toggleMobileDrawer()" aria-label="Open Navigation Menu">
                <i class="fa-solid fa-bars"></i>
            </button>
        </div>
    </div>

    <!-- Mobile Offcanvas Drawer -->
    <div class="mobile-backdrop" id="navBackdrop" onclick="toggleMobileDrawer()"></div>
    <div class="mobile-drawer" id="mobileDrawer">
        <div class="mobile-drawer-header">
            <div style="color:#ffc800; font-weight:800; font-size:18px;">VIMAL AGENCY</div>
            <button class="mobile-drawer-close" onclick="toggleMobileDrawer()" aria-label="Close Menu">
                <i class="fa-solid fa-xmark"></i>
            </button>
        </div>
        <div class="mobile-drawer-body">
            <% if(headerUname != null) { %>
                <div style="padding:10px 14px; background:rgba(255,200,0,0.1); border-radius:10px; margin-bottom:10px; display:flex; align-items:center; gap:10px;">
                    <div class="user-avatar"><%= headerUname.substring(0,1).toUpperCase() %></div>
                    <div>
                        <div style="font-size:11px; color:#cbd5e1;">Logged In As</div>
                        <div style="font-weight:700; color:#ffc800;"><%= headerUname %></div>
                    </div>
                </div>
            <% } %>

            <a href="index.jsp" class="mobile-nav-link <%= pageName.equals("index.jsp") ? "active" : "" %>">
                <i class="fa-solid fa-house" style="width:20px;"></i> Home
            </a>

            <div>
                <a href="javascript:void(0)" class="mobile-nav-link justify-content-between" onclick="toggleMobileCategories()">
                    <span><i class="fa-solid fa-tags" style="width:20px;"></i> Products</span>
                    <i class="fa-solid fa-chevron-down" id="catChevron" style="font-size:12px; transition:0.3s;"></i>
                </a>
                <div class="mobile-categories-accordion" id="mobileCatAccordion">
                    <a href="products.jsp">All Products</a>
                    <a href="products.jsp#Wafers">Wafers</a>
                    <a href="products.jsp#Western_Snacks">Western Snacks</a>
                    <a href="products.jsp#Snack_Pellets">Snack Pellets</a>
                    <a href="products.jsp#Namkeen">Namkeen</a>
                    <a href="products.jsp#Peantus">Peanuts</a>
                    <a href="products.jsp#Khakhra">Khakhra</a>
                    <a href="products.jsp#Wafer_Biscuit">Wafer Biscuit</a>
                    <a href="products.jsp#Confectionary">Confectionary</a>
                    <a href="products.jsp#Gippi">Gippi Noodles</a>
                    <a href="products.jsp#Olee">Olee</a>
                </div>
            </div>

            <a href="feedback.jsp" class="mobile-nav-link <%= pageName.equals("feedback.jsp") ? "active" : "" %>">
                <i class="fa-solid fa-comment-dots" style="width:20px;"></i> Feedback
            </a>
            <a href="about-us.jsp" class="mobile-nav-link <%= pageName.equals("about-us.jsp") ? "active" : "" %>">
                <i class="fa-solid fa-circle-info" style="width:20px;"></i> About Us
            </a>
            <a href="contactus.jsp" class="mobile-nav-link <%= pageName.equals("contactus.jsp") ? "active" : "" %>">
                <i class="fa-solid fa-phone" style="width:20px;"></i> Contact Us
            </a>

            <% if(headerUname != null) { %>
                <a href="my_orders.jsp" class="mobile-nav-link <%= pageName.equals("my_orders.jsp") ? "active" : "" %>">
                    <i class="fa-solid fa-box-open" style="width:20px;"></i> My Orders
                </a>
                <div style="height:1px; background:rgba(255,255,255,0.1); margin:10px 0;"></div>
                <a href="logout.jsp" class="mobile-nav-link" style="color:#f87171;">
                    <i class="fa-solid fa-right-from-bracket" style="width:20px;"></i> Logout
                </a>
            <% } else { %>
                <div style="height:1px; background:rgba(255,255,255,0.1); margin:10px 0;"></div>
                <a href="login.jsp" class="mobile-nav-link" style="background:#ffc800; color:#1a242f !important; font-weight:700;">
                    <i class="fa-solid fa-arrow-right-to-bracket" style="width:20px;"></i> Sign In
                </a>
            <% } %>
        </div>
    </div>

    <script>
        function toggleUserMenu() {
            var menu = document.getElementById("userMenu");
            if (menu) menu.classList.toggle("show-user-menu");
        }

        function toggleMobileDrawer() {
            var drawer = document.getElementById("mobileDrawer");
            var backdrop = document.getElementById("navBackdrop");
            if (drawer && backdrop) {
                drawer.classList.toggle("active");
                backdrop.classList.toggle("active");
            }
        }

        function toggleMobileCategories() {
            var acc = document.getElementById("mobileCatAccordion");
            var chev = document.getElementById("catChevron");
            if (acc) acc.classList.toggle("show");
            if (chev) chev.style.transform = acc.classList.contains("show") ? "rotate(180deg)" : "rotate(0deg)";
        }

        window.addEventListener('click', function (event) {
            if (!event.target.closest('.user-dropdown')) {
                var menu = document.getElementById("userMenu");
                if (menu && menu.classList.contains('show-user-menu')) {
                    menu.classList.remove('show-user-menu');
                }
            }
        });

        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape') {
                var drawer = document.getElementById("mobileDrawer");
                var backdrop = document.getElementById("navBackdrop");
                if (drawer && drawer.classList.contains("active")) {
                    drawer.classList.remove("active");
                    if (backdrop) backdrop.classList.remove("active");
                }
            }
        });
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>

</body>

</html>
