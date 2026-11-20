<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="common/lending-session.jspf" %>
<%
    synchronized (session) {
        request.setAttribute("tieuDe", "Trang nhân viên");
        request.setAttribute("pageId", "home");
        LoanDraft draft = (LoanDraft) session.getAttribute("libman.loanDraft");
        if (!"GET".equals(request.getMethod())) { response.sendError(405); return; }
        try (ReaderDAO readers = new ReaderDAO()) {
            request.setAttribute("librarian", readers.getLibrarian(signedInMember.getUsername()));
        } catch (SQLException error) {
            logSql(error);
            request.setAttribute("errorMessage", "Không thể đọc dữ liệu MySQL. Kiểm tra cấu hình kết nối rồi thử lại.");
        }

        request.setAttribute("draft", draft);
        request.setAttribute("hasDraft", draft != null && draft.getSize() > 0);
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
