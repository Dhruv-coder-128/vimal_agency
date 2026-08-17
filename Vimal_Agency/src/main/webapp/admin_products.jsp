<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="com.vimal.utils.DatabaseManager" %>
        <%@ page import="java.sql.*" %>
            <%@ page import="com.vimal.utils.DatabaseManager" %>

                <% // 👉 STEP 1: STRICT ADMIN SESSION LOCKDOWN if (session.getAttribute("admin_id")==null) {
                    response.sendRedirect("admin_login.jsp?msg=admin_auth_required"); return; } %>

                    <!DOCTYPE html>
                    <html>

                    <head>
                        <title>Products Inventory | Vimal Admin</title>
                        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
                            rel="stylesheet">
                        <link rel="stylesheet"
                            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                        <style>
                            /* Layout Fix for Sidebar */
                            .admin-main {
                                margin-left: 260px;
                                padding: 35px;
                                background: #f8f9fa;
                                min-height: 100vh;
                            }

                            .btn-action {
                                padding: 6px 12px;
                                border-radius: 8px;
                                border: none;
                                transition: 0.3s;
                                text-decoration: none;
                                display: inline-block;
                            }

                            .btn-view {
                                background: #e8f5e9;
                                color: #2e7d32;
                            }

                            .btn-view:hover {
                                background: #2e7d32;
                                color: white;
                            }

                            .btn-edit {
                                background: #e3f2fd;
                                color: #0d6efd;
                            }

                            .btn-edit:hover {
                                background: #0d6efd;
                                color: white;
                            }

                            .btn-delete {
                                background: #ffebee;
                                color: #f44336;
                            }

                            .btn-delete:hover {
                                background: #f44336;
                                color: white;
                            }

                            .modal-content {
                                border-radius: 15px;
                                border: none;
                                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                            }

                            /* Center Toast Styling */
                            .toast-container-header {
                                position: fixed;
                                top: 20px;
                                left: 50%;
                                transform: translateX(-50%);
                                z-index: 2000;
                                width: 100%;
                                max-width: 600px;
                            }

                            .toast-success-header {
                                border-left: 8px solid #28a745 !important;
                                border-radius: 12px !important;
                                background: white !important;
                                box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15) !important;
                            }

                            .toast-danger-header {
                                border-left: 8px solid #dc3545 !important;
                                border-radius: 12px !important;
                                background: white !important;
                                box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15) !important;
                            }
                        </style>
                    </head>

                    <body>

                        <%@ include file="admin_header.jsp" %>

                            <div class="admin-main">
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <div>
                                        <h1 style="font-weight: 800; color: #1a242f; margin: 0; letter-spacing: -1px;">
                                            Products Inventory</h1>
                                        <p style="color: #7f8c8d; margin: 0;">Manage your Vimal Agency snacks and
                                            inventory.</p>
                                    </div>
                                    <button type="button" class="btn btn-warning fw-bold px-4 py-2 text-dark"
                                        data-bs-toggle="modal" data-bs-target="#addProductModal"
                                        style="border-radius: 10px; box-shadow: 0 4px 12px rgba(255, 200, 0, 0.2);">
                                        <i class="fa-solid fa-plus me-2"></i> Add New Product
                                    </button>
                                </div>

                                <% String successMsg=null; String errorMsg=null; Connection
                                    con=DatabaseManager.getConnection(); // 🔥 1. DELETE LOGIC String
                                    action=request.getParameter("action"); if(action !=null && action.equals("delete"))
                                    { try { PreparedStatement ps=con.prepareStatement("DELETE FROM products WHERE
                                    listing_code=?"); ps.setString(1, request.getParameter("id")); ps.executeUpdate();
                                    successMsg="Product deleted successfully!" ; } catch(Exception e) {
                                    errorMsg="Error: " + e.getMessage(); } } // 🔥 2. INSERT LOGIC (DUPLICATE CODE
                                    CHECK) if(request.getMethod().equalsIgnoreCase("POST") &&
                                    request.getParameter("action_type")==null) { try { String
                                    pCode=request.getParameter("p_code"); // Check if code already exists
                                    PreparedStatement chk=con.prepareStatement("SELECT COUNT(*) FROM products WHERE
                                    code=?"); chk.setString(1, pCode); ResultSet rsChk=chk.executeQuery(); rsChk.next();
                                    if(rsChk.getInt(1)> 0) {
                                    errorMsg = "Error: Item Code '" + pCode + "' already exists! Please use a unique
                                    code.";
                                    } else {
                                    String sql = "INSERT INTO products (code, product_name, product_price,
                                    product_category, product_describe, product_image) VALUES (?, ?, ?, ?, ?, ?)";
                                    PreparedStatement ps = con.prepareStatement(sql);
                                    ps.setString(1, pCode);
                                    ps.setString(2, request.getParameter("p_name"));
                                    ps.setString(3, request.getParameter("p_price"));
                                    ps.setString(4, request.getParameter("p_cat"));
                                    ps.setString(5, request.getParameter("p_desc"));
                                    ps.setString(6, request.getParameter("p_img"));
                                    ps.executeUpdate();
                                    successMsg = request.getParameter("p_name") + " added successfully!";
                                    }
                                    } catch(Exception e) { errorMsg = "Error: " + e.getMessage(); }
                                    }

                                    // 🔥 3. UPDATE LOGIC (DUPLICATE CODE CHECK FOR OTHER ITEMS)
                                    if(request.getMethod().equalsIgnoreCase("POST") &&
                                    "update".equals(request.getParameter("action_type"))) {
                                    try {
                                    String pCode = request.getParameter("p_code");
                                    String listingCode = request.getParameter("listing_code");

                                    // Check if code exists on a DIFFERENT product
                                    PreparedStatement chk = con.prepareStatement("SELECT COUNT(*) FROM products WHERE
                                    code = ? AND listing_code != ?");
                                    chk.setString(1, pCode);
                                    chk.setString(2, listingCode);
                                    ResultSet rsChk = chk.executeQuery();
                                    rsChk.next();
                                    if(rsChk.getInt(1) > 0) {
                                    errorMsg = "Error: Item Code '" + pCode + "' is already assigned to another
                                    product!";
                                    } else {
                                    String sql = "UPDATE products SET code=?, product_name=?, product_price=?,
                                    product_category=?, product_describe=?, product_image=? WHERE listing_code=?";
                                    PreparedStatement ps = con.prepareStatement(sql);
                                    ps.setString(1, pCode);
                                    ps.setString(2, request.getParameter("p_name"));
                                    ps.setString(3, request.getParameter("p_price"));
                                    ps.setString(4, request.getParameter("p_cat"));
                                    ps.setString(5, request.getParameter("p_desc"));
                                    ps.setString(6, request.getParameter("p_img"));
                                    ps.setString(7, listingCode);
                                    ps.executeUpdate();
                                    successMsg = request.getParameter("p_name") + " updated successfully!";
                                    }
                                    } catch(Exception e) { errorMsg = "Error: " + e.getMessage(); }
                                    }
                                    %>

                                    <div class="stat-card p-0 overflow-hidden"
                                        style="background: white; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.05); border-top: 5px solid #ffc800;">
                                        <table class="table table-hover align-middle mb-0">
                                            <thead style="background: #f8f9fa;">
                                                <tr>
                                                    <th class="ps-4 py-3">ID</th>
                                                    <th>Code</th>
                                                    <th>Image</th>
                                                    <th>Name</th>
                                                    <th>Category</th>
                                                    <th>Price</th>
                                                    <th class="text-center">Action</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <% try { ResultSet rs=con.createStatement().executeQuery("SELECT * FROM
                                                    products"); while(rs.next()) { String
                                                    safeName=rs.getString("product_name").replace("'", "\\'" ); String
                                                    safeDesc=rs.getString("product_describe") !=null ?
                                                    rs.getString("product_describe").replace("'", "\\'"
                                                    ).replace("\n", " " ) : "" ; %>
                                                    <tr style="border-bottom: 1px solid #f1f1f1;">
                                                        <td class="ps-4 fw-bold">#<%= rs.getInt("listing_code") %>
                                                        </td>
                                                        <td><span class="badge bg-secondary">
                                                                <%= rs.getString("code") %>
                                                            </span></td>
                                                        <td><img src="<%= rs.getString(" product_image") %>"
                                                            style="width: 50px; height: 50px; border-radius: 10px;
                                                            object-fit: contain; border: 1px solid #eee; background:
                                                            #fff;"></td>
                                                        <td class="fw-bold">
                                                            <%= rs.getString("product_name") %>
                                                        </td>
                                                        <td><span class="badge bg-light text-dark border px-3 py-2">
                                                                <%= rs.getString("product_category") %>
                                                            </span></td>
                                                        <td class="text-success fw-bold">₹ <%=
                                                                rs.getDouble("product_price") %>
                                                        </td>
                                                        <td class="text-center">
                                                            <!-- 👁️ VIEW DETAILS BUTTON -->
                                                            <button type="button" class="btn-action btn-view me-2"
                                                                data-bs-toggle="modal"
                                                                data-bs-target="#viewProductModal"
                                                                onclick="fillViewModal('<%= rs.getInt(" listing_code")
                                                                %>', '<%= rs.getString("code") %>', '<%= safeName %>', '
                                                                        <%= rs.getDouble("product_price") %>', '<%=
                                                                                rs.getString("product_category") %>', '
                                                                                <%= rs.getString("product_image") %>', '
                                                                                    <%= safeDesc %>')">
                                                                                        <i class="fa-solid fa-eye"></i>
                                                            </button>
                                                            <!-- ✏️ EDIT BUTTON -->
                                                            <button type="button" class="btn-action btn-edit me-2"
                                                                data-bs-toggle="modal"
                                                                data-bs-target="#editProductModal"
                                                                onclick="fillEditModal('<%= rs.getInt(" listing_code")
                                                                %>', '<%= rs.getString("code") %>', '<%= safeName %>', '
                                                                        <%= rs.getDouble("product_price") %>', '<%=
                                                                                rs.getString("product_category") %>', '
                                                                                <%= rs.getString("product_image") %>', '
                                                                                    <%= safeDesc %>')">
                                                                                        <i
                                                                                            class="fa-solid fa-pen-to-square"></i>
                                                            </button>
                                                            <!-- 🗑️ DELETE BUTTON -->
                                                            <a href="admin_products.jsp?action=delete&id=<%= rs.getInt("
                                                                listing_code") %>" class="btn-action btn-delete"
                                                                onclick="return confirm('Security Check: Delete this
                                                                snack?')">
                                                                <i class="fa-solid fa-trash"></i>
                                                            </a>
                                                        </td>
                                                    </tr>
                                                    <% } con.close(); } catch(Exception e) { out.println(e); } %>
                                            </tbody>
                                        </table>
                                    </div>
                            </div>

                            <!-- 1️⃣ ADD PRODUCT MODAL -->
                            <div class="modal fade" id="addProductModal" tabindex="-1">
                                <div class="modal-dialog modal-dialog-centered modal-lg">
                                    <div class="modal-content">
                                        <div class="modal-header"
                                            style="background: #f8f9fa; border-radius: 15px 15px 0 0;">
                                            <h5 class="modal-title fw-bold">Add New Item</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                        </div>
                                        <form method="POST">
                                            <div class="modal-body p-4">
                                                <div class="row g-3">
                                                    <div class="col-md-6"><label class="fw-bold">Item Code</label><input
                                                            type="text" name="p_code" class="form-control"
                                                            placeholder="e.g. WF101" required></div>
                                                    <div class="col-md-6"><label class="fw-bold">Name</label><input
                                                            type="text" name="p_name" class="form-control"
                                                            placeholder="Product Name" required></div>
                                                    <div class="col-md-6"><label class="fw-bold">Price (₹)</label><input
                                                            type="number" name="p_price" class="form-control" required>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <label class="fw-bold">Category</label>
                                                        <select name="p_cat" class="form-select" required>
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
                                                    <div class="col-12"><label class="fw-bold">Image Path</label><input
                                                            type="text" name="p_img" class="form-control"
                                                            placeholder="./Product/.." required></div>
                                                    <div class="col-12"><label
                                                            class="fw-bold">Description</label><textarea name="p_desc"
                                                            class="form-control" rows="2"></textarea></div>
                                                </div>
                                            </div>
                                            <div class="modal-footer border-0 p-4">
                                                <button type="button" class="btn btn-light fw-bold"
                                                    data-bs-dismiss="modal">Cancel</button>
                                                <button type="submit" class="btn btn-warning fw-bold px-4">Save
                                                    Product</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>

                            <!-- 2️⃣ EDIT PRODUCT MODAL -->
                            <div class="modal fade" id="editProductModal" tabindex="-1">
                                <div class="modal-dialog modal-dialog-centered modal-lg">
                                    <div class="modal-content">
                                        <div class="modal-header"
                                            style="background: #f0f7ff; border-radius: 15px 15px 0 0;">
                                            <h5 class="modal-title fw-bold">Edit Product Details</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                        </div>
                                        <form method="POST">
                                            <input type="hidden" name="action_type" value="update">
                                            <input type="hidden" name="listing_code" id="edit_listing_code">
                                            <div class="modal-body p-4">
                                                <div class="row g-3">
                                                    <div class="col-md-6"><label class="fw-bold">Item Code</label><input
                                                            type="text" name="p_code" id="edit_code"
                                                            class="form-control shadow-none" required></div>
                                                    <div class="col-md-6"><label class="fw-bold">Product
                                                            Name</label><input type="text" name="p_name" id="edit_name"
                                                            class="form-control shadow-none" required></div>
                                                    <div class="col-md-6"><label class="fw-bold">Price (₹)</label><input
                                                            type="number" name="p_price" id="edit_price"
                                                            class="form-control shadow-none" required></div>
                                                    <div class="col-md-6">
                                                        <label class="fw-bold">Category</label>
                                                        <select name="p_cat" id="edit_cat"
                                                            class="form-select shadow-none" required>
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
                                                    <div class="col-12"><label class="fw-bold">Image Path</label><input
                                                            type="text" name="p_img" id="edit_img"
                                                            class="form-control shadow-none" required></div>
                                                    <div class="col-12"><label
                                                            class="fw-bold">Description</label><textarea name="p_desc"
                                                            id="edit_desc" class="form-control shadow-none"
                                                            rows="3"></textarea></div>
                                                </div>
                                            </div>
                                            <div class="modal-footer border-0 p-4">
                                                <button type="button" class="btn btn-light fw-bold"
                                                    data-bs-dismiss="modal">Cancel</button>
                                                <button type="submit" class="btn btn-primary fw-bold px-4">Update
                                                    Changes</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>

                            <!-- 3️⃣ VIEW PRODUCT DETAILS MODAL -->
                            <div class="modal fade" id="viewProductModal" tabindex="-1">
                                <div class="modal-dialog modal-dialog-centered modal-lg">
                                    <div class="modal-content">
                                        <div class="modal-header"
                                            style="background: #e8f5e9; border-radius: 15px 15px 0 0;">
                                            <h5 class="modal-title fw-bold text-success"><i
                                                    class="fa-solid fa-circle-info me-2"></i> Product Complete Details
                                            </h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                        </div>
                                        <div class="modal-body p-4">
                                            <div class="row align-items-center">
                                                <div class="col-md-4 text-center border-end mb-3 mb-md-0">
                                                    <img id="view_img" src="" alt="Product Image"
                                                        style="max-width: 100%; max-height: 220px; border-radius: 12px; object-fit: contain; box-shadow: 0 4px 12px rgba(0,0,0,0.08); background: #fff; padding: 5px;">
                                                </div>
                                                <div class="col-md-8 ps-md-4">
                                                    <div class="row g-3">
                                                        <div class="col-6">
                                                            <small class="text-muted d-block">Listing ID</small>
                                                            <span id="view_listing_code"
                                                                class="fw-bold text-dark fs-6"></span>
                                                        </div>
                                                        <div class="col-6">
                                                            <small class="text-muted d-block">Item Code</small>
                                                            <span id="view_code" class="fw-bold text-dark fs-6"></span>
                                                        </div>
                                                        <div class="col-12">
                                                            <small class="text-muted d-block">Product Name</small>
                                                            <h4 id="view_name" class="fw-bold text-primary mb-0"></h4>
                                                        </div>
                                                        <div class="col-6">
                                                            <small class="text-muted d-block">Category</small>
                                                            <span id="view_cat"
                                                                class="badge bg-light text-dark border px-3 py-2 mt-1 fs-6"></span>
                                                        </div>
                                                        <div class="col-6">
                                                            <small class="text-muted d-block">Price</small>
                                                            <span class="fw-bold text-success fs-4">₹ <span
                                                                    id="view_price"></span></span>
                                                        </div>
                                                        <div class="col-12 mt-2">
                                                            <small class="text-muted d-block">Description</small>
                                                            <div id="view_desc"
                                                                class="p-3 bg-light rounded-3 text-secondary mt-1"
                                                                style="min-height: 70px; font-size: 14px; border: 1px solid #eee; white-space: pre-line;">
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="modal-footer border-0 p-3 bg-light"
                                            style="border-radius: 0 0 15px 15px;">
                                            <button type="button" class="btn btn-secondary fw-bold px-4"
                                                data-bs-dismiss="modal">Close</button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- TOAST NOTIFICATION -->
                            <div class="toast-container-header">
                                <div id="statusToast" class="toast align-items-center text-dark border-0 shadow-lg"
                                    role="alert" aria-live="assertive" aria-atomic="true">
                                    <div class="d-flex align-items-center p-3">
                                        <div class="toast-body w-100">
                                            <div class="d-flex align-items-center justify-content-center">
                                                <div id="toastIconBg"
                                                    class="rounded-circle d-flex align-items-center justify-content-center me-4"
                                                    style="width: 45px; height: 45px; flex-shrink: 0;">
                                                    <i id="toastIcon" class="fa-solid fa-lg"></i>
                                                </div>
                                                <div>
                                                    <strong id="toastTitle" class="d-block"
                                                        style="font-size: 18px; margin-bottom: 2px;"></strong>
                                                    <span id="toastMsg" class="text-muted"
                                                        style="font-size: 15px; font-weight: 500;"></span>
                                                </div>
                                            </div>
                                        </div>
                                        <button type="button" class="btn-close me-2 shadow-none" data-bs-dismiss="toast"
                                            aria-label="Close"></button>
                                    </div>
                                </div>
                            </div>

                            <script>
                                function fillEditModal(id, code, name, price, cat, img, desc) {
                                    document.getElementById('edit_listing_code').value = id;
                                    document.getElementById('edit_code').value = code;
                                    document.getElementById('edit_name').value = name;
                                    document.getElementById('edit_price').value = price;
                                    document.getElementById('edit_cat').value = cat;
                                    document.getElementById('edit_img').value = img;
                                    document.getElementById('edit_desc').value = desc;
                                }

                                function fillViewModal(id, code, name, price, cat, img, desc) {
                                    document.getElementById('view_listing_code').innerText = "#" + id;
                                    document.getElementById('view_code').innerText = (code && code !== 'null' && code !== '') ? code : 'N/A';
                                    document.getElementById('view_name').innerText = name;
                                    document.getElementById('view_price').innerText = parseFloat(price).toFixed(2);
                                    document.getElementById('view_cat').innerText = cat;
                                    document.getElementById('view_img').src = img;

                                    if (desc && desc.trim() !== 'null' && desc.trim() !== '') {
                                        document.getElementById('view_desc').innerText = desc;
                                    } else {
                                        document.getElementById('view_desc').innerText = "No description available for this snack item.";
                                    }
                                }

                                window.onload = function () {
            <% if (successMsg != null) { %>
                                        let toast = document.getElementById('statusToast');
                                        toast.classList.add('toast-success-header');
                                        document.getElementById('toastIconBg').className = "bg-success text-white rounded-circle d-flex align-items-center justify-content-center me-4";
                                        document.getElementById('toastIcon').className = "fa-solid fa-check fa-lg";
                                        document.getElementById('toastTitle').className = "d-block text-success";
                                        document.getElementById('toastTitle').innerText = "Success";
                                        document.getElementById('toastMsg').innerText = "<%= successMsg %>";
                                        var myToast = new bootstrap.Toast(toast, { delay: 3500 });
                                        myToast.show();
            <% } else if (errorMsg != null) { %>
                                        let toast = document.getElementById('statusToast');
                                        toast.classList.add('toast-danger-header');
                                        document.getElementById('toastIconBg').className = "bg-danger text-white rounded-circle d-flex align-items-center justify-content-center me-4";
                                        document.getElementById('toastIcon').className = "fa-solid fa-triangle-exclamation fa-lg";
                                        document.getElementById('toastTitle').className = "d-block text-danger";
                                        document.getElementById('toastTitle').innerText = "Duplicate Error";
                                        document.getElementById('toastMsg').innerText = "<%= errorMsg %>";
                                        var myToast = new bootstrap.Toast(toast, { delay: 4500 });
                                        myToast.show();
            <% } %>
        };
                            </script>
                            <script
                                src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
                    </body>

                    </html>