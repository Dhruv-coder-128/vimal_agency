<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.vimal.utils.DatabaseManager" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.vimal.utils.DatabaseManager" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.vimal.utils.DatabaseManager" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.vimal.utils.DatabaseManager" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Management | Vimal Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .table td, .table th { padding: 12px 15px !important; font-size: 14px; vertical-align: middle !important; }
        .role-admin { color: #dc3545; font-weight: 700; background: #fff5f5; padding: 4px 8px; border-radius: 5px; }
        .role-user { color: #0d6efd; font-weight: 700; background: #f0f7ff; padding: 4px 8px; border-radius: 5px; }
        .status-active { color: #28a745; font-weight: 700; }
        .status-blocked { color: #dc3545; font-weight: 700; }
        .action-flex { display: flex; gap: 8px; justify-content: center; }
        .btn-action { padding: 6px 10px; border-radius: 8px; border: none; transition: 0.3s; }
        .btn-edit { background: #e3f2fd; color: #0d6efd; }
        .btn-delete { background: #ffebee; color: #f44336; }
        .toast-container-header { position: fixed; top: 25px; left: 50%; transform: translateX(-50%); z-index: 2500; width: max-content; min-width: 400px; }
        .toast-success-header { border-left: 8px solid #28a745 !important; border-radius: 12px !important; background: white !important; box-shadow: 0 10px 35px rgba(0,0,0,0.15) !important; padding: 10px 20px; }
        /* Password style */
        .pass-hide { font-family: 'Courier New', Courier, monospace; letter-spacing: 2px; font-weight: bold; }
    </style>
</head>
<body>

    <%@ include file="admin_header.jsp" %>

    <div class="admin-main p-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1 style="font-weight: 800; color: #1a242f; margin: 0; letter-spacing: -1px;">User Management</h1>
                <p style="color: #7f8c8d; margin: 0;">Manage administrative roles and customer accounts.</p>
            </div>
            <button type="button" class="btn btn-warning fw-bold px-4 py-2" data-bs-toggle="modal" data-bs-target="#addUserModal" style="border-radius: 10px;">
                + Add New User
            </button>
        </div>

        <%
            String successMsg = null;
            Connection con = DatabaseManager.getConnection();

            // 1. INSERT NEW USER LOGIC
            if(request.getMethod().equalsIgnoreCase("POST") && "add_user".equals(request.getParameter("action"))) {
                try {
                    String sql = "INSERT INTO users (username, email, password, role, status, created_at) VALUES (?, ?, ?, ?, 1, NOW())";
                    PreparedStatement ps = con.prepareStatement(sql);
                    ps.setString(1, request.getParameter("username"));
                    ps.setString(2, request.getParameter("email"));
                    ps.setString(3, request.getParameter("password"));
                    ps.setString(4, request.getParameter("role"));
                    ps.executeUpdate();
                    successMsg = "New " + request.getParameter("role").toUpperCase() + " added successfully!";
                } catch(Exception e) { out.println(e); }
            }

            // 2. UPDATE USER LOGIC (Sudharelo)
if(request.getMethod().equalsIgnoreCase("POST") && "update_user".equals(request.getParameter("action"))) {
    try {
        String sql = "UPDATE users SET username=?, email=?, password=?, role=?, status=? WHERE id=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, request.getParameter("username"));
        ps.setString(2, request.getParameter("email"));
        ps.setString(3, request.getParameter("password"));
        ps.setString(4, request.getParameter("role"));
        ps.setString(5, request.getParameter("status"));
        ps.setString(6, request.getParameter("user_id"));
        
        ps.executeUpdate();
        successMsg = "User account updated successfully!";
    } catch(Exception e) { out.println(e); }
}

            // 3. DELETE USER LOGIC
            if(request.getParameter("del_id") != null) {
                PreparedStatement ps = con.prepareStatement("DELETE FROM users WHERE id = ?");
                ps.setString(1, request.getParameter("del_id"));
                ps.executeUpdate();
                successMsg = "User account deleted successfully!";
            }
        %>

        <div class="stat-card p-0 overflow-hidden" style="background: white; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.05); border-top: 5px solid #ffc800;">
            <table class="table table-hover align-middle mb-0 text-center">
                <thead style="background: #f8f9fa;">
                    <tr>
                        <th class="py-3 px-4">ID</th>
                        <th class="text-start">Username</th>
                        <th class="text-start">Email</th>
                        <th>Password</th> <th>Role</th>
                        <th>Status</th>
                        <th>Joined On</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            ResultSet rs = con.createStatement().executeQuery("SELECT * FROM users ORDER BY id DESC");
                            
                            SimpleDateFormat dbFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                            SimpleDateFormat userFormat = new SimpleDateFormat("dd-MM-yyyy | hh:mm a");

                            while(rs.next()) {
                                String role = rs.getString("role");
                                int status = rs.getInt("status");
                                String plainPass = rs.getString("password");
                                int uId = rs.getInt("id");
                                
                                String joinedOnRaw = rs.getString("created_at"); 
                                String finalDate = "";
                                if(joinedOnRaw != null) {
                                    Date date = dbFormat.parse(joinedOnRaw);
                                    finalDate = userFormat.format(date);
                                }
                    %>
                    <tr style="border-bottom: 1px solid #f1f1f1;">
                        <td class="fw-bold">#<%= uId %></td>
                        <td class="text-start"><%= rs.getString("username") %></td>
                        <td class="text-start text-muted"><%= rs.getString("email") %></td>
                        
                        <td>
                            <div class="d-flex align-items-center justify-content-center">
                                <span id="pass_<%= uId %>" class="pass-hide me-2">••••••••</span>
                                <button type="button" class="btn btn-sm text-primary p-0" onclick="togglePass('<%= uId %>', '<%= plainPass %>')" style="background:none; border:none;">
                                    <i id="icon_<%= uId %>" class="fa-solid fa-eye"></i>
                                </button>
                            </div>
                        </td>

                        <td><span class="<%= "admin".equals(role) ? "role-admin" : "role-user" %>"><%= role.toUpperCase() %></span></td>
                        <td><span class="<%= (status == 1) ? "status-active" : "status-blocked" %>"><%= (status == 1) ? "Active" : "Blocked" %></span></td>
                        
                        <td style="font-size: 13px; color: #555; white-space: nowrap;">
                            <i class="fa-regular fa-clock me-1 text-warning"></i> <%= finalDate %>
                        </td>
                        
                        <td>
                            <div class="action-flex">
                                <button type="button" class="btn-action btn-edit" data-bs-toggle="modal" data-bs-target="#editUserModal" 
onclick="fillUserModal('<%= uId %>', '<%= rs.getString("username") %>', '<%= rs.getString("email") %>', '<%= plainPass %>', '<%= role %>', '<%= status %>')">
    <i class="fa-solid fa-user-gear"></i>
</button>
                                <a href="admin_users.jsp?del_id=<%= uId %>" class="btn-action btn-delete" onclick="return confirm('Delete this user account?')"><i class="fa-solid fa-trash"></i></a>
                            </div>
                        </td>
                    </tr>
                    <% } con.close(); } catch(Exception e) { out.println(e); } %>
                </tbody>
            </table>
        </div>
    </div>

    <div class="modal fade" id="addUserModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="border-radius: 15px;">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Add New User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="POST">
                    <input type="hidden" name="action" value="add_user">
                    <div class="modal-body p-4">
                        <div class="mb-3"><label class="fw-bold mb-1">Username</label><input type="text" name="username" class="form-control" placeholder="Enter username..." required></div>
                        <div class="mb-3"><label class="fw-bold mb-1">Email</label><input type="email" name="email" class="form-control" placeholder="email@gmail.com" required></div>
                        <div class="mb-3">
                            <label class="fw-bold mb-1">Password</label>
                            <input type="password" name="password" class="form-control" placeholder="Enter password..." required>
                        </div>
                        <div class="mb-3">
                            <label class="fw-bold mb-1">Assign Role</label>
                            <select name="role" class="form-select">
                                <option value="user">User (Customer)</option>
                                <option value="admin">Admin (Staff)</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer border-0"><button type="submit" class="btn btn-warning fw-bold px-4">Create Account</button></div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="editUserModal" tabindex="-1" style="z-index: 3000;">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius: 15px;">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Edit User Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="POST">
                <input type="hidden" name="action" value="update_user">
                <input type="hidden" name="user_id" id="edit_user_id">
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="fw-bold mb-1">Username</label>
                        <input type="text" name="username" id="edit_username" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="fw-bold mb-1">Email</label>
                        <input type="email" name="email" id="edit_email" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="fw-bold mb-1">Password</label>
                        <input type="text" name="password" id="edit_password" class="form-control" required>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="fw-bold mb-1">Role</label>
                            <select name="role" id="edit_role" class="form-select">
                                <option value="user">User</option>
                                <option value="admin">Admin</option>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="fw-bold mb-1">Status</label>
                            <select name="status" id="edit_status" class="form-select">
                                <option value="1">Active</option>
                                <option value="0">Blocked</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="submit" class="btn btn-primary fw-bold px-4">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>
    <div class="toast-container-header">
        <div id="successToast" class="toast toast-success-header align-items-center text-dark border-0 shadow-lg" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex align-items-center p-2">
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
        // Password Toggle Function
        function togglePass(id, actualPass) {
            var passSpan = document.getElementById('pass_' + id);
            var icon = document.getElementById('icon_' + id);
            
            if (passSpan.innerText === '••••••••') {
                passSpan.innerText = actualPass;
                passSpan.classList.remove('pass-hide');
                icon.classList.replace('fa-eye', 'fa-eye-slash');
            } else {
                passSpan.innerText = '••••••••';
                passSpan.classList.add('pass-hide');
                icon.classList.replace('fa-eye-slash', 'fa-eye');
            }
        }

        function fillUserModal(id, username, email, password, role, status) {
    document.getElementById('edit_user_id').value = id;
    document.getElementById('edit_username').value = username;
    document.getElementById('edit_email').value = email;
    document.getElementById('edit_password').value = password;
    document.getElementById('edit_role').value = role;
    document.getElementById('edit_status').value = status;
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