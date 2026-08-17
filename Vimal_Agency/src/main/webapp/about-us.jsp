<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    // SESSION AUTHENTICATION CHECK
    if (session.getAttribute("user_id") == null && session.getAttribute("uid") == null && session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp?msg=auth_required");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <!-- Basic Meta Configuration -->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us | Vimal Agency</title>
    
    <!-- External CSS Libraries -->
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <!-- Bootstrap 5 CSS Framework -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Google Font (Outfit) -->
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;800&display=swap" rel="stylesheet">
    
    <!-- Animate.css for Animations -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>

    <style>
        /* ==============================
           ROOT VARIABLES (Theme Colors)
        ============================== */
        :root {
            --gold: #ffc800;   /* Primary Gold Accent Color */
            --dark: #0f172a;   /* Main Dark Theme Color */
            --accent: #334155; /* Secondary Accent Shade */
        }

        /* ==============================
           GLOBAL BODY STYLING
        ============================== */
        body {
            font-family: 'Outfit', sans-serif; /* Custom Font */
            background-color: #fcfcfc;         /* Light Background */
            overflow-x: hidden;                /* Prevent Horizontal Scroll */
        }

        /* ==============================
           HERO SECTION DESIGN
           Glassmorphism + Background Image
        ============================== */
        .hero-section {
            background: linear-gradient(135deg, rgba(15, 23, 42, 0.95), rgba(51, 65, 85, 0.8)), 
                        url('https://images.unsplash.com/photo-1553413077-190dd305871c?q=80&w=1500&auto=format&fit=crop');
            background-size: cover;
            background-position: center;
            height: 450px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            text-align: center;
            clip-path: ellipse(150% 100% at 50% 0%); /* Curved Bottom Shape */
        }

        /* ==============================
           STATS COUNTER SECTION
        ============================== */
        .stats-wrapper {
            margin-top: -100px; /* Pull section upward over hero */
            position: relative;
            z-index: 100;       /* Keep above hero section */
        }

        .stat-card {
            background: white;
            padding: 30px;
            border-radius: 24px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.08);
            text-align: center;
            border-bottom: 5px solid var(--gold);
            transition: 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }

        /* Hover Animation Effect */
        .stat-card:hover { 
            transform: translateY(-12px); 
        }

        .stat-number { 
            font-size: 2.5rem; 
            font-weight: 800; 
            color: var(--dark); 
            display: block; 
        }

        .stat-label { 
            color: #64748b; 
            font-weight: 500; 
            text-transform: uppercase; 
            letter-spacing: 1px; 
            font-size: 0.85rem; 
        }

        /* ==============================
           INFORMATION GRID SECTION
        ============================== */
        .info-grid { 
            padding: 80px 0; 
        }

        /* Modern Card Styling */
        .modern-table-card {
            background: #ffffff;
            border-radius: 30px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.03);
        }

        /* Quick Details Horizontal Layout */
        .quick-details-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
            padding: 20px 0;
        }

        .quick-item {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        /* Small Icon Box */
        .icon-small {
            width: 40px; 
            height: 40px;
            background: rgba(255, 200, 0, 0.1);
            color: var(--gold);
            border-radius: 10px;
            display: flex;
            align-items: center; 
            justify-content: center;
            font-size: 1.1rem;
        }

        .item-label { 
            color: #64748b; 
            font-size: 0.75rem; 
            text-transform: uppercase; 
            letter-spacing: 0.5px; 
            font-weight: 600; 
            margin-bottom: 0; 
        }

        .item-val { 
            color: var(--dark); 
            font-weight: 700; 
            font-size: 0.95rem; 
            margin: 0; 
        }

        /* ==============================
           REACH / DEALER SECTION
        ============================== */
        .reach-container {
            background: linear-gradient(135deg, #ffffff, #fffdf0);
            border-radius: 30px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.03);
            border: 1px solid rgba(255, 200, 0, 0.2);
        }

        .reach-stat-box {
            background: white;
            padding: 25px;
            border-radius: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.02);
            border: 1px solid #f1f5f9;
            text-align: center;
            transition: 0.3s;
        }

        /* Hover Zoom Effect */
        .reach-stat-box:hover {
            transform: scale(1.05);
            border-color: var(--gold);
        }

        .reach-num { 
            font-size: 2.2rem; 
            font-weight: 800; 
            color: var(--gold); 
            margin-bottom: 5px; 
        }

        .reach-txt { 
            color: #64748b; 
            font-weight: 600; 
            font-size: 0.85rem; 
        }

        /* ==============================
           TEAM / LEADERSHIP SECTION
        ============================== */
        .team-card-modern {
            background: white;
            margin-bottom: 20px;
            padding: 25px;
            border-radius: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 15px rgba(0,0,0,0.02);
            border: 1px solid #f1f5f9;
            transition: 0.3s;
        }

        /* Dark Hover Effect */
        .team-card-modern:hover { 
            background: var(--dark); 
            color: white; 
        }

        .team-card-modern:hover .badge { 
            background: var(--gold) !important; 
            color: var(--dark) !important; 
        }

        /* ==============================
           HEAD OFFICE & BRANCH SECTION
        ============================== */
        .dark-branch-section {
            background: var(--dark);
            border-radius: 40px;
            padding: 60px;
            color: white;
            position: relative;
            overflow: hidden;
        }
    </style>
</head>

<body>

    <!-- Include Header File (Common Navigation Bar) -->
    <%@ include file="header.jsp" %>

    <!-- ==============================
         HERO SECTION (Company Introduction)
    ============================== -->
    <section class="hero-section">
        <div class="container animate__animated animate__fadeIn">
            <h1 class="display-3 fw-800 mb-2">Vimal Agency</h1>
            <p class="lead opacity-75">Trust. Tradition. Taste. Since 1987.</p>
        </div>
    </section>

    <div class="container stats-wrapper">
        <div class="row g-4 justify-content-center">
            <div class="col-6 col-md-3">
                <div class="stat-card">
                    <span class="stat-number">1987</span>
                    <span class="stat-label">Established</span>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="stat-card">
                    <span class="stat-number">38+</span>
                    <span class="stat-label">Years Legacy</span>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="stat-card">
                    <span class="stat-number">700+</span>
                    <span class="stat-label">Customers</span>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="stat-card">
                    <span class="stat-number">#1</span>
                    <span class="stat-label">Distributor</span>
                </div>
            </div>
        </div>
    </div>

    <div class="container info-grid">
        <div class="modern-table-card mb-5">
            <div class="quick-details-row">
                <div class="quick-item">
                    <div class="icon-small"><i class="fa-solid fa-id-card"></i></div>
                    <div><p class="item-label">Agency Name</p><p class="item-val">Vimal Agency</p></div>
                </div>
                <div class="quick-item">
                    <div class="icon-small"><i class="fa-solid fa-location-dot"></i></div>
                    <div><p class="item-label">Main Location</p><p class="item-val">Khamdhrol Road, Junagadh</p></div>
                </div>
                <div class="quick-item">
                    <div class="icon-small"><i class="fa-solid fa-phone"></i></div>
                    <div><p class="item-label">Helpline</p><p class="item-val">+91 98258 47167</p></div>
                </div>
                <div class="quick-item">
                    <div class="icon-small"><i class="fa-solid fa-envelope"></i></div>
                    <div><p class="item-label">Email Address</p><p class="item-val">vimalagency4@gmail.com</p></div>
                </div>
            </div>
        </div>

        <div class="row g-5">
            <div class="col-lg-7">
                <h2 class="fw-800 mb-4 animate__animated animate__fadeInLeft">Our Story</h2>
                <p class="text-secondary fs-5 mb-5" style="line-height: 1.8;">
                    Started as a vision in 1987, Vimal Agency has evolved into a premier FMCG distributor. 
                    As the <strong>first-ever distributor for Balaji Wafers</strong>, we take pride in our 
                    unwavering commitment to quality and a network that spans across Junagadh.
                </p>

                <div class="reach-container mb-5 animate__animated animate__fadeInUp" style="border-left: 8px solid var(--gold);">
                    <h2 class="fw-800 mb-4" style="color: var(--dark);">The Triumph</h2>
                    <p class="text-dark" style="line-height: 1.7; text-align: justify; font-size: 0.95rem;">
                        In 1987, <strong>Mr. Hareshbhai Sanghavi</strong> embarked on a visionary journey by meeting Mr. Chandubhai Virani, the founder of Balaji Wafers. 
                        He started the business with a humble investment, purchasing his first stock worth only <strong>₹240</strong>. 
                    </p>
                    
                    <div class="p-3 my-4 rounded-3" style="background: rgba(255, 200, 0, 0.1); border: 1px dashed var(--gold);">
                        <i class="fa-solid fa-chart-line me-2 text-warning"></i>
                        <span class="fw-bold">A Historical Milestone:</span> 
                        Through decades of dedication, Vimal Agency once achieved a staggering <strong>25% share of the total yearly turnover of Balaji Wafers</strong>.
                    </div>

                    <p class="text-dark mb-0" style="line-height: 1.7; font-size: 0.95rem;">
                        Today, Hareshbhai is celebrated as the <strong>1st Dealer</strong> in Balaji Wafers' history. 
                        Even Chandubhai Virani now acknowledges that Hareshbhai’s vision for the market was absolutely correct.
                    </p>
                </div>

                <div class="reach-container">
                    <h4 class="fw-800 mb-4 text-warning d-flex align-items-center">
                        <i class="fa-solid fa-globe me-2"></i> Balaji Wafers: Global Legacy
                    </h4>
                    <div class="row g-3">
                        <div class="col-6 col-md-3">
                            <div class="reach-stat-box">
                                <p class="reach-num">7</p>
                                <p class="reach-txt">Factories</p>
                            </div>
                        </div>
                        <div class="col-6 col-md-3">
                            <div class="reach-stat-box">
                                <p class="reach-num">15</p>
                                <p class="reach-txt">States</p>
                            </div>
                        </div>
                        <div class="col-6 col-md-3">
                            <div class="reach-stat-box">
                                <p class="reach-num">40+</p>
                                <p class="reach-txt">Countries</p>
                            </div>
                        </div>
                        <div class="col-6 col-md-3">
                            <div class="reach-stat-box">
                                <p class="reach-num">1400+</p>
                                <p class="reach-txt">Dealers</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-5">
                <h2 class="fw-800 mb-4 text-lg-end">Leadership</h2>
                <div class="team-list">
                    <div class="team-card-modern">
                        <div><div class="fw-700 fs-5 mb-1">Mr. Hareshbhai Sanghavi</div><div class="team-role">Proprietor</div></div>
                        <span class="badge bg-light text-dark border p-2">Since 1987</span>
                    </div>
                    <div class="team-card-modern">
                        <div><div class="fw-700 fs-5 mb-1">Mr. Vipulbhai Sanghavi</div><div class="team-role">General Manager</div></div>
                        <span class="badge bg-light text-dark border p-2">Since 1990</span>
                    </div>
                    <div class="team-card-modern">
                        <div><div class="fw-700 fs-5 mb-1">Mr. Manojbhai Sanghavi</div><div class="team-role">Finance Department</div></div>
                        <span class="badge bg-light text-dark border p-2">Since 1994</span>
                    </div>
                    <div class="team-card-modern">
                        <div><div class="fw-700 fs-5 mb-1">Mr. Harsh Sanghavi</div><div class="team-role">HR Department</div></div>
                        <span class="badge bg-light text-dark border p-2">Since 2015</span>
                    </div>
                    <div class="team-card-modern">
                        <div><div class="fw-700 fs-5 mb-1">Mr. Meet Sanghavi</div><div class="team-role">Marketing Department</div></div>
                        <span class="badge bg-light text-dark border p-2">Since 2018</span>
                    </div>
                    <div class="team-card-modern">
                        <div><div class="fw-700 fs-5 mb-1">Mr. Karan Sanghavi</div><div class="team-role">Data Analyst / IT Manager </div></div>
                        <span class="badge bg-light text-dark border p-2">Since 2021</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="dark-branch-section mt-5 animate__animated animate__fadeInUp">
            <div class="row align-items-center text-center text-md-start">
                <div class="col-md-6 mb-4 mb-md-0 border-md-end border-secondary border-opacity-25">
                    <h3 class="fw-800 text-warning mb-4"><i class="fa-solid fa-building me-2"></i> Head Office</h3>
                    <p class="opacity-75 fs-5">Uparkot Road, Gebanshah Chowk,<br>Vardhman Complex, Junagadh.</p>
                    <div class="mt-4"><span class="p-2 bg-secondary bg-opacity-25 rounded-3 border border-secondary"><strong>GSTIN:</strong> 24AKOPS0609MIZS</span></div>
                </div>
                <div class="col-md-6 ps-md-5">
                    <h3 class="fw-800 text-warning mb-4"><i class="fa-solid fa-location-dot me-2"></i> Branch</h3>
                    <p class="opacity-75 fs-5">Plot 1/2/3, Satyam Park - 2,<br>Khamdhrol Road, Junagadh.</p>
                    <p class="mt-3"><i class="fa-solid fa-phone-volume text-warning me-2"></i> 98258 47167</p>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="footer.jsp" %>   
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
