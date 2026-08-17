<%@ page import="java.sql.*" %>
    <%@ page import="com.vimal.utils.DatabaseManager" %>

        <% //======================================================// 1️ SESSION VALIDATION - CHECK IF USER IS LOGGED IN
            //======================================================// Retrieve user_id from session object Object
            userIdObj=session.getAttribute("user_id"); // If user_id is not found in session, return 401 Unauthorized
            status if(userIdObj==null) { response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); return; // Stop
            further execution } // Convert session object to integer userId int userId=(Integer) userIdObj;
            //======================================================// 2️ GET REQUEST PARAMETERS FROM CLIENT (FORM/AJAX)
            //======================================================// Product name String
            name=request.getParameter("name"); // Product price (received as String) String
            priceStr=request.getParameter("price"); // Product image path String img=request.getParameter("img"); //
            Action type: can be 'add' , 'minus' , or 'delete' String action=request.getParameter("action"); // Continue
            only if product name is provided if(name !=null) { Connection con=null; try {
            //======================================================// 3️ DATABASE CONNECTION (MySQL JDBC)
            //======================================================// Load MySQL JDBC Driver // Establish connection
            with database con=DatabaseManager.getConnection();
            //======================================================// 4️ ADD PRODUCT LOGIC (Default OR action="add" )
            //======================================================if ("add".equals(action) || action==null) { // Check
            if product already exists in cart for this user String
            checkQuery="SELECT * FROM cart WHERE user_id=? AND product_name=?" ; PreparedStatement
            checkPs=con.prepareStatement(checkQuery); checkPs.setInt(1, userId); checkPs.setString(2, name); ResultSet
            rs=checkPs.executeQuery(); if(rs.next()) { // -------------------------------------------------- // If
            product already exists → Increase quantity by 1 // --------------------------------------------------
            PreparedStatement
            up=con.prepareStatement( "UPDATE cart SET qty = qty + 1 WHERE user_id=? AND product_name=?" ); up.setInt(1,
            userId); up.setString(2, name); up.executeUpdate(); } else if(priceStr !=null && img !=null) { //
            -------------------------------------------------- // If product does NOT exist → Insert new row in cart //
            -------------------------------------------------- PreparedStatement
            ins=con.prepareStatement( "INSERT INTO cart (user_id, product_name, price, image, qty) VALUES (?, ?, ?, ?, 1)"
            ); ins.setInt(1, userId); ins.setString(2, name); // Convert price string into integer before storing
            ins.setInt(3, Integer.parseInt(priceStr)); ins.setString(4, img); ins.executeUpdate(); } }
            //======================================================// 5️ MINUS LOGIC (Decrease Quantity)
            //======================================================else if ("minus".equals(action)) { // Decrease
            quantity only if qty> 1
            PreparedStatement minusPs = con.prepareStatement(
            "UPDATE cart SET qty = qty - 1 WHERE user_id=? AND product_name=? AND qty > 1"
            );

            minusPs.setInt(1, userId);
            minusPs.setString(2, name);
            minusPs.executeUpdate();
            }

            // ======================================================
            // 6️ DELETE LOGIC (Remove Product From Cart)
            // ======================================================
            else if ("delete".equals(action)) {

            // Delete specific product for this user
            PreparedStatement delPs = con.prepareStatement(
            "DELETE FROM cart WHERE user_id=? AND product_name=?"
            );

            delPs.setInt(1, userId);
            delPs.setString(2, name);
            delPs.executeUpdate();
            }

            } catch(Exception e) {

            // ======================================================
            // 7️ ERROR HANDLING
            // ======================================================
            // Print error details in server console for debugging
            e.printStackTrace();

            } finally {

            // ======================================================
            // 8 CLOSE DATABASE CONNECTION (IMPORTANT)
            // ======================================================
            if(con != null)
            con.close();
            }
            }
            %>