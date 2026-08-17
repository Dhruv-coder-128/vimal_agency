<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.vimal.utils.DatabaseManager" %>
<%@ page import="java.sql.*" %>

<%
    // SECURITY LOGIC: Login check
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return; 
    }
%>

<!DOCTYPE html>
<html lang="gu">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vimal Agency | Premium Snacks</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    <link rel='stylesheet' type='text/css' href='main.css'>

    <style>
        :root {
            --primary-gold: #ffc800;
            --deep-navy: #0f172a;
            --soft-white: #f8fafc;
        }

        body { 
            font-family: 'Outfit', sans-serif; 
            background-color: var(--soft-white);
            color: var(--deep-navy);
        }

        /* Modern Ticker */
        .promo-ticker {
            background: var(--deep-navy);
            color: white;
            padding: 12px 0;
            font-size: 0.9rem;
            letter-spacing: 1px;
            overflow: hidden;
        }
        .ticker-wrap { display: flex; animation: ticker 25s linear infinite; }
        @keyframes ticker { 0% { transform: translateX(100%); } 100% { transform: translateX(-100%); } }

        /* Hero Section 2.0 */
        .hero-v2 {
            background: radial-gradient(circle at top right, rgba(255, 200, 0, 0.15), transparent),
                        radial-gradient(circle at bottom left, rgba(15, 23, 42, 0.05), transparent);
            padding: 100px 0;
            position: relative;
        }

        .hero-title { font-weight: 800; font-size: 4rem; line-height: 1.1; }
        .hero-highlight { color: var(--primary-gold); position: relative; }
        .hero-highlight::after {
            content: ''; position: absolute; bottom: 10px; left: 0; width: 100%; height: 8px;
            background: rgba(255, 200, 0, 0.3); z-index: -1;
        }

        /* Floating Animation */
        .img-float { animation: floating 3s ease-in-out infinite; }
        @keyframes floating {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-20px); }
        }

        /* Premium Product Cards */
        .glass-card {
            background: white;
            border-radius: 24px;
            padding: 25px;
            border: 1px solid rgba(255, 255, 255, 0.3);
            box-shadow: 0 20px 40px rgba(0,0,0,0.04);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            height: 100%;
        }
        .glass-card:hover {
            transform: translateY(-15px);
            box-shadow: 0 30px 60px rgba(255, 200, 0, 0.15);
        }

        .card-img-wrap {
            background: #f1f5f9;
            border-radius: 18px;
            padding: 20px;
            margin-bottom: 20px;
            display: flex;
            justify-content: center;
        }
        .card-img-wrap img { max-height: 200px; object-fit: contain; }

        /* Buttons */
        .btn-premium {
            background: var(--deep-navy);
            color: white;
            padding: 14px 40px;
            border-radius: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: 0.3s;
            border: none;
        }
        .btn-premium:hover {
            background: var(--primary-gold);
            color: var(--deep-navy);
            box-shadow: 0 10px 25px rgba(255, 200, 0, 0.4);
        }

        .section-header { font-weight: 800; font-size: 2.5rem; margin-bottom: 60px; }
    </style>
</head>

<body>

    <%@ include file="header.jsp" %>   

    <div class="promo-ticker">
        <div class="ticker-wrap">
            <%
                try (Connection cn = DatabaseManager.getConnection();
                     Statement stOffer = cn.createStatement();
                     ResultSet rs = stOffer.executeQuery("SELECT offer_text FROM offers WHERE is_active=1")) {
                    while (rs.next()) {
            %>
                <span class="mx-5 fw-600"><i class="fa-solid fa-star text-warning me-2"></i><%= rs.getString("offer_text") %></span>
            <% 
                    }
                } catch(Exception ignored) {} 
            %>
        </div>
    </div>

    <section class="hero-v2">
        <div class="container">
            <div class="row align-items-center g-5">
                <div class="col-lg-6 animate__animated animate__fadeIn">
                    <h1 class="hero-title mb-4">
                        Premium Taste <br> 
                        <span class="hero-highlight">Vimal Agency</span>
                    </h1>
                    <p class="text-muted fs-5 mb-5" style="max-width: 500px;">
                        Authentic snacks from Junagadh. Quality is our tradition since 1987. 
                        Get the best wafers delivered to your doorstep.
                    </p>
                    <div class="d-flex gap-3">
                        <a href="products.jsp" class="btn-premium text-decoration-none">Shop Collection</a>
                        <div class="d-flex align-items-center gap-2 ms-3">
                            <div class="bg-success rounded-circle" style="width: 10px; height: 10px;"></div>
                            <small class="fw-bold">Available in 15+ States</small>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6 text-center animate__animated animate__zoomIn">
                    <img src="./Product/home_page_photo.png" class="img-fluid img-float" alt="Hero">
                </div>
            </div>
        </div>
    </section>

    <div class="container py-5">
        <div class="text-center">
            <h2 class="section-header">Curated Best Sellers</h2>
        </div>
        <div class="row g-4">
            <%
                String[] bestSellerNames = {"CRUNCHEX - CHILI TADKA", "FARALI CHEVDO", "ALOO SEV", "MASALA MAMRA"};
                String[] imagePaths = {"./Product/chili_tadka.png", "./Product/farali_chevdo.jpg", "./Product/aloo_sev.webp", "./Product/masala_mamra.webp"};
                String[] tags = {"Bestseller", "Traditional", "Classic", "Hot Deal"};

                try (Connection conHome = DatabaseManager.getConnection()) {
                    for (int i = 0; i < bestSellerNames.length; i++) {
                        String displayPrice = "10";
                        try (PreparedStatement ps = conHome.prepareStatement("SELECT product_price FROM products WHERE product_name = ?")) {
                            ps.setString(1, bestSellerNames[i]);
                            try (ResultSet rsPrice = ps.executeQuery()) {
                                if (rsPrice.next()) {
                                    displayPrice = rsPrice.getString("product_price");
                                }
                            }
                        }
            %>
                <div class="col-lg-3 col-md-6">
                    <div class="glass-card">
                        <div class="card-img-wrap">
                            <img src="<%= imagePaths[i] %>" alt="<%= bestSellerNames[i] %>">
                        </div>
                        <div class="text-center">
                            <span class="badge <%= (i == 0) ? "bg-warning text-dark" : "bg-light text-dark" %> mb-2"><%= tags[i] %></span>
                            <h5 class="fw-bold text-uppercase" style="font-size: 0.95rem;"><%= bestSellerNames[i] %></h5>
                            <h4 class="fw-800 text-navy">₹ <%= displayPrice %></h4>
                            <a href="products.jsp" class="btn btn-sm btn-outline-dark rounded-pill mt-2 px-4">Add to Cart</a>
                        </div>
                    </div>
                </div>
            <% 
                    }
                } catch(Exception e) {
                    out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
                }
            %>
        </div>
    </div>  

    <%@ include file="footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>