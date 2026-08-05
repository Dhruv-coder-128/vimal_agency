<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.vimal.utils.DatabaseManager" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.vimal.utils.DatabaseManager" %>
<%
    if (session.getAttribute("admin_id") == null) {
        response.sendRedirect("admin_login.jsp?msg=admin_auth_required");
        return; 
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Customer Ledger | Vimal Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif; background-color: #f8f9fa; color: #333; }
        .admin-main { margin-left: 260px; padding: 30px; min-height: 100vh; }
        
        /* Clean Ledger Box */
        .ledger-box { background: #ffffff; border: 1px solid #dee2e6; border-radius: 4px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
        .ledger-header { background: #f8f9fa; padding: 15px 20px; border-bottom: 1px solid #dee2e6; font-weight: 600; font-size: 16px; }
        
        /* Master User Row */
        .master-user-row { cursor: pointer; background: #ffffff !important; transition: background 0.15s; }
        .master-user-row:hover { background: #f1f3f5 !important; }
        
        /* CRM Panel Grid */
        .crm-panel { background: #f8f9fa; padding: 20px; border: 1px solid #dee2e6; margin: 10px 15px; border-radius: 4px; }
        .info-card { background: #ffffff; border: 1px solid #dee2e6; padding: 15px; border-radius: 4px; height: 100%; }
        .info-title { font-size: 14px; font-weight: 700; color: #495057; border-bottom: 2px solid #dee2e6; padding-bottom: 5px; margin-bottom: 10px; }
        
        .info-row { display: flex; justify-content: space-between; padding: 6px 0; border-bottom: 1px dashed #dee2e6; font-size: 13px; }
        .info-label { color: #6c757d; font-weight: 500; }
        .info-value { color: #212529; font-weight: 600; }
        
        /* Right Side Orders & Items */
        .orders-card { background: #ffffff; border: 1px solid #dee2e6; border-radius: 4px; }
        .orders-title { background: #e9ecef; padding: 10px 15px; font-size: 13px; font-weight: 700; color: #495057; border-bottom: 1px solid #dee2e6; }
        
        .order-row-header { cursor: pointer; background: #ffffff !important; transition: background 0.15s; font-size: 13px; }
        .order-row-header:hover { background: #e9ecef !important; }
        
        /* Inner Items SKU Table */
        .inner-item-box { background: #f8f9fa; border: 1px solid #ced4da; padding: 10px; border-radius: 4px; margin: 5px 10px; }
        
        .status-pill { padding: 3px 8px; border-radius: 3px; font-size: 11px; font-weight: bold; text-transform: uppercase; }
        .status-del { background: #d1e7dd; color: #0f5132; }
        .status-pen { background: #fff3cd; color: #664d03; }
        .status-can { background: #f8d7da; color: #842029; }

        @media print {
            .no-print { display: none !important; }
            .admin-main { margin-left: 0 !important; padding: 0 !important; }
            .collapse { display: block !important; height: auto !important; }
        }
    </style>
</head>
<body>

    <div class="no-print">
        <%@ include file="admin_header.jsp" %>
    </div>

    <div class="admin-main">
        <!-- Main Top Header -->
        <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom no-print">
            <div>
                <h2 style="font-weight: 700; color: #212529; margin: 0; font-size: 24px;">Customer Accounts Ledger</h2>
                <p style="color: #6c757d; margin: 3px 0 0 0; font-size: 13px;">Manage distributors, view registered profiles, and track complete invoice histories.</p>
            </div>
            <button onclick="window.print()" class="btn btn-sm btn-outline-secondary fw-bold text-dark px-3 py-2" style="background: white; border-radius: 4px;">
                <i class="fa-solid fa-print me-1"></i> Print Statement
            </button>
        </div>

        <!-- 📝 MASTER TABLE -->
        <div class="ledger-box">
            <div class="ledger-header">
                <i class="fa-solid fa-list me-2 text-secondary"></i>Retailer Accounts Directory
            </div>
            
            <table class="table align-middle mb-0 table-bordered">
                <thead style="background: #f8f9fa; font-size: 13px; color: #495057;">
                    <tr>
                        <th class="ps-3" style="width: 80px;">User ID</th>
                        <th>Account Name</th>
                        <th>Mobile Number</th>
                        <th>City Location</th>
                        <th class="text-center no-print" style="width: 130px;">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        Connection con = null;
                        Connection conOrders = null;
                        Connection conItems = null;
                        
                        PreparedStatement psUsers = null;
                        PreparedStatement psOrders = null;
                        PreparedStatement psItems = null;
                        
                        try {
                            con = DatabaseManager.getConnection();
                            conOrders = DatabaseManager.getConnection();
                            conItems = DatabaseManager.getConnection();
                            
                            // 1️⃣ LEVEL 1: Unique User Consolidation
                            String userQuery = "SELECT user_id, customer_name, phone, city FROM orders GROUP BY user_id ORDER BY customer_name ASC";
                            psUsers = con.prepareStatement(userQuery);
                            ResultSet rsUsers = psUsers.executeQuery();
                            
                            while(rsUsers.next()) {
                                int uId = rsUsers.getInt("user_id");
                                String rawName = rsUsers.getString("customer_name");
                                String cName = (rawName != null && !rawName.equals(".")) ? rawName : "Client ID: " + uId;
                                String cPhone = rsUsers.getString("phone");
                                String cCity = rsUsers.getString("city");
                    %>
                    <!-- USER ROW -->
                    <tr class="master-user-row" data-bs-toggle="collapse" data-bs-target="#crmBox_<%= uId %>">
                        <td class="ps-3 fw-bold text-secondary">#<%= uId %></td>
                        <td class="fw-bold text-dark"><i class="fa-solid fa-folder me-2 text-muted" style="font-size: 13px;"></i><%= cName %></td>
                        <td><%= (cPhone != null && !cPhone.equals(".")) ? cPhone : "-" %></td>
                        <td><%= (cCity != null && !cCity.equals(".")) ? cCity : "Junagadh" %></td>
                        <td class="text-center no-print">
                            <span class="text-primary font-weight-bold" style="font-size: 12px; cursor: pointer;">
                                <i class="fa-solid fa-eye me-1"></i> View Ledger
                            </span>
                        </td>
                    </tr>
                    
                    <!-- 🛠️ LEVEL 2 & 3: CRM DROP DOWN GRID -->
                    <tr id="crmBox_<%= uId %>" class="collapse" style="background: #eef1f4;">
                        <td colspan="5" class="p-0">
                            <div class="crm-panel">
                                <div class="row g-3">
                                    
                                    <!-- 📝 LEFT BLOCK: Profile Details -->
                                    <div class="col-lg-5">
                                        <div class="info-card">
                                            <div class="info-title">Account Profile</div>
                                            <div class="info-row"><span class="info-label">Name</span><span class="info-value"><%= cName %></span></div>
                                            <div class="info-row"><span class="info-label">Client Code</span><span class="info-value">VIMAL-<%= uId %></span></div>
                                            <div class="info-row"><span class="info-label">Mobile</span><span class="info-value text-primary"><%= (cPhone != null && !cPhone.equals(".")) ? cPhone : "N/A" %></span></div>
                                            <div class="info-row" style="border-bottom: 0;"><span class="info-label">City</span><span class="info-value"><%= (cCity != null && !cCity.equals(".")) ? cCity : "Junagadh" %></span></div>
                                        </div>
                                    </div>
                                    
                                    <!-- 🛍️ RIGHT BLOCK: Invoices & Inside Items -->
                                    <div class="col-lg-7">
                                        <div class="orders-card">
                                            <div class="orders-title">Invoice Transactions</div>
                                            
                                            <table class="table mb-0 align-middle table-sm border-0">
                                                <thead style="background: #f1f3f5; font-size: 12px; color: #495057;">
                                                    <tr>
                                                        <th class="ps-3 py-2">Invoice No.</th>
                                                        <th>Date</th>
                                                        <th class="text-center">Status</th>
                                                        <th class="text-end pe-3">Net Value</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <%
                                                        String orderSql = "SELECT order_id, final_total, status, order_date FROM orders WHERE user_id = ? ORDER BY order_date DESC";
                                                        psOrders = conOrders.prepareStatement(orderSql);
                                                        psOrders.setInt(1, uId);
                                                        ResultSet rsOrders = psOrders.executeQuery();
                                                        
                                                        boolean hasOrders = false;
                                                        while(rsOrders.next()) {
                                                            hasOrders = true;
                                                            int oId = rsOrders.getInt("order_id");
                                                            double totalAmt = rsOrders.getDouble("final_total");
                                                            String oStatus = rsOrders.getString("status");
                                                            String oDate = rsOrders.getString("order_date");
                                                            
                                                            String statusPill = "status-pen";
                                                            if(oStatus != null) {
                                                                if(oStatus.equalsIgnoreCase("Delivered")) statusPill = "status-del";
                                                                else if(oStatus.equalsIgnoreCase("Cancelled")) statusPill = "status-can";
                                                            }
                                                    %>
                                                    <!-- Level 2 Invoice Row -->
                                                    <tr class="order-row-header" data-bs-toggle="collapse" data-bs-target="#innerItems_<%= oId %>">
                                                        <td class="ps-3 fw-bold text-primary"><i class="fa-solid fa-angle-right me-1 text-muted" style="font-size: 10px;"></i>#<%= oId %></td>
                                                        <td class="text-secondary" style="font-size: 12px;"><%= oDate.substring(0, 16) %></td>
                                                        <td class="text-center"><span class="status-pill <%= statusPill %>"><%= oStatus %></span></td>
                                                        <td class="text-end fw-bold text-dark pe-3">₹ <%= String.format("%.2f", totalAmt) %></td>
                                                    </tr>
                                                    
                                                    <!-- Level 3 Inside Items Breakdown -->
                                                    <tr id="innerItems_<%= oId %>" class="collapse">
                                                        <td colspan="4" class="p-0 bg-light">
                                                            <div class="inner-item-box border">
                                                                <table class="table table-sm table-bordered bg-white mb-0" style="font-size: 12px;">
                                                                    <thead class="table-light">
                                                                        <tr>
                                                                            <th class="text-center" style="width: 40px;">Img</th>
                                                                            <th>Item Name</th>
                                                                            <th class="text-center" style="width: 70px;">Rate</th>
                                                                            <th class="text-center" style="width: 50px;">Qty</th>
                                                                            <th class="text-end pe-2" style="width: 90px;">Total</th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        <%
                                                                            String itemSql = "SELECT product_name, price, qty, image FROM order_items WHERE order_id = ?";
                                                                            psItems = conItems.prepareStatement(itemSql);
                                                                            psItems.setInt(1, oId);
                                                                            ResultSet rsItems = psItems.executeQuery();
                                                                            
                                                                            while(rsItems.next()) {
                                                                                double price = rsItems.getDouble("price");
                                                                                int qty = rsItems.getInt("qty");
                                                                                double total = price * qty;
                                                                        %>
                                                                        <tr>
                                                                            <td class="text-center py-1">
                                                                                <img src="<%= rsItems.getString("image") %>" style="width: 25px; height: 25px; object-fit: contain;">
                                                                            </td>
                                                                            <td class="text-secondary fw-semibold"><%= rsItems.getString("product_name") %></td>
                                                                            <td class="text-center text-muted">₹<%= String.format("%.0f", price) %></td>
                                                                            <td class="text-center fw-bold"><%= qty %></td>
                                                                            <td class="text-end fw-bold text-dark pe-2">₹<%= String.format("%.2f", total) %></td>
                                                                        </tr>
                                                                        <% } %>
                                                                    </tbody>
                                                                </table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <%
                                                        }
                                                        if(!hasOrders) {
                                                            out.println("<tr><td colspan='4' class='text-center text-muted p-2'>No transaction entries logged.</td></tr>");
                                                        }
                                                    %>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                    
                                </div>
                            </div>
                        </td>
                    </tr>
                    <% 
                            }
                        } catch(Exception e) { 
                            out.println("<tr><td colspan='5' class='text-danger p-3'>System error occurred: "+e.getMessage()+"</td></tr>"); 
                        } finally {
                            if(psUsers != null) psUsers.close();
                            if(psOrders != null) psOrders.close();
                            if(psItems != null) psItems.close();
                            if(con != null) con.close();
                            if(conOrders != null) conOrders.close();
                            if(conItems != null) conItems.close();
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>