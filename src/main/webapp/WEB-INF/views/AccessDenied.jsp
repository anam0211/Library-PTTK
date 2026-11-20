<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("tieuDe","Không có quyền truy cập"); request.setAttribute("demoRole","reader"); request.setAttribute("pageId","forbidden"); %>
<%@ include file="common/header.jspf" %>
<main class="shell"><section class="workspace">
  <div class="page-heading"><h1 class="screen-title">Không có quyền truy cập</h1></div>
  <div class="home-content"><p class="home-greeting">Tài khoản của bạn không có quyền sử dụng trang này.</p>
  <a class="button neutral" href="<c:out value='${homeUrl}' />">Về trang chủ</a></div>
</section></main>
<%@ include file="common/footer.jspf" %>
