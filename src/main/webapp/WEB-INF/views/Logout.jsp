<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    response.setHeader("Cache-Control", "no-store");
    if (!"POST".equals(request.getMethod())) { response.sendError(405); return; }
    if (session.getAttribute("csrf") == null || !session.getAttribute("csrf").equals(request.getParameter("csrf"))) {
        response.sendError(403); return;
    }
    session.invalidate();
    response.sendRedirect(request.getContextPath()+"/dang-nhap");
%>
