<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%
    // 🔥 SECURITY & DYNAMIC TIME-BASED MAINTENANCE CONTROL LOGIC
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return; 
    }

    String currentSessionUser = session.getAttribute("username").toString();
    int isMaintenanceActive = 0;
    String formattedReturnTime = ""; 
    long targetEndTimeMillis = 0; 
    int floatingCartCount = 0;

    Connection cnM = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        cnM = DriverManager.getConnection("jdbc:mysql://localhost:3306/vimal_agency", "root", "");
        
        PreparedStatement psM = cnM.prepareStatement("SELECT maintenance_mode, maintenance_start, maintenance_end FROM users WHERE username = ?");
        psM.setString(1, currentSessionUser);
        ResultSet rsM = psM.executeQuery();
        if(rsM.next()) {
            int masterSwitch = rsM.getInt("maintenance_mode");
            Timestamp startTime = rsM.getTimestamp("maintenance_start");
            Timestamp endTime = rsM.getTimestamp("maintenance_end");
            
            java.util.Date now = new java.util.Date();
            
            if(masterSwitch == 1) {
                if(startTime != null && endTime != null) {
                    if(now.after(startTime) && now.before(endTime)) {
                        isMaintenanceActive = 1; 
                        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy 'at' hh:mm a");
                        formattedReturnTime = sdf.format(endTime);
                        targetEndTimeMillis = endTime.getTime();
                    } 
                    else if(now.after(endTime)) {
                        isMaintenanceActive = 0; 
                        PreparedStatement psUpdate = cnM.prepareStatement("UPDATE users SET maintenance_mode = 0, maintenance_start = NULL, maintenance_end = NULL");
                        psUpdate.executeUpdate();
                        psUpdate.close();
                    }
                } else {
                    isMaintenanceActive = 1; 
                }
            }
        }
        rsM.close();
        psM.close();
    } catch(Exception e) {
        isMaintenanceActive = 0; 
    } finally {
        if(cnM != null) try { cnM.close(); } catch(Exception e){}
    }

    // 🎛️ SECRET ADMIN BYPASS LOGIC
    if("1".equals(request.getParameter("admin_bypass"))) {
        session.setAttribute("bypass_maintenance", "true");
        response.sendRedirect("index.jsp");
        return;
    }
    if("true".equals(session.getAttribute("bypass_maintenance"))) {
        isMaintenanceActive = 0; 
    }

    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); 
    response.setHeader("Pragma", "no-cache"); 
    response.setDateHeader("Expires", 0); 
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vimal Agency | Premium Snacks</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    
    <!-- Lottie Player Script -->
    <script src="https://unpkg.com/@lottiefiles/lottie-player@latest/dist/lottie-player.js"></script>

    <!-- Google Fonts for Brand / Features section -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Paytone+One&family=Zilla+Slab:wght@700;800&family=Inter:wght@400;500&display=swap" rel="stylesheet">
    
    <script src="https://unpkg.com/scrollreveal"></script>

    <style>
        :root {
            --primary-gold: #ffc800;
            --deep-navy: #0f172a;
            --soft-white: #f8fafc;
            --premium-orange: #ff6b6b;
            
            --maint-dark-bg: #0b111e;
            --maint-card-bg: #111827;
            --maint-orange: #f97316;
            --maint-text-muted: #9ca3af;
        }

        body { 
            font-family: 'Outfit', sans-serif; 
            background-color: var(--soft-white);
            color: var(--deep-navy);
            overflow-x: hidden;
        }

        .maint-body {
            background-color: var(--maint-dark-bg) !important;
            color: #ffffff !important;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 30px 0;
        }
        .maint-container {
            max-width: 1050px;
            width: 100%;
            background: var(--maint-card-bg);
            border-radius: 24px;
            overflow: hidden;
            border: 1px solid #1f2937;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
            position: relative;
        }
        
        /* 🐅 100% Freeze-Free Smooth CSS Moving Hazard Stripes */
        .vimal-agency-prova-fixed-stripe {
            height: 16px !important;
            width: 100% !important;
            display: block !important;
            overflow: hidden !important;
            position: relative !important;
            border-top-left-radius: 22px !important;
            border-top-right-radius: 22px !important;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.5) !important;
            background: #000000;
        }

        .vimal-agency-prova-fixed-stripe::before {
            content: "";
            position: absolute;
            top: 0;
            left: -100%;
            width: 300%;
            height: 100%;
            background: repeating-linear-gradient(
                -45deg,
                #f97316,
                #f97316 20px,
                #000000 20px,
                #000000 40px
            );
            animation: slideStripeCSS 3s linear infinite;
        }

        @keyframes slideStripeCSS {
            0% {
                transform: translateX(0);
            }
            100% {
                transform: translateX(56.57px);
            }
        }
        .maint-badge-top {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(249, 115, 22, 0.1);
            color: var(--maint-orange);
            padding: 8px 16px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
        }
        .maint-heading-main {
            font-size: 2.8rem;
            font-weight: 800;
            line-height: 1.2;
            letter-spacing: -1px;
        }
        .maint-highlight {
            color: var(--maint-orange);
        }
        .maint-desc {
            color: var(--maint-text-muted);
            font-size: 0.95rem;
            line-height: 1.6;
        }
        .maint-chip {
            background: #1f2937;
            color: #e5e7eb;
            padding: 6px 14px;
            border-radius: 50px;
            font-size: 13px;
            font-weight: 500;
            border: 1px solid #374151;
        }
        .btn-maint-action {
            background: var(--maint-orange);
            color: #111827;
            padding: 12px 28px;
            border-radius: 12px;
            font-weight: 700;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            transition: 0.3s;
            border: none;
        }
        .btn-maint-action:hover {
            background: #ea580c;
            color: #111827;
            box-shadow: 0 10px 25px rgba(249, 115, 22, 0.3);
            transform: translateY(-2px);
        }
        .maint-visual-box {
            background: radial-gradient(circle at center, rgba(249, 115, 22, 0.08) 0%, transparent 70%);
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 400px;
            border-left: 1px solid #1f2937;
        }
        .crane-anim-wrap {
            position: relative;
            width: 200px;
            height: 150px;
            border-bottom: 4px solid #374151;
        }
        .crane-pillar {
            position: absolute;
            bottom: 0;
            left: 40px;
            width: 16px;
            height: 100px;
            background: repeating-linear-gradient(0deg, var(--maint-orange), var(--maint-orange) 10px, #1f2937 10px, #1f2937 20px);
        }
        .crane-arm {
            position: absolute;
            top: 50px;
            left: 40px;
            width: 120px;
            height: 6px;
            background: var(--maint-orange);
            transform-origin: left center;
            animation: craneMove 3s ease-in-out infinite alternate; 
        }

        @keyframes craneMove {
            0% { transform: rotate(0deg) scaleX(0.85); }
            50% { transform: rotate(-7deg) scaleX(1.1); }
            100% { transform: rotate(4deg) scaleX(0.95); }
        }
        .crane-weight {
            position: absolute;
            right: 10px;
            top: 6px;
            width: 2px;
            height: 40px;
            background: #4b5563;
        }
        .crane-block {
            position: absolute;
            right: -6px;
            bottom: -12px;
            width: 14px;
            height: 14px;
            background: #1f2937;
            border: 2px solid #4b5563;
        }
        .crane-sun {
            position: absolute;
            top: 15px;
            right: 25px;
            width: 24px;
            height: 24px;
            background: #7c2d12;
            border-radius: 50%;
        }
        .maint-footer {
            border-top: 1px solid #1f2937;
            padding: 15px 40px;
            font-size: 13px;
            color: #6b7280;
        }
        .maint-social-icons a {
            color: #9ca3af;
            font-size: 15px;
            transition: 0.2s;
        }
        .maint-social-icons a:hover {
            color: var(--maint-orange);
        }

        /* Secret / Hidden Admin Bypass Link Styling */
        .secret-bypass-link {
            color: #374151 !important;
            text-decoration: none;
            transition: 0.2s;
        }
        .secret-bypass-link:hover {
            color: #6b7280 !important;
            text-decoration: underline;
        }

        /* Live Site Styles */
        .promo-ticker {
            background: var(--deep-navy); color: white; padding: 12px 0; font-size: 0.9rem; letter-spacing: 1px; overflow: hidden;
        }
        .ticker-wrap { display: flex; animation: ticker 25s linear infinite; }
        @keyframes ticker { 0% { transform: translateX(100%); } 100% { transform: translateX(-100%); } }

        .hero-v2 {
            background: radial-gradient(circle at top right, rgba(255, 200, 0, 0.15), transparent),
                        radial-gradient(circle at bottom left, rgba(15, 23, 42, 0.05), transparent);
            padding: 40px 0; position: relative;
        }

        .hero-title { font-weight: 800; font-size: 4rem; line-height: 1.1; }
        .hero-highlight { color: var(--primary-gold); position: relative; }

        .img-float { animation: floating 3s ease-in-out infinite; }
        @keyframes floating { 0%, 100% { transform: translateY(0); } 50% { transform: translateY(-20px); } }

        .trust-card { transition: 0.3s; padding: 25px; border-radius: 20px; border: 1px solid transparent; }
        .trust-card:hover { background: #fff; box-shadow: 0 15px 35px rgba(0,0,0,0.05); border-color: var(--primary-gold); transform: translateY(-5px); }
        .trust-icon { font-size: 2.5rem; color: var(--primary-gold); margin-bottom: 15px; }

        .cat-chip {
            background: white; border: 1px solid #e2e8f0; padding: 12px 25px; border-radius: 50px; text-decoration: none; color: var(--deep-navy); font-weight: 600; transition: 0.3s; display: inline-block;
        }
        .cat-chip:hover { background: var(--primary-gold); border-color: var(--primary-gold); transform: translateY(-3px); }

        .glass-card {
            background: white; border-radius: 24px; padding: 25px; box-shadow: 0 20px 40px rgba(0,0,0,0.04); transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275); height: 100%; text-decoration: none; color: inherit; display: block; position: relative;
        }
        .glass-card:hover { transform: translateY(-15px); box-shadow: 0 30px 60px rgba(255, 200, 0, 0.15); }

        .card-img-wrap {
            background: #f1f5f9; border-radius: 18px; padding: 20px; margin-bottom: 20px; display: flex; justify-content: center; height: 220px; overflow: hidden;
        }
        .card-img-wrap img { max-height: 100%; object-fit: contain; transition: 0.5s; }
        .glass-card:hover .card-img-wrap img { transform: scale(1.1); }

        .promo-banner {
            background: linear-gradient(90deg, #0f172a 0%, #1e293b 100%); border-radius: 30px; padding: 60px; position: relative; overflow: hidden; color: white;
        }
        .banner-circle { position: absolute; background: var(--primary-gold); border-radius: 50%; opacity: 0.1; z-index: 0; }

        .btn-premium {
            background: var(--deep-navy); color: white; padding: 14px 40px; border-radius: 12px; font-weight: 600; transition: 0.3s; border: none;
        }
        .btn-premium:hover { background: var(--primary-gold); color: var(--deep-navy); box-shadow: 0 10px 25px rgba(255, 200, 0, 0.4); }

        .section-header { font-weight: 800; font-size: 2.5rem; margin-bottom: 40px; }

        /* Additional Integrated Brand Bar & Sliding Feature Styles */
        .hero-banner {
            width: 100%;
            max-height: 450px;
            overflow: hidden;
        }
        .hero-banner img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }
        .brand-section {
            background-color: #f4ea00;
            padding: 15px 0;
            overflow: hidden;
            white-space: nowrap;
            position: relative;
        }
        .brand-track {
            display: inline-flex;
            align-items: center;
            gap: 50px;
            animation: scrollLogos 20s linear infinite;
        }
        .brand-section:hover .brand-track {
            animation-play-state: paused;
        }
        .brand-item-img {
            height: 45px;
            width: auto;
            object-fit: contain;
            cursor: pointer;
            transition: transform 0.2s ease-in-out;
        }
        .brand-item-img:hover {
            transform: scale(1.15);
        }
        @keyframes scrollLogos {
            0% { transform: translateX(0); }
            100% { transform: translateX(-50%); }
        }

        .promo-banner-wrapper {
            padding: 60px 20px 40px 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            background-color: #ffffff;
        }
        .banner-container {
            position: relative;
            width: 100%;
            max-width: 1100px;
            margin: 0 auto;
        }
         .banner-card {
            background-color: #01153e;
            border-radius: 36px;
            padding: 60px 70px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            width: 90%;
            min-height: 450px;
            position: relative;
        }
        .banner-content {
            width: 75%;
            color: #ffffff;
        }
        .banner-description {
            font-size: 1.15rem;
            line-height: 1.6;
            color: #e0e6ed;
            font-weight: 400;
            margin-bottom: 30px;
        }
        .banner-divider {
            border: 0;
            height: 1px;
            background-color: rgba(255, 255, 255, 0.15);
            margin-bottom: 30px;
            width: 100%;
        }
        .banner-title {
            font-family: 'Paytone One', 'Arial Black', sans-serif;
            font-size: 2.2rem;
            font-weight: 400;
            color: #ffd000;
            line-height: 1.2;
            letter-spacing: 0.3px;
        }
        .banner-image-wrapper {
            position: absolute;
            right: 5%;
            top: 52%;
            transform: translateY(-50%);
            width: 340px;
            z-index: 2;
            pointer-events: none;
        }
        .banner-image-wrapper img {
            width: 100%;
            height: auto;
            display: block;
            filter: drop-shadow(0px 15px 25px rgba(0, 0, 0, 0.25));
        }

        .feature-strip {
            width: 100%;
            background-color: #ffffff;
            padding: 30px 0 50px 0;
            overflow: hidden;
            white-space: nowrap;
            font-family: 'Zilla Slab', Georgia, serif;
        }
        .feature-track {
            display: flex;
            align-items: center;
            width: max-content;
            animation: slideText 25s linear infinite;
        }
        .feature-strip:hover .feature-track {
            animation-play-state: paused;
        }
        .feature-item {
            display: inline-flex;
            align-items: center;
            margin-right: 70px;
        }
        .icon-circle {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 20px;
            flex-shrink: 0;
        }
        .bg-yellow { background-color: #fff2c6; }
        .bg-peach  { background-color: #ffe8d6; }
        .icon-circle lottie-player {
            width: 55px;
            height: 55px;
        }
        .feature-text {
            font-size: 22px;
            line-height: 1.1;
            color: #1a1a1a;
            font-weight: 800;
            letter-spacing: -0.3px;
        }
        @keyframes slideText {
            0% { transform: translateX(0); }
            100% { transform: translateX(-50%); }
        }

        @media (max-width: 992px) {
            .banner-card {
                width: 100%;
                padding: 40px 30px;
            }
            .banner-content {
                width: 100%;
            }
            .banner-image-wrapper {
                position: relative;
                right: auto;
                top: auto;
                transform: none;
                width: 300px;
                margin: -40px auto 0 auto;
            }
            .banner-container {
                display: flex;
                flex-direction: column;
                align-items: center;
            }
        }
    </style>
</head>
<body class="<%= (isMaintenanceActive == 1) ? "maint-body" : "" %>">

    <% if(isMaintenanceActive == 1) { %>
        <div class="container maint-container animate__animated animate__fadeIn p-0">
            <div class="vimal-agency-prova-fixed-stripe" id="movingRibbonStripe"></div>
            
            <div class="row g-0 align-items-center">
                <div class="col-lg-7 p-4 p-md-5">
                    <div class="maint-badge-top mb-3">
                        <i class="fa-solid fa-triangle-exclamation"></i> Site Under Construction
                    </div>
                    
                    <h1 class="maint-heading-main mb-3">
                        We're <span class="maint-highlight">building</span> your next great experience.
                    </h1>
                    
                    <p class="maint-desc mb-3">
                        Hello <b><%= currentSessionUser %></b>, Vimal Agency portal is undergoing system optimization.
                    </p>

                    <div class="mb-3">
                        <div class="d-flex justify-content-between text-muted small fw-bold mb-1" style="font-size: 12px;">
                            <span>System Upgrade Progress</span>
                            <span class="text-warning">78% Completed</span>
                        </div>
                        <div class="progress" style="height: 8px; background: #1f2937; border-radius: 10px;">
                            <div class="progress-bar bg-warning progress-bar-striped progress-bar-animated" style="width: 78%; border-radius: 10px;"></div>
                        </div>
                    </div>
                    
                    <% if(!formattedReturnTime.isEmpty()) { %>
                        <div class="alert border-0 p-3 mb-3 d-flex align-items-center gap-3" style="background: rgba(249, 115, 22, 0.08); border-radius: 12px;">
                            <i class="fa-solid fa-clock text-warning fs-4"></i>
                            <div>
                                <small class="d-block text-muted text-uppercase fw-bold" style="font-size: 11px;">Live Reopening Countdown</small>
                                <span class="fw-bold text-white fs-6" id="countdownTimer">Calculating time...</span>
                            </div>
                        </div>
                    <% } %>

                    <div class="mb-3">
                        <form onsubmit="event.preventDefault(); alert('Thank you! We will notify you via email when live.');" class="input-group">
                            <input type="email" class="form-control bg-dark text-white border-secondary" placeholder="Enter your email address..." required style="border-radius: 10px 0 0 10px; font-size: 14px;">
                            <button class="btn btn-warning fw-bold text-dark px-3" type="submit" style="border-radius: 0 10px 10px 0; font-size: 13px;">Notify Me!</button>
                        </form>
                    </div>

                    <div class="d-flex flex-wrap gap-2 mb-4">
                        <span class="maint-chip">Fast • Secure</span>
                        <span class="maint-chip">B2B Portal</span>
                        <span class="maint-chip">Launching Soon</span>
                    </div>
                    
                    <div>
                        <a href="logout.jsp" class="btn-maint-action">
                            <i class="fa-solid fa-right-from-bracket"></i> Logout Portal
                        </a>
                    </div>
                </div>
                
                <div class="col-lg-5 maint-visual-box d-none d-lg-flex">
                    <div class="crane-anim-wrap">
                        <div class="crane-sun"></div>
                        <div class="crane-pillar"></div>
                        <div class="crane-arm">
                            <div class="crane-weight">
                                <div class="crane-block"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- 🎛️ SECRET ADMIN BYPASS PLACED DISCREETLY AT THE FOOTER -->
            <div class="maint-footer d-flex justify-content-between align-items-center">
                <div>
                    © 2026 Vimal Agency. All rights reserved. 
                    <span class="ms-2">|</span> 
                    <a href="index.jsp?admin_bypass=1" class="secret-bypass-link ms-2" title="Admin Preview">Admin Access</a>
                </div>
                <div class="maint-social-icons d-flex gap-3">
                    <a href="#"><i class="fa-brands fa-twitter"></i></a>
                    <a href="#"><i class="fa-brands fa-linkedin-in"></i></a>
                    <a href="#"><i class="fa-brands fa-github"></i></a>
                </div>
            </div>
        </div>
    <% } else { %>
        <%@ include file="header.jsp" %>

        <%
            boolean isUserLoggedIn = (session.getAttribute("user_id") != null);
            double homeAvailCredit = 0.0;
            double homeUsedCredit = 0.0;
            double homeCreditLimit = 0.0;

            if (isUserLoggedIn) {
                int homeUserId = (Integer) session.getAttribute("user_id");
                Connection conHomeCredit = null;
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conHomeCredit = DriverManager.getConnection("jdbc:mysql://localhost:3306/vimal_agency?useUnicode=yes&characterEncoding=UTF-8", "root", "");
                    PreparedStatement psHomeCredit = conHomeCredit.prepareStatement("SELECT credit_limit, used_credit FROM users WHERE id = ?");
                    psHomeCredit.setInt(1, homeUserId);
                    ResultSet rsHomeCredit = psHomeCredit.executeQuery();
                    if (rsHomeCredit.next()) {
                        homeCreditLimit = rsHomeCredit.getDouble("credit_limit");
                        homeUsedCredit = rsHomeCredit.getDouble("used_credit");
                        homeAvailCredit = homeCreditLimit - homeUsedCredit;
                    }
                    rsHomeCredit.close();
                    psHomeCredit.close();
                } catch(Exception e) {
                    e.printStackTrace();
                } finally {
                    if (conHomeCredit != null) try { conHomeCredit.close(); } catch(Exception ex){}
                }
            }
        %>

        <% if (isUserLoggedIn) { %>
        <div class="container my-4">
            <div class="p-3 p-md-4 rounded-4 shadow-sm text-white" style="background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%); border-left: 6px solid #ffc800;">
                <div class="d-flex align-items-center justify-content-between flex-wrap gap-3">
                    
                    <div class="d-flex align-items-center gap-3">
                        <div class="bg-warning text-dark rounded-circle d-flex align-items-center justify-content-center flex-shrink-0" style="width: 50px; height: 50px; font-size: 20px;">
                            <i class="fa-solid fa-wallet"></i>
                        </div>
                        <div>
                            <div class="text-warning fw-bold text-uppercase small" style="letter-spacing: 0.5px; font-size: 11px;">
                                B2B Credit Wallet Balance
                            </div>
                            <h3 class="mb-0 fw-extrabold text-white" style="font-size: 1.5rem;">
                                <span class="inr-format" data-val="<%= homeAvailCredit %>">₹ <%= homeAvailCredit %></span>
                            </h3>
                        </div>
                    </div>

                    <div class="d-flex align-items-center gap-3 flex-wrap">
                        <% if (homeUsedCredit < 0) { %>
                            <span class="badge bg-success text-white px-3 py-2 rounded-pill fw-bold" style="font-size: 12px;">
                                <i class="fa-solid fa-circle-plus me-1"></i> Advance: <span class="inr-format" data-val="<%= Math.abs(homeUsedCredit) %>">₹ <%= Math.abs(homeUsedCredit) %></span>
                            </span>
                        <% } else if (homeUsedCredit > 0) { %>
                            <span class="badge bg-danger text-white px-3 py-2 rounded-pill fw-bold" style="font-size: 12px;">
                                <i class="fa-solid fa-hand-holding-dollar me-1"></i> Outstanding: <span class="inr-format" data-val="<%= homeUsedCredit %>">₹ <%= homeUsedCredit %></span>
                            </span>
                        <% } else { %>
                            <span class="badge bg-secondary text-white px-3 py-2 rounded-pill fw-bold" style="font-size: 12px;">
                                <i class="fa-solid fa-check me-1"></i> Zero Dues
                            </span>
                        <% } %>

                        <a href="user_credit.jsp" class="btn btn-warning fw-bold rounded-3 px-3 py-2" style="background:#ffc800; border:none; color:#0f172a; font-size: 13px;">
                            Manage Wallet <i class="fa-solid fa-arrow-right ms-1"></i>
                        </a>
                    </div>

                </div>
            </div>
        </div>
        <% } %>

        <%
            Connection conFloat = null;
            PreparedStatement psFloat = null;
            ResultSet rsFloat = null;
            try {
                if (cur_u_id != null) {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conFloat = DriverManager.getConnection("jdbc:mysql://localhost:3306/vimal_agency", "root", "");
                    
                    psFloat = conFloat.prepareStatement("SELECT SUM(qty) FROM cart WHERE user_id = ?");
                    psFloat.setInt(1, cur_u_id);
                    rsFloat = psFloat.executeQuery();
                    
                    if (rsFloat.next()) {
                        floatingCartCount = rsFloat.getInt(1);
                    }
                }
            } catch (Exception e) {
            } finally {
                if (rsFloat != null) try { rsFloat.close(); } catch (Exception e){}
                if (psFloat != null) try { psFloat.close(); } catch (Exception e){}
                if (conFloat != null) try { conFloat.close(); } catch (Exception e){}
            }
        %>

        <div class="greeting-bar text-center text-muted">
            <span id="dynamic-greeting">Hello</span>, <%= currentSessionUser %> 👋 | Welcome to Vimal Agency.
        </div>

        <%-- 
    <div class="promo-ticker d-flex align-items-center">
        <!-- ફિક્સ્ડ અનાઉન્સમેન્ટ ટેક્સ્ટ (આ સ્ક્રોલ નહીં થાય) -->
        <div class="fixed-announcement px-3 text-warning fw-bold border-end border-secondary flex-shrink-0" style="z-index: 2; background: var(--deep-navy);">
            <i class="fa-solid fa-bullhorn me-2"></i>ANNOUNCEMENT:
        </div>

        <!-- સ્ક્રોલિંગ ટિકર વ્રેપર -->
        <div class="ticker-wrap overflow-hidden w-100">
            <div class="ticker-inner d-flex">
                <%
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection cn=DriverManager.getConnection("jdbc:mysql://localhost:3306/vimal_agency","root","");
                        ResultSet rs=cn.createStatement().executeQuery("SELECT offer_text FROM offers WHERE is_active=1");
                        while(rs.next()){
                %>
                    <span class="mx-5 fw-600 text-nowrap"><i class="fa-solid fa-star text-warning me-2"></i><%= rs.getString("offer_text") %></span>
                <% } cn.close(); } catch(Exception e) { %>
                    <span class="mx-5 fw-600 text-nowrap">Fresh Stock Available! • Fast Delivery in Junagadh • Balaji Premium Quality</span>
                <% } %>
            </div>
        </div>
    </div>
--%>
        
        <section class="hero-v2">
            <div class="container">
                <div class="row align-items-center g-5">
                    <div class="col-lg-6 hero-text-box">
                        <h1 class="hero-title mb-4">
                            Premium Taste <br> 
                            <span class="hero-highlight">Vimal Agency</span>
                        </h1>
                        <p class="text-muted fs-5 mb-5" style="max-width: 500px;">
                            Authentic snacks from Junagadh. Quality is our tradition since 1987. 
                            Get the freshest Balaji Wafers delivered directly to your doorstep.
                        </p>
                        <div class="d-flex align-items-center gap-4">
                            <a href="products.jsp" class="btn-premium text-decoration-none">Shop Collection</a>
                            <div class="d-flex align-items-center gap-2">
                                <span class="text-success fs-4 animate__animated animate__pulse animate__infinite">●</span>
                                <small class="fw-bold text-muted">JUNAGADH'S #1 DISTRIBUTOR</small>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-6 text-center">
                        <img src="./Product/home_page_photo.png" class="img-fluid img-float" alt="Hero">
                    </div>
                </div>
            </div>
        </section>

        <!-- 1. Hero Banner Image -->
        <!-- <div class="hero-banner">
            <img src="banner.jpg" alt="Hero Banner">-->
            <br> 
        </div>

        <!-- 2. Yellow Brand Bar (Brand Logos Loop) -->
        <div class="brand-section">
            <div class="brand-track">
                <!-- Original Brand Logos -->
                <img src="./Balaji Brand Photos/image_9.avif" alt="Chataka Pataka" class="brand-item-img">
                <img src="./Balaji Brand Photos/image_10.avif" alt="Gippi" class="brand-item-img">
                <img src="./Balaji Brand Photos/image_11.avif" alt="Two Slices" class="brand-item-img">
                <img src="./Balaji Brand Photos/image_12.avif" alt="Dum Bar" class="brand-item-img">
                <img src="./Balaji Brand Photos/image_13.avif" alt="Katak Batak" class="brand-item-img">
                <img src="./Balaji Brand Photos/image_14.avif" alt="Olee" class="brand-item-img">
                <img src="./Balaji Brand Photos/image_15.avif" alt="Numyums" class="brand-item-img">
                <img src="./Balaji Brand Photos/image_16.avif" alt="Snackem" class="brand-item-img">
                <img src="./Balaji Brand Photos/image_17.avif" alt="Amaize" class="brand-item-img">
                <img src="./Balaji Brand Photos/image_18.avif" alt="Rumbles" class="brand-item-img">
                <img src="./Balaji Brand Photos/image_19.avif" alt="Crunchex" class="brand-item-img">
                <img src="./Balaji Brand Photos/image_20.avif" alt="Crunchem" class="brand-item-img">

                <!-- Duplicate Logos for Seamless Loop -->
                <img src="./Balaji Brand Photos/image_9.avif" alt="Chataka Pataka" class="brand-item-img">
                <img src="./Balaji Brand Photos/image_10.avif" alt="Gippi" class="brand-item-img">
                <img src="./Balaji Brand Photos/image_11.avif" alt="Two Slices" class="brand-item-img">
                <img src="./Balaji Brand Photos/image_12.avif" alt="Dum Bar" class="brand-item-img">
                <img src="./Balaji Brand Photos/image_13.avif" alt="Katak Batak" class="brand-item-img">
                <img src="./Balaji Brand Photos/image_14.avif" alt="Olee" class="brand-item-img">
                <img src="./Balaji Brand Photos/image_15.avif" alt="Numyums" class="brand-item-img">
                <img src="./Balaji Brand Photos/image_16.avif" alt="Snackem" class="brand-item-img">
                <img src="./Balaji Brand Photos/image_17.avif" alt="Amaize" class="brand-item-img">
                <img src="./Balaji Brand Photos/image_18.avif" alt="Rumbles" class="brand-item-img">
                <img src="./Balaji Brand Photos/image_19.avif" alt="Crunchex" class="brand-item-img">
                <img src="./Balaji Brand Photos/image_20.avif" alt="Crunchem" class="brand-item-img">
            </div>
        </div>

        
        <!-- 3. Promo Banner Section (AMaize Banner) -->
         <br>
         <br>
        <div class="promo-banner-wrapper">
            <div class="banner-container">
                <div class="banner-card">
                    <div class="banner-content">
                        <p class="banner-description">
                            With 16 precision touchpoints, our machines handle it all. No human hands, just seamless automation. From washing to packaging, every step is crafted efficiently to ensure each bag of Balaji Wafers is as perfect as the last.
                        </p>
                        
                        <hr class="banner-divider">
                        
                        <h2 class="banner-title">
                            No shortcuts - just cutting-edge technology at work!
                        </h2>
                    </div>
                </div>

                <!-- Floating Product Image -->
                <div class="banner-image-wrapper">
                    <img src="./Balaji Brand Photos/nachos.webp" alt="Balaji AMaize Cheese Chilli">
                </div>
            </div>
        </div>

        <!-- 4. Sliding Feature Strip -->
         <br>
         <br>
        <div class="feature-strip">
            <div class="feature-track">

                <div class="feature-item">
                    <div class="icon-circle bg-yellow">
                        <lottie-player src="https://cdn.shopify.com/s/files/1/0917/0347/6515/files/Bold_Seasonings.json?v=1749542772" background="transparent" loop autoplay></lottie-player>
                    </div>
                    <div class="feature-text">Bold<br />seasonings</div>
                </div>

                <div class="feature-item">
                    <div class="icon-circle bg-yellow">
                        <lottie-player src="https://cdn.shopify.com/s/files/1/0917/0347/6515/files/Innovative_Range.json?v=1749542845" background="transparent" loop autoplay></lottie-player>
                    </div>
                    <div class="feature-text">Innovative<br />range</div>
                </div>

                <div class="feature-item">
                    <div class="icon-circle bg-yellow">
                        <lottie-player src="https://cdn.shopify.com/s/files/1/0917/0347/6515/files/Strong_Crunch_2_ed086842-fa4a-4731-aaeb-f11705078716.json?v=1749542863" background="transparent" loop autoplay></lottie-player>
                    </div>
                    <div class="feature-text">Strong<br />crunch</div>
                </div>

                <div class="feature-item">
                    <div class="icon-circle bg-peach">
                        <lottie-player src="https://cdn.shopify.com/s/files/1/0917/0347/6515/files/Value_Packed.json?v=1749542892" background="transparent" loop autoplay></lottie-player>
                    </div>
                    <div class="feature-text">Value<br />packed</div>
                </div>

                <div class="feature-item">
                    <div class="icon-circle bg-peach">
                        <lottie-player src="https://cdn.shopify.com/s/files/1/0917/0347/6515/files/Uncompromising_Quality.json?v=1749542934" background="transparent" loop autoplay></lottie-player>
                    </div>
                    <div class="feature-text">Uncompromising<br />quality</div>
                </div>

                <div class="feature-item">
                    <div class="icon-circle bg-yellow">
                        <lottie-player src="https://cdn.shopify.com/s/files/1/0917/0347/6515/files/Fully_Automated_Factories_2.json?v=1749542970" background="transparent" loop autoplay></lottie-player>
                    </div>
                    <div class="feature-text">Fully automated<br />factories</div>
                </div>

                <!-- Duplicates -->
                <div class="feature-item">
                    <div class="icon-circle bg-yellow">
                        <lottie-player src="https://cdn.shopify.com/s/files/1/0917/0347/6515/files/Bold_Seasonings.json?v=1749542772" background="transparent" loop autoplay></lottie-player>
                    </div>
                    <div class="feature-text">Bold<br />seasonings</div>
                </div>

                <div class="feature-item">
                    <div class="icon-circle bg-yellow">
                        <lottie-player src="https://cdn.shopify.com/s/files/1/0917/0347/6515/files/Innovative_Range.json?v=1749542845" background="transparent" loop autoplay></lottie-player>
                    </div>
                    <div class="feature-text">Innovative<br />range</div>
                </div>

                <div class="feature-item">
                    <div class="icon-circle bg-yellow">
                        <lottie-player src="https://cdn.shopify.com/s/files/1/0917/0347/6515/files/Strong_Crunch_2_ed086842-fa4a-4731-aaeb-f11705078716.json?v=1749542863" background="transparent" loop autoplay></lottie-player>
                    </div>
                    <div class="feature-text">Strong<br />crunch</div>
                </div>

                <div class="feature-item">
                    <div class="icon-circle bg-peach">
                        <lottie-player src="https://cdn.shopify.com/s/files/1/0917/0347/6515/files/Value_Packed.json?v=1749542892" background="transparent" loop autoplay></lottie-player>
                    </div>
                    <div class="feature-text">Value<br />packed</div>
                </div>

                <div class="feature-item">
                    <div class="icon-circle bg-peach">
                        <lottie-player src="https://cdn.shopify.com/s/files/1/0917/0347/6515/files/Uncompromising_Quality.json?v=1749542934" background="transparent" loop autoplay></lottie-player>
                    </div>
                    <div class="feature-text">Uncompromising<br />quality</div>
                </div>

                <div class="feature-item">
                    <div class="icon-circle bg-yellow">
                        <lottie-player src="https://cdn.shopify.com/s/files/1/0917/0347/6515/files/Fully_Automated_Factories_2.json?v=1749542970" background="transparent" loop autoplay></lottie-player>
                    </div>
                    <div class="feature-text">Fully automated<br />factories</div>
                </div>

            </div>
        </div>

        <!-- <div class="container py-5">
            <div class="row text-center g-4">
                <div class="col-md-3 trust-item"><div class="trust-card"><i class="fa-solid fa-truck-fast trust-icon"></i><h6 class="fw-bold">Fast Delivery</h6><p class="text-muted small mb-0">Within 24 Hours</p></div></div>
                <div class="col-md-3 trust-item"><div class="trust-card"><i class="fa-solid fa-shield-halved trust-icon"></i><h6 class="fw-bold">100% Authentic</h6><p class="text-muted small mb-0">Authorized Dealer</p></div></div>
                <div class="col-md-3 trust-item"><div class="trust-card"><i class="fa-solid fa-cookie-bite trust-icon"></i><h6 class="fw-bold">Fresh Quality</h6><p class="text-muted small mb-0">Daily Stock Update</p></div></div>
                <div class="col-md-3 trust-item"><div class="trust-card"><i class="fa-solid fa-wallet trust-icon"></i><h6 class="fw-bold">Best Price</h6><p class="text-muted small mb-0">Wholesale Rates</p></div></div>
            </div>
        </div> -->

        <!-- <div class="container py-5">
            <h3 class="fw-800 mb-4">Explore Categories</h3>
            <div class="d-flex flex-wrap gap-3">
                <a href="products.jsp#Wafers" class="cat-chip">🥔 Wafers</a>
                <a href="products.jsp#Namkeen" class="cat-chip">🥨 Namkeen</a>
                <a href="products.jsp#Peantus" class="cat-chip">🥜 Peanuts</a>
                <a href="products.jsp#Khakhra" class="cat-chip">🍪 Khakhra</a>
                <a href="products.jsp#Western_Snacks" class="cat-chip">🍟 Western Snacks</a>
                <a href="products.jsp#Gippi" class="cat-chip">🍜 Noodles</a>
            </div>
        </div>

        <div class="container py-5">
            <div class="d-flex justify-content-between align-items-end mb-5">
                <h2 class="section-header mb-0">Best Sellers</h2>
                <a href="products.jsp" class="text-navy fw-bold text-decoration-none">View All <i class="fa-solid fa-arrow-right ms-1"></i></a>
            </div>

            <div class="row g-4">
                <%
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conHome = DriverManager.getConnection("jdbc:mysql://localhost:3306/vimal_agency","root","");
                        
                        String[] bestSellerNames = {"CRUNCHEX - CHILI TADKA", "FARALI CHEVDO", "ALOO SEV", "MASALA MAMRA"};
                        String[] imagePaths = {"./Product/chili_tadka.png", "./Product/farali_chevdo.jpg", "./Product/aloo_sev.webp", "./Product/masala_mamra.webp"};
                        String[] tags = {"Bestseller", "Traditional", "Classic", "Hot Deal"};

                        for(int i=0; i < bestSellerNames.length; i++) {
                            PreparedStatement ps = conHome.prepareStatement("SELECT product_price FROM products WHERE product_name = ?");
                            ps.setString(1, bestSellerNames[i]);
                            ResultSet rsPrice = ps.executeQuery();
                            
                            String displayPrice = "10";
                            if(rsPrice.next()) {
                                displayPrice = rsPrice.getString("product_price");
                            }
                            rsPrice.close();
                            ps.close();
                %>
                    <div class="col-lg-3 col-md-6 best-seller-card">
                        <div class="glass-card">
                            <div class="card-img-wrap">
                                <img src="<%= imagePaths[i] %>" alt="<%= bestSellerNames[i] %>">
                            </div>
                            <div class="text-center">
                                <span class="badge <%= (i==0) ? "bg-warning text-dark" : "bg-light text-dark" %> mb-2"><%= tags[i] %></span>
                                <h5 class="fw-bold text-uppercase" style="font-size: 0.95rem; height: 40px; overflow: hidden;"><%= bestSellerNames[i] %></h5>
                                <h4 class="fw-800 text-navy mb-3">₹ <%= displayPrice %></h4>
                                
                                <div class="progress mb-3" style="height: 5px; border-radius: 10px;">
                                    <div class="progress-bar bg-success" style="width: 80%"></div>
                                </div>
                                
                                <button onclick="addToCartNotification('<%= bestSellerNames[i] %>')" class="btn btn-premium w-100 py-2 fs-6">Buy Now</button>
                            </div>
                        </div>
                    </div>
                <% 
                        } conHome.close();
                    } catch(Exception e) { out.println(e.getMessage()); }
                %>
            </div>
        </div> -->

        <div class="container py-5">
            <div class="promo-banner shadow-lg">
                <div class="row align-items-center">
                    <div class="col-md-7 position-relative" style="z-index: 1;">
                        <h2 class="fw-800 display-5 mb-3">Special Weekend Offer!</h2>
                        <p class="fs-5 opacity-75 mb-4">Get direct factory prices on bulk orders above ₹1000. Freshness guaranteed in every bite.</p>
                        <a href="products.jsp" class="btn btn-warning btn-lg fw-bold rounded-pill px-5">Shop Wholesale</a>
                    </div>
                    <div class="col-md-5 d-none d-md-block text-center position-relative">
                        <img src="./Product/home_page_photo.png" style="width: 100%; filter: drop-shadow(0 20px 40px rgba(0,0,0,0.5));" alt="Snacks">
                    </div>
                </div>
                <div class="banner-circle" style="width: 300px; height: 300px; top: -150px; right: -100px;"></div>
                <div class="banner-circle" style="width: 150px; height: 150px; bottom: -50px; left: 100px;"></div>
            </div>
        </div>

        <a href="cart.jsp" class="floating-cart" title="Your Cart">
            <i class="fa-solid fa-basket-shopping"></i>
            <span class="cart-count" id="global-cart-count"><%= floatingCartCount %></span>
        </a>
        
        <div class="position-fixed bottom-0 start-0 p-3" style="z-index: 11;">
            <div id="cartToast" class="toast align-items-center text-white bg-success border-0 animated fadeIn" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex">
                    <div class="toast-body">
                        <i class="fa-solid fa-circle-check me-2"></i> <span id="toast-item-name">Product</span> has been added to your cart!
                    </div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
            </div>
        </div>

        <%@ include file="footer.jsp" %>
    <% } %> 

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const inrFormatter = new Intl.NumberFormat('en-IN', {
                style: 'currency',
                currency: 'INR',
                minimumFractionDigits: 2
            });

            document.querySelectorAll('.inr-format').forEach(function(element) {
                let rawVal = parseFloat(element.getAttribute('data-val'));
                if (!isNaN(rawVal)) {
                    element.innerText = inrFormatter.format(rawVal);
                }
            });
        });

        const sr = ScrollReveal({
            distance: '60px',
            duration: 2000,
            delay: 400,
            reset: false
        });

        if(document.querySelector('.hero-text-box')) {
            sr.reveal('.hero-text-box', { origin: 'left' });
            sr.reveal('.img-float', { origin: 'right', delay: 600 });
            sr.reveal('.trust-item', { interval: 200, origin: 'bottom' });
            sr.reveal('.best-seller-card', { interval: 200, origin: 'bottom' });
            sr.reveal('.promo-banner', { scale: 0.8, delay: 300 });
        }

        const hours = new Date().getHours();
        let greeting = "Hello";
        if (hours < 12) greeting = "Good Morning";
        else if (hours < 17) greeting = "Good Afternoon";
        else greeting = "Good Evening";
        if(document.getElementById('dynamic-greeting')) {
            document.getElementById('dynamic-greeting').innerText = greeting;
        }

        let currentCartCount = <%= floatingCartCount %>; 
        function addToCartNotification(itemName) {
            currentCartCount++;
            let globalCart = document.getElementById('global-cart-count');
            if(globalCart) globalCart.innerText = currentCartCount;
            
            let toastItem = document.getElementById('toast-item-name');
            if(toastItem) toastItem.innerText = itemName;
            
            var toastEl = document.getElementById('cartToast');
            if(toastEl) {
                var toast = new bootstrap.Toast(toastEl);
                toast.show();
            }
        }

        // 🔥 HAZARD STRIPE MOVING SCRIPT
        let ribbonPosition = 0;
        setInterval(() => {
            let stripeElement = document.getElementById('movingRibbonStripe');
            if (stripeElement) {
                ribbonPosition -= 2;
                stripeElement.style.backgroundPosition = ribbonPosition + 'px 0px';
            }
        }, 25);

        // 🔥 LIVE COUNTDOWN TIMER SCRIPT
        <% if(isMaintenanceActive == 1 && targetEndTimeMillis > 0) { %>
            const targetTime = <%= targetEndTimeMillis %>;
            setInterval(() => {
                const now = new Date().getTime();
                const distance = targetTime - now;

                if (distance < 0) {
                    document.getElementById("countdownTimer").innerText = "Website is launching shortly...";
                    window.location.reload();
                } else {
                    const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                    const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
                    const seconds = Math.floor((distance % (1000 * 60)) / 1000);

                    document.getElementById("countdownTimer").innerText = 
                        String(hours).padStart(2, '0') + " Hours : " + 
                        String(minutes).padStart(2, '0') + " Minutes : " + 
                        String(seconds).padStart(2, '0') + " Seconds";
                }
            }, 1000);
        <% } %>
    </script>
</body>
</html>