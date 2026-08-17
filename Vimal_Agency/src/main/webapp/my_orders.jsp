<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.vimal.utils.DatabaseManager" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    if (session.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp?msg=auth_required");
        return;
    }
%>

<!DOCTYPE html>
<html lang="gu">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Dashboard | Vimal Agency</title>

    <!-- Google Fonts & Font Awesome 6 -->
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        :root {
            --bg-body: #f8fafc;
            --card-bg: #ffffff;
            --card-border: #e2e8f0;
            --primary-navy: #0f172a;
            --accent-gold: #d97706;
            --accent-gold-light: #fffbebe6;
            --text-main: #1e293b;
            --text-muted: #64748b;
            --status-pending: #d97706;
            --status-delivered: #059669;
            --status-cancelled: #e11d48;
        }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: var(--bg-body);
            color: var(--text-main);
            min-height: 100vh;
        }

        .hero-banner {
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
            padding: 55px 0 85px;
            color: white;
            border-radius: 0 0 30px 30px;
        }

        .portal-pill {
            background: rgba(251, 191, 36, 0.15);
            color: #fbbf24;
            border: 1px solid rgba(251, 191, 36, 0.3);
            border-radius: 50px;
            padding: 5px 16px;
            font-size: 0.75rem;
            font-weight: 800;
            letter-spacing: 1.2px;
            display: inline-block;
        }

        .content-container {
            margin-top: -40px;
            padding-bottom: 60px;
        }

        .order-card {
            background: var(--card-bg);
            border: 1px solid var(--card-border);
            border-radius: 20px;
            padding: 24px;
            margin-bottom: 20px;
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
            box-shadow: 0 4px 20px -2px rgba(0, 0, 0, 0.03);
        }

        .order-card:hover {
            transform: translateY(-3px);
            border-color: #cbd5e1;
            box-shadow: 0 12px 25px -5px rgba(0, 0, 0, 0.08);
        }

        .status-orb {
            width: 56px;
            height: 56px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.3rem;
            flex-shrink: 0;
        }

        .orb-pending {
            background: #fef3c7;
            color: #b45309;
        }

        .orb-delivered {
            background: #d1fae5;
            color: #047857;
        }

        .orb-cancelled {
            background: #ffe4e6;
            color: #be123c;
        }

        .invoice-chip {
            font-size: 0.78rem;
            font-weight: 800;
            color: var(--accent-gold);
            cursor: pointer;
            letter-spacing: 0.5px;
            transition: opacity 0.2s;
        }

        .invoice-chip:hover {
            opacity: 0.8;
        }

        .order-amount {
            font-size: 1.55rem;
            font-weight: 800;
            color: var(--primary-navy);
            letter-spacing: -0.5px;
        }

        .btn-track {
            background: var(--primary-navy);
            color: #ffffff;
            padding: 10px 22px;
            border-radius: 12px;
            font-weight: 700;
            font-size: 0.85rem;
            border: none;
            transition: all 0.25s ease;
        }

        .btn-track:hover {
            background: #1e293b;
            color: #ffffff;
        }

        .btn-cancel {
            background: #fee2e2;
            color: #b91c1c;
            padding: 10px 18px;
            border-radius: 12px;
            font-weight: 700;
            font-size: 0.85rem;
            text-decoration: none;
            border: none;
            transition: 0.2s ease;
        }

        .btn-cancel:hover {
            background: #fecaca;
            color: #991b1b;
        }

        .summary-pane {
            display: none;
            border-top: 1px dashed var(--card-border);
            margin-top: 20px;
            padding-top: 20px;
        }

        .item-chip {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px;
            border-radius: 12px;
            background: #f8fafc;
            margin-bottom: 8px;
        }

        .item-chip img {
            width: 48px;
            height: 48px;
            border-radius: 8px;
            object-fit: cover;
            border: 1px solid #e2e8f0;
        }

        .status-timeline {
            display: flex;
            align-items: center;
            position: relative;
            margin-top: 10px;
        }

        .status-timeline::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 2px;
            background: #e2e8f0;
            z-index: 1;
            transform: translateY(-50%);
        }

        .timeline-step {
            position: relative;
            z-index: 2;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: #ffffff;
            border: 2px solid #e2e8f0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            color: var(--text-muted);
            margin-right: auto;
        }

        .timeline-step:last-child {
            margin-right: 0;
        }

        .timeline-step.active {
            background: var(--status-delivered);
            border-color: var(--status-delivered);
            color: #ffffff;
        }

        .rotate-chevron {
            transition: transform 0.3s ease;
        }

        .rotate-chevron.open {
            transform: rotate(180deg);
        }
    </style>
</head>

<body>

    <%@ include file="header.jsp" %>

    <!-- Hero Header Section -->
    <div class="hero-banner text-center">
        <div class="container">
            <span class="portal-pill mb-2">VIMAL AGENCY PORTAL</span>
            <h1 class="display-6 fw-800 text-white mb-0">Order <span style="color: #fbbf24;">Insights</span></h1>
        </div>
    </div>

    <!-- Main Content Container -->
    <div class="container content-container">
        <%
            Connection con = null;
            try {
                Object uidObj = session.getAttribute("user_id");
                int u_id = Integer.parseInt(uidObj.toString());
                con = DatabaseManager.getConnection();

                // Cancel Order Logic
                String cancelId = request.getParameter("cancel_id");
                if (cancelId != null && !cancelId.trim().isEmpty()) {
                    String cancelSql = "UPDATE orders SET status='Cancelled' WHERE order_id=? AND user_id=? AND status='Pending'";
                    try (PreparedStatement psCancel = con.prepareStatement(cancelSql)) {
                        psCancel.setInt(1, Integer.parseInt(cancelId));
                        psCancel.setInt(2, u_id);
                        psCancel.executeUpdate();
                    }
                    response.sendRedirect("my_orders.jsp");
                    return;
                }

                String ordersSql = "SELECT * FROM orders WHERE user_id=? ORDER BY order_id DESC";
                try (PreparedStatement ps = con.prepareStatement(ordersSql)) {
                    ps.setInt(1, u_id);
                    try (ResultSet rs = ps.executeQuery()) {
                        SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy • hh:mm a");
                        boolean hasOrders = false;

                        while (rs.next()) {
                            hasOrders = true;
                            int oId = rs.getInt("order_id");
                            String status = rs.getString("status");
                            String icon = "fa-box-open";
                            String orbClass = "orb-delivered";

                            if ("Pending".equalsIgnoreCase(status)) {
                                icon = "fa-hourglass-half";
                                orbClass = "orb-pending";
                            } else if ("Cancelled".equalsIgnoreCase(status)) {
                                icon = "fa-ban";
                                orbClass = "orb-cancelled";
                            }

                            Timestamp orderDate = rs.getTimestamp("order_date");
                            String formattedDate = (orderDate != null) ? sdf.format(orderDate) : "";
        %>

        <!-- Order Card -->
        <div class="order-card">
            <div class="d-flex flex-column flex-md-row align-items-start align-items-md-center justify-content-between gap-3">

                <!-- Left Info Section -->
                <div class="d-flex align-items-center gap-3">
                    <div class="status-orb <%= orbClass %>">
                        <i class="fa-solid <%= icon %>"></i>
                    </div>
                    <div>
                        <span class="invoice-chip" onclick="copyInvoice('<%= oId %>')">
                            INVOICE #<%= oId %> <i class="fa-regular fa-copy ms-1"></i>
                        </span>
                        <div class="order-amount">₹<%= rs.getInt("final_total") %></div>
                        <div class="text-muted small">
                            <i class="fa-regular fa-calendar me-1"></i>
                            <%= formattedDate %>
                        </div>
                    </div>
                </div>

                <!-- Right Action Buttons -->
                <div class="d-flex align-items-center gap-3 w-100 w-md-auto justify-content-between justify-content-md-end">
                    <% if ("Pending".equalsIgnoreCase(status)) { %>
                        <a href="javascript:void(0)" onclick="confirmCancel(<%= oId %>)" class="btn-cancel">
                            <i class="fa-solid fa-xmark me-1"></i> Cancel
                        </a>
                    <% } %>

                    <button class="btn-track" onclick="toggleItems(<%= oId %>)">
                        Explore Order <i class="fa-solid fa-chevron-down ms-1 rotate-chevron" id="chevron-<%= oId %>"></i>
                    </button>
                </div>

            </div>

            <!-- Accordion Details Pane -->
            <div id="items-<%= oId %>" class="summary-pane">

                <!-- Mini Status Progress Tracker -->
                <div class="mb-4 px-2">
                    <div class="text-muted small fw-700 mb-1">ORDER TRACKING</div>
                    <div class="status-timeline">
                        <div class="timeline-step active"><i class="fa-solid fa-check"></i></div>
                        <div class="timeline-step <%= !"Cancelled".equalsIgnoreCase(status) ? "active" : "" %>"><i class="fa-solid fa-gear"></i></div>
                        <div class="timeline-step <%= "Delivered".equalsIgnoreCase(status) ? "active" : "" %>"><i class="fa-solid fa-truck"></i></div>
                    </div>
                </div>

                <div class="row g-4">
                    <!-- Products Purchased -->
                    <div class="col-lg-7">
                        <h6 class="text-muted small fw-800 text-uppercase mb-3">Items Purchased</h6>
                        <%
                            String itemSql = "SELECT * FROM order_items WHERE order_id=?";
                            try (PreparedStatement psItems = con.prepareStatement(itemSql)) {
                                psItems.setInt(1, oId);
                                try (ResultSet rsI = psItems.executeQuery()) {
                                    while (rsI.next()) {
                                        String itmImg = rsI.getString("image");
                        %>
                        <div class="item-chip">
                            <img src="<%= (itmImg != null ? itmImg : "") %>" alt="Product Image">
                            <div class="flex-grow-1">
                                <span class="fw-700 text-dark d-block mb-1"><%= rsI.getString("product_name") %></span>
                                <span class="text-muted small">Qty: <%= rsI.getInt("qty") %> × ₹<%= rsI.getInt("price") %></span>
                            </div>
                            <span class="fw-800 text-dark">₹<%= rsI.getInt("qty") * rsI.getInt("price") %></span>
                        </div>
                        <%
                                    }
                                }
                            }
                        %>
                    </div>

                    <!-- Shipping Address Details -->
                    <div class="col-lg-5 border-start-lg ps-lg-4">
                        <h6 class="text-muted small fw-800 text-uppercase mb-3">Delivery Information</h6>
                        <div class="bg-white p-3 rounded-3 mb-3 border">
                            <div class="text-warning-emphasis small fw-700 mb-1">
                                <i class="fa-solid fa-location-dot me-2 text-warning"></i>Shipping Address
                            </div>
                            <p class="text-muted small mb-0">
                                <%= (rs.getString("address") != null ? rs.getString("address") : "") %>,<br>
                                <%= (rs.getString("city") != null ? rs.getString("city") : "") %> - <%= (rs.getString("pincode") != null ? rs.getString("pincode") : "") %>
                            </p>
                        </div>

                        <div class="d-flex justify-content-between align-items-center">
                            <span class="text-muted small fw-700">Order Status:</span>
                            <span class="badge rounded-pill text-capitalize px-3 py-2 <%= orbClass %>"><%= status %></span>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <%
                        }
                        if (!hasOrders) {
        %>
        <div class="card p-5 text-center shadow-sm border-0 rounded-4">
            <i class="fa-solid fa-basket-shopping text-muted mb-3" style="font-size: 3rem;"></i>
            <h4 class="fw-bold">No orders found</h4>
            <p class="text-muted">You haven't placed any orders yet. Browse our snacks catalog!</p>
            <a href="products.jsp" class="btn btn-warning fw-bold px-4 py-2 mx-auto" style="border-radius: 10px;">Shop Now</a>
        </div>
        <%
                        }
                    }
                }
            } catch (Exception e) {
                out.print("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
            } finally {
                if (con != null) try { con.close(); } catch (Exception ignored) {}
            }
        %>
    </div>

    <!-- Interactive JS -->
    <script>
        function toggleItems(id) {
            const pane = document.getElementById("items-" + id);
            const chevron = document.getElementById("chevron-" + id);

            if (pane.style.display === "block") {
                pane.style.display = "none";
                chevron.classList.remove("open");
            } else {
                pane.style.display = "block";
                chevron.classList.add("open");
            }
        }

        function confirmCancel(id) {
            if (confirm('Are you sure you want to cancel Order #' + id + '?')) {
                window.location.href = "my_orders.jsp?cancel_id=" + id;
            }
        }

        function copyInvoice(id) {
            navigator.clipboard.writeText(id);
            alert("Invoice #" + id + " copied to clipboard!");
        }
    </script>

</body>

</html>