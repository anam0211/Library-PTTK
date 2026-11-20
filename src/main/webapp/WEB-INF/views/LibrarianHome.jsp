<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="common/lending-session.jspf" %>
<%
    synchronized (session) {
        request.setAttribute("tieuDe", "Trang nhân viên");
        request.setAttribute("pageId", "home");
        if (!"GET".equals(request.getMethod())) { response.sendError(405); return; }
%>
<%@ include file="common/header.jspf" %>
<main class="shell">
<section id="home-screen" aria-labelledby="home-title" data-screen="home">
      <div class="workspace">
        <div class="page-heading">
          <h1 class="screen-title" id="home-title" tabindex="-1">Trang nhân viên</h1>
        </div>
        <div class="home-content">
          <p class="home-greeting" id="greeting">Xin chào, <c:out value="${sessionScope.signedInMember.fullName}" /></p>
          <button class="button primary" id="start-lending" type="button">Cho mượn tài liệu</button>
        </div>
      </div>
    </section>
<noscript>Hãy bật JavaScript để sử dụng giao diện LibMan.</noscript>
</main>
<%@ include file="common/footer.jspf" %>

<% } %>
