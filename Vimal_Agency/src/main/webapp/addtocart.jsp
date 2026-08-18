<%@ page import="java.sql.*" %>
<%@ page import="com.vimal.utils.DatabaseManager" %>

<%
    // 1. SESSION VALIDATION
    Object userIdObj = session.getAttribute("user_id");
    if (userIdObj == null) {
        userIdObj = session.getAttribute("uid");
    }

    if (userIdObj == null) {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        return;
    }

    int userId = (userIdObj instanceof Integer) ? (Integer) userIdObj : Integer.parseInt(userIdObj.toString());

    // 2. GET REQUEST PARAMETERS
    String name = request.getParameter("name");
    String priceStr = request.getParameter("price");
    String img = request.getParameter("img");
    String action = request.getParameter("action");

    if (name != null) {
        Connection con = null;
        try {
            con = DatabaseManager.getConnection();

            if ("add".equals(action) || action == null) {
                String checkQuery = "SELECT * FROM cart WHERE user_id=? AND product_name=?";
                try (PreparedStatement checkPs = con.prepareStatement(checkQuery)) {
                    checkPs.setInt(1, userId);
                    checkPs.setString(2, name);
                    try (ResultSet rs = checkPs.executeQuery()) {
                        if (rs.next()) {
                            try (PreparedStatement up = con.prepareStatement("UPDATE cart SET qty = qty + 1 WHERE user_id=? AND product_name=?")) {
                                up.setInt(1, userId);
                                up.setString(2, name);
                                up.executeUpdate();
                            }
                        } else if (priceStr != null && img != null) {
                            try (PreparedStatement ins = con.prepareStatement("INSERT INTO cart (user_id, product_name, price, image, qty) VALUES (?, ?, ?, ?, 1)")) {
                                ins.setInt(1, userId);
                                ins.setString(2, name);
                                ins.setInt(3, (int) Math.round(Double.parseDouble(priceStr.trim())));
                                ins.setString(4, img);
                                ins.executeUpdate();
                            }
                        }
                    }
                }
            } else if ("minus".equals(action)) {
                try (PreparedStatement minusPs = con.prepareStatement("UPDATE cart SET qty = qty - 1 WHERE user_id=? AND product_name=? AND qty > 1")) {
                    minusPs.setInt(1, userId);
                    minusPs.setString(2, name);
                    minusPs.executeUpdate();
                }
            } else if ("delete".equals(action)) {
                try (PreparedStatement delPs = con.prepareStatement("DELETE FROM cart WHERE user_id=? AND product_name=?")) {
                    delPs.setInt(1, userId);
                    delPs.setString(2, name);
                    delPs.executeUpdate();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (con != null) {
                try { con.close(); } catch (Exception ignored) {}
            }
        }
    }
%>
