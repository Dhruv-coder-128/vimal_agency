<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.vimal.utils.DatabaseManager" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%
    if (session.getAttribute("admin_id") == null) {
        response.sendRedirect("admin_login.jsp?msg=admin_auth_required");
        return;
    }

    String successMsg = null;
    Connection con = null;

    try {
        con = DatabaseManager.getConnection();

        if (request.getParameter("del_id") != null) {
            try (PreparedStatement ps = con.prepareStatement("DELETE FROM feedback WHERE id = ?")) {
                ps.setInt(1, Integer.parseInt(request.getParameter("del_id")));
                int rows = ps.executeUpdate();
                if (rows > 0) {
                    response.sendRedirect("admin_feedback.jsp?status=deleted");
                    return;
                }
            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>Error deleting feedback: " + e.getMessage() + "</div>");
            }
        }

        if ("deleted".equals(request.getParameter("status"))) {
            successMsg = "Feedback record removed successfully!";
        }
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>Database Error: " + e.getMessage() + "</div>");
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Feedbacks | Vimal Admin</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        .admin-main {
            margin-left: 0;
            padding: clamp(15px, 3vw, 35px);
            min-height: 100vh;
            background: #f8f9fa;
            width: 100%;
        }

        @media (min-width: 992px) {
            .admin-main {
                margin-left: 260px;
                width: calc(100% - 260px);
            }
        }

        .table td,
        .table th {
            padding: 12px 15px !important;
            font-size: 14px;
            vertical-align: middle !important;
        }

        .star-rating {
            color: #ffc107;
            font-weight: 700;
        }

        .msg-cell {
            max-width: 300px;
            color: #555;
            font-style: italic;
            line-height: 1.4;
        }

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
            box-shadow: 0 10px 35px rgba(0, 0, 0, 0.15) !important;
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

        <div class="stat-card p-0 overflow-hidden" style="background: white; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.05); border-top: 5px solid #ffc800;">
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
                        if (con != null) {
                            try (Statement st = con.createStatement();
                                 ResultSet rs = st.executeQuery("SELECT * FROM feedback ORDER BY id DESC")) {
                                SimpleDateFormat dbFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                                SimpleDateFormat userFormat = new SimpleDateFormat("dd-MM-yyyy | hh:mm a");

                                while (rs.next()) {
                                    int fId = rs.getInt("id");
                                    int rating = rs.getInt("experience");
                                    String name = rs.getString("name");
                                    String mail = rs.getString("mail");
                                    String message = rs.getString("message");
                                    String rawDate = rs.getString("created_at");
                                    String finalDate = "";
                                    if (rawDate != null) {
                                        try {
                                            Date date = dbFormat.parse(rawDate);
                                            finalDate = userFormat.format(date);
                                        } catch (Exception ignored) {
                                            finalDate = rawDate;
                                        }
                                    }
                    %>
                    <tr style="border-bottom: 1px solid #f1f1f1;">
                        <td class="fw-bold">#<%= fId %></td>
                        <td class="text-start">
                            <div class="fw-bold"><%= (name != null ? name : "") %></div>
                            <div class="text-muted small"><%= (mail != null ? mail : "") %></div>
                        </td>
                        <td>
                            <div class="star-rating">
                                <% for (int i = 1; i <= 5; i++) { %>
                                    <i class="<%= (i <= rating) ? "fa-solid" : "fa-regular" %> fa-star"></i>
                                <% } %>
                                <span class="ms-1">(<%= rating %>)</span>
                            </div>
                        </td>
                        <td class="text-start msg-cell text-truncate" style="max-width: 250px;">
                            "<%= (message != null ? message : "") %>"
                        </td>
                        <td style="font-size: 13px; color: #666; white-space: nowrap;">
                            <%= finalDate %>
                        </td>
                        <td>
                            <a href="admin_feedback.jsp?del_id=<%= fId %>" class="btn-delete" onclick="return confirm('Delete this feedback?')">
                                <i class="fa-solid fa-trash-can"></i>
                            </a>
                        </td>
                    </tr>
                    <%
                                }
                            } catch (Exception e) {
                                out.println("<tr><td colspan='6' class='text-danger text-center'>Error: " + e.getMessage() + "</td></tr>");
                            } finally {
                                try { con.close(); } catch (Exception ignored) {}
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- SUCCESS TOAST NOTIFICATION -->
    <div class="toast-container-header">
        <div id="successToast" class="toast toast-success-header align-items-center text-dark border-0 shadow-lg" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex align-items-center p-2">
                <div class="toast-body">
                    <div class="d-flex align-items-center gap-2">
                        <div class="bg-success text-white rounded-circle d-flex align-items-center justify-content-center me-2" style="width: 35px; height: 35px;">
                            <i class="fa-solid fa-check"></i>
                        </div>
                        <strong class="text-success" style="font-size: 17px;">Success:</strong>
                        <span style="font-size: 15px; white-space: nowrap;"><%= (successMsg != null) ? successMsg : "" %></span>
                    </div>
                </div>
                <button type="button" class="btn-close ms-4 me-2" data-bs-dismiss="toast"></button>
            </div>
        </div>
    </div>

    <script>
        window.onload = function () {
            <% if ("deleted".equals(request.getParameter("status"))) { %>
                var myToast = new bootstrap.Toast(document.getElementById('successToast'), { delay: 3000 });
                myToast.show();
            <% } %>
        };
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>
