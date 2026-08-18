<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 👉 Server mathi admin ni identity kadhi nakho
    session.removeAttribute("admin_id");
    session.removeAttribute("username"); // Jo tame username set karyu hoy to

    // 👉 Aakhu session khali kari nakho
    session.invalidate();

    // 👉 Have login page par dhakeli dyo
    response.sendRedirect("admin_login.jsp?msg=logged_out");
    return; // 🔥 Aa line add kari dyo jethi security perfect rahe
%>
