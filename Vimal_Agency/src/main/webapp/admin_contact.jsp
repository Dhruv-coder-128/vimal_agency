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
            try (PreparedStatement ps = con.prepareStatement("DELETE FROM contact_us WHERE id = ?")) {
                ps.setInt(1, Integer.parseInt(request.getParameter("del_id")));
                ps.executeUpdate();
                successMsg = "Contact lead deleted successfully!";
            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>Error deleting lead: " + e.getMessage() + "</div>");
            }
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
    <title>Contact Leads | Vimal Admin</title>

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

        .contact-link {
            text-decoration: none;
            color: #25d366;
            font-weight: 700;
            transition: 0.3s;
        }

        .contact-link:hover {
            color: #128c7e;
        }

        .msg-box {
            max-width: 250px;
            color: #444;
            line-height: 1.4;
        }

        .btn-delete {
            background: #ffebee;
            color: #f44336;
            border: none;
            padding: 6px 10px;
            border-radius: 8px;
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
                Contact Enquiries
            </h1>
            <p style="color: #7f8c8d; margin: 0;">
                Manage leads and customer enquiries from Vimal Agency website.
            </p>
        </div>

        <div class="stat-card p-0 overflow-hidden" style="background: white; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.05); border-top: 5px solid #ffc800;">
            <table class="table table-hover align-middle mb-0 text-center">
                <!-- Table Header -->
                <thead style="background: #f8f9fa;">
                    <tr>
                        <th class="py-3 px-4">ID</th>
                        <th class="text-start">Name & Email</th>
                        <th>Contact No.</th>
                        <th class="text-start">Message</th>
                        <th>Enquiry Date</th>
                        <th>Action</th>
                    </tr>
                </thead>

                <tbody>
                    <%
                        if (con != null) {
                            try (Statement st = con.createStatement();
                                 ResultSet rs = st.executeQuery("SELECT * FROM contact_us ORDER BY id DESC")) {
                                SimpleDateFormat dbFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                                SimpleDateFormat userFormat = new SimpleDateFormat("dd-MM-yyyy | hh:mm a");

                                while (rs.next()) {
                                    int cId = rs.getInt("id");
                                    String name = rs.getString("name");
                                    String email = rs.getString("email");
                                    String mobile = rs.getString("cno");
                                    String message = rs.getString("message");
                                    String rawDate = rs.getString("created_time");
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
                        <!-- Lead ID -->
                        <td class="fw-bold">#<%= cId %></td>

                        <!-- Name & Email -->
                        <td class="text-start">
                            <div class="fw-bold"><%= (name != null ? name : "") %></div>
                            <div class="text-muted small"><%= (email != null ? email : "") %></div>
                        </td>

                        <!-- Contact Number + WhatsApp -->
                        <td>
                            <div class="d-flex flex-column gap-1">
                                <a href="tel:<%= (mobile != null ? mobile : "") %>" class="text-dark fw-bold" style="text-decoration:none;">
                                    <i class="fa-solid fa-phone me-1 text-primary"></i><%= (mobile != null ? mobile : "-") %>
                                </a>
                                <% if (mobile != null && !mobile.trim().isEmpty()) { %>
                                <a href="https://wa.me/91<%= mobile.trim() %>" target="_blank" class="contact-link small">
                                    <i class="fa-brands fa-whatsapp me-1"></i>WhatsApp Chat
                                </a>
                                <% } %>
                            </div>
                        </td>

                        <!-- Message Column -->
                        <td class="text-start msg-box">
                            <div class="text-truncate" style="max-width: 200px;" title="<%= (message != null ? message : "") %>">
                                <%= (message != null ? message : "") %>
                            </div>
                        </td>

                        <!-- Formatted Date -->
                        <td style="font-size: 13px; color: #666; white-space: nowrap;">
                            <%= finalDate %>
                        </td>

                        <!-- Delete Button -->
                        <td>
                            <a href="admin_contact.jsp?del_id=<%= cId %>" class="btn-delete" onclick="return confirm('Delete this lead?')">
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
            <% if (successMsg != null) { %>
                var myToast = new bootstrap.Toast(document.getElementById('successToast'), { delay: 3000 });
                myToast.show();
            <% } %>
        };
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>
