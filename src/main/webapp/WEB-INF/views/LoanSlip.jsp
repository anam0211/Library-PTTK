<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="common/lending-session.jspf" %>
<%
    synchronized (session) {
        request.setAttribute("tieuDe", "Phiếu mượn tài liệu");
        request.setAttribute("pageId", "slip");
        LoanDraft draft = (LoanDraft) session.getAttribute("libman.loanDraft");
        if ("POST".equals(request.getMethod())) {
            if (!"finish".equals(request.getParameter("action"))) { response.sendError(400); return; }
            try {
                checkDraft(draft, request.getParameter("draftId"));
                session.removeAttribute("libman.loanDraft");
                session.removeAttribute("libman.borrowing");
                session.removeAttribute("libman.savedLoanId");
            } catch (LoanValidationException error) {
                session.setAttribute("loanError", error.getMessage());
                response.sendRedirect(response.encodeRedirectURL(request.getContextPath() + "/cho-muon-tai-lieu"));
                return;
            }
            response.sendRedirect(response.encodeRedirectURL(request.getContextPath() + "/nhan-vien"));
            return;
        }
        String value = request.getParameter("loanId");
        int loanId = value == null && session.getAttribute("libman.savedLoanId") != null
                ? (Integer) session.getAttribute("libman.savedLoanId") : integer(value);
        try (LoanSlipDAO loans = new LoanSlipDAO()) {
            LoanSlip2 savedLoan = loans.getById(loanId);
            request.setAttribute("savedLoan", savedLoan);
            if (savedLoan == null) request.setAttribute("errorMessage", "Không tìm thấy phiếu mượn. Hãy chọn bạn đọc để lập phiếu.");
            else request.setAttribute("librarian", savedLoan.getLibrarian());
        } catch (SQLException error) {
            logSql(error);
            request.setAttribute("errorMessage", "Không thể đọc phiếu mượn từ MySQL. Vui lòng thử lại.");
        }

        request.setAttribute("draft", draft);
        request.setAttribute("hasDraft", draft != null && draft.getSize() > 0);
%>
<%@ include file="common/header.jspf" %>
<main class="shell">
<section id="slip-screen" aria-labelledby="slip-title" data-screen="slip">
      <p class="print-only" id="print-slip-id"><c:out value="${savedLoan.slipNumber}" /></p>
      <div class="workspace">
        <div class="page-heading">
          <h1 class="screen-title" id="slip-title" tabindex="-1">Phiếu mượn tài liệu</h1>
        </div>
        <c:if test="${not empty errorMessage}"><p class="message" role="alert"><c:out value="${errorMessage}" /></p></c:if><div class="receipt-notice" role="status" ${empty savedLoan ? 'hidden' : ''}>
          <strong>Cho mượn thành công</strong>
          <span aria-hidden="true">·</span>
          <span id="slip-number"><c:out value="${savedLoan.slipNumber}" /></span>
        </div>
        <dl class="panel receipt-info">
          <div class="receipt-reader">
            <dt>Bạn đọc</dt>
            <dd id="slip-reader"><c:out value="${savedLoan.reader.readerCode}" /> – <c:out value="${savedLoan.reader.fullName}" /></dd>
          </div>
          <div>
            <dt>Thẻ thư viện</dt>
            <dd id="slip-card"><c:out value="${savedLoan.libraryCard.cardNumber}" /></dd>
          </div>
          <div>
            <dt>Ngày mượn</dt>
            <dd id="slip-date"><c:out value="${savedLoan.borrowedAtText}" /></dd>
          </div>
          <div class="receipt-staff">
            <dt>Nhân viên cho mượn</dt>
            <dd id="slip-staff"><c:out value="${savedLoan.librarian.fullName}" /> · <c:out value="${savedLoan.librarian.code}" /></dd>
          </div>
        </dl>

        <section class="table-section" aria-labelledby="slip-items-title">
          <div class="section-head">
            <h2 id="slip-items-title">Tài liệu đã cho mượn</h2>
            <span class="quantity" id="slip-total"><c:out value="${savedLoan.loanDetails.size()}" /> bản</span>
          </div>
          <div class="table-wrap">
            <table aria-labelledby="slip-items-title">
              <thead>
                <tr>
                  <th scope="col">Mã bản</th>
                  <th class="title-col" scope="col">Tên tài liệu</th>
                  <th scope="col">Tình trạng lúc mượn</th>
                  <th scope="col">Hạn trả</th>
                </tr>
              </thead>
              <tbody id="slip-rows"><c:forEach var="detail" items="${savedLoan.loanDetails}"><tr>
                  <td class="code"><c:out value="${detail.documentCopy.copyCode}" /></td><td><c:out value="${detail.documentCopy.titleName}" /></td>
                  <td><c:out value="${detail.conditionAtLoan}" /><c:if test="${not empty detail.note}"><p class="condition-note"><c:out value="${detail.note}" /></p></c:if></td>
                  <td><c:out value="${detail.dueDateText}" /></td></tr></c:forEach></tbody>
            </table>
          </div>
        </section>
        <div class="actions end">
          <button class="button secondary" id="print-slip" type="button" ${empty savedLoan ? 'disabled' : ''}>In phiếu mượn</button>
          <form class="action-form" method="post" action="<c:url value='/phieu-muon' />"><input type="hidden" name="csrf" value="<c:out value='${csrf}' />"><input type="hidden" name="draftId" value="<c:out value='${draft.token}' />"><input type="hidden" name="action" value="finish"><button class="button primary" id="finish" type="submit">Hoàn tất</button></form>
        </div>
      </div>
    </section>

</main>
<%@ include file="common/footer.jspf" %>

<% } %>
