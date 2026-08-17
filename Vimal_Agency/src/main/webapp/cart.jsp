<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vimal.utils.DatabaseManager" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="gu">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Premium Cart | Vimal Agency</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>

    <style>
        :root {
            --primary-dark: #0f172a;
            --accent-gold: #ffc800;
            --soft-gray: #f1f5f9;
            --premium-white: #ffffff;
        }

        body {
            font-family: 'Outfit', sans-serif;
            background-color: #f8fafc;
            color: var(--primary-dark);
        }

        .cart-header {
            padding: 40px 0;
            background: linear-gradient(to right, var(--primary-dark), #1e293b);
            color: white;
            border-radius: 0 0 50px 50px;
            margin-bottom: -50px;
        }

        .premium-wrapper {
            display: grid;
            grid-template-columns: 1fr 380px;
            gap: 30px;
            padding-top: 20px;
        }

        .item-box {
            background: var(--premium-white);
            border-radius: 24px;
            padding: 20px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            border: 1px solid rgba(0,0,0,0.05);
            transition: 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        .item-box:hover {
            transform: scale(1.02);
            box-shadow: 0 20px 40px rgba(0,0,0,0.05);
        }

        .img-container {
            width: 120px; height: 120px;
            background: var(--soft-gray);
            border-radius: 18px;
            padding: 10px;
            display: flex; align-items: center; justify-content: center;
        }
        .img-container img { max-width: 100%; max-height: 100%; object-fit: contain; }

        .qty-switch {
            display: inline-flex;
            align-items: center;
            background: var(--soft-gray);
            border-radius: 50px;
            padding: 5px;
        }
        .q-btn {
            width: 32px; height: 32px;
            border-radius: 50%;
            border: none;
            background: white;
            font-weight: 800;
            transition: 0.2s;
        }
        .q-btn:hover { background: var(--accent-gold); }

        .summary-glass {
            background: var(--premium-white);
            border-radius: 30px;
            padding: 35px;
            position: sticky; top: 30px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 10px 30px rgba(0,0,0,0.02);
        }

        .line-item { display: flex; justify-content: space-between; margin-bottom: 12px; font-weight: 500; color: #64748b; }
        .grand-total {
            margin-top: 25px;
            padding-top: 20px;
            border-top: 2px dashed #e2e8f0;
            font-size: 1.8rem;
            font-weight: 800;
            color: var(--primary-dark);
        }

        .btn-checkout {
            width: 100%;
            background: var(--primary-dark);
            color: white;
            padding: 18px;
            border-radius: 18px;
            font-weight: 700;
            border: none;
            margin-top: 25px;
            transition: 0.4s;
            box-shadow: 0 10px 20px rgba(15, 23, 42, 0.2);
        }
        .btn-checkout:hover {
            background: var(--accent-gold);
            color: var(--primary-dark);
            transform: translateY(-5px);
        }

        .promo-pill {
            background: #fffdf5;
            border: 2px dashed var(--accent-gold);
            border-radius: 15px;
            padding: 15px;
            margin-bottom: 25px;
        }

        @media (max-width: 992px) {
            .premium-wrapper { grid-template-columns: 1fr; }
        }
    </style>
</head>

<body>

<%@ include file="header.jsp" %>

<div class="cart-header">
    <div class="container text-center">
        <h1 class="fw-800 animate__animated animate__fadeInDown">Secure Shopping Cart</h1>
        <p class="opacity-75">Review your selections and proceed to a taste of tradition.</p>
    </div>
</div>

<div class="container pb-5">
    <div class="premium-wrapper">
        <div class="cart-items-column animate__animated animate__fadeInLeft">
            <%
                Object uIdObj = session.getAttribute("user_id");
                if (uIdObj == null) uIdObj = session.getAttribute("uid");
                int user_id = 0;
                if (uIdObj != null) {
                    user_id = (uIdObj instanceof Integer) ? (Integer) uIdObj : Integer.parseInt(uIdObj.toString());
                }
                int subtotal = 0;
                boolean empty = true;
                String promoCode = request.getParameter("promoCode");
                double discount = 0;

                try (Connection con = DatabaseManager.getConnection()) {
                    String sql = "SELECT c.*, p.product_category FROM cart c JOIN products p ON c.product_name = p.product_name WHERE c.user_id = ?";
                    try (PreparedStatement ps = con.prepareStatement(sql)) {
                        ps.setInt(1, user_id);
                        try (ResultSet rs = ps.executeQuery()) {
                            while(rs.next()){
                                empty = false;
                                String pName = rs.getString("product_name");
                                int price = rs.getInt("price");
                                int qty = rs.getInt("qty");
                                subtotal += (price * qty);
            %>
            <div class="item-box">
                <div class="img-container me-4">
                    <img src="<%= (rs.getString("image") != null ? rs.getString("image") : "") %>" alt="Product">
                </div>
                <div class="flex-grow-1">
                    <span class="badge bg-light text-muted mb-1"><%= (rs.getString("product_category") != null ? rs.getString("product_category") : "") %></span>
                    <h5 class="fw-800 mb-1 text-uppercase"><%= (pName != null ? pName : "") %></h5>
                    <div class="text-success fw-bold fs-5">&#8377; <%= price %></div>
                </div>
                <div class="text-end">
                    <div class="qty-switch mb-2">
                        <button class="q-btn" onclick="updateQty('<%= (pName != null ? pName.replace("'", "\\'") : "") %>', 'minus')"><i class="fa-solid fa-minus"></i></button>
                        <span class="mx-3 fw-800"><%= qty %></span>
                        <button class="q-btn" onclick="updateQty('<%= (pName != null ? pName.replace("'", "\\'") : "") %>', 'add')"><i class="fa-solid fa-plus"></i></button>
                    </div>
                    <button class="btn btn-link text-danger text-decoration-none fw-600 p-0" onclick="updateQty('<%= (pName != null ? pName.replace("'", "\\'") : "") %>', 'delete')">
                        <i class="fa-solid fa-trash-can me-1"></i> Remove
                    </button>
                </div>
            </div>
            <% 
                            }
                        }
                    }
                    if(!empty && promoCode != null && !promoCode.trim().isEmpty()) {
                        try (PreparedStatement psP = con.prepareStatement("SELECT discount_percentage FROM promo WHERE code_name = ?")) {
                            psP.setString(1, promoCode.trim());
                            try (ResultSet rsP = psP.executeQuery()) {
                                if(rsP.next()) discount = subtotal * (rsP.getInt(1)/100.0);
                            }
                        }
                    }
                } catch(Exception ignored) {}
                
                if(empty) {
            %>
            <div class="item-box justify-content-center py-5">
                <div class="text-center">
                    <i class="fa-solid fa-basket-shopping display-1 text-light mb-4"></i>
                    <h3 class="text-muted fw-800">Your basket is empty</h3>
                    <a href="products.jsp" class="btn btn-dark mt-3 px-4 py-2" style="border-radius: 12px;">Start Shopping</a>
                </div>
            </div>
            <% } %>
        </div>

        <div class="summary-column animate__animated animate__fadeInRight">
            <div class="summary-glass">
                <h4 class="fw-800 mb-4">Order Summary</h4>
                
                <div class="promo-pill">
                    <label class="small fw-800 text-muted mb-2 text-uppercase">Promo Code</label>
                    <div class="input-group">
                        <input type="text" id="pInput" class="form-control border-0 bg-transparent" placeholder="Enter Code" value="<%= (promoCode != null) ? promoCode : "" %>">
                        <button class="btn btn-warning fw-800 px-3" onclick="applyPromo()" style="border-radius: 10px;">Apply</button>
                    </div>
                </div>

                <div class="line-item"><span>Subtotal</span><span>&#8377; <%= subtotal %></span></div>
                <% if(discount > 0) { %>
                <div class="line-item text-success"><span>Savings</span><span>- &#8377; <%= (int)discount %></span></div>
                <% } %>
                <% int ship = (subtotal > 0 && subtotal < 1000) ? 100 : 0; %>
                <div class="line-item"><span>Shipping</span><span><%= (ship == 0 && !empty) ? "FREE" : "&#8377; "+ship %></span></div>
                
                <div class="grand-total d-flex justify-content-between align-items-center">
                    <span>Total</span>
                    <span>&#8377; <%= (int)(subtotal + ship - discount) %></span>
                </div>

                <button class="btn-checkout" onclick="processCheckout()">
                    PROCEED TO CHECKOUT <i class="fa-solid fa-arrow-right-long ms-2"></i>
                </button>

                <p class="text-center mt-4 mb-0">
                    <a href="products.jsp" class="text-muted text-decoration-none small fw-600">
                        <i class="fa-solid fa-chevron-left me-1"></i> Back to Products
                    </a>
                </p>
            </div>
        </div>
    </div>
</div>

<script>
    function applyPromo() {
        let code = document.getElementById("pInput").value;
        window.location.href = "cart.jsp?promoCode=" + encodeURIComponent(code);
    }
    function updateQty(name, action) {
        fetch('addtocart.jsp?name=' + encodeURIComponent(name) + '&action=' + action)
        .then(() => location.reload());
    }
    function processCheckout() {
        if(<%= empty %>) {
            return alert("Cart is empty");
        }
        
        let subtotal = "<%= subtotal %>";
        let discount = "<%= (int)discount %>";
        let shipping = "<%= (subtotal > 0 && subtotal < 1000) ? 100 : 0 %>";
        let finalTotal = "<%= (int)(subtotal + ((subtotal > 0 && subtotal < 1000) ? 100 : 0) - discount) %>";
        
        let url = "checkout.jsp?subtotal=" + subtotal + 
                  "&discount=" + discount + 
                  "&shipping=" + shipping + 
                  "&final_total=" + finalTotal;
                  
        window.location.href = url;
    }
</script>
</body>
</html>