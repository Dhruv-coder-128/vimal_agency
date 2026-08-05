<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.vimal.utils.DatabaseManager" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.vimal.utils.DatabaseManager" %>

<%
    // 👉 STEP 1: STRICT USER SESSION CHECK
    if (session.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp?msg=auth_required");
        return; 
    }
%>

<!DOCTYPE html>
<html lang="gu">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us | Vimal Agency</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    <link rel="stylesheet" href="main.css">

    <style>
        :root {
            --gold: #ffc800;
            --dark: #0f172a;
        }

        body {
            font-family: 'Outfit', sans-serif;
            background-color: #f8fafc;
        }

        /* Hero Section */
        .contact-hero {
            background: linear-gradient(135deg, var(--dark) 0%, #1e293b 100%);
            padding: 80px 0 150px 0;
            color: white;
            text-align: center;
        }

        /* Glass Cards */
        .contact-container-wrapper {
            margin-top: -100px;
            padding-bottom: 80px;
        }

        .info-card-modern {
            background: white;
            border-radius: 24px;
            padding: 30px;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            transition: 0.3s;
            height: 100%;
            border-bottom: 4px solid transparent;
        }

        .info-card-modern:hover {
            transform: translateY(-10px);
            border-bottom: 4px solid var(--gold);
        }

        .icon-box {
            width: 60px; height: 60px;
            background: rgba(255, 200, 0, 0.1);
            color: var(--gold);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            margin: 0 auto 20px auto;
            font-size: 1.5rem;
        }

        /* Form Styling */
        .contact-form-card {
            background: white;
            border-radius: 30px;
            padding: 50px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.08);
        }

        .input-group-custom {
            position: relative;
            margin-bottom: 25px;
        }

        .form-control-custom {
            border: 2px solid #f1f5f9;
            border-radius: 12px;
            padding: 15px 20px;
            font-weight: 500;
            transition: 0.3s;
            width: 100%;
        }

        .form-control-custom:focus {
            outline: none;
            border-color: var(--gold);
            background: #fffdf5;
        }

        .btn-send {
            background: var(--dark);
            color: white;
            padding: 15px 40px;
            border-radius: 12px;
            font-weight: 700;
            border: none;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: 0.4s;
            width: 100%;
        }

        .btn-send:hover {
            background: var(--gold);
            color: var(--dark);
            transform: scale(1.02);
        }

        /* Toast Styles */
        .toast-message {
            position: fixed; top: -100px; left: 50%;
            transform: translateX(-50%); background: #fff;
            padding: 20px 30px; border-radius: 20px;
            box-shadow: 0 15px 45px rgba(0,0,0,0.2);
            z-index: 9999; display: flex; align-items: center; gap: 15px;
            transition: 0.6s cubic-bezier(0.68, -0.55, 0.265, 1.35);
        }
        .toast-message.active { top: 40px; }
    </style>
</head>

<body>

<%@ include file="header.jsp" %>

<div id="toast" class="toast-message">
    <i class="fa-solid fa-circle-check text-success fs-2"></i>
    <div>
        <strong class="d-block">Message Sent!</strong>
        <small class="text-muted">We will get back to you shortly.</small>
    </div>
</div>

<%
String success=null;
if("POST".equalsIgnoreCase(request.getMethod())) {
    request.setCharacterEncoding("UTF-8");
    String name=request.getParameter("name");
    String email=request.getParameter("email");
    String cno=request.getParameter("cno");
    String message=request.getParameter("message");

    try {
        Connection cn=DatabaseManager.getConnection();
        PreparedStatement st=cn.prepareStatement("INSERT INTO contact_us(name,email,cno,message) VALUES(?,?,?,?)");
        st.setString(1,name);
        st.setString(2,email);
        st.setString(3,cno);
        st.setString(4,message);
        if(st.executeUpdate()>0){ success="1"; }
        st.close(); cn.close();
    } catch(Exception e){ out.println(e); }
}
%>

<section class="contact-hero">
    <div class="container animate__animated animate__fadeIn">
        <h1 class="display-4 fw-800">Get In Touch</h1>
        <p class="lead opacity-75">Any questions or feedback? Just drop us a message!</p>
    </div>
</section>

<div class="container contact-container-wrapper">
    <div class="row g-4 mb-5 justify-content-center">
        <div class="col-md-4 animate__animated animate__fadeInUp">
            <div class="info-card-modern">
                <div class="icon-box"><i class="fa-solid fa-phone-volume"></i></div>
                <h5 class="fw-bold">Call Us</h5>
                <p class="text-muted mb-0">+91 98258 47167</p>
                <p class="text-muted small">Mon - Sat (9am - 7pm)</p>
            </div>
        </div>
        <div class="col-md-4 animate__animated animate__fadeInUp" style="animation-delay: 0.1s;">
            <div class="info-card-modern">
                <div class="icon-box"><i class="fa-solid fa-envelope-open-text"></i></div>
                <h5 class="fw-bold">Email Us</h5>
                <p class="text-muted mb-0">vimalagency4@gmail.com</p>
                <p class="text-muted small">We reply within 24 hours</p>
            </div>
        </div>
        <div class="col-md-4 animate__animated animate__fadeInUp" style="animation-delay: 0.2s;">
            <div class="info-card-modern">
                <div class="icon-box"><i class="fa-solid fa-map-location-dot"></i></div>
                <h5 class="fw-bold">Visit Us</h5>
                <p class="text-muted mb-0">Satyam Park, Khamdhrol Road</p>
                <p class="text-muted small">Junagadh, Gujarat</p>
            </div>
        </div>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-10 animate__animated animate__fadeIn">
            <div class="contact-form-card">
                <div class="row g-5">
                    <div class="col-md-6 border-end">
                        <h3 class="fw-800 mb-4">Send us a Message</h3>
                        <form action="" method="post">
                            <div class="input-group-custom">
                                <label class="small fw-bold text-muted mb-2">FULL NAME</label>
                                <input type="text" name="name" value="<%= session.getAttribute("username") %>" class="form-control-custom" readonly>
                            </div>
                            <div class="input-group-custom">
                                <label class="small fw-bold text-muted mb-2">EMAIL ADDRESS</label>
                                <input type="email" name="email" value="<%= session.getAttribute("user_email") %>" class="form-control-custom" readonly>
                            </div>
                            <div class="input-group-custom">
                                <label class="small fw-bold text-muted mb-2">MOBILE NUMBER</label>
                                <input type="text" name="cno" placeholder="e.g. 9876543210" class="form-control-custom" required>
                            </div>
                            <div class="input-group-custom">
                                <label class="small fw-bold text-muted mb-2">YOUR MESSAGE</label>
                                <textarea name="message" class="form-control-custom" rows="4" placeholder="How can we help you?" required></textarea>
                            </div>
                            <button type="submit" class="btn-send">Send Message <i class="fa-solid fa-paper-plane ms-2"></i></button>
                        </form>
                    </div>
                    
                    <div class="col-md-6">
                        <h3 class="fw-800 mb-4">Our Location</h3>
                        <div class="rounded-4 overflow-hidden shadow-sm" style="height: 300px; background: #eee;">
                            <iframe 
                                src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3711.9612345678!2d70.45!3d21.52!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x0%3A0x0!2zMjHCsDMxJzEyLjAiTiA3MMKwMjcnMDAuMCJF!5e0!3m2!1sen!2sin!4v1234567890" 
                                width="100%" height="100%" style="border:0;" allowfullscreen="" loading="lazy">
                            </iframe>
                        </div>
                        <div class="mt-4">
                            <p class="fw-600 mb-1"><i class="fa-solid fa-id-badge text-warning me-2"></i> GSTIN:</p>
                            <p class="text-muted">24AKOPS0609MIZS</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>

<script>
function showSuccessToast() {
    const toast = document.getElementById("toast");
    toast.classList.add("active");
    setTimeout(() => { 
        toast.classList.remove("active");
        setTimeout(() => { window.location="index.jsp"; }, 600);
    }, 3000);
}

<% if("1".equals(success)){ %>
    window.onload = function() {
        showSuccessToast();
    };
<% } %>
</script>

</body>
</html>