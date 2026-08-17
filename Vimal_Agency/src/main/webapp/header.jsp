<%@ page import="java.sql.*" %>
<%@ page import="com.vimal.utils.DatabaseManager" %>

<%
    String pageName = request.getRequestURI();
    if (pageName != null) {
        pageName = pageName.substring(pageName.lastIndexOf("/") + 1);
    } else {
        pageName = "";
    }
    String uname = (String) session.getAttribute("username");
%>

<!DOCTYPE html>
<html>

<head>
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
            padding: 0 2%;
            background-color: #1a242f;
            height: 65px;
            position: sticky;
            top: 0;
            z-index: 1000;
            overflow: visible !important;
        }

        #logo {
            margin-left: 10px;
            font-size: 26px;
            font-weight: bold;
            text-decoration: none;
            margin-top: 5px;
        }

        .user-dropdown {
            position: relative;
            display: inline-block;
            margin-left: 15px;
            overflow: visible !important;
        }

        .user-trigger {
            display: flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
            padding: 5px 12px;
            border-radius: 50px;
            transition: 0.3s;
            background: transparent !important;
            margin-top: 8px;
        }

        .user-trigger:hover {
            background: rgba(255, 200, 0, 0.1) !important;
        }

        .user-avatar {
            width: 35px;
            height: 35px;
            background: #ffc800;
            color: #4a2c7c;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 1.1em;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        }

        .user-info-text {
            display: flex;
            flex-direction: column;
            line-height: 1.1;
            text-align: left;
            padding-top: 4px;
        }

        .hello-text {
            font-size: 0.72em;
            color: #ccc;
            margin-bottom: 1px;
        }

        .uname-text {
            color: #ffc800;
            font-weight: bold;
            font-size: 0.92em;
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .nav-list {
            display: flex;
            align-items: center;
            margin: 0;
            padding: 0;
            list-style: none;
            overflow: visible !important;
        }

        .nav-link a,
        .dropbtn {
            text-decoration: none !important;
            margin-top: 10px;
            display: inline-block;
            transition: 0.3s;
        }

        .dropdown {
            position: relative;
            display: inline-block;
        }

        .dropdown-content {
            display: none;
            position: absolute;
            background-color: #1a242f;
            min-width: 180px;
            box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.2);
            z-index: 1050;
            border-radius: 4px;
            top: 100%;
        }

        .dropdown-content a {
            color: white !important;
            padding: 6px 16px !important;
            text-decoration: none;
            display: block;
            font-size: 14px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            transition: 0.2s;
        }

        .dropdown-content a:hover {
            background-color: #0b46a5;
            padding-left: 20px !important;
        }

        .dropdown:hover .dropdown-content {
            display: block;
        }

        .cart-container {
            position: relative;
            display: inline-block;
            padding: 0 10px;
            text-decoration: none !important;
        }

        .cart-container i {
            font-size: 20px;
            color: white;
            transition: 0.3s;
        }

        .cart-badge {
            position: absolute;
            top: -8px;
            right: -2px;
            background-color: #ff4757;
            color: white;
            font-size: 10px;
            font-weight: bold;
            padding: 2px 6px;
            border-radius: 50%;
            border: 2px solid #1a242f;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        }

        .user-dropdown-content {
            display: none;
            position: absolute;
            right: 0;
            top: 120%;
            background-color: #fff;
            min-width: 195px;
            box-shadow: 0px 8px 25px rgba(0, 0, 0, 0.15);
            border-radius: 12px;
            z-index: 9999 !important;
            padding: 8px 0;
            border: 1px solid #eee;
        }

        .dropdown-header {
            padding: 4px 18px 8px 18px;
            font-size: 11px;
            color: #a0a0a0;
            text-transform: uppercase;
            font-weight: 800;
            letter-spacing: 0.8px;
        }

        .user-dropdown-content a {
            color: #2c3e50 !important;
            padding: 10px 18px;
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
            font-weight: 600;
            font-size: 16px;
            transition: 0.2s;
        }

        .user-dropdown-content a:hover {
            background: #f8f9fb;
            color: #0b46a5 !important;
        }

        .user-dropdown-content a i {
            color: #0b46a5;
            font-size: 18px;
        }

        .dropdown-divider {
            height: 1px;
            background: #f0f0f0;
            margin: 6px 0;
        }

        .dropdown-logout-btn {
            width: 90%;
            margin: 6px 5%;
            background: #ff4d4d;
            color: white !important;
            border: none;
            padding: 9px;
            border-radius: 8px;
            font-weight: bold;
            font-size: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            cursor: pointer;
            text-decoration: none;
            transition: 0.3s ease;
        }

        .dropdown-logout-btn:hover {
            background: #cc0000;
            transform: scale(1.02);
        }

        .show-user-menu {
            display: block !important;
        }
    </style>
</head>

<body>

    <div class="nav-div">
        <div>
            <a href="index.jsp" id="logo">
                <span style="color:#ffc800;">V</span>imal <span style="color:#ffc800;">A</span>gency
            </a>
        </div>

        <div>
            <ul class="nav-list">
                <li class="nav-link">
                    <a class="<%= pageName.equals("index.jsp") ? "nav-active" : "" %>" href="index.jsp">Home</a>
                </li>
                <li class="nav-link">
                    <div class="dropdown">
                        <a href="products.jsp" class="dropbtn <%= pageName.equals("products.jsp") ? "nav-active" : "" %>">Product</a>
                        <div class="dropdown-content">
                            <a href="products.jsp#Wafers">Wafer</a>
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

                <li class="nav-link"><a class="<%= pageName.equals("feedback.jsp") ? "nav-active" : "" %>" href="feedback.jsp">Feedback</a></li>
                <li class="nav-link"><a class="<%= pageName.equals("about-us.jsp") ? "nav-active" : "" %>" href="about-us.jsp">About Us</a></li>
                <li class="nav-link"><a class="<%= pageName.equals("contactus.jsp") ? "nav-active" : "" %>" href="contactus.jsp">Contact Us</a></li>

                <li class="nav-link">
                    <a href="cart.jsp" class="cart-container">
                        <i class="fa-solid fa-cart-shopping"></i>
                        <%
                            int cartCount = 0;
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
                                                cartCount = rsCount.getInt(1);
                                            }
                                        }
                                    }
                                }
                            } catch (Exception ignored) {}
                        %>
                        <% if(cartCount > 0) { %>
                            <span class="cart-badge"><%= cartCount %></span>
                        <% } %>
                    </a>
                </li>

                <% if(uname != null){ %>
                    <li class="nav-link">
                        <div class="user-dropdown">
                            <div class="user-trigger" onclick="toggleUserMenu()">
                                <div class="user-avatar">
                                    <%= uname.substring(0,1).toUpperCase() %>
                                </div>
                                <div class="user-info-text">
                                    <span class="hello-text">Hello,</span>
                                    <span class="uname-text">
                                        <%= uname %> <i class="fa-solid fa-chevron-down" style="font-size: 0.8em;"></i>
                                    </span>
                                </div>
                            </div>

                            <div id="userMenu" class="user-dropdown-content">
                                <div class="dropdown-header">My Account</div>

                                <a href="my_orders.jsp"><i class="fa-solid fa-box-open"></i> My Orders</a>

                                <div class="dropdown-divider"></div>

                                <a href="logout.jsp" class="dropdown-logout-btn">
                                    <i class="fa-solid fa-right-from-bracket"></i> Logout
                                </a>
                            </div>
                        </div>
                    </li>
                <% } %>
            </ul>
        </div>
    </div>

    <script>
        function toggleUserMenu() {
            var menu = document.getElementById("userMenu");
            if (menu) menu.classList.toggle("show-user-menu");
        }

        window.onclick = function (event) {
            if (!event.target.closest('.user-dropdown')) {
                var menu = document.getElementById("userMenu");
                if (menu && menu.classList.contains('show-user-menu')) {
                    menu.classList.remove('show-user-menu');
                }
            }
        }
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>

</body>

</html>