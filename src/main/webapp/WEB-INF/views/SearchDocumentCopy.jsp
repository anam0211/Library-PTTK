<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="common/lending-session.jspf" %>
<%
    synchronized (session) {
        request.setAttribute("tieuDe", "Thêm tài liệu");
        request.setAttribute("pageId", "copies");
        LoanDraft draft = (LoanDraft) session.getAttribute("libman.loanDraft");
        if (!"GET".equals(request.getMethod())) { response.sendError(405); return; }
        String copyCode = request.getParameter("copyCode");
        request.setAttribute("copyQuery", copyCode);
        request.setAttribute("copySearched", copyCode != null);
        try (ReaderDAO readers = new ReaderDAO()) {
            request.setAttribute("librarian", readers.getLibrarian(signedInMember.getUsername()));
            BorrowingContext borrowing = draft == null ? null : loadBorrowingContext(readers, draft.getReaderId());
            if (draft == null) request.setAttribute("errorMessage", "Hãy chọn bạn đọc trước khi lập phiếu.");
            request.setAttribute("borrowing", borrowing);
            if (copyCode != null && !copyCode.isBlank() && copyCode.length() <= 255) {
                DocumentCopy2 foundCopy = new DocumentCopyDAO(readers.connection()).findByCode(copyCode.trim());
                request.setAttribute("foundCopy", foundCopy);
                if (foundCopy != null) {
                    request.setAttribute("conditions", conditions(foundCopy));
                    String error = draft == null ? "Hãy chọn bạn đọc trước." : copyError(foundCopy, draft, borrowing);
                    request.setAttribute("copyError", error);
                    request.setAttribute("canPick", error.isEmpty());
                }
            }
        } catch (SQLException error) {
            logSql(error);
            request.setAttribute("errorMessage", "Không thể đọc dữ liệu MySQL. Kiểm tra kết nối rồi thử lại.");
        }

        request.setAttribute("draft", draft);
        request.setAttribute("hasDraft", draft != null && draft.getSize() > 0);
%>
<%@ include file="common/header.jspf" %>
<main class="shell">
<section id="copies-screen" aria-labelledby="copies-title" data-screen="copies">
      <div class="workspace">
        <div class="page-heading">
          <h1 class="screen-title" id="copies-title" tabindex="-1">Thêm tài liệu</h1>
        </div>
        <form class="panel search-form" id="copy-form" method="get" action="<c:url value='/tim-ban-tai-lieu' />" role="search" aria-label="Tìm bản tài liệu">
          <label for="copy-query">Mã bản tài liệu</label>
          <div class="search-controls">
            <div class="search-input">
              <span class="lens" aria-hidden="true"></span>
              <input id="copy-query" name="copyCode" maxlength="255" value="<c:out value='${copyQuery}' />" type="search" placeholder="Nhập mã bản, ví dụ BT001" autocomplete="off" autocapitalize="characters" required>
            </div>
            <button class="button primary" type="submit">Tìm kiếm</button>
          </div>
        </form>
        <section class="table-section" id="copy-result" aria-labelledby="copy-result-title" ${not copySearched ? 'hidden' : ''}>
          <div class="section-head">
            <h2 id="copy-result-title">Kết quả tìm kiếm</h2>
          </div>
          <div class="table-wrap" id="copy-table-wrap" ${empty foundCopy ? 'hidden' : ''}>
            <table class="copy-table" aria-labelledby="copy-result-title">
              <thead>
                <tr>
                  <th scope="col">Mã bản</th>
                  <th scope="col">Mã đầu</th>
                  <th class="title-col" scope="col">Tên tài liệu</th>
                  <th scope="col">Vị trí</th>
                  <th scope="col">Trạng thái / Hình thức</th>
                </tr>
              </thead>
              <tbody id="copy-rows"><c:if test="${not empty foundCopy}"><tr>
                <td class="code"><c:out value="${foundCopy.copyCode}" /></td><td class="code"><c:out value="${foundCopy.titleCode}" /></td>
                <td><c:out value="${foundCopy.titleName}" /></td><td class="code"><c:out value="${foundCopy.location}" /></td>
                <td><span class="result-state ${foundCopy.available ? '' : 'unavailable'}"><c:out value="${foundCopy.copyStatus}" /></span><span class="result-mode"> / <c:out value="${foundCopy.usageType}" /></span></td>
              </tr></c:if></tbody>
            </table>
          </div>
          <div class="loan-inspection" id="copy-inspection" ${empty foundCopy ? 'hidden' : ''}>
            <div class="loan-field">
              <label for="loan-condition">Tình trạng lúc mượn</label>
              <select id="loan-condition" name="condition" form="add-copy-form" required ${canPick ? '' : 'disabled'}><c:forEach var="condition" items="${conditions}">
                <option value="<c:out value='${condition}' />" ${condition == foundCopy.physicalCondition ? 'selected' : ''}><c:out value="${condition}" /></option></c:forEach></select>
            </div>
            <div class="loan-field">
              <label for="loan-condition-note">Ghi chú tình trạng <span class="optional">(không bắt buộc)</span></label>
              <textarea id="loan-condition-note" name="note" form="add-copy-form" rows="2" maxlength="255" placeholder="Ví dụ: Bìa trầy nhẹ, góc trang bị gấp…" ${canPick ? '' : 'disabled'}></textarea>
            </div>
          </div>
          <p class="empty" id="copy-empty" role="status" ${not empty foundCopy ? 'hidden' : ''}>Không tìm thấy bản tài liệu phù hợp.</p>
          <p class="message" id="copy-message" role="alert" ${empty copyError ? 'hidden' : ''}><c:out value="${copyError}" /></p>
        </section>
        <c:if test="${not empty errorMessage}"><p class="message" role="alert"><c:out value="${errorMessage}" /></p></c:if><div class="actions">
          <button class="button neutral" id="back-to-loan" type="button" data-url="<c:url value='/cho-muon-tai-lieu' />">Quay lại</button>
          <form id="add-copy-form" class="action-form" method="post" action="<c:url value='/cho-muon-tai-lieu' />"><input type="hidden" name="csrf" value="<c:out value='${csrf}' />"><input type="hidden" name="draftId" value="<c:out value='${draft.token}' />"><input type="hidden" name="action" value="add"><input type="hidden" name="copyCode" value="<c:out value='${foundCopy.copyCode}' />"><button class="button primary" id="add-copy" type="submit" ${canPick ? '' : 'disabled'}>Thêm vào danh sách</button></form>
        </div>
      </div>
    </section>

</main>
<%@ include file="common/ExitConfirmation.jspf" %>
<%@ include file="common/footer.jspf" %>

<% } %>
