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
        .category-container { margin: 60px 0 30px; }
        .category-title {
            font-weight: 800;
            font-size: 2.5rem;
            position: relative;
            display: inline-block;
            margin-bottom: 40px;
        }
        .category-title::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 0;
            width: 60px;
            height: 6px;
            background: var(--accent);
            border-radius: 10px;
        }

        /* Product Grid Fix */
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 30px;
        }

        .product-card {
            background: var(--white);
            border-radius: 25px;
            padding: 20px;
            text-align: center;
            border: 1px solid rgba(0,0,0,0.03);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            position: relative;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .product-card:hover {
            transform: translateY(-15px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.06);
        }

        .img-wrapper {
            background: #f1f5f9;
            border-radius: 20px;
            padding: 15px;
            margin-bottom: 20px;
            height: 200px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }
        .img-wrapper img {
            max-width: 90%;
            max-height: 90%;
            object-fit: contain;
            transition: 0.5s;
        }
        .product-card:hover .img-wrapper img { transform: scale(1.1); }

        .price-tag {
            font-size: 1.5rem;
            font-weight: 800;
            color: var(--primary);
            margin: 15px 0;
        }

        .btn-add-cart {
            background: var(--primary);
            color: var(--white);
            border: none;
            padding: 14px;
            border-radius: 15px;
            font-weight: 700;
            width: 100%;
            transition: 0.3s;
        }
        .btn-add-cart:hover {
            background: var(--accent);
            color: var(--primary);
            box-shadow: 0 10px 20px rgba(255, 200, 0, 0.3);
        }

        /* Toast Message (Top Center) */
        .toast-message {
            position: fixed; 
            top: 25px; 
            left: 50%; 
            transform: translateX(-50%) translateY(-150%); 
            background: white; 
            padding: 15px 25px; 
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.15);
            z-index: 10001; 
            display: flex; 
            align-items: center; 
            gap: 15px;
            transition: 0.5s cubic-bezier(0.68, -0.55, 0.265, 1.55);
            border-bottom: 5px solid #28a745;
            min-width: 320px; 
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

<div id="toast-overlay" class="toast-overlay"></div>
<div id="toast" class="toast-message">
    <i class="fa-solid fa-circle-check text-success fs-2"></i>
    <div class="text-start">
        <strong class="d-block" style="font-size: 1.1rem; color: #0f172a;">Cart Updated</strong>
        <p id="toast-body" class="mb-0 text-muted small"></p>
    </div>
</div>

<div class="container pb-5">
<%
    // Product Helper Class
    class Product {
        String name, image, describe, category;
        int price;
        Product(String name, String image, String describe, int price, String category) {
            this.name = name;
            this.image = image;
            this.describe = describe;
            this.price = price;
            this.category = category;
        }
    }

    Connection cn = null;
    Statement st = null;
    ResultSet rs = null;

    // LinkedHashMap maintains category order while grouping products
    Map<String, List<Product>> categoryMap = new LinkedHashMap<>();

    try {
        cn = DatabaseManager.getConnection();

        // 👉 STRICT ORDER BY listing_code ASC
        String sql = "SELECT * FROM products ORDER BY listing_code ASC";

        st = cn.createStatement();
        rs = st.executeQuery(sql);

        while(rs.next()) {
            String cat = rs.getString("product_category");
            Product p = new Product(
                rs.getString("product_name"),
                rs.getString("product_image"),
                rs.getString("product_describe"),
                rs.getInt("product_price"),
                cat
            );

            if (!categoryMap.containsKey(cat)) {
                categoryMap.put(cat, new ArrayList<Product>());
            }
            categoryMap.get(cat).add(p);
        }

        // Render Categories and Products
        for (Map.Entry<String, List<Product>> entry : categoryMap.entrySet()) {
            String categoryName = entry.getKey();
            List<Product> productList = entry.getValue();
%>
            <div class="category-container animate__animated animate__fadeIn">
                <h1 class="category-title" id="<%= categoryName.replace(" ", "_") %>"><%= categoryName %></h1>
                <div class="product-grid">
                <% for (Product p : productList) { %>
                    <div class="product-card">
                        <div>
                            <div class="img-wrapper">
                                <img src="<%= p.image %>" alt="Product">
                            </div>
                            <h5 class="fw-800 mb-2"><%= p.name %></h5>
                            <p class="text-muted small mb-0" style="height: 40px; overflow: hidden;">
                                <%= p.describe != null ? p.describe : "Premium Quality Snack" %>
                            </p>
                        </div>
                        <div>
                            <div class="price-tag">₹ <%= p.price %></div>
                            <button class="btn-add-cart" 
                                    onclick="addToCart(this)" 
                                    data-name="<%= p.name %>" 
                                    data-price="<%= p.price %>" 
                                    data-img="<%= p.image %>">
                                <i class="fa-solid fa-cart-shopping me-2"></i> Add to Cart
                            </button>
                        </div>
                    </div>
                <% } %>
                </div>
            </div>
<%
        }
    } catch(Exception e) { 
        out.println("<div class='alert alert-danger'>" + e + "</div>"); 
    } finally { 
        try { if(rs!=null) rs.close(); if(st!=null) st.close(); if(cn!=null) cn.close(); } catch(Exception ex){} 
    }
%>
</div>

<%@ include file="footer.jsp" %>

<script>
function updateHeaderCart() {
    fetch('get_cart_count.jsp')
    .then(response => response.text())
    .then(data => {
        const badge = document.getElementById('cart-count'); 
        if(badge) {
            badge.innerText = data.trim();
        }
    });
}

function showSuccessToast(name) {
    const toast = document.getElementById("toast");
    const toastBody = document.getElementById("toast-body");
    
    toastBody.innerHTML = "<strong>" + name + "</strong> has been added to your cart successfully!";
    
    toast.classList.add("active");
    setTimeout(() => { 
        toast.classList.remove("active"); 
    }, 2500);
}

function addToCart(btn) {
    let name = btn.dataset.name;
    let price = btn.dataset.price;
    let img = btn.dataset.img;

    fetch('addtocart.jsp?name=' + encodeURIComponent(name) + '&price=' + price + '&img=' + encodeURIComponent(img))
    .then(response => {
        if(response.status === 401) {
            window.location.href = "login.jsp";
        } else {
            showSuccessToast(name);
            
            setTimeout(() => {
                location.reload();
            }, 2000); 
        }
    })
    .catch(err => {
        console.error("Error:", err);
    });
}
</script>

<button onclick="window.scrollTo({top: 0, behavior: 'smooth'})" 
        style="position:fixed; bottom:30px; right:30px; border:none; background:var(--accent); width:55px; height:55px; border-radius:20px; box-shadow:0 10px 20px rgba(0,0,0,0.1); z-index:999;">
    <i class="fa-solid fa-arrow-up fs-5"></i>
</button>

</body>
</html>