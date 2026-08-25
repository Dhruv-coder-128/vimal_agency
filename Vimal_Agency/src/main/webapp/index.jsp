<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.vimal.utils.DatabaseManager" %>
<%@ page import="java.sql.*" %>

<%
    // SECURITY: User must be logged in.
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String currentSessionUser = session.getAttribute("username").toString();
    int floatingCartCount = 0;

    // Load the logged-in user's cart count using the project's shared DB manager.
    Connection conFloat = null;
    PreparedStatement psFloat = null;
    ResultSet rsFloat = null;

    try {
        Object cartUserIdObj = session.getAttribute("user_id");

        if (cartUserIdObj != null) {
            int cartUserId = Integer.parseInt(cartUserIdObj.toString());

            conFloat = DatabaseManager.getConnection();
            psFloat = conFloat.prepareStatement(
                "SELECT COALESCE(SUM(qty), 0) FROM cart WHERE user_id = ?"
            );
            psFloat.setInt(1, cartUserId);
            rsFloat = psFloat.executeQuery();

            if (rsFloat.next()) {
                floatingCartCount = rsFloat.getInt(1);
            }
        }
    } catch (Exception ignored) {
        floatingCartCount = 0;
    } finally {
        if (rsFloat != null) try { rsFloat.close(); } catch (Exception ignored) {}
        if (psFloat != null) try { psFloat.close(); } catch (Exception ignored) {}
        if (conFloat != null) try { conFloat.close(); } catch (Exception ignored) {}
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


        /* Responsive safety fixes */
        @media (max-width: 767.98px) {
            .maint-body { padding: 15px 0; }
            .maint-container { width: calc(100% - 24px); border-radius: 18px; }
            .maint-heading-main { font-size: clamp(1.9rem, 8vw, 2.5rem); }
            .maint-footer {
                padding: 14px 18px;
                flex-direction: column;
                align-items: flex-start !important;
                gap: 12px;
            }
            .hero-v2 { padding: 45px 0 35px; }
            .hero-title { font-size: clamp(2.2rem, 11vw, 3.4rem); }
            .hero-text-box { text-align: center; }
            .hero-text-box p { margin-left: auto; margin-right: auto; font-size: 1rem !important; }
            .hero-text-box .d-flex { flex-direction: column; gap: 16px !important; }
            .btn-premium { width: 100%; max-width: 320px; padding: 13px 22px; }
            .hero-v2 img { max-width: 92%; }
            .brand-track { gap: 28px; }
            .brand-item-img { height: 32px; }
            .promo-banner-wrapper { padding: 35px 12px 25px; }
            .banner-card { border-radius: 24px; padding: 32px 22px; min-height: auto; }
            .banner-description { font-size: 0.98rem; }
            .banner-title { font-size: 1.65rem; }
            .banner-image-wrapper { width: min(250px, 75vw); margin-top: -15px; }
            .feature-strip { padding: 20px 0 30px; }
            .feature-item { margin-right: 35px; }
            .icon-circle { width: 65px; height: 65px; margin-right: 12px; }
            .icon-circle lottie-player { width: 42px; height: 42px; }
            .feature-text { font-size: 17px; }
            .promo-banner { border-radius: 22px !important; padding: 30px 22px !important; }
        }

        @media (max-width: 420px) {
            .hero-title { font-size: 2.15rem; }
            .banner-title { font-size: 1.45rem; }
            .feature-item { margin-right: 25px; }
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
    
        .product-title {
            font-size: 0.95rem;
            min-height: 42px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .promo-ticker {
            min-height: 46px;
        }

        .ticker-wrap {
            min-width: 0;
        }

        .ticker-inner {
            width: max-content;
            animation: ticker 28s linear infinite;
            white-space: nowrap;
        }

        @media (max-width: 767.98px) {
            .promo-ticker {
                font-size: 0.78rem;
            }

            .fixed-announcement {
                padding-left: 10px !important;
                padding-right: 10px !important;
                font-size: 0.72rem;
            }

            .hero-v2 {
                padding: 42px 0 32px;
            }

            .hero-text-box {
                text-align: center;
            }

            .hero-text-box p {
                margin-left: auto;
                margin-right: auto;
                font-size: 1rem !important;
            }

            .hero-text-box > .d-flex {
                flex-direction: column;
                justify-content: center;
                gap: 14px !important;
            }

            .hero-text-box .btn-premium {
                width: min(100%, 320px);
            }

            .hero-v2 .img-float {
                max-width: 92%;
            }

            .brand-section {
                overflow-x: hidden;
            }

            .banner-card {
                min-height: 330px;
            }

            .banner-image-wrapper {
                width: min(230px, 65vw);
            }

            .feature-track {
                animation-duration: 35s;
            }

            .section-header {
                font-size: 1.8rem;
            }

            .glass-card {
                padding: 16px;
            }

            .card-img-wrap {
                height: 190px;
            }
        }

        @media (max-width: 420px) {
            .hero-title {
                font-size: 2.15rem;
            }

            .fixed-announcement {
                display: none;
            }

            .promo-ticker {
                padding: 9px 0;
            }

            .banner-card {
                min-height: 300px;
                padding: 28px 18px;
            }
        }

</style>
</head>
<body>

    <%@ include file="header.jsp" %>

        <div class="greeting-bar text-center text-muted">
            <span id="dynamic-greeting">Hello</span>, <%= currentSessionUser %> 👋 | Welcome to Vimal Agency.
        </div>

        <div class="promo-ticker d-flex align-items-center">
            <div class="fixed-announcement px-3 text-warning fw-bold border-end border-secondary flex-shrink-0"
                 style="z-index:2;background:var(--deep-navy);">
                <i class="fa-solid fa-bullhorn me-2"></i>ANNOUNCEMENT
            </div>

            <div class="ticker-wrap overflow-hidden w-100">
                <div class="ticker-inner d-flex">
                    <%
                        boolean offerFound = false;
                        try (Connection offerCon = DatabaseManager.getConnection();
                             PreparedStatement offerPs = offerCon.prepareStatement(
                                 "SELECT offer_text FROM offers WHERE is_active = 1");
                             ResultSet offerRs = offerPs.executeQuery()) {

                            while (offerRs.next()) {
                                offerFound = true;
                    %>
                        <span class="mx-5 fw-600 text-nowrap">
                            <i class="fa-solid fa-star text-warning me-2"></i>
                            <%= offerRs.getString("offer_text") %>
                        </span>
                    <%
                            }
                        } catch (Exception ignored) {
                        }

                        if (!offerFound) {
                    %>
                        <span class="mx-5 fw-600 text-nowrap">
                            Fresh Stock Available! • Fast Delivery in Junagadh • Balaji Premium Quality
                        </span>
                    <% } %>
                </div>
            </div>
        </div>

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

        <div class="container py-5">
            <div class="d-flex justify-content-between align-items-end mb-4 mb-md-5">
                <div>
                    <span class="text-uppercase fw-bold text-warning small">Customer favourites</span>
                    <h2 class="section-header mb-0 mt-1">Best Sellers</h2>
                </div>
                <a href="products.jsp" class="text-navy fw-bold text-decoration-none">
                    View All <i class="fa-solid fa-arrow-right ms-1"></i>
                </a>
            </div>

            <div class="row g-4">
                <%
                    String[] bestSellerNames = {
                        "CRUNCHEX - CHILI TADKA",
                        "FARALI CHEVDO",
                        "ALOO SEV",
                        "MASALA MAMRA"
                    };

                    String[] imagePaths = {
                        "./Product/chili_tadka.png",
                        "./Product/farali_chevdo.jpg",
                        "./Product/aloo_sev.webp",
                        "./Product/masala_mamra.webp"
                    };

                    String[] tags = {
                        "Bestseller",
                        "Traditional",
                        "Classic",
                        "Hot Deal"
                    };

                    try (Connection conHome = DatabaseManager.getConnection()) {
                        for (int i = 0; i < bestSellerNames.length; i++) {
                            String displayPrice = "10";

                            try (PreparedStatement psHome = conHome.prepareStatement(
                                    "SELECT product_price FROM products WHERE product_name = ?")) {

                                psHome.setString(1, bestSellerNames[i]);

                                try (ResultSet rsPrice = psHome.executeQuery()) {
                                    if (rsPrice.next()) {
                                        displayPrice = rsPrice.getString("product_price");
                                    }
                                }
                            }
                %>
                    <div class="col-lg-3 col-md-6 col-12 best-seller-card">
                        <div class="glass-card">
                            <div class="card-img-wrap">
                                <img src="<%= imagePaths[i] %>"
                                     alt="<%= bestSellerNames[i] %>"
                                     loading="lazy">
                            </div>

                            <div class="text-center">
                                <span class="badge <%= (i == 0)
                                    ? "bg-warning text-dark"
                                    : "bg-light text-dark" %> mb-2">
                                    <%= tags[i] %>
                                </span>

                                <h5 class="fw-bold text-uppercase product-title">
                                    <%= bestSellerNames[i] %>
                                </h5>

                                <h4 class="fw-800 text-navy mb-3">
                                    ₹ <%= displayPrice %>
                                </h4>

                                <a href="products.jsp"
                                   class="btn btn-sm btn-outline-dark rounded-pill mt-1 px-4">
                                    Shop Now
                                </a>
                            </div>
                        </div>
                    </div>
                <%
                        }
                    } catch (Exception ignored) {
                %>
                    <div class="col-12">
                        <div class="alert alert-light border text-center">
                            Products are temporarily unavailable. Please try again shortly.
                        </div>
                    </div>
                <% } %>
            </div>
        </div>

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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const inrFormatter = new Intl.NumberFormat("en-IN", {
                style: "currency",
                currency: "INR",
                minimumFractionDigits: 2
            });

            document.querySelectorAll(".inr-format").forEach(function (element) {
                const rawVal = parseFloat(element.getAttribute("data-val"));
                if (!Number.isNaN(rawVal)) {
                    element.textContent = inrFormatter.format(rawVal);
                }
            });

            const greetingElement = document.getElementById("dynamic-greeting");
            if (greetingElement) {
                const hour = new Date().getHours();
                greetingElement.textContent =
                    hour < 12 ? "Good Morning" :
                    hour < 17 ? "Good Afternoon" :
                    "Good Evening";
            }

            if (typeof ScrollReveal !== "undefined") {
                const sr = ScrollReveal({
                    distance: "45px",
                    duration: 900,
                    delay: 100,
                    reset: false,
                    mobile: true
                });

                sr.reveal(".hero-text-box", { origin: "left" });
                sr.reveal(".hero-v2 .img-float", { origin: "right", delay: 150 });
                sr.reveal(".best-seller-card", { interval: 100, origin: "bottom" });
                sr.reveal(".promo-banner", { scale: 0.96, delay: 100 });
                sr.reveal(".trust-item", { interval: 100, origin: "bottom" });
            }

            const globalCart = document.getElementById("global-cart-count");
            if (globalCart) {
                globalCart.textContent = "<%= floatingCartCount %>";
            }
        });

        let currentCartCount = <%= floatingCartCount %>;

        function addToCartNotification(itemName) {
            currentCartCount++;

            const globalCart = document.getElementById("global-cart-count");
            if (globalCart) {
                globalCart.textContent = currentCartCount;
            }

            const toastItem = document.getElementById("toast-item-name");
            if (toastItem) {
                toastItem.textContent = itemName;
            }

            const toastEl = document.getElementById("cartToast");
            if (toastEl && typeof bootstrap !== "undefined") {
                new bootstrap.Toast(toastEl).show();
            }
        }
    </script>
</body>
</html>