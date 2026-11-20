<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="common/lending-session.jspf" %>
<%
    synchronized (session) {
        request.setAttribute("tieuDe", "Chọn bạn đọc");
        request.setAttribute("pageId", "readers");
        LoanDraft draft = (LoanDraft) session.getAttribute("libman.loanDraft");
        if ("POST".equals(request.getMethod())) {
            if (!"selectReader".equals(request.getParameter("action"))) { response.sendError(400); return; }
            try (ReaderDAO readers = new ReaderDAO()) {
                int readerId = integer(request.getParameter("readerId"));
                if (readers.getById(readerId) == null) throw new LoanValidationException("Bạn đọc không tồn tại.");
                if (draft != null && draft.getSize() > 0)
                    throw new LoanValidationException("Hủy hoặc đổi bạn đọc để bỏ danh sách đang lập trước.");
                // Version 3: selecting the reader loads card, policy, current loans and unpaid fines.
                BorrowingContext borrowing = loadBorrowingContext(readers, readerId);
                session.setAttribute("libman.borrowing", borrowing);
                session.setAttribute("libman.loanDraft", new LoanDraft(readerId));
                session.removeAttribute("libman.savedLoanId");
            } catch (LoanValidationException error) {
                session.setAttribute("loanError", error.getMessage());
            } catch (SQLException error) {
                logSql(error);
                session.setAttribute("loanError", "Không thể đọc thông tin bạn đọc từ MySQL. Vui lòng thử lại.");
            }
            response.sendRedirect(response.encodeRedirectURL(request.getContextPath() + "/cho-muon-tai-lieu"));
            return;
        }
        String keyword = request.getParameter("keyword");
        if (keyword != null) session.setAttribute("readerKeyword", keyword);
        else keyword = (String) session.getAttribute("readerKeyword");
        request.setAttribute("keyword", keyword);
        request.setAttribute("searched", keyword != null);
        if (keyword != null && keyword.length() > 200) request.setAttribute("errorMessage", "Từ khóa tối đa 200 ký tự.");
        else if (keyword != null && keyword.isBlank()) request.setAttribute("errorMessage", "Nhập mã bạn đọc, mã thẻ hoặc họ tên.");
        else try (ReaderDAO readers = new ReaderDAO()) {
            request.setAttribute("librarian", readers.getLibrarian(signedInMember.getUsername()));
            List<Reader2> matches = readers.searchReader(keyword);
            for (Reader2 reader : matches) {
                LibraryCard2 card = readers.getUsableCard(reader.getId(), BorrowingContext.today());
                reader.setCard(card == null ? readers.getLatestCard(reader.getId()) : card);
            }
            request.setAttribute("readers", matches);
        } catch (SQLException error) {
            logSql(error);
            request.setAttribute("errorMessage", "Không thể đọc dữ liệu MySQL. Kiểm tra kết nối rồi tìm lại.");
        }

        request.setAttribute("draft", draft);
        request.setAttribute("hasDraft", draft != null && draft.getSize() > 0);
%>
<%@ include file="common/header.jspf" %>
<main class="shell">
<section id="readers-screen" aria-labelledby="readers-title" data-screen="readers">
      <div class="workspace">
        <div class="page-heading">
          <h1 class="screen-title" id="readers-title" tabindex="-1">Chọn bạn đọc</h1>
        </div>
        <form class="panel search-form" id="reader-form" method="get" action="<c:url value='/tim-ban-doc' />" role="search" aria-label="Tìm bạn đọc">
          <label for="reader-query">Mã bạn đọc, mã thẻ hoặc họ tên</label>
          <div class="search-controls">
            <div class="search-input">
              <span class="lens" aria-hidden="true"></span>
              <input id="reader-query" name="keyword" maxlength="200" value="<c:out value='${keyword}' />" type="search" placeholder="BD001, TD001 hoặc Nguyễn Văn An" autocomplete="off" required>
            </div>
            <button class="button primary" type="submit">Tìm kiếm</button>
          </div>
        </form>
        <section class="table-section" id="reader-results" aria-labelledby="reader-results-title" ${not searched ? 'hidden' : ''}>
          <div class="section-head">
            <h2 id="reader-results-title">Kết quả tìm kiếm</h2>
          </div>
          <div class="table-wrap" id="reader-table-wrap" ${empty readers ? 'hidden' : ''}>
            <table aria-labelledby="reader-results-title">
              <thead>
                <tr>
                  <th scope="col">Mã bạn đọc</th>
                  <th class="title-col" scope="col">Họ và tên</th>
                  <th scope="col">Mã thẻ</th>
                  <th scope="col">Hạn thẻ</th>
                  <th class="action-col" scope="col">Thao tác</th>
                </tr>
              </thead>
              <tbody id="reader-rows"><c:forEach var="reader" items="${readers}">
                <tr><td class="code"><c:out value="${reader.readerCode}" /></td><td><c:out value="${reader.fullName}" /></td>
                <td class="code"><c:out value="${reader.card.cardNumber}" default="Chưa có thẻ" /></td>
                <td><c:out value="${reader.card.expiryText}" default="—" /></td>
                <td class="action-col"><form method="post" action="<c:url value='/tim-ban-doc' />"><input type="hidden" name="csrf" value="<c:out value='${csrf}' />"><input type="hidden" name="draftId" value="<c:out value='${draft.token}' />">
                  <input type="hidden" name="action" value="selectReader"><input type="hidden" name="readerId" value="<c:out value='${reader.id}' />">
                  <button class="table-action" type="submit">Lập phiếu</button></form></td></tr>
              </c:forEach></tbody>
            </table>
          </div>
          <p class="empty" id="reader-empty" ${not empty readers ? 'hidden' : ''}>Không tìm thấy bạn đọc phù hợp.</p>
        </section>
        <c:if test="${not empty errorMessage}"><p class="message" role="alert"><c:out value="${errorMessage}" /></p></c:if>
        <div class="actions">
          <button class="button neutral" type="button" data-home>Quay lại</button>
        </div>
      </div>
    </section>

</main>
<%@ include file="common/footer.jspf" %>

<% } %>
