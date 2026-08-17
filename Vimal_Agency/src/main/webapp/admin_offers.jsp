<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ page import="com.vimal.utils.DatabaseManager" %>
        <%@ page import="java.sql.*" %>
            <%@ page import="com.vimal.utils.DatabaseManager" %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta charset="UTF-8">
                    <title>Marketing Offers | Vimal Admin</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                    <style>
                        /* Compact Row & Text Styling */
                        .table td,
                        .table th {
                            padding: 10px 15px !important;
                            /* Row height nani kari */
                            font-size: 14px;
                            vertical-align: middle !important;
                        }

                        .offer-text-cell {
                            max-width: 450px;
                            color: #444;
                            line-height: 1.3;
                            text-align: left;
                        }

                        /* Action buttons side-by-side */
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

                        .status-badge {
                            font-weight: 700;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                        }

                        .dot {
                            height: 7px;
                            width: 7px;
                            background-color: #28a745;
                            border-radius: 50%;
                            display: inline-block;
                            margin-right: 6px;
                        }

                        /* Professional Single Line Toast */
                        .toast-container-header {
                            position: fixed;
                            top: 25px;
                            left: 50%;
                            transform: translateX(-50%);
                            z-index: 2500;
                            width: max-content;
                            min-width: 420px;
                        }

                        .toast-success-header {
                            border-left: 8px solid #28a745 !important;
                            border-radius: 12px !important;
                            background: white !important;
                            box-shadow: 0 10px 35px rgba(0, 0, 0, 0.15) !important;
                            padding: 10px 20px;
                        }
                    </style>
                </head>

                <body>

                    <%@ include file="admin_header.jsp" %>

                        <div class="admin-main p-4">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <div>
                                    <h1 style="font-weight: 800; color: #1a242f; margin: 0; letter-spacing: -1px;">
                                        Marketing Offers</h1>
                                    <p style="color: #7f8c8d; margin: 0;">Update your website banners and promotional
                                        text.</p>
                                </div>
                                <button type="button" class="btn btn-warning fw-bold px-4 py-2" data-bs-toggle="modal"
                                    data-bs-target="#addOfferModal" style="border-radius: 10px;">
                                    + Create New Offer
                                </button>
                            </div>

                            <% String successMsg=null; Connection con=DatabaseManager.getConnection(); // UPDATE LOGIC
                                if(request.getMethod().equalsIgnoreCase("POST") && "update"
                                .equals(request.getParameter("action"))) { String
                                sql="UPDATE offers SET offer_text=?, is_active=? WHERE id=?" ; PreparedStatement
                                ps=con.prepareStatement(sql); ps.setString(1, request.getParameter("offer_text"));
                                ps.setInt(2, Integer.parseInt(request.getParameter("is_active"))); ps.setString(3,
                                request.getParameter("offer_id")); ps.executeUpdate();
                                successMsg="Offer updated successfully!" ; } // INSERT LOGIC
                                if(request.getMethod().equalsIgnoreCase("POST") && "add"
                                .equals(request.getParameter("action"))) { String
                                sql="INSERT INTO offers (offer_text, is_active) VALUES (?, ?)" ; PreparedStatement
                                ps=con.prepareStatement(sql); ps.setString(1, request.getParameter("offer_text"));
                                ps.setInt(2, Integer.parseInt(request.getParameter("is_active"))); ps.executeUpdate();
                                successMsg="New offer created successfully!" ; } // DELETE LOGIC
                                if(request.getParameter("del_id") !=null) { PreparedStatement
                                ps=con.prepareStatement("DELETE FROM offers WHERE id=?"); ps.setString(1,
                                request.getParameter("del_id")); ps.executeUpdate();
                                successMsg="Offer deleted successfully!" ; } %>

                                <div class="stat-card p-0 overflow-hidden"
                                    style="background: white; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.05); border-top: 5px solid #ffc800;">
                                    <table class="table table-hover align-middle mb-0 text-center">
                                        <thead style="background: #f8f9fa;">
                                            <tr>
                                                <th class="py-3 px-4">ID</th>
                                                <th class="text-start ps-4">Offer Text</th>
                                                <th>Status</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% ResultSet rs=con.createStatement().executeQuery("SELECT * FROM offers");
                                                while(rs.next()) { int isActive=rs.getInt("is_active"); %>
                                                <tr style="border-bottom: 1px solid #f1f1f1;">
                                                    <td class="fw-bold px-4">#<%= rs.getInt("id") %>
                                                    </td>
                                                    <td class="offer-text-cell">
                                                        <%= rs.getString("offer_text") %>
                                                    </td>
                                                    <td>
                                                        <div class="status-badge <%= (isActive == 1) ? " text-success"
                                                            : "text-danger" %>">
                                                            <% if(isActive==1) { %><span class="dot"></span>
                                                                <% } %>
                                                                    <%= (isActive==1) ? "Active" : "Inactive" %>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div class="action-flex">
                                                            <button type="button" class="btn-action btn-edit"
                                                                data-bs-toggle="modal" data-bs-target="#editOfferModal"
                                                                onclick="fillEditModal('<%= rs.getInt(" id") %>', '<%=
                                                                    rs.getString("offer_text") %>', '<%= isActive %>')">
                                                                        <i class="fa-solid fa-pen-to-square"></i>
                                                            </button>
                                                            <a href="admin_offers.jsp?del_id=<%= rs.getInt(" id") %>"
                                                                class="btn-action btn-delete" onclick="return
                                                                confirm('Delete this offer?')">
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

                        <div class="modal fade" id="editOfferModal" tabindex="-1">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content" style="border-radius: 15px;">
                                    <div class="modal-header">
                                        <h5 class="modal-title fw-bold">Edit Offer</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                    </div>
                                    <form method="POST">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="offer_id" id="edit_offer_id">
                                        <div class="modal-body p-4">
                                            <div class="mb-3">
                                                <label class="fw-bold mb-2">Offer Text</label>
                                                <textarea name="offer_text" id="edit_offer_text" class="form-control"
                                                    rows="3" required></textarea>
                                            </div>
                                            <div class="mb-3">
                                                <label class="fw-bold mb-2">Status</label>
                                                <select name="is_active" id="edit_is_active" class="form-select">
                                                    <option value="1">Active</option>
                                                    <option value="0">Inactive</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="modal-footer border-0">
                                            <button type="submit" class="btn btn-primary fw-bold px-4">Update
                                                Changes</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <div class="modal fade" id="addOfferModal" tabindex="-1">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content" style="border-radius: 15px;">
                                    <div class="modal-header">
                                        <h5 class="modal-title fw-bold">Create New Offer</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                    </div>
                                    <form method="POST">
                                        <input type="hidden" name="action" value="add">
                                        <div class="modal-body p-4">
                                            <div class="mb-3">
                                                <label class="fw-bold mb-2">Offer Text</label>
                                                <input type="text" name="offer_text" class="form-control"
                                                    placeholder="Enter banner text..." required>
                                            </div>
                                            <div class="mb-3">
                                                <label class="fw-bold mb-2">Status</label>
                                                <select name="is_active" class="form-select">
                                                    <option value="1">Active</option>
                                                    <option value="0">Inactive</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="modal-footer border-0">
                                            <button type="submit" class="btn btn-warning fw-bold px-4">Save
                                                Offer</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <div class="toast-container-header">
                            <div id="successToast"
                                class="toast toast-success-header align-items-center text-dark border-0 shadow-lg"
                                role="alert" aria-live="assertive" aria-atomic="true">
                                <div class="d-flex align-items-center">
                                    <div class="toast-body">
                                        <div class="d-flex align-items-center gap-2">
                                            <div class="bg-success text-white rounded-circle d-flex align-items-center justify-content-center me-2"
                                                style="width: 35px; height: 35px;">
                                                <i class="fa-solid fa-check"></i>
                                            </div>
                                            <strong class="text-success" style="font-size: 17px;">Success:</strong>
                                            <span style="font-size: 15px; white-space: nowrap;">
                                                <%= (successMsg !=null) ? successMsg : "" %>
                                            </span>
                                        </div>
                                    </div>
                                    <button type="button" class="btn-close ms-4 me-2" data-bs-dismiss="toast"></button>
                                </div>
                            </div>
                        </div>

                        <script>
                            function fillEditModal(id, text, status) {
                                document.getElementById('edit_offer_id').value = id;
                                document.getElementById('edit_offer_text').value = text;
                                document.getElementById('edit_is_active').value = status;
                            }

                            window.onload = function () {
            <% if (successMsg != null) { %>
                var myToast = new bootstrap.Toast(document.getElementById('successToast'), { delay: 3000 });
                                    myToast.show();
            <% } %>
        };
                        </script>
                        <script
                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>