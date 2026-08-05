<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.vimal.utils.DatabaseManager" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.vimal.utils.DatabaseManager" %>

<%
    // 👉 STEP 1: USER SESSION CHECK (SECURITY)
    // Jo user login nathi, to tene feedback page na dekhavu joie.
    if (session.getAttribute("user_id") == null) {
        // Login page par redirect karyu
        response.sendRedirect("login.jsp?msg=auth_required");
        return; 
    }
%>

<!DOCTYPE html>
<html>
<head>
<title>Vimal Agency - Customer Feedback</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<link rel="stylesheet" href="main.css">

<style>
/* 🔥 CENTER TOAST MESSAGE */
.toast-message {
    position: fixed; top: -150px; left: 50%;
    transform: translateX(-50%); background: #fff;
    padding: 15px 25px; border-radius: 12px;
    box-shadow: 0 10px 40px rgba(0,0,0,0.2);
    border-left: 6px solid #4caf50; display: flex;
    align-items: center; z-index: 10001;
    min-width: 380px; transition: 0.6s cubic-bezier(0.68, -0.55, 0.265, 1.35);
}

.toast-message.active { top: 40px; }
.toast-content { display: flex; align-items: center; gap: 15px; }
.toast-icon { font-size: 28px; color: #4caf50; }
.toast-title { font-weight: 800; color: #333; display: block; font-size: 16px; }
#toast-body { font-size: 14px; color: #666; margin: 0; }
.toast-close { cursor: pointer; font-size: 22px; color: #ccc; margin-left: 20px; }

/* Existing Page Styles */
.feedback-wrapper { padding: 50px 0; background: #f4f7f6; min-height: 80vh; display: flex; justify-content: center; align-items: center; }
.feedback-card { width: 100%; max-width: 500px; border: none; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); overflow: hidden; }
.feedback-title { background: #1a242f; color: #ffc800; padding: 20px; text-align: center; font-size: 24px; font-weight: bold; }
.btn-submit { background: #ffc800; color: #1a242f; font-weight: bold; padding: 12px; border-radius: 8px; transition: 0.3s; border: none; }
.btn-submit:hover { background: #e6b800; transform: translateY(-2px); }
</style>
</head>

<body>

<%@ include file="header.jsp" %>

<div id="toast" class="toast-message">
    <div class="toast-content">
        <i class="fa-solid fa-circle-check toast-icon"></i>
        <div class="toast-text">
            <span class="toast-title">Success</span>
            <p id="toast-body">Feedback submitted successfully!</p>
        </div>
        <span class="toast-close" onclick="closeToast()">&times;</span>
    </div>
</div>

<%
/* ================= BACKEND LOGIC ================= */
String successFlag = "0";

if ("POST".equalsIgnoreCase(request.getMethod())) {
    request.setCharacterEncoding("UTF-8"); // Emoji support
    
    String name = request.getParameter("name");
    String mail = request.getParameter("mail");
    String experience = request.getParameter("experience");
    String message = request.getParameter("message");

    Connection cn = null;
    PreparedStatement st = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        // UTF-8 Connection
        cn = DatabaseManager.getConnection();
        st = cn.prepareStatement("INSERT INTO feedback (name, mail, experience, message) VALUES (?, ?, ?, ?)");

        st.setString(1, name);
        st.setString(2, mail);
        st.setInt(3, Integer.parseInt(experience));
        st.setString(4, message);

        int no = st.executeUpdate();
        if (no > 0) { successFlag = "1"; }
    }
    catch(Exception e){ out.println("<pre style='color:red'>"+e+"</pre>"); }
    finally { try { if(st!=null) st.close(); if(cn!=null) cn.close(); } catch(Exception ex){} }
}
%>

<div class="feedback-wrapper">
    <div class="card feedback-card">
        <div class="feedback-title">
            <i class="fa-solid fa-comment-dots"></i> Customer Feedback
        </div>
        <div class="card-body p-4">
            <form method="post">
                <div class="mb-3">
                    <label class="form-label fw-bold">Full Name</label>
                    <input type="text" name="name" class="form-control" value="<%= session.getAttribute("username") %>" readonly required>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-bold">Email Address</label>
                    <input type="email" name="mail" class="form-control" value="<%= session.getAttribute("user_email") %>" readonly required>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-bold">How was your experience?</label>
                    <select name="experience" class="form-select">
                        <option value="5">⭐⭐⭐⭐⭐ Excellent</option>
                        <option value="4">⭐⭐⭐⭐ Good</option>
                        <option value="3">⭐⭐⭐ Average</option>
                        <option value="2">⭐⭐ Poor</option>
                        <option value="1">⭐ Bad</option>
                    </select>
                </div>
                <div class="mb-4">
                    <label class="form-label fw-bold">Message</label>
                    <textarea name="message" class="form-control" rows="4" placeholder="Write your feedback here..." required></textarea>
                </div>
                <div class="d-grid">
                    <button type="submit" class="btn btn-submit">
                        <i class="fa-solid fa-paper-plane"></i> Submit Feedback
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function showSuccessToast() {
    const toast = document.getElementById("toast");
    toast.classList.add("active");
    setTimeout(() => { closeToast(); }, 3500);
}

function closeToast() {
    document.getElementById("toast").classList.remove("active");
    setTimeout(() => { window.location="index.jsp"; }, 600);
}

<% if("1".equals(successFlag)){ %>
    window.onload = function() {
        showSuccessToast();
    };
<% } %>
</script>

<%@ include file="footer.jsp" %>
</body>
</html>