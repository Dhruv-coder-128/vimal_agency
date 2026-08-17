<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="com.vimal.utils.DatabaseManager" %>
<%@ page import="java.sql.*" %>

<%
    // Ensure user session
    Object uIdObj = session.getAttribute("user_id");
    if (uIdObj == null) uIdObj = session.getAttribute("uid");
    if (uIdObj == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int u_id = (uIdObj instanceof Integer) ? (Integer) uIdObj : Integer.parseInt(uIdObj.toString());

    if (request.getMethod().equalsIgnoreCase("POST")) {
        request.setCharacterEncoding("UTF-8");
        try {
            String name = request.getParameter("name");
            String phn = request.getParameter("phone");
            String addr = request.getParameter("address");
            String city = request.getParameter("city");
            String pin = request.getParameter("pincode");
            int sub = Integer.parseInt(request.getParameter("subtotal"));
            int disc = Integer.parseInt(request.getParameter("discount"));
            int ship = Integer.parseInt(request.getParameter("shipping"));
            int total = Integer.parseInt(request.getParameter("final_total"));

            try (Connection con = DatabaseManager.getConnection()) {
                String sql = "INSERT INTO orders (user_id, customer_name, address, city, pincode, phone, subtotal, discount, shipping, final_total) VALUES (?,?,?,?,?,?,?,?,?,?)";
                int orderId = 0;
                try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setInt(1, u_id);
                    ps.setString(2, name);
                    ps.setString(3, addr);
                    ps.setString(4, city);
                    ps.setString(5, pin);
                    ps.setString(6, phn);
                    ps.setInt(7, sub);
                    ps.setInt(8, disc);
                    ps.setInt(9, ship);
                    ps.setInt(10, total);
                    ps.executeUpdate();

                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            orderId = rs.getInt(1);
                        }
                    }
                }

                if (orderId > 0) {
                    String itemSql = "INSERT INTO order_items (order_id, product_name, price, qty, image) SELECT ?, product_name, price, qty, image FROM cart WHERE user_id = ?";
                    try (PreparedStatement psItems = con.prepareStatement(itemSql)) {
                        psItems.setInt(1, orderId);
                        psItems.setInt(2, u_id);
                        psItems.executeUpdate();
                    }
                }

                String delSql = "DELETE FROM cart WHERE user_id = ?";
                try (PreparedStatement psDel = con.prepareStatement(delSql)) {
                    psDel.setInt(1, u_id);
                    psDel.executeUpdate();
                }
            }

            response.sendRedirect("my_orders.jsp");
            return;
        } catch (Exception e) {
            out.print("<div class='alert alert-danger text-center'>Error: " + e.getMessage() + "</div>");
        }
    }

    String subtotal = request.getParameter("subtotal");
    String discount = request.getParameter("discount");
    String shipping = request.getParameter("shipping");
    String finalTotal = request.getParameter("final_total");

    if (subtotal == null) subtotal = "0";
    if (discount == null) discount = "0";
    if (shipping == null) shipping = "0";
    if (finalTotal == null) finalTotal = "0";
%>

<!DOCTYPE html>
<html>

<head>
    <title>Checkout - Vimal Agency</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css">
    <style>
        :root {
            --primary: #4a2c7c;
            --secondary: #f0c14b;
            --bg: #f4f7f6;
            --success: #2ecc71;
        }

        body {
            font-family: 'Segoe UI', Tahoma, sans-serif;
            background: var(--bg);
            margin: 0;
        }

        .container {
            max-width: 900px;
            margin: 40px auto;
            padding: 20px;
        }

        .checkout-card {
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
        }

        h2 {
            color: var(--primary);
            border-bottom: 2px solid #eee;
            padding-bottom: 10px;
            margin-bottom: 25px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-weight: bold;
            margin-bottom: 8px;
            color: #555;
        }

        .form-control {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            box-sizing: border-box;
            font-size: 16px;
        }

        .row {
            display: flex;
            gap: 20px;
        }

        .col {
            flex: 1;
        }

        .order-summary {
            background: #f9f9f9;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 25px;
            border-left: 5px solid var(--primary);
        }

        .summary-line {
            display: flex;
            justify-content: space-between;
            margin: 8px 0;
            font-size: 15px;
        }

        .total-line {
            font-weight: bold;
            font-size: 1.2em;
            color: var(--success);
            border-top: 1px solid #ddd;
            padding-top: 10px;
            margin-top: 10px;
        }

        .btn-place-order {
            width: 100%;
            background: var(--success);
            color: white;
            border: none;
            padding: 15px;
            border-radius: 8px;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.3s;
        }

        .btn-place-order:hover {
            background: #27ae60;
            transform: translateY(-2px);
        }
    </style>
</head>

<body>

    <%@ include file="header.jsp" %>

    <div class="container">
        <div class="checkout-card">
            <h2><i class="fa-solid fa-truck-fast"></i> Delivery Address</h2>

            <div class="order-summary">
                <div class="summary-line"><span>Subtotal:</span> <span>₹ <%= subtotal %></span></div>
                <div class="summary-line"><span>Discount:</span> <span style="color:var(--success);">- ₹ <%= discount %></span></div>
                <div class="summary-line"><span>Shipping:</span> <span>₹ <%= shipping %></span></div>
                <div class="summary-line total-line"><span>Net Amount:</span> <span>₹ <%= finalTotal %></span></div>
            </div>

            <form action="place_order.jsp" method="post">
                <input type="hidden" name="subtotal" value="<%= subtotal %>">
                <input type="hidden" name="discount" value="<%= discount %>">
                <input type="hidden" name="shipping" value="<%= shipping %>">
                <input type="hidden" name="final_total" value="<%= finalTotal %>">

                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="name" class="form-control" placeholder="Enter your full name" required>
                </div>

                <div class="form-group">
                    <label>Phone Number</label>
                    <input type="text" name="phone" class="form-control" placeholder="Enter mobile number" required>
                </div>

                <div class="form-group">
                    <label>Shipping Address</label>
                    <textarea name="address" class="form-control" rows="3" placeholder="Flat / House No. / Colony" required></textarea>
                </div>

                <div class="row">
                    <div class="col form-group">
                        <label>City</label>
                        <input type="text" name="city" class="form-control" placeholder="City" required>
                    </div>
                    <div class="col form-group">
                        <label>Pincode</label>
                        <input type="text" name="pincode" class="form-control" placeholder="6-digit code" required>
                    </div>
                </div>

                <button type="submit" class="btn-place-order">
                    <i class="fa-solid fa-check-circle"></i> CONFIRM ORDER
                </button>
            </form>
        </div>
    </div>
</body>

</html>