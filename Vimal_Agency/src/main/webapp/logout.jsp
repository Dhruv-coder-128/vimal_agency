<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Session mathi user details remove karo
    session.removeAttribute("username");
    session.removeAttribute("user_id");

    // Session ne completely destroy karo
    session.invalidate();

    // Login page par redirect karo
    response.sendRedirect("login.jsp");
%>
