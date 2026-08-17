<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.vimal.utils.DatabaseManager" %>
        <%@ page import="java.sql.*" %>
            <%@ page import="com.vimal.utils.DatabaseManager" %>
                <% if (session.getAttribute("admin_id")==null) {
                    response.sendRedirect("admin_login.jsp?msg=admin_auth_required"); return; } %>

                    <!DOCTYPE html>
                    <html>

                    <head>
                        <title>Customer Ledger CRM | Vimal Admin</title>
                        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
                            rel="stylesheet">
                        <link rel="stylesheet"
                            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                        <link
                            href="https://fonts.googleapis.com/css2?family=Public+Sans:wght@300;400;500;600;700&display=swap"
                            rel="stylesheet">

                        <style>
                            body {
                                font-family: 'Public Sans', sans-serif;
                                background-color: #f0f2f5;
                                color: #1e293b;
                            }

                            .admin-main {
                                margin-left: 260px;
                                padding: 30px;
                                min-height: 100vh;
                            }

                            /* Main Master Table Styling */
                            .master-table-card {
                                background: white;
                                border-radius: 12px;
                                border: 1px solid #e2e8f0;
                                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
                                overflow: hidden;
                            }

                            .user-row {
                                background: #ffffff !important;
                                cursor: pointer;
                                transition: background 0.2s;
                            }

                            .user-row:hover {
                                background: #f8fafc !important;
                            }

                            /* Salesforce Style CRM Layout */
                            .crm-container {
                                background: #f8fafc;
                                padding: 25px;
                                border-radius: 12px;
                                border: 1px solid #cbd5e1;
                                margin: 10px;
                            }

                            /* Top Banner */
                            .crm-header-banner {
                                background: white;
                                padding: 20px;
                                border-radius: 8px;
                                border: 1px solid #e2e8f0;
                                margin-bottom: 20px;
                                display: flex;
                                align-items: center;
                                justify-content: space-between;
                            }

                            .crm-avatar {
                                width: 44px;
                                height: 44px;
                                background: #e0f2fe;
                                color: #0284c7;
                                border-radius: 8px;
                                font-weight: 700;
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                font-size: 18px;
                            }

                            /* Summary Grid */
                            .crm-mini-spec {
                                font-size: 12px;
                                color: #64748b;
                                margin-bottom: 2px;
                                text-transform: uppercase;
                                font-weight: 600;
                                letter-spacing: 0.3px;
                            }

                            .crm-mini-value {
                                font-size: 14px;
                                font-weight: 600;
                                color: #0f172a;
                            }

                            /* Left Section Fields */
                            .crm-fields-card {
                                background: white;
                                border-radius: 8px;
                                border: 1px solid #e2e8f0;
                                padding: 20px;
                                height: 100%;
                            }

                            .field-group {
                                border-bottom: 1px solid #f1f5f9;
                                padding: 10px 0;
                                display: flex;
                                justify-content: space-between;
                                align-items: center;
                            }

                            .field-label {
                                font-size: 13px;
                                color: #64748b;
                                font-weight: 500;
                            }

                            .field-value {
                                font-size: 13px;
                                color: #1e293b;
                                font-weight: 600;
                                text-align: right;
                            }

                            /* Right Section Sideboxes (Related Lists) */
                            .crm-side-box {
                                background: white;
                                border-radius: 8px;
                                border: 1px solid #e2e8f0;
                                margin-bottom: 15px;
                                overflow: hidden;
                            }

                            .side-box-title {
                                background: #f8fafc;
                                padding: 12px 16px;
                                border-bottom: 1px solid #e2e8f0;
                                font-size: 13px;
                                font-weight: 700;
                                color: #334155;
                                display: flex;
                                align-items: center;
                            }

                            .inner-table {
                                font-size: 13px;
                                margin-bottom: 0;
                            }

                            .inner-table th {
                                background: #f8fafc !important;
                                color: #64748b;
                                font-weight: 600;
                            }

                            .badge-status {
                                padding: 4px 8px;
                                border-radius: 4px;
                                font-size: 11px;
                                font-weight: 600;
                            }

                            .status-delivered {
                                background: #dcfce7;
                                color: #15803d;
                            }

                            .status-pending {
                                background: #fef3c7;
                                color: #b45309;
                            }

                            .status-cancelled {
                                background: #fee2e2;
                                color: #b91c1c;
                            }

                            @media print {
                                .no-print {
                                    display: none !important;
                                }

                                .admin-main {
                                    margin-left: 0 !important;
                                    padding: 0 !important;
                                }

                                .collapse {
                                    display: block !important;
                                    height: auto !important;
                                }
                            }
                        </style>
                    </head>

                    <body>

                        <div class="no-print">
                            <%@ include file="admin_header.jsp" %>
                        </div>

                        <div class="admin-main">
                            <!-- Top Toolbar -->
                            <div class="d-flex justify-content-between align-items-center mb-4 no-print">
                                <div>
                                    <h1
                                        style="font-weight: 700; color: #0f172a; margin: 0; letter-spacing: -0.5px; font-size: 26px;">
                                        Account Ledger Matrix</h1>
                                    <p style="color: #64748b; margin: 2px 0 0 0; font-size: 13px;">CRM formatted console
                                        for managing distributors, store locations, and multi-tier transaction history.
                                    </p>
                                </div>
                                <button onclick="window.print()"
                                    class="btn btn-white border border-secondary fw-bold text-dark px-3 py-2 style-radius"
                                    style="border-radius: 8px; background: white;">
                                    <i class="fa-solid fa-print me-2 text-secondary"></i> Print System Ledger
                                </button>
                            </div>

                            <!-- 📝 MAIN MASTER CLIENTS TABLE -->
                            <div class="master-table-card">
                                <div class="bg-white p-3 border-bottom">
                                    <span class="fw-bold text-dark"><i
                                            class="fa-solid fa-building me-2 text-primary"></i>Active Retailer
                                        Accounts</span>
                                </div>

                                <table class="table align-middle mb-0">
                                    <thead
                                        style="background: #f8fafc; font-size: 12px; text-transform: uppercase; color: #64748b;">
                                        <tr>
                                            <th class="ps-4 py-2.5" style="width: 90px;">UID</th>
                                            <th>Account Entity Name</th>
                                            <th>Registered Mobile</th>
                                            <th>Primary City</th>
                                            <th class="text-center no-print" style="width: 140px;">Console</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% Connection con=null; Connection conOrders=null; Connection conItems=null;
                                            PreparedStatement psUsers=null; PreparedStatement psOrders=null;
                                            PreparedStatement psItems=null; try { con=DatabaseManager.getConnection();
                                            conOrders=DatabaseManager.getConnection();
                                            conItems=DatabaseManager.getConnection(); // 1️⃣ LEVEL 1: Fetching Unique
                                            Clients from Orders String
                                            userQuery="SELECT user_id, customer_name, phone, city FROM orders GROUP BY user_id ORDER BY customer_name ASC"
                                            ; psUsers=con.prepareStatement(userQuery); ResultSet
                                            rsUsers=psUsers.executeQuery(); while(rsUsers.next()) { int
                                            uId=rsUsers.getInt("user_id"); String
                                            rawName=rsUsers.getString("customer_name"); String cName=(rawName !=null &&
                                            !rawName.equals(".")) ? rawName : "Retail Client #" + uId; String
                                            cPhone=rsUsers.getString("phone"); String cCity=rsUsers.getString("city");
                                            String initial=cName.trim().substring(0, 1).toUpperCase(); %>
                                            <!-- MASTER USER ROW -->
                                            <tr class="user-row" data-bs-toggle="collapse"
                                                data-bs-target="#crmConsole_<%= uId %>">
                                                <td class="ps-4 fw-bold text-secondary">#<%= uId %>
                                                </td>
                                                <td class="fw-bold text-dark"><i
                                                        class="fa-solid fa-shop me-2 text-muted"
                                                        style="font-size: 14px;"></i>
                                                    <%= cName %>
                                                </td>
                                                <td class="fw-medium">
                                                    <%= (cPhone !=null && !cPhone.equals(".")) ? cPhone : "-" %>
                                                </td>
                                                <td><span class="badge bg-light text-dark border">
                                                        <%= (cCity !=null && !cCity.equals(".")) ? cCity : "Junagadh" %>
                                                    </span></td>
                                                <td class="text-center no-print">
                                                    <button type="button"
                                                        class="btn btn-sm btn-light border font-semibold px-2.5 py-1"
                                                        style="font-size: 12px;">
                                                        <i class="fa-solid fa-sliders me-1 text-primary"></i> Open
                                                        Console
                                                    </button>
                                                </td>
                                            </tr>

                                            <!-- 🛠️ LEVEL 2 & 3: SALESFORCE CRM EXPANDABLE VIEW -->
                                            <tr id="crmConsole_<%= uId %>" class="collapse"
                                                style="background: #f1f5f9;">
                                                <td colspan="5" class="p-0">
                                                    <div class="crm-container">

                                                        <!-- 🏆 CRM Top Banner Box -->
                                                        <div class="crm-header-banner shadow-sm">
                                                            <div class="d-flex align-items-center">
                                                                <div class="crm-avatar me-3">
                                                                    <%= initial %>
                                                                </div>
                                                                <div>
                                                                    <small class="text-muted d-block font-medium"
                                                                        style="font-size: 11px;">Account Console</small>
                                                                    <h4 class="fw-bold text-dark m-0"
                                                                        style="font-size: 18px;">
                                                                        <%= cName %>
                                                                    </h4>
                                                                </div>
                                                            </div>

                                                            <!-- Dynamic Quick Stats Row -->
                                                            <div class="d-flex gap-5 pe-4 text-start d-none d-md-flex">
                                                                <div>
                                                                    <div class="crm-mini-spec">Billing Area</div>
                                                                    <div class="crm-mini-value text-primary">
                                                                        <%= (cCity !=null && !cCity.equals(".")) ? cCity
                                                                            : "Main Hub" %>
                                                                    </div>
                                                                </div>
                                                                <div>
                                                                    <div class="crm-mini-spec">Account Type</div>
                                                                    <div class="crm-mini-value"><span
                                                                            class="text-success">●</span> Retail
                                                                        Distributor</div>
                                                                </div>
                                                                <div>
                                                                    <div class="crm-mini-spec">Primary Contact</div>
                                                                    <div class="crm-mini-value">
                                                                        <%= (cPhone !=null && !cPhone.equals(".")) ?
                                                                            cPhone : "Verified" %>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <!-- 📊 CRM Two Column Split Layout -->
                                                        <div class="row g-3">

                                                            <!-- 📝 LEFT COLUMN: Account Information Fields -->
                                                            <div class="col-lg-5">
                                                                <div class="crm-fields-card shadow-sm">
                                                                    <h6
                                                                        class="fw-bold text-dark border-bottom pb-2 mb-2">
                                                                        <i
                                                                            class="fa-solid fa-circle-info text-primary me-2"></i>Account
                                                                        Details</h6>

                                                                    <div class="field-group"><span
                                                                            class="field-label">Account Name</span><span
                                                                            class="field-value">
                                                                            <%= cName %>
                                                                        </span></div>
                                                                    <div class="field-group"><span
                                                                            class="field-label">Client Code
                                                                            Reference</span><span
                                                                            class="field-value">VIMAL-R-<%= uId %>
                                                                                </span></div>
                                                                    <div class="field-group"><span
                                                                            class="field-label">Status</span><span
                                                                            class="field-value text-success fw-bold">Active
                                                                            Check ✔</span></div>
                                                                    <div class="field-group"><span
                                                                            class="field-label">Mobile
                                                                            Network</span><span
                                                                            class="field-value text-primary">
                                                                            <%= (cPhone !=null && !cPhone.equals(".")) ?
                                                                                cPhone : "No Record" %>
                                                                        </span></div>
                                                                    <div class="field-group"><span
                                                                            class="field-label">Dispatch
                                                                            Location</span><span class="field-value">
                                                                            <%= (cCity !=null && !cCity.equals(".")) ?
                                                                                cCity : "Junagadh, Gujarat" %>
                                                                        </span></div>
                                                                    <div class="field-group" style="border-0;"><span
                                                                            class="field-label">Tax
                                                                            Assignment</span><span
                                                                            class="field-value text-muted">GST
                                                                            Registered Status</span></div>
                                                                </div>
                                                            </div>

                                                            <!-- 🛍️ RIGHT COLUMN: Orders List & Nested Items Breakdown -->
                                                            <div class="col-lg-7">

                                                                <!-- RELATED LIST BOX: Orders -->
                                                                <div class="crm-side-box shadow-sm">
                                                                    <div class="side-box-title">
                                                                        <i class="fa-solid fa-receipt text-warning me-2"
                                                                            style="font-size: 15px;"></i> Orders Ledger
                                                                        & Invoice Breakdown
                                                                    </div>

                                                                    <div class="p-0">
                                                                        <table class="table inner-table align-middle">
                                                                            <thead>
                                                                                <tr>
                                                                                    <th class="ps-3">Invoice Code</th>
                                                                                    <th>Execution Date</th>
                                                                                    <th class="text-center">Status</th>
                                                                                    <th class="text-end pe-3">Net Value
                                                                                    </th>
                                                                                </tr>
                                                                            </thead>
                                                                            <tbody>
                                                                                <% // Fetching user specific orders
                                                                                    String
                                                                                    orderSql="SELECT order_id, final_total, status, order_date FROM orders WHERE user_id = ? ORDER BY order_date DESC"
                                                                                    ;
                                                                                    psOrders=conOrders.prepareStatement(orderSql);
                                                                                    psOrders.setInt(1, uId); ResultSet
                                                                                    rsOrders=psOrders.executeQuery();
                                                                                    boolean hasOrders=false;
                                                                                    while(rsOrders.next()) {
                                                                                    hasOrders=true; int
                                                                                    oId=rsOrders.getInt("order_id");
                                                                                    double
                                                                                    totalAmt=rsOrders.getDouble("final_total");
                                                                                    String
                                                                                    oStatus=rsOrders.getString("status");
                                                                                    String
                                                                                    oDate=rsOrders.getString("order_date");
                                                                                    String statusClass="status-pending"
                                                                                    ; if(oStatus !=null) {
                                                                                    if(oStatus.equalsIgnoreCase("Delivered"))
                                                                                    statusClass="status-delivered" ;
                                                                                    else
                                                                                    if(oStatus.equalsIgnoreCase("Cancelled"))
                                                                                    statusClass="status-cancelled" ; }
                                                                                    %>
                                                                                    <!-- 🧾 Level 2 Row: Order Header (Click to drill down further) -->
                                                                                    <tr style="cursor: pointer; background: #ffffff;"
                                                                                        data-bs-toggle="collapse"
                                                                                        data-bs-target="#crmItems_<%= oId %>"
                                                                                        title="Click to view inside product SKU details">
                                                                                        <td
                                                                                            class="ps-3 fw-bold text-primary">
                                                                                            <i class="fa-solid fa-caret-down me-1.5 text-muted"
                                                                                                style="font-size: 11px;"></i>INV-
                                                                                            <%= oId %>
                                                                                        </td>
                                                                                        <td class="text-secondary">
                                                                                            <%= oDate.substring(0, 16)
                                                                                                %>
                                                                                        </td>
                                                                                        <td class="text-center"><span
                                                                                                class="badge-status <%= statusClass %>">
                                                                                                <%= oStatus %>
                                                                                            </span></td>
                                                                                        <td
                                                                                            class="text-end fw-bold text-dark pe-3">
                                                                                            ₹ <%= String.format("%.2f",
                                                                                                totalAmt) %>
                                                                                        </td>
                                                                                    </tr>

                                                                                    <!-- 🍿 Level 3 Row: Nested Collapse Products Breakdown Inside Order -->
                                                                                    <tr id="crmItems_<%= oId %>"
                                                                                        class="collapse">
                                                                                        <td colspan="4"
                                                                                            class="p-2 bg-light">
                                                                                            <div
                                                                                                class="inner-item-box p-2 bg-white rounded border mx-2 shadow-sm">
                                                                                                <table
                                                                                                    class="table table-sm table-borderless align-middle mb-0 text-start"
                                                                                                    style="font-size: 12px;">
                                                                                                    <thead
                                                                                                        style="border-bottom: 1px solid #e2e8f0; background: #f8fafc;">
                                                                                                        <tr>
                                                                                                            <th class="text-center py-1"
                                                                                                                style="width: 45px;">
                                                                                                                SKU</th>
                                                                                                            <th
                                                                                                                class="py-1">
                                                                                                                Product
                                                                                                                Description
                                                                                                            </th>
                                                                                                            <th class="text-center py-1"
                                                                                                                style="width: 80px;">
                                                                                                                Rate
                                                                                                            </th>
                                                                                                            <th class="text-center py-1"
                                                                                                                style="width: 60px;">
                                                                                                                Qty</th>
                                                                                                            <th class="text-end py-1 pe-2"
                                                                                                                style="width: 100px;">
                                                                                                                Total
                                                                                                            </th>
                                                                                                        </tr>
                                                                                                    </thead>
                                                                                                    <tbody>
                                                                                                        <% String
                                                                                                            itemSql="SELECT product_name, price, qty, image FROM order_items WHERE order_id = ?"
                                                                                                            ;
                                                                                                            psItems=conItems.prepareStatement(itemSql);
                                                                                                            psItems.setInt(1,
                                                                                                            oId);
                                                                                                            ResultSet
                                                                                                            rsItems=psItems.executeQuery();
                                                                                                            while(rsItems.next())
                                                                                                            { double
                                                                                                            price=rsItems.getDouble("price");
                                                                                                            int
                                                                                                            qty=rsItems.getInt("qty");
                                                                                                            double
                                                                                                            rowTot=price
                                                                                                            * qty; %>
                                                                                                            <tr
                                                                                                                style="border-bottom: 1px dashed #f1f5f9;">
                                                                                                                <td
                                                                                                                    class="text-center py-1">
                                                                                                                    <img src="<%= rsItems.getString("
                                                                                                                        image")
                                                                                                                        %>"
                                                                                                                    style="width:
                                                                                                                    28px;
                                                                                                                    height:
                                                                                                                    28px;
                                                                                                                    border-radius:
                                                                                                                    4px;
                                                                                                                    object-fit:
                                                                                                                    contain;
                                                                                                                    border:
                                                                                                                    1px
                                                                                                                    solid
                                                                                                                    #e2e8f0;
                                                                                                                    background:
                                                                                                                    #fff;">
                                                                                                                </td>
                                                                                                                <td
                                                                                                                    class="fw-semibold text-secondary py-1">
                                                                                                                    <%= rsItems.getString("product_name")
                                                                                                                        %>
                                                                                                                </td>
                                                                                                                <td
                                                                                                                    class="text-center font-monospace text-muted py-1">
                                                                                                                    ₹<%= String.format("%.2f",
                                                                                                                        price)
                                                                                                                        %>
                                                                                                                </td>
                                                                                                                <td
                                                                                                                    class="text-center fw-bold text-dark py-1">
                                                                                                                    <%= qty
                                                                                                                        %>
                                                                                                                </td>
                                                                                                                <td
                                                                                                                    class="text-end fw-bold text-primary py-1 pe-2">
                                                                                                                    ₹<%= String.format("%.2f",
                                                                                                                        rowTot)
                                                                                                                        %>
                                                                                                                </td>
                                                                                                            </tr>
                                                                                                            <% } %>
                                                                                                    </tbody>
                                                                                                </table>
                                                                                            </div>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <% } if(!hasOrders) {
                                                                                        out.println("<tr>
                                                                                        <td colspan='4'
                                                                                            class='text-center text-muted p-3'>
                                                                                            No verified ledger
                                                                                            statements recorded for this
                                                                                            client.</td>
                                            </tr>");
                                            }
                                            %>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        </div> <!-- Right Column End -->
                        </div> <!-- CRM Split Row End -->

                        </div>
                        </td>
                        </tr>
                        <% } } catch(Exception e) { out.println("<tr>
                            <td colspan='5' class='text-danger p-4'>System Pipeline Error: "+e.getMessage()+"</td>
                            </tr>");
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

                            <script
                                src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
                    </body>

                    </html>