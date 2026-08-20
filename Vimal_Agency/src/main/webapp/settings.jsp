<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.vimal.utils.DatabaseManager" %>
<%@ page import="com.vimal.dao.UserDAO" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%
    // 1. AUTHENTICATION CHECK
    Object uIdObj = session.getAttribute("user_id");
    if (uIdObj == null) {
        uIdObj = session.getAttribute("uid");
    }

    if (uIdObj == null && session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp?msg=auth_required");
        return;
    }

    int currentUserId = 0;
    if (uIdObj != null) {
        currentUserId = (uIdObj instanceof Integer) ? (Integer) uIdObj : Integer.parseInt(uIdObj.toString());
    }

    String successMsg = null;
    String errorMsg = null;
    String oneTimeRecoveryKey = null;

    UserDAO.ensureSchemaUpdated();

    // 2. HANDLE POST ACTIONS
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("change_password".equals(action)) {
            String currPass = request.getParameter("current_password");
            String newPass = request.getParameter("new_password");
            String confPass = request.getParameter("confirm_password");

            if (currPass == null || currPass.trim().isEmpty() ||
                newPass == null || newPass.trim().isEmpty() ||
                confPass == null || confPass.trim().isEmpty()) {
                errorMsg = "All password fields are required.";
            } else if (newPass.length() < 6) {
                errorMsg = "New password must be at least 6 characters long.";
            } else if (!newPass.equals(confPass)) {
                errorMsg = "New password and confirmation do not match.";
            } else {
                try {
                    boolean changed = UserDAO.changePassword(currentUserId, currPass.trim(), newPass.trim());
                    if (changed) {
                        successMsg = "Your password has been changed successfully!";
                    } else {
                        errorMsg = "Current password is incorrect. Please try again.";
                    }
                } catch (Exception e) {
                    errorMsg = "Error updating password: " + e.getMessage();
                }
            }
        } else if ("generate_key".equals(action)) {
            String currPass = request.getParameter("current_password_for_key");
            if (currPass == null || currPass.trim().isEmpty()) {
                errorMsg = "Current password is required to generate a recovery key.";
            } else {
                try {
                    oneTimeRecoveryKey = UserDAO.generateOrRegenerateRecoveryKey(currentUserId, currPass.trim());
                    if (oneTimeRecoveryKey != null) {
                        successMsg = "Recovery Secret Key generated successfully! Please save it now.";
                    } else {
                        errorMsg = "Current password verification failed. Recovery key was not generated.";
                    }
                } catch (Exception e) {
                    errorMsg = "Error generating recovery key: " + e.getMessage();
                }
            }
        } else if ("update_preferences".equals(action)) {
            int notifyOrders = "1".equals(request.getParameter("notify_orders")) ? 1 : 0;
            int notifyPromos = "1".equals(request.getParameter("notify_promos")) ? 1 : 0;
            try {
                boolean prefUpdated = UserDAO.updateUserPreferences(currentUserId, notifyOrders, notifyPromos);
                if (prefUpdated) {
                    successMsg = "Preferences saved successfully!";
                } else {
                    errorMsg = "Failed to update preferences.";
                }
            } catch (Exception e) {
                errorMsg = "Error saving preferences: " + e.getMessage();
            }
        }
    }

    // 3. FETCH CURRENT USER DATA
    String username = "";
    String email = "";
    String role = "user";
    String memberSince = "";
    String recoveryKeyHash = null;
    String recoveryKeyCreatedAt = "";
    int notifyOrders = 1;
    int notifyPromos = 1;

    try (Connection con = DatabaseManager.getConnection();
         PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE id=?")) {
        ps.setInt(1, currentUserId);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                username = rs.getString("username");
                email = rs.getString("email");
                role = rs.getString("role");
                Timestamp createdAtTs = rs.getTimestamp("created_at");
                if (createdAtTs != null) {
                    memberSince = new SimpleDateFormat("MMMM d, yyyy").format(createdAtTs);
                }
                recoveryKeyHash = rs.getString("recovery_key_hash");
                Timestamp recCreatedTs = rs.getTimestamp("recovery_key_created_at");
                if (recCreatedTs != null) {
                    recoveryKeyCreatedAt = new SimpleDateFormat("dd MMM yyyy, hh:mm a").format(recCreatedTs);
                }
                notifyOrders = rs.getInt("notify_orders");
                notifyPromos = rs.getInt("notify_promos");
            }
        }
    } catch (Exception e) {
        errorMsg = "Database error: " + e.getMessage();
    }

    String downloadDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Account Settings | Vimal Agency</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700;800&family=JetBrains+Mono:wght@600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel='stylesheet' type='text/css' href='main.css'>

    <style>
        :root {
            --primary: #0f172a;
            --accent: #ffc800;
            --bg: #f8fafc;
            --card-bg: #ffffff;
            --border: #e2e8f0;
        }

        body {
            font-family: 'Outfit', sans-serif;
            background-color: var(--bg);
            color: #1e293b;
            min-height: 100vh;
        }

        .settings-header {
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
            padding: clamp(35px, 6vw, 55px) 0 clamp(60px, 8vw, 80px);
            color: white;
            border-radius: 0 0 clamp(25px, 5vw, 40px) clamp(25px, 5vw, 40px);
            margin-bottom: clamp(-35px, -6vw, -50px);
        }

        .settings-container {
            max-width: 900px;
            margin: 0 auto;
            padding: 0 15px 60px;
        }

        .settings-card {
            background: var(--card-bg);
            border-radius: 20px;
            padding: clamp(20px, 4vw, 32px);
            margin-bottom: 25px;
            border: 1px solid var(--border);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.03);
            transition: 0.2s;
        }

        .settings-card:hover {
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.05);
        }

        .section-title {
            font-weight: 800;
            font-size: 1.25rem;
            color: var(--primary);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            border-bottom: 1.5px solid #f1f5f9;
            padding-bottom: 12px;
        }

        .section-title i {
            color: #d97706;
        }

        .form-label-custom {
            font-size: 0.85rem;
            font-weight: 700;
            color: #475569;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 6px;
        }

        .form-control-custom {
            width: 100%;
            min-height: 46px;
            padding: 11px 16px;
            border: 1.5px solid var(--border);
            border-radius: 12px;
            font-size: 0.95rem;
            background: #f8fafc;
            color: #0f172a;
            transition: 0.2s;
        }

        .form-control-custom:focus {
            outline: none;
            border-color: #d97706;
            background: #ffffff;
            box-shadow: 0 0 0 3px rgba(217, 119, 6, 0.12);
        }

        .btn-custom-primary {
            background: var(--primary);
            color: white;
            font-weight: 700;
            padding: 12px 24px;
            border-radius: 12px;
            border: none;
            transition: 0.25s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
        }

        .btn-custom-primary:hover {
            background: var(--accent);
            color: var(--primary);
            box-shadow: 0 6px 15px rgba(255, 200, 0, 0.3);
        }

        .btn-custom-warning {
            background: #f59e0b;
            color: #0f172a;
            font-weight: 700;
            padding: 10px 20px;
            border-radius: 12px;
            border: none;
            transition: 0.25s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
        }

        .btn-custom-warning:hover {
            background: #d97706;
            color: white;
        }

        /* Recovery Box */
        .recovery-status-box {
            background: #f8fafc;
            border: 1.5px solid var(--border);
            border-radius: 16px;
            padding: 20px;
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
        }

        .recovery-key-display-box {
            background: #0f172a;
            color: #ffc800;
            border-radius: 14px;
            padding: 18px;
            text-align: center;
            margin: 15px 0;
            border: 1.5px dashed #ffc800;
        }

        .recovery-key-text {
            font-family: 'JetBrains Mono', monospace;
            font-size: clamp(1.1rem, 3.5vw, 1.4rem);
            font-weight: 800;
            letter-spacing: 2px;
            word-break: break-all;
            user-select: all;
            margin: 8px 0;
        }

        .toggle-switch-card {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #f1f5f9;
        }

        .toggle-switch-card:last-child {
            border-bottom: none;
        }
    </style>
</head>
<body>

    <%@ include file="header.jsp" %>

    <div class="settings-header">
        <div class="container text-center">
            <h1 class="fw-800 animate__animated animate__fadeInDown" style="font-size: clamp(1.8rem, 4vw, 2.5rem);">Account Settings</h1>
            <p class="opacity-75 mb-0">Manage your profile, password security, and recovery credentials.</p>
        </div>
    </div>

    <div class="settings-container">

        <!-- Alerts -->
        <% if (successMsg != null) { %>
            <div class="alert alert-success alert-dismissible fade show rounded-4 shadow-sm mb-4" role="alert">
                <i class="fa-solid fa-circle-check fs-5 me-2"></i> <%= successMsg %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>

        <% if (errorMsg != null) { %>
            <div class="alert alert-danger alert-dismissible fade show rounded-4 shadow-sm mb-4" role="alert">
                <i class="fa-solid fa-triangle-exclamation fs-5 me-2"></i> <%= errorMsg %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>

        <!-- ONE-TIME RECOVERY KEY BANNER (IF JUST GENERATED) -->
        <% if (oneTimeRecoveryKey != null) { %>
            <div class="settings-card border-warning" style="border-width: 2px; background: #fffdf5;">
                <div class="d-flex align-items-center gap-2 mb-2 text-warning">
                    <i class="fa-solid fa-shield-halved fs-4 text-warning"></i>
                    <h4 class="fw-bold mb-0 text-dark">Your New Recovery Secret Key</h4>
                </div>
                <p class="text-muted small mb-3">
                    Save this key now in a safe offline location. It is required for account recovery if you forget your password. <strong>This key will not be shown again.</strong>
                </p>

                <div class="recovery-key-display-box">
                    <span class="small text-uppercase text-light" style="letter-spacing: 1px; font-weight: 600;">Secret Recovery Key</span>
                    <div class="recovery-key-text" id="activeKeyText"><%= oneTimeRecoveryKey %></div>
                    <div class="d-flex justify-content-center gap-2 flex-wrap mt-3">
                        <button type="button" class="btn btn-sm btn-outline-warning fw-bold px-3" id="btnCopySettings" onclick="copySettingsKey()">
                            <i class="fa-regular fa-copy me-1"></i> <span id="copySettingsLabel">Copy Key</span>
                        </button>
                        <button type="button" class="btn btn-sm btn-info text-white fw-bold px-3" onclick="downloadSettingsKey()">
                            <i class="fa-solid fa-download me-1"></i> Download File (.txt)
                        </button>
                    </div>
                </div>

                <div class="p-2 px-3 bg-light rounded-3 text-secondary small border">
                    <i class="fa-solid fa-lock text-success me-1"></i>
                    Your previous recovery key (if any) has been securely replaced and invalidated.
                </div>
            </div>

            <script>
                function copySettingsKey() {
                    var key = document.getElementById("activeKeyText").innerText.trim();
                    navigator.clipboard.writeText(key).then(function() {
                        document.getElementById("copySettingsLabel").innerText = "Copied!";
                        setTimeout(function() {
                            document.getElementById("copySettingsLabel").innerText = "Copy Key";
                        }, 2500);
                    });
                }

                function downloadSettingsKey() {
                    var username = "<%= username %>";
                    var key = "<%= oneTimeRecoveryKey %>";
                    var date = "<%= downloadDate %>";

                    var content = "========================================\n"
                                + "VIMAL AGENCY\n"
                                + "Account Recovery Key\n"
                                + "========================================\n\n"
                                + "Username: " + username + "\n\n"
                                + "Recovery Key:\n"
                                + key + "\n\n"
                                + "IMPORTANT:\n"
                                + "Keep this file private.\n"
                                + "Anyone who has this recovery key may be able\n"
                                + "to reset the account password.\n\n"
                                + "Generated:\n"
                                + date + "\n"
                                + "========================================\n";

                    var blob = new Blob([content], { type: "text/plain;charset=utf-8" });
                    var link = document.createElement("a");
                    link.href = URL.createObjectURL(blob);
                    link.download = "VimalAgency-Recovery-Key.txt";
                    document.body.appendChild(link);
                    link.click();
                    document.body.removeChild(link);
                }
            </script>
        <% } %>

        <!-- SECTION 1: ACCOUNT INFORMATION -->
        <div class="settings-card">
            <div class="section-title">
                <i class="fa-solid fa-user-gear"></i> Account Profile
            </div>
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label-custom">Username</label>
                    <input type="text" class="form-control-custom" value="<%= username %>" readonly style="cursor: not-allowed; opacity: 0.85;">
                </div>
                <div class="col-md-6">
                    <label class="form-label-custom">Email Address</label>
                    <input type="email" class="form-control-custom" value="<%= email %>" readonly style="cursor: not-allowed; opacity: 0.85;">
                </div>
                <div class="col-md-6">
                    <label class="form-label-custom">Member Since</label>
                    <input type="text" class="form-control-custom" value="<%= memberSince.isEmpty() ? "Active Customer" : memberSince %>" readonly style="cursor: not-allowed; opacity: 0.85;">
                </div>
                <div class="col-md-6">
                    <label class="form-label-custom">Account Status</label>
                    <div>
                        <span class="badge bg-success px-3 py-2 fs-6 rounded-pill">
                            <i class="fa-solid fa-circle-check me-1"></i> Active <%= "admin".equalsIgnoreCase(role) ? "(Administrator)" : "(Customer)" %>
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <!-- SECTION 2: SECURITY (CHANGE PASSWORD + RECOVERY KEY) -->
        <div class="settings-card">
            <div class="section-title">
                <i class="fa-solid fa-shield-halved"></i> Security & Recovery
            </div>

            <!-- Change Password Sub-section -->
            <h6 class="fw-bold text-dark mb-3"><i class="fa-solid fa-key text-warning me-2"></i>Change Account Password</h6>
            <form method="post" class="mb-4">
                <input type="hidden" name="action" value="change_password">
                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label-custom">Current Password</label>
                        <input type="password" name="current_password" class="form-control-custom" placeholder="Enter current password" required autocomplete="current-password">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label-custom">New Password</label>
                        <input type="password" name="new_password" class="form-control-custom" placeholder="Min 6 characters" minlength="6" required autocomplete="new-password">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label-custom">Confirm New Password</label>
                        <input type="password" name="confirm_password" class="form-control-custom" placeholder="Re-enter new password" minlength="6" required autocomplete="new-password">
                    </div>
                    <div class="col-12 mt-3">
                        <button type="submit" class="btn-custom-primary">
                            <i class="fa-solid fa-floppy-disk"></i> Update Password
                        </button>
                    </div>
                </div>
            </form>

            <hr class="my-4" style="border-color: #e2e8f0;">

            <!-- Recovery Secret Key Sub-section -->
            <h6 class="fw-bold text-dark mb-2"><i class="fa-solid fa-vault text-warning me-2"></i>Offline Recovery Secret Key</h6>
            <p class="text-muted small mb-3">
                Your Recovery Secret Key allows you to reset your password offline without relying on email delivery.
            </p>

            <div class="recovery-status-box">
                <div>
                    <div class="d-flex align-items-center gap-2 mb-1">
                        <span class="fw-bold">Status:</span>
                        <% if (recoveryKeyHash != null && !recoveryKeyHash.isEmpty()) { %>
                            <span class="badge bg-success-subtle text-success border border-success px-3 py-1 rounded-pill fw-bold">
                                <i class="fa-solid fa-circle-check"></i> Configured
                            </span>
                        <% } else { %>
                            <span class="badge bg-warning-subtle text-warning border border-warning px-3 py-1 rounded-pill fw-bold">
                                <i class="fa-solid fa-triangle-exclamation"></i> Not Configured
                            </span>
                        <% } %>
                    </div>
                    <% if (recoveryKeyHash != null && !recoveryKeyHash.isEmpty() && !recoveryKeyCreatedAt.isEmpty()) { %>
                        <small class="text-muted d-block">Generated on: <%= recoveryKeyCreatedAt %></small>
                    <% } %>
                </div>

                <button type="button" class="btn-custom-warning" data-bs-toggle="modal" data-bs-target="#recoveryKeyModal">
                    <i class="fa-solid fa-arrows-rotate"></i>
                    <%= (recoveryKeyHash != null && !recoveryKeyHash.isEmpty()) ? "Regenerate Key" : "Generate Key" %>
                </button>
            </div>
        </div>

        <!-- SECTION 3: PREFERENCES -->
        <div class="settings-card">
            <div class="section-title">
                <i class="fa-solid fa-sliders"></i> Communication Preferences
            </div>
            <form method="post">
                <input type="hidden" name="action" value="update_preferences">
                <div class="toggle-switch-card">
                    <div>
                        <div class="fw-bold">Order Notifications</div>
                        <small class="text-muted">Receive order status and delivery updates.</small>
                    </div>
                    <div class="form-check form-switch fs-5">
                        <input class="form-check-input" type="checkbox" name="notify_orders" value="1" <%= notifyOrders == 1 ? "checked" : "" %>>
                    </div>
                </div>

                <div class="toggle-switch-card">
                    <div>
                        <div class="fw-bold">Special Offers & Promos</div>
                        <small class="text-muted">Stay notified about festival discounts and limited offers.</small>
                    </div>
                    <div class="form-check form-switch fs-5">
                        <input class="form-check-input" type="checkbox" name="notify_promos" value="1" <%= notifyPromos == 1 ? "checked" : "" %>>
                    </div>
                </div>

                <div class="mt-3">
                    <button type="submit" class="btn-custom-primary">
                        <i class="fa-solid fa-check"></i> Save Preferences
                    </button>
                </div>
            </form>
        </div>

        <!-- SECTION 4: ACCOUNT ACTIONS -->
        <div class="settings-card">
            <div class="section-title text-danger">
                <i class="fa-solid fa-arrow-right-from-bracket text-danger"></i> Session & Sign Out
            </div>
            <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
                <div>
                    <div class="fw-bold">Sign Out of Vimal Agency</div>
                    <small class="text-muted">Securely terminate your current browsing session.</small>
                </div>
                <a href="logout.jsp" class="btn btn-outline-danger fw-bold px-4 py-2 rounded-3">
                    <i class="fa-solid fa-right-from-bracket me-1"></i> Sign Out
                </a>
            </div>
        </div>

    </div>

    <!-- MODAL: VERIFY CURRENT PASSWORD TO GENERATE/REGENERATE RECOVERY KEY -->
    <div class="modal fade" id="recoveryKeyModal" tabindex="-1" aria-labelledby="recoveryKeyModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 border-0 shadow-lg">
                <div class="modal-header bg-light rounded-top-4 border-bottom">
                    <h5 class="modal-title fw-bold" id="recoveryKeyModalLabel">
                        <i class="fa-solid fa-shield-halved text-warning me-2"></i> Security Verification
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form method="post">
                    <input type="hidden" name="action" value="generate_key">
                    <div class="modal-body p-4">
                        <p class="text-muted small mb-3">
                            Please confirm your current account password to generate a new offline Recovery Secret Key.
                        </p>
                        <div class="mb-3">
                            <label class="form-label-custom">Current Password</label>
                            <input type="password" name="current_password_for_key" class="form-control-custom" placeholder="Enter your current password" required autocomplete="current-password">
                        </div>
                        <div class="alert alert-warning p-2 small mb-0">
                            <i class="fa-solid fa-circle-exclamation me-1"></i> Generating a new key will immediately replace and invalidate any previous recovery key.
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-3 pt-0">
                        <button type="button" class="btn btn-light fw-bold rounded-3" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-warning fw-bold px-4 rounded-3 text-dark">
                            <i class="fa-solid fa-key me-1"></i> Generate & Display Key
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <%@ include file="footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
