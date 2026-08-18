<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.vimal.utils.DatabaseManager" %>
<%@ page import="java.sql.*" %>

<%
    if (session.getAttribute("admin_id") == null) {
        response.sendRedirect("admin_login.jsp?msg=admin_auth_required");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Promo Codes | Vimal Admin</title>
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

        .table td,
        .table th {
            padding: 10px 15px !important;
            font-size: 14px;
            vertical-align: middle !important;
        }

        .promo-code-badge {
            font-weight: 800;
            color: #0d6efd;
            background: #eef6ff;
            padding: 4px 10px;
            border-radius: 6px;
        }

        .category-badge {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            color: #6c757d;
            font-size: 12px;
            padding: 2px 8px;
            border-radius: 4px;
        }

        .action-flex {
            display: flex;
            gap: 8px;
            justify-content: center;
        }

        .btn-action {
            padding: 6px 10px;
            border-radius: 8px;
            border: none;
            transition: 0.3s;
        }

        .btn-edit {
            background: #e3f2fd;
            color: #0d6efd;
        }

        .btn-delete {
            background: #ffebee;
            color: #f44336;
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

    <%@ include file="admin_header.jsp" %>

    <div class="admin-main p-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1 style="font-weight: 800; color: #1a242f; margin: 0; letter-spacing: -1px;">Promo Codes</h1>
                <p style="color: #7f8c8d; margin: 0;">Manage targeted category discounts for Vimal Agency.</p>
            </div>
            <button type="button" class="btn btn-warning fw-bold px-4 py-2" data-bs-toggle="modal"
                data-bs-target="#addPromoModal" style="border-radius: 10px;">
                + Add New Promo
            </button>
        </div>

        <%
            String successMsg = null;
            Connection con = null;

            try {
                con = DatabaseManager.getConnection();

                if (request.getMethod().equalsIgnoreCase("POST")) {
                    request.setCharacterEncoding("UTF-8");
                    String action = request.getParameter("action");

                    if ("add".equals(action)) {
                        String sql = "INSERT INTO promo (code_name, discount_percentage, description, min_order_amount, category_name) VALUES (?, ?, ?, ?, ?)";
                        try (PreparedStatement ps = con.prepareStatement(sql)) {
                            ps.setString(1, request.getParameter("code_name"));
                            ps.setInt(2, Integer.parseInt(request.getParameter("discount")));
                            ps.setString(3, request.getParameter("description"));
                            ps.setInt(4, Integer.parseInt(request.getParameter("min_amount")));
                            ps.setString(5, request.getParameter("category_name"));
                            ps.executeUpdate();
                            successMsg = "Promo created for " + request.getParameter("category_name") + " category!";
                        }
                    } else if ("update".equals(action)) {
                        String sql = "UPDATE promo SET code_name=?, discount_percentage=?, description=?, min_order_amount=?, category_name=? WHERE id=?";
                        try (PreparedStatement ps = con.prepareStatement(sql)) {
                            ps.setString(1, request.getParameter("code_name"));
                            ps.setInt(2, Integer.parseInt(request.getParameter("discount")));
                            ps.setString(3, request.getParameter("description"));
                            ps.setInt(4, Integer.parseInt(request.getParameter("min_amount")));
                            ps.setString(5, request.getParameter("category_name"));
                            ps.setInt(6, Integer.parseInt(request.getParameter("promo_id")));
                            ps.executeUpdate();
                            successMsg = "Promo updated successfully!";
                        }
                    }
                }

                if (request.getParameter("del_id") != null) {
                    try (PreparedStatement ps = con.prepareStatement("DELETE FROM promo WHERE id=?")) {
                        ps.setInt(1, Integer.parseInt(request.getParameter("del_id")));
                        ps.executeUpdate();
                        successMsg = "Promo deleted successfully!";
                    }
                }
            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
            }
        %>

        <div class="stat-card p-0 overflow-hidden"
            style="background: white; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.05); border-top: 5px solid #ffc800;">
            <table class="table table-hover align-middle mb-0 text-center">
                <thead style="background: #f8f9fa;">
                    <tr>
                        <th class="py-3 px-4">ID</th>
                        <th>Code</th>
                        <th>Category</th>
                        <th>Discount</th>
                        <th class="text-start">Description</th>
                        <th>Min. Order</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if (con != null) {
                            try (Statement st = con.createStatement();
                                 ResultSet rs = st.executeQuery("SELECT * FROM promo ORDER BY id DESC")) {
                                while (rs.next()) {
                                    int pId = rs.getInt("id");
                                    String cName = rs.getString("code_name");
                                    String catName = rs.getString("category_name");
                                    int disc = rs.getInt("discount_percentage");
                                    String desc = rs.getString("description");
                                    int minOrd = rs.getInt("min_order_amount");
                                    String safeDesc = (desc != null) ? desc.replace("'", "\\'").replace("\"", "&quot;") : "";
                    %>
                    <tr>
                        <td class="px-4 fw-bold">#<%= pId %></td>
                        <td><span class="promo-code-badge"><%= (cName != null ? cName : "") %></span></td>
                        <td><span class="category-badge"><%= (catName != null ? catName : "All") %></span></td>
                        <td class="text-success fw-bold"><%= disc %>% OFF</td>
                        <td class="text-start text-muted" style="max-width: 250px;"><%= (desc != null ? desc : "-") %></td>
                        <td class="fw-bold">₹ <%= minOrd %></td>
                        <td>
                            <div class="action-flex">
                                <button type="button" class="btn-action btn-edit" data-bs-toggle="modal"
                                    data-bs-target="#editPromoModal"
                                    onclick="fillEditModal('<%= pId %>', '<%= (cName != null ? cName : "") %>', '<%= disc %>', '<%= safeDesc %>', '<%= minOrd %>', '<%= (catName != null ? catName : "All") %>')">
                                    <i class="fa-solid fa-pen-to-square"></i>
                                </button>
                                <a href="admin_promos.jsp?del_id=<%= pId %>" class="btn-action btn-delete"
                                    onclick="return confirm('Delete this promo code?')">
                                    <i class="fa-solid fa-trash"></i>
                                </a>
                            </div>
                        </td>
                    </tr>
                    <%
                                }
                            } catch (Exception e) {
                                out.println("<tr><td colspan='7' class='text-danger text-center'>Error: " + e.getMessage() + "</td></tr>");
                            } finally {
                                try { con.close(); } catch (Exception ignored) {}
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Edit Promo Modal -->
    <div class="modal fade" id="editPromoModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="border-radius: 15px;">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Edit Promo Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="POST">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="promo_id" id="edit_promo_id">
                    <div class="modal-body p-4">
                        <div class="row g-3">
                            <div class="col-md-6"><label class="fw-bold mb-1">Code Name</label><input
                                    type="text" name="code_name" id="edit_code_name" class="form-control" required></div>
                            <div class="col-md-6"><label class="fw-bold mb-1">Discount (%)</label><input
                                    type="number" name="discount" id="edit_discount" class="form-control" required></div>
                            <div class="col-12">
                                <label class="fw-bold mb-1">Target Category</label>
                                <select name="category_name" id="edit_category_name" class="form-select">
                                    <option value="All">All Categories</option>
                                    <option value="Wafers">Wafers</option>
                                    <option value="Western Snacks">Western Snacks</option>
                                    <option value="Snack Pellets">Snack Pellets</option>
                                    <option value="Namkeen">Namkeen</option>
                                    <option value="Peanuts">Peanuts</option>
                                    <option value="Khakhra">Khakhra</option>
                                    <option value="Wafer Biscuit">Wafer Biscuit</option>
                                    <option value="Confectionary">Confectionary</option>
                                    <option value="Gippi Noodles">Gippi Noodles</option>
                                    <option value="Olee">Olee</option>
                                </select>
                            </div>
                            <div class="col-12"><label class="fw-bold mb-1">Min. Amount (₹)</label><input
                                    type="number" name="min_amount" id="edit_min_amount" class="form-control" required></div>
                            <div class="col-12"><label class="fw-bold mb-1">Description</label><textarea
                                    name="description" id="edit_description" class="form-control" rows="2"></textarea></div>
                        </div>
                    </div>
                    <div class="modal-footer border-0"><button type="submit" class="btn btn-primary fw-bold px-4">Update Promo</button></div>
                </form>
            </div>
        </div>
    </div>

    <!-- Add Promo Modal -->
    <div class="modal fade" id="addPromoModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="border-radius: 15px;">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Create Promo Code</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="POST">
                    <input type="hidden" name="action" value="add">
                    <div class="modal-body p-4">
                        <div class="row g-3">
                            <div class="col-md-6"><label class="fw-bold mb-1">Code Name</label><input
                                    type="text" name="code_name" class="form-control" placeholder="VIMAL20" required></div>
                            <div class="col-md-6"><label class="fw-bold mb-1">Discount (%)</label><input
                                    type="number" name="discount" class="form-control" placeholder="20" required></div>
                            <div class="col-12">
                                <label class="fw-bold mb-1">Apply to Category</label>
                                <select name="category_name" class="form-select" required>
                                    <option value="All">All Categories</option>
                                    <option value="Wafers">Wafers</option>
                                    <option value="Western Snacks">Western Snacks</option>
                                    <option value="Snack Pellets">Snack Pellets</option>
                                    <option value="Namkeen">Namkeen</option>
                                    <option value="Peanuts">Peanuts</option>
                                    <option value="Khakhra">Khakhra</option>
                                    <option value="Wafer Biscuit">Wafer Biscuit</option>
                                    <option value="Confectionary">Confectionary</option>
                                    <option value="Gippi Noodles">Gippi Noodles</option>
                                    <option value="Olee">Olee</option>
                                </select>
                            </div>
                            <div class="col-12"><label class="fw-bold mb-1">Min. Amount (₹)</label><input
                                    type="number" name="min_amount" class="form-control" value="0" required></div>
                            <div class="col-12"><label class="fw-bold mb-1">Description</label><textarea
                                    name="description" class="form-control" rows="2"></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0"><button type="submit" class="btn btn-warning fw-bold px-4">Save Promo</button></div>
                </form>
            </div>
        </div>
    </div>

    <!-- Toast Notification -->
    <div class="toast-container-header">
        <div id="successToast" class="toast toast-success-header align-items-center text-dark border-0 shadow-lg"
            role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex align-items-center">
                <div class="toast-body">
                    <div class="d-flex align-items-center gap-2">
                        <div class="bg-success text-white rounded-circle d-flex align-items-center justify-content-center me-2"
                            style="width: 35px; height: 35px;"><i class="fa-solid fa-check"></i>
                        </div>
                        <strong class="text-success" style="font-size: 17px; white-space: nowrap;">Success:</strong>
                        <span style="font-size: 15px; white-space: nowrap;"><%= (successMsg != null) ? successMsg : "" %></span>
                    </div>
                </div>
                <button type="button" class="btn-close ms-4 me-2" data-bs-dismiss="toast"></button>
            </div>
        </div>
    </div>

    <script>
        function fillEditModal(id, name, discount, desc, min, category) {
            document.getElementById('edit_promo_id').value = id;
            document.getElementById('edit_code_name').value = name;
            document.getElementById('edit_discount').value = discount;
            document.getElementById('edit_description').value = desc;
            document.getElementById('edit_min_amount').value = min;
            document.getElementById('edit_category_name').value = category;
        }

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
