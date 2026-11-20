<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.SQLException,vn.edu.library.dao.*,vn.edu.library.model.*" %>
<%@ include file="common/reader-access.jspf" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setHeader("Cache-Control", "no-store");
    if (!"GET".equals(request.getMethod())) { response.sendError(405); return; }
    request.setAttribute("tieuDe", "Trang bạn đọc");
    request.setAttribute("demoRole", "reader");
    request.setAttribute("pageId", "home");
%>
<%@ include file="common/header.jspf" %>
<main class="shell">
<section id="home-screen" aria-labelledby="home-title" data-screen="home">
      <div class="workspace">
        <div class="page-heading">
          <h1 class="screen-title" id="home-title" tabindex="-1">Trang bạn đọc</h1>
        </div>
        <div class="home-content">
          <p class="home-greeting">Tra cứu thông tin tài liệu trong thư viện.</p>
          <button class="button primary" id="start-search" type="button">Tìm kiếm tài liệu</button>
        </div>
      </div>
    </section>
<noscript>Hãy bật JavaScript để sử dụng giao diện LibMan.</noscript>
</main>
<%@ include file="common/footer.jspf" %>
