<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.vimal.utils.DatabaseManager" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.vimal.utils.DatabaseManager" %>
<!DOCTYPE html>
<html>
<head>
    <title>Promo Codes | Vimal Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .table td, .table th { padding: 10px 15px !important; font-size: 14px; vertical-align: middle !important; }
        .promo-code-badge { font-weight: 800; color: #0d6efd; background: #eef6ff; padding: 4px 10px; border-radius: 6px; }
        .category-badge { background: #f8f9fa; border: 1px solid #dee2e6; color: #6c757d; font-size: 12px; padding: 2px 8px; border-radius: 4px; }
        .action-flex { display: flex; gap: 8px; justify-content: center; }
        .btn-action { padding: 6px 10px; border-radius: 8px; border: none; transition: 0.3s; }
        .btn-edit { background: #e3f2fd; color: #0d6efd; }
        .btn-delete { background: #ffebee; color: #f44336; }
        .toast-container-header { position: fixed; top: 25px; left: 50%; transform: translateX(-50%); z-index: 2500; width: max-content; min-width: 400px; }
        .toast-success-header { border-left: 8px solid #28a745 !important; border-radius: 12px !important; background: white !important; box-shadow: 0 10px 35px rgba(0,0,0,0.15) !important; padding: 8px 20px; }
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
            <button type="button" class="btn btn-warning fw-bold px-4 py-2" data-bs-toggle="modal" data-bs-target="#addPromoModal" style="border-radius: 10px;">
                + Add New Promo
            </button>
        </div>

        <%
            String successMsg = null;
            // Emoji support mate UTF-8 connection string
            Connection con = DatabaseManager.getConnection();
            
            if(request.getMethod().equalsIgnoreCase("POST")) {
                request.setCharacterEncoding("UTF-8"); // Encoding set karyu
                String action = request.getParameter("action");
                
                if("add".equals(action)) {
                    // Fixed: Input name 'category_name' match karyu
                    String sql = "INSERT INTO promo (code_name, discount_percentage, description, min_order_amount, category_name) VALUES (?, ?, ?, ?, ?)";
                    PreparedStatement ps = con.prepareStatement(sql);
                    ps.setString(1, request.getParameter("code_name"));
                    ps.setString(2, request.getParameter("discount"));
                    ps.setString(3, request.getParameter("description"));
                    ps.setString(4, request.getParameter("min_amount"));
                    ps.setString(5, request.getParameter("category_name"));
                    ps.executeUpdate();
                    successMsg = "Promo created for " + request.getParameter("category_name") + " category!";
                } else if("update".equals(action)) {
                    String sql = "UPDATE promo SET code_name=?, discount_percentage=?, description=?, min_order_amount=?, category_name=? WHERE id=?";
                    PreparedStatement ps = con.prepareStatement(sql);
                    ps.setString(1, request.getParameter("code_name"));
                    ps.setString(2, request.getParameter("discount"));
                    ps.setString(3, request.getParameter("description"));
                    ps.setString(4, request.getParameter("min_amount"));
                    ps.setString(5, request.getParameter("category_name"));
                    ps.setString(6, request.getParameter("promo_id"));
                    ps.executeUpdate();
                    successMsg = "Promo updated successfully!";
                }
            }

            if(request.getParameter("del_id") != null) {
                PreparedStatement ps = con.prepareStatement("DELETE FROM promo WHERE id = ?");
                ps.setString(1, request.getParameter("del_id"));
                ps.executeUpdate();
                successMsg = "Promo deleted successfully!";
            }
        %>

        <div class="stat-card p-0 overflow-hidden" style="background: white; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.05); border-top: 5px solid #ffc800;">
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
                        ResultSet rs = con.createStatement().executeQuery("SELECT * FROM promo ORDER BY id DESC");
                        while(rs.next()) {
                    %>
                    <tr style="border-bottom: 1px solid #f1f1f1;">
                        <td class="fw-bold">#<%= rs.getInt("id") %></td>
                        <td><span class="promo-code-badge"><%= rs.getString("code_name") %></span></td>
                        <td><span class="category-badge"><%= rs.getString("category_name") %></span></td>
                        <td class="fw-bold text-success"><%= rs.getInt("discount_percentage") %>%</td>
                        <td class="text-start" style="max-width: 220px;"><%= rs.getString("description") %></td>
                        <td class="fw-bold">₹<%= rs.getDouble("min_order_amount") %></td>
                        <td>
                            <div class="action-flex">
                                <button type="button" class="btn-action btn-edit" data-bs-toggle="modal" data-bs-target="#editPromoModal" 
                                        onclick="fillEditModal('<%= rs.getInt("id") %>', '<%= rs.getString("code_name") %>', '<%= rs.getInt("discount_percentage") %>', '<%= rs.getString("description") %>', '<%= rs.getDouble("min_order_amount") %>', '<%= rs.getString("category_name") %>')">
                                    <i class="fa-solid fa-pen-to-square"></i>
                                </button>
                                <a href="admin_promos.jsp?del_id=<%= rs.getInt("id") %>" class="btn-action btn-delete" onclick="return confirm('Delete this promo?')">
                                    <i class="fa-solid fa-trash"></i>
                                </a>
                            </div>
                        </td>
                    </tr>
                    <% } con.close(); %>
                </tbody>
            </table>
        </div>
    </div>

    <div class="modal fade" id="editPromoModal" tabindex="-1" style="z-index: 3000;">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="border-radius: 15px;">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Edit Promo Code</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="POST">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="promo_id" id="edit_promo_id">
                    <div class="modal-body p-4">
                        <div class="row g-3">
                            <div class="col-md-6"><label class="fw-bold mb-1">Code Name</label><input type="text" name="code_name" id="edit_code_name" class="form-control" required></div>
                            <div class="col-md-6"><label class="fw-bold mb-1">Discount (%)</label><input type="number" name="discount" id="edit_discount" class="form-control" required></div>
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
                            <div class="col-12"><label class="fw-bold mb-1">Min. Amount (₹)</label><input type="number" name="min_amount" id="edit_min_amount" class="form-control" required></div>
                            <div class="col-12"><label class="fw-bold mb-1">Description</label><textarea name="description" id="edit_description" class="form-control" rows="2"></textarea></div>
                        </div>
                    </div>
                    <div class="modal-footer border-0"><button type="submit" class="btn btn-primary fw-bold px-4">Update Promo</button></div>
                </form>
            </div>
        </div>
    </div>

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
                            <div class="col-md-6"><label class="fw-bold mb-1">Code Name</label><input type="text" name="code_name" class="form-control" placeholder="VIMAL20" required></div>
                            <div class="col-md-6"><label class="fw-bold mb-1">Discount (%)</label><input type="number" name="discount" class="form-control" placeholder="20" required></div>
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
                            <div class="col-12"><label class="fw-bold mb-1">Min. Amount (₹)</label><input type="number" name="min_amount" class="form-control" value="0" required></div>
                            <div class="col-12"><label class="fw-bold mb-1">Description</label><textarea name="description" class="form-control" rows="2"></textarea></div>
                        </div>
                    </div>
                    <div class="modal-footer border-0"><button type="submit" class="btn btn-warning fw-bold px-4">Save Promo</button></div>
                </form>
            </div>
        </div>
    </div>

    <div class="toast-container-header">
        <div id="successToast" class="toast toast-success-header align-items-center text-dark border-0 shadow-lg" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex align-items-center">
                <div class="toast-body"><div class="d-flex align-items-center gap-2">
                    <div class="bg-success text-white rounded-circle d-flex align-items-center justify-content-center me-2" style="width: 35px; height: 35px;"><i class="fa-solid fa-check"></i></div>
                    <strong class="text-success" style="font-size: 17px; white-space: nowrap;">Success:</strong>
                    <span style="font-size: 15px; white-space: nowrap;"><%= (successMsg != null) ? successMsg : "" %></span>
                </div></div>
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
        window.onload = function() {
            <% if(successMsg != null) { %>
                var myToast = new bootstrap.Toast(document.getElementById('successToast'), { delay: 3000 });
                myToast.show();
            <% } %>
        };
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>