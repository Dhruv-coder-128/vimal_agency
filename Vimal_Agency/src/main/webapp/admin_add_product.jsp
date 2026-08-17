<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.vimal.utils.DatabaseManager" %>
<%@ page import="java.sql.*" %>

<%
    if (session.getAttribute("admin_id") == null) {
        response.sendRedirect("admin_login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>

<head>
    <title>Add New Product | Vimal Admin</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        .admin-main {
            margin-left: 260px;
            padding: 35px;
            background: #f8f9fa;
            min-height: 100vh;
        }

        .form-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.05);
            border-top: 5px solid #ffc800;
            padding: 25px;
        }
    </style>
</head>

<body>

    <!-- Include Admin Header (Navigation + Sidebar) -->
    <%@ include file="admin_header.jsp" %>

    <div class="admin-main">

        <!-- Page Heading Section -->
        <div class="mb-4">
            <h1 style="font-weight: 800; color: #1a242f; margin: 0; letter-spacing: -1px;">
                Add New Snack
            </h1>
            <p style="color: #7f8c8d;">
                Enter details to add a product to your inventory.
            </p>
        </div>

        <%
            if (request.getMethod().equalsIgnoreCase("POST")) {
                request.setCharacterEncoding("UTF-8");
                String p_name = request.getParameter("p_name");
                String p_price = request.getParameter("p_price");
                String p_cat = request.getParameter("p_cat");
                String p_img = request.getParameter("p_img");
                String p_desc = request.getParameter("p_desc");
                String p_code = request.getParameter("p_code");

                try (Connection con = DatabaseManager.getConnection()) {
                    String query = "INSERT INTO products (code, product_name, product_price, product_category, product_describe, product_image) VALUES (?, ?, ?, ?, ?, ?)";
                    try (PreparedStatement ps = con.prepareStatement(query)) {
                        ps.setString(1, p_code);
                        ps.setString(2, p_name);
                        ps.setInt(3, Integer.parseInt(p_price));
                        ps.setString(4, p_cat);
                        ps.setString(5, p_desc);
                        ps.setString(6, p_img);
                        int result = ps.executeUpdate();
                        if (result > 0) {
                            out.println("<script>alert('Product Added Successfully!'); window.location='admin_products.jsp';</script>");
                        }
                    }
                } catch (Exception e) {
                    out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
                }
            }
        %>

        <!-- PRODUCT ADD FORM -->
        <div class="form-card shadow-sm">

            <form action="admin_add_product.jsp" method="POST">

                <!-- Product Code & Name Row -->
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-bold">Product Code</label>
                        <input type="text" name="p_code" class="form-control shadow-none" placeholder="e.g. WF101" required>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-bold">Product Name</label>
                        <input type="text" name="p_name" class="form-control shadow-none" placeholder="Crunchy Wafers" required>
                    </div>
                </div>

                <!-- Price & Category Row -->
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-bold">Price (₹)</label>
                        <input type="number" name="p_price" class="form-control shadow-none" placeholder="10" required>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label class="fw-bold mb-2">Category</label>
                        <select name="p_cat" class="form-select shadow-none" required>
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
                </div>

                <!-- Product Description -->
                <div class="mb-3">
                    <label class="form-label fw-bold">Description</label>
                    <textarea name="p_desc" class="form-control shadow-none" rows="3" placeholder="Describe your product..."></textarea>
                </div>

                <!-- Image Path Input -->
                <div class="mb-4">
                    <label class="form-label fw-bold">Image Path</label>
                    <input type="text" name="p_img" class="form-control shadow-none" placeholder="./Product/snack.png" required>
                    <small class="text-muted">
                        Relative path from root directory.
                    </small>
                </div>

                <!-- Action Buttons -->
                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-warning fw-bold px-4 py-2 text-dark">
                        <i class="fa-solid fa-plus me-1"></i> Save Product
                    </button>

                    <a href="admin_products.jsp" class="btn btn-outline-secondary px-4 py-2">
                        Cancel
                    </a>
                </div>

            </form>
        </div>
    </div>

    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>

</body>

</html>