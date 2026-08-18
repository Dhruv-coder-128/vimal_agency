<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.vimal.utils.DatabaseManager" %>
<%@ page import="java.sql.*" %>

<%
    // STEP 1: STRICT ADMIN SESSION LOCKDOWN
    if (session.getAttribute("admin_id") == null) {
        response.sendRedirect("admin_login.jsp?msg=admin_auth_required");
        return;
    }

    // AJAX HANDLE
    if (request.getMethod().equalsIgnoreCase("POST") && "ajax_update_status".equals(request.getParameter("action"))) {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        try (Connection con = DatabaseManager.getConnection()) {
            int oId = Integer.parseInt(request.getParameter("order_id"));
            String sql = "UPDATE orders SET status=? WHERE order_id=?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, request.getParameter("new_status"));
                ps.setInt(2, oId);
                int rows = ps.executeUpdate();

                if (rows > 0) {
                    out.print("{\"status\":\"success\", \"message\":\"Order #" + request.getParameter("order_id") + " status changed to " + request.getParameter("new_status") + " successfully!\"}");
                } else {
                    out.print("{\"status\":\"error\", \"message\":\"Failed to update database.\"}");
                }
            }
        } catch (Exception e) {
            out.print("{\"status\":\"error\", \"message\":\"" + e.getMessage() + "\"}");
        }
        out.flush();
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Orders | Vimal Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .admin-main {
            margin-left: 0;
            padding: clamp(15px, 3vw, 35px);
            background: #f8f9fa;
            min-height: 100vh;
            width: 100%;
        }

        @media (min-width: 992px) {
            .admin-main {
                margin-left: 260px;
                width: calc(100% - 260px);
            }
        }

        .status-badge { padding: 6px 12px; border-radius: 20px; font-weight: 600; font-size: 13px; display: inline-block; width: 95px; text-align: center; }
        .status-pending { background: #fff3cd; color: #856404; }
        .status-delivered { background: #d4edda; color: #155724; }
        .status-cancelled { background: #f8d7da; color: #721c24; }

        .toast-container-header {
            position: fixed;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            z-index: 9999;
            width: max-content;
            max-width: min(92vw, 500px);
        }
        .custom-toast {
            background: #ffffff !important;
            border-radius: 12px !important;
            box-shadow: 0 15px 40px rgba(0,0,0,0.2) !important;
            padding: 12px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border: none !important;
            transition: all 0.3s ease-in-out;
        }
        .toast-border-pending { border-left: 8px solid #ffc107 !important; }
        .toast-border-delivered { border-left: 8px solid #28a745 !important; }
        .toast-border-cancelled { border-left: 8px solid #dc3545 !important; }

        .toast-icon-box {
            width: 42px; height: 42px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 18px; margin-right: 15px; flex-shrink: 0;
        }

        .filter-btn.active { background-color: #ffc800 !important; color: #000 !important; border-color: #ffc800 !important; font-weight: bold; }
        .search-box { max-width: 350px; border-radius: 20px; padding-left: 40px; }
        .search-icon { position: absolute; left: 15px; top: 10px; color: #a0aec0; }
    </style>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.17.5/xlsx.full.min.js"></script>
</head>
<body>

    <%@ include file="admin_header.jsp" %>

    <div class="admin-main">
        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1 style="font-weight: 800; color: #1a242f; margin: 0; letter-spacing: -1px;">Customer Orders</h1>
                <p style="color: #7f8c8d; margin: 0;">Update order status, live filter, and export data seamlessly.</p>
            </div>
            <button onclick="exportToExcel()" class="btn btn-success px-4 rounded-pill shadow-sm">
                <i class="fa-solid fa-file-excel me-2"></i> Export to Excel
            </button>
        </div>

        <!-- Filters & Live Search Panel -->
        <div class="row g-3 mb-4 align-items-center bg-white p-3 rounded-3 shadow-sm mx-0">
            <div class="col-md-6 d-flex gap-2" id="filterContainer">
                <button class="btn btn-outline-dark btn-sm filter-btn active rounded-pill px-3" onclick="filterStatus('All', this)">All Orders</button>
                <button class="btn btn-outline-dark btn-sm filter-btn rounded-pill px-3" onclick="filterStatus('Pending', this)">Pending</button>
                <button class="btn btn-outline-dark btn-sm filter-btn rounded-pill px-3" onclick="filterStatus('Delivered', this)">Delivered</button>
                <button class="btn btn-outline-dark btn-sm filter-btn rounded-pill px-3" onclick="filterStatus('Cancelled', this)">Cancelled</button>
            </div>
            <div class="col-md-6 position-relative text-end">
                <i class="fa-solid fa-magnifying-glass search-icon"></i>
                <input type="text" id="orderSearch" class="form-control form-control-sm search-box d-inline-block shadow-none" placeholder="Search by ID, Name or Phone..." onkeyup="liveSearch()">
            </div>
        </div>

        <!-- Orders Table Card -->
        <div class="stat-card p-0 overflow-hidden bg-white" style="border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.05); border-top: 5px solid #ffc800;">
            <table class="table table-hover align-middle mb-0 text-center" id="ordersTable">
                <thead style="background: #f8f9fa;">
                    <tr>
                        <th class="py-3">Order ID</th>
                        <th>Customer</th>
                        <th>Phone</th>
                        <th>Total Amount</th>
                        <th>Status</th>
                        <th>Change Status</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        Connection con = null;
                        try {
                            con = DatabaseManager.getConnection();
                            try (Statement st = con.createStatement();
                                 ResultSet rs = st.executeQuery("SELECT * FROM orders ORDER BY order_date DESC")) {
                                while (rs.next()) {
                                    int orderId = rs.getInt("order_id");
                                    String status = rs.getString("status");
                                    String badgeClass = "status-pending";
                                    if ("Delivered".equalsIgnoreCase(status)) badgeClass = "status-delivered";
                                    if ("Cancelled".equalsIgnoreCase(status)) badgeClass = "status-cancelled";

                                    double finalTotal = rs.getDouble("final_total");
                                    long amountInt = (long) finalTotal;
                                    String doubleStr = String.format("%.2f", finalTotal);
                                    String decimalPart = doubleStr.substring(doubleStr.indexOf("."));
                                    String str = String.valueOf(amountInt);
                                    String formattedAmount = "";

                                    if (str.length() > 3) {
                                        String lastThree = str.substring(str.length() - 3);
                                        String remaining = str.substring(0, str.length() - 3);
                                        String temp = "";
                                        int cnt = 0;
                                        for (int i = remaining.length() - 1; i >= 0; i--) {
                                            temp = remaining.charAt(i) + temp;
                                            cnt++;
                                            if (cnt == 2 && i != 0) {
                                                temp = "," + temp;
                                                cnt = 0;
                                            }
                                        }
                                        formattedAmount = "Rs." + temp + "," + lastThree + decimalPart;
                                    } else {
                                        formattedAmount = "Rs." + str + decimalPart;
                                    }
                    %>
                    <tr style="border-bottom: 1px solid #f1f1f1;" data-status="<%= (status != null ? status : "") %>">
                        <td class="fw-bold">#<%= orderId %></td>
                        <td class="text-start ps-4"><%= (rs.getString("customer_name") != null ? rs.getString("customer_name") : "") %></td>
                        <td><%= (rs.getString("phone") != null ? rs.getString("phone") : "-") %></td>
                        <td class="text-success fw-bold"><%= formattedAmount %></td>
                        <td><span id="badge-<%= orderId %>" class="status-badge <%= badgeClass %>"><%= (status != null ? status : "") %></span></td>
                        <td>
                            <select class="form-select form-select-sm shadow-none d-inline-block" style="width: 130px;" onchange="updateStatusAJAX(<%= orderId %>, this.value)">
                                <option value="Pending" <%= "Pending".equalsIgnoreCase(status) ? "selected" : "" %>>Pending</option>
                                <option value="Delivered" <%= "Delivered".equalsIgnoreCase(status) ? "selected" : "" %>>Delivered</option>
                                <option value="Cancelled" <%= "Cancelled".equalsIgnoreCase(status) ? "selected" : "" %>>Cancelled</option>
                            </select>
                        </td>
                    </tr>
                    <%
                                }
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='6' class='text-danger text-center'>Error: " + e.getMessage() + "</td></tr>");
                        } finally {
                            if (con != null) try { con.close(); } catch (Exception ignored) {}
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Live Notification Container -->
    <div class="toast-container-header">
        <div id="ajaxToast" class="toast custom-toast fade hide" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex align-items-center">
                <div id="toastIconBox" class="toast-icon-box">
                    <i id="toastIcon" class="fa-solid"></i>
                </div>
                <div>
                    <strong id="toastTitle" style="font-size: 16px; font-weight: 700; display: block;">Notification</strong>
                    <span id="toastMsg" style="font-size: 14px; color: #555; font-weight: 500;">Status updated successfully!</span>
                </div>
            </div>
            <button type="button" class="btn-close ms-4 shadow-none" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
    </div>

    <script>
        // 1. Live Search Feature
        function liveSearch() {
            let input = document.getElementById("orderSearch").value.toLowerCase();
            let rows = document.querySelectorAll("#ordersTable tbody tr");
            rows.forEach(row => {
                let text = row.innerText.toLowerCase();
                row.style.display = text.includes(input) ? "" : "none";
            });
        }

        // 2. Status Tab Filter Feature
        function filterStatus(status, btn) {
            document.querySelectorAll(".filter-btn").forEach(b => b.classList.remove("active"));
            btn.classList.add("active");

            let rows = document.querySelectorAll("#ordersTable tbody tr");
            rows.forEach(row => {
                let rowStatus = row.getAttribute("data-status");
                if (status === "All" || (rowStatus && rowStatus.toLowerCase() === status.toLowerCase())) {
                    row.style.display = "";
                } else {
                    row.style.display = "none";
                }
            });
        }

        // 3. AJAX Update Status Feature
        function updateStatusAJAX(orderId, newStatus) {
            let formData = new URLSearchParams();
            formData.append("action", "ajax_update_status");
            formData.append("order_id", orderId);
            formData.append("new_status", newStatus);

            fetch('', {
                method: "POST",
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: formData.toString()
            })
            .then(res => res.json())
            .then(data => {
                if(data.status === "success") {
                    let badge = document.getElementById("badge-" + orderId);
                    let row = badge.closest("tr");

                    row.setAttribute("data-status", newStatus);
                    badge.classList.remove("status-pending", "status-delivered", "status-cancelled");
                    badge.innerText = newStatus;

                    let checkStatus = newStatus.toLowerCase();
                    if(checkStatus === "pending") badge.classList.add("status-pending");
                    else if(checkStatus === "delivered") badge.classList.add("status-delivered");
                    else if(checkStatus === "cancelled") badge.classList.add("status-cancelled");

                    let toastElement = document.getElementById('ajaxToast');
                    let iconBox = document.getElementById('toastIconBox');
                    let icon = document.getElementById('toastIcon');
                    let title = document.getElementById('toastTitle');

                    toastElement.classList.remove("toast-border-pending", "toast-border-delivered", "toast-border-cancelled");
                    iconBox.className = "toast-icon-box";
                    icon.className = "fa-solid";

                    if(checkStatus === "delivered") {
                        toastElement.classList.add("toast-border-delivered");
                        iconBox.classList.add("bg-success", "text-white");
                        icon.classList.add("fa-circle-check");
                        title.className = "text-success";
                        title.innerText = "Delivered!";
                    } else if(checkStatus === "cancelled") {
                        toastElement.classList.add("toast-border-cancelled");
                        iconBox.classList.add("bg-danger", "text-white");
                        icon.classList.add("fa-circle-xmark");
                        title.className = "text-danger";
                        title.innerText = "Cancelled!";
                    } else {
                        toastElement.classList.add("toast-border-pending");
                        iconBox.classList.add("bg-warning", "text-dark");
                        icon.classList.add("fa-clock");
                        title.className = "text-warning";
                        title.innerText = "Pending";
                    }

                    document.getElementById("toastMsg").innerText = data.message;
                    let myToast = new bootstrap.Toast(toastElement, { delay: 3000 });
                    myToast.show();
                } else {
                    alert("Database Error: " + data.message);
                }
            })
            .catch(err => {
                console.error("Error:", err);
                alert("Status updated, please refresh if color change does not display immediately.");
            });
        }

        // 4. Export to Excel Feature
        function exportToExcel() {
            let table = document.getElementById("ordersTable");
            let cloneTable = table.cloneNode(true);
            cloneTable.querySelectorAll("tr").forEach(tr => {
                if(tr.lastElementChild) tr.removeChild(tr.lastElementChild);
            });
            let wb = XLSX.utils.table_to_book(cloneTable, {sheet: "Orders_Report"});
            XLSX.writeFile(wb, "Vimal_Agency_Orders.xlsx");
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
