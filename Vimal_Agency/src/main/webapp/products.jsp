<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.vimal.utils.DatabaseManager" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%
    // STEP 1: USER SESSION CHECK
    if (session.getAttribute("user_id") == null && session.getAttribute("uid") == null && session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp?msg=auth_required");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products | Vimal Agency</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    <link rel='stylesheet' type='text/css' href='main.css'>

    <style>
        :root {
            --primary: #0f172a;
            --accent: #ffc800;
            --bg: #f8fafc;
            --white: #ffffff;
        }

        body {
            font-family: 'Outfit', sans-serif;
            background-color: var(--bg);
            color: var(--primary);
        }

        /* Category Header Design */
        .category-container { margin: clamp(30px, 6vw, 60px) 0 20px; }
        .category-title {
            font-weight: 800;
            font-size: clamp(1.8rem, 4vw, 2.5rem);
            position: relative;
            display: inline-block;
            margin-bottom: clamp(20px, 4vw, 40px);
        }
        .category-title::after {
            content: '';
            position: absolute;
            bottom: -8px;
            left: 0;
            width: 50px;
            height: 5px;
            background: var(--accent);
            border-radius: 10px;
        }

        /* Responsive Product Grid */
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(min(100%, 240px), 1fr));
            gap: clamp(15px, 3vw, 30px);
        }

        .product-card {
            background: var(--white);
            border-radius: 20px;
            padding: clamp(15px, 3vw, 22px);
            text-align: center;
            border: 1px solid rgba(0,0,0,0.04);
            box-shadow: 0 4px 15px rgba(0,0,0,0.02);
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            position: relative;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .product-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.06);
        }

        .img-wrapper {
            background: #f1f5f9;
            border-radius: 16px;
            padding: 12px;
            margin-bottom: 15px;
            height: 180px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }
        .img-wrapper img {
            max-width: 90%;
            max-height: 90%;
            object-fit: contain;
            transition: 0.4s;
        }
        .product-card:hover .img-wrapper img { transform: scale(1.08); }

        .price-tag {
            font-size: 1.4rem;
            font-weight: 800;
            color: var(--primary);
            margin: 10px 0;
        }

        .btn-add-cart {
            background: var(--primary);
            color: var(--white);
            border: none;
            padding: 12px;
            border-radius: 12px;
            font-weight: 700;
            width: 100%;
            min-height: 44px;
            transition: 0.25s;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }
        .btn-add-cart:hover {
            background: var(--accent);
            color: var(--primary);
            box-shadow: 0 8px 18px rgba(255, 200, 0, 0.3);
        }

        /* Toast Message (Top Center) */
        .toast-message {
            position: fixed;
            top: 20px;
            left: 50%;
            transform: translateX(-50%) translateY(-150%);
            background: white;
            padding: 12px 20px;
            border-radius: 14px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.15);
            z-index: 10001;
            display: flex;
            align-items: center;
            gap: 12px;
            transition: 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
            border-bottom: 5px solid #28a745;
            max-width: min(92vw, 420px);
            width: max-content;
            visibility: hidden;
            opacity: 0;
        }
        .toast-message.active {
            visibility: visible;
            opacity: 1;
            transform: translateX(-50%) translateY(0);
        }
        .toast-overlay {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.1); backdrop-filter: blur(2px);
            z-index: 10000; display: none;
        }
    </style>
</head>
<body>

    <%@ include file="header.jsp" %>

    <div class="toast-overlay" id="toastOverlay" onclick="closeToast()"></div>
    <div class="toast-message" id="toastMsg">
        <i class="fa-solid fa-circle-check text-success fs-4"></i>
        <div>
            <h6 class="fw-bold mb-0" id="toastTitle">Added to Cart!</h6>
            <small class="text-muted" id="toastBody">Product is now in your basket.</small>
        </div>
    </div>

    <div class="container pb-5">
        <%
            // Categories mapping
            Map<String, String> catMap = new LinkedHashMap<>();
            catMap.put("Wafers", "Wafers");
            catMap.put("Western Snacks", "Western_Snacks");
            catMap.put("Snack Pellets", "Snack_Pellets");
            catMap.put("Namkeen", "Namkeen");
            catMap.put("Peantus", "Peantus");
            catMap.put("Khakhra", "Khakhra");
            catMap.put("Wafer Biscuit", "Wafer_Biscuit");
            catMap.put("Confectionary", "Confectionary");
            catMap.put("Gippi", "Gippi");
            catMap.put("Olee", "Olee");

            try (Connection con = DatabaseManager.getConnection()) {
                for (Map.Entry<String, String> entry : catMap.entrySet()) {
                    String categoryName = entry.getKey();
                    String anchorTag = entry.getValue();

                    String sql = "SELECT * FROM products WHERE product_category = ? ORDER BY listing_code ASC";
                    try (PreparedStatement ps = con.prepareStatement(sql)) {
                        ps.setString(1, categoryName);
                        try (ResultSet rs = ps.executeQuery()) {
                            boolean hasItems = false;

                            while (rs.next()) {
                                if (!hasItems) {
                                    hasItems = true;
        %>
            <!-- Category Header -->
            <div class="category-container" id="<%= anchorTag %>">
                <h2 class="category-title"><%= categoryName %></h2>
                <div class="product-grid">
        <%
                                }
                                int lCode = rs.getInt("listing_code");
                                String pName = rs.getString("product_name");
                                int price = rs.getInt("product_price");
                                String img = rs.getString("product_image");
                                String desc = rs.getString("product_describe");
        %>
                    <!-- Product Card -->
                    <div class="product-card">
                        <div>
                            <div class="img-wrapper">
                                <img src="<%= (img != null ? img : "") %>" alt="<%= (pName != null ? pName : "Product") %>" loading="lazy">
                            </div>
                            <h5 class="fw-bold text-dark mb-1" style="font-size: 1.05rem; line-height: 1.3;"><%= (pName != null ? pName : "") %></h5>
                            <p class="text-muted small mb-0" style="min-height: 38px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;"><%= (desc != null ? desc : "") %></p>
                        </div>
                        <div>
                            <div class="price-tag">₹ <%= price %></div>
                            <button class="btn-add-cart" onclick="addToCart('<%= (pName != null ? pName.replace("'", "\\'") : "") %>', '<%= price %>', '<%= (img != null ? img.replace("'", "\\'") : "") %>')">
                                <i class="fa-solid fa-cart-plus me-1"></i> Add to Cart
                            </button>
                        </div>
                    </div>
        <%
                            }
                            if (hasItems) {
        %>
                </div>
            </div>
        <%
                            }
                        }
                    }
                }
            } catch (Exception e) {
                out.println("<div class='alert alert-danger mt-4'>Error loading product catalog: " + e.getMessage() + "</div>");
            }
        %>
    </div>

    <%@ include file="footer.jsp" %>

    <script>
        function addToCart(name, price, img) {
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "addtocart.jsp", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    showToast(name + " added to cart!");
                }
            };
            xhr.send("name=" + encodeURIComponent(name) + "&price=" + encodeURIComponent(price) + "&img=" + encodeURIComponent(img));
        }

        function showToast(bodyText) {
            document.getElementById("toastBody").innerText = bodyText;
            document.getElementById("toastMsg").classList.add("active");
            document.getElementById("toastOverlay").style.display = "block";

            setTimeout(function () {
                closeToast();
            }, 2500);
        }

        function closeToast() {
            document.getElementById("toastMsg").classList.remove("active");
            document.getElementById("toastOverlay").style.display = "none";
        }
    </script>
</body>
</html>
