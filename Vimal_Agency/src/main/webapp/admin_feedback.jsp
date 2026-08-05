<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.vimal.utils.DatabaseManager" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.vimal.utils.DatabaseManager" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.vimal.utils.DatabaseManager" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.vimal.utils.DatabaseManager" %>

<%
    // ==========================================================
    // 1️ ADMIN SESSION SECURITY CHECK
    // ==========================================================
    // If admin is not logged in, redirect to login page
    if (session.getAttribute("admin_id") == null) {
        response.sendRedirect("admin_login.jsp");
        return; // Stop further execution
    }

    String successMsg = null;

    // ==========================================================
    // 2️ DATABASE CONNECTION (UTF-8 ENABLED)
    // ==========================================================
    // Unicode support ensures emojis and special characters work properly
    Connection con = DatabaseManager.getConnection();

    // ==========================================================
    // 3️ DELETE LOGIC WITH REDIRECT
    // ==========================================================
    // If del_id parameter is present in URL, delete that feedback
    if(request.getParameter("del_id") != null) {
        try {
            PreparedStatement ps = con.prepareStatement(
                "DELETE FROM feedback WHERE id = ?"
            );

            ps.setString(1, request.getParameter("del_id"));

            int rows = ps.executeUpdate();

            // If deletion successful, redirect with status parameter
            if(rows > 0) {
                response.sendRedirect("admin_feedback.jsp?status=deleted");
                return;
            }

        } catch(Exception e) {
            out.println(e); // Print error if occurs
        }
    }

    // ==========================================================
    // 4️ SUCCESS MESSAGE AFTER REDIRECT
    // ==========================================================
    if("deleted".equals(request.getParameter("status"))) {
        successMsg = "Feedback record removed successfully!";
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Customer Feedbacks | Vimal Admin</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        /* ==========================================================
           PAGE LAYOUT STYLING
        ========================================================== */
        .admin-main { 
            margin-left: 260px; 
            min-height: 100vh; 
            background: #f8f9fa; 
        }

        /* Table formatting */
        .table td, .table th { 
            padding: 12px 15px !important; 
            font-size: 14px; 
            vertical-align: middle !important; 
        }

        /* Star rating styling */
        .star-rating { 
            color: #ffc107; 
            font-weight: 700; 
        }

        /* Feedback message styling */
        .msg-cell { 
            max-width: 300px; 
            color: #555; 
            font-style: italic; 
            line-height: 1.4; 
        }

        /* Delete button styling */
        .btn-delete { 
            background: #ffebee; 
            color: #f44336; 
            border: none; 
            padding: 6px 10px; 
            border-radius: 8px; 
            transition: 0.3s; 
        }

        .btn-delete:hover { 
            background: #f44336; 
            color: white; 
        }

        /* Toast container styling */
        .toast-container-header { 
            position: fixed; 
            top: 25px; 
            left: 50%; 
            transform: translateX(-50%); 
            z-index: 2500; 
            width: max-content; 
            min-width: 400px; 
        }

        .toast-success-header { 
            border-left: 8px solid #28a745 !important; 
            border-radius: 12px !important; 
            background: white !important; 
            box-shadow: 0 10px 35px rgba(0,0,0,0.15) !important; 
            padding: 8px 20px; 
        }
    </style>
</head>

<body>

    <!-- Include Admin Header (Sidebar + Navbar) -->
    <%@ include file="admin_header.jsp" %>

    <div class="admin-main p-4">

        <!-- Page Heading -->
        <div class="mb-4">
            <h1 style="font-weight: 800; color: #1a242f; margin: 0; letter-spacing: -1px;">
                Customer Feedbacks
            </h1>
            <p style="color: #7f8c8d; margin: 0;">
                Review what your customers are saying about Vimal Agency.
            </p>
        </div>

        <!-- ==========================================================
             FEEDBACK TABLE SECTION
        ========================================================== -->
        <div class="stat-card p-0 overflow-hidden" 
             style="background: white; border-radius: 15px; 
                    box-shadow: 0 5px 20px rgba(0,0,0,0.05); 
                    border-top: 5px solid #ffc800;">

            <table class="table table-hover align-middle mb-0 text-center">

                <!-- Table Header -->
                <thead style="background: #f8f9fa;">
                    <tr>
                        <th class="py-3 px-4">ID</th>
                        <th class="text-start">Customer Name</th>
                        <th>Experience</th>
                        <th class="text-start">Message</th>
                        <th>Submitted On</th>
                        <th>Action</th>
                    </tr>
                </thead>

                <tbody>
                    <%
                        try {

                            // Fetch feedback records in descending order
                            ResultSet rs = con.createStatement().executeQuery(
                                "SELECT * FROM feedback ORDER BY id DESC"
                            );

                            // Date format conversion
                            SimpleDateFormat dbFormat = 
                                new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

                            SimpleDateFormat userFormat = 
                                new SimpleDateFormat("dd-MM-yyyy | hh:mm a");

                            while(rs.next()) {

                                int rating = rs.getInt("experience");

                                String rawDate = rs.getString("created_at");
                                String finalDate = "";

                                if(rawDate != null) {
                                    Date date = dbFormat.parse(rawDate);
                                    finalDate = userFormat.format(date);
                                }
                    %>

                    <!-- Table Row -->
                    <tr style="border-bottom: 1px solid #f1f1f1;">

                        <!-- Feedback ID -->
                        <td class="fw-bold">
                            #<%= rs.getInt("id") %>
                        </td>

                        <!-- Customer Name & Email -->
                        <td class="text-start">
                            <div class="fw-bold">
                                <%= rs.getString("name") %>
                            </div>
                            <div class="text-muted small">
                                <%= rs.getString("mail") %>
                            </div>
                        </td>

                        <!-- Star Rating Display -->
                        <td>
                            <div class="star-rating">
                                <% for(int i=1; i<=5; i++) { %>
                                    <!-- Show solid star if within rating, otherwise outline star -->
                                    <i class="<%= (i <= rating) ? "fa-solid" : "fa-regular" %> fa-star"></i>
                                <% } %>
                                <span class="ms-1">(<%= rating %>)</span>
                            </div>
                        </td>

                        <!-- Feedback Message -->
                        <td class="text-start msg-cell text-truncate" style="max-width: 250px;">
                            "<%= rs.getString("message") %>"
                        </td>

                        <!-- Formatted Date -->
                        <td style="font-size: 13px; color: #666; white-space: nowrap;">
                            <%= finalDate %>
                        </td>

                        <!-- Delete Action -->
                        <td>
                            <a href="admin_feedback.jsp?del_id=<%= rs.getInt("id") %>" 
                               class="btn-delete" 
                               onclick="return confirm('Delete this feedback?')">
                                <i class="fa-solid fa-trash-can"></i>
                            </a>
                        </td>

                    </tr>

                    <% 
                        } 
                        con.close(); 
                        } catch(Exception e) { 
                            out.println(e); 
                        } 
                    %>

                </tbody>
            </table>
        </div>
    </div>

    <!-- ==========================================================
         SUCCESS TOAST NOTIFICATION
    ========================================================== -->
    <div class="toast-container-header">
        <div id="successToast" 
             class="toast toast-success-header align-items-center text-dark border-0 shadow-lg" 
             role="alert" aria-live="assertive" aria-atomic="true">

            <div class="d-flex align-items-center p-2">
                <div class="toast-body">
                    <div class="d-flex align-items-center gap-2">

                        <!-- Success Icon -->
                        <div class="bg-success text-white rounded-circle 
                                    d-flex align-items-center justify-content-center me-2"
                             style="width: 35px; height: 35px;">
                            <i class="fa-solid fa-check"></i>
                        </div>

                        <strong class="text-success" style="font-size: 17px;">
                            Success:
                        </strong>

                        <span style="font-size: 15px; white-space: nowrap;">
                            <%= (successMsg != null) ? successMsg : "" %>
                        </span>

                    </div>
                </div>

                <!-- Close Button -->
                <button type="button" class="btn-close ms-4 me-2" data-bs-dismiss="toast"></button>
            </div>
        </div>
    </div>

    <!-- ==========================================================
         TOAST DISPLAY SCRIPT
    ========================================================== -->
    <script>
        window.onload = function() {

            // Show toast only if redirect status = deleted
            <% if("deleted".equals(request.getParameter("status"))) { %>
                var myToast = new bootstrap.Toast(
                    document.getElementById('successToast'), 
                    { delay: 3000 }
                );
                myToast.show();
            <% } %>
        };
    </script>

    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
