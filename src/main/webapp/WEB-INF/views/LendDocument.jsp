<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="common/lending-session.jspf" %>

<%
    synchronized (session) {
        request.setAttribute("tieuDe", "Cho mượn tài liệu");
        request.setAttribute("pageId", "lend");
        LoanDraft draft = (LoanDraft) session.getAttribute("libman.loanDraft");
        if ("POST".equals(request.getMethod())) {
            String action = request.getParameter("action");
            String destination = "/cho-muon-tai-lieu";
            try {
                checkDraft(draft, request.getParameter("draftId"));
                if ("cancel".equals(action) || "change".equals(action)) {
                    session.removeAttribute("libman.loanDraft");
                    session.removeAttribute("libman.borrowing");
                    session.removeAttribute("libman.savedLoanId");
                    destination = "change".equals(action) ? "/tim-ban-doc" : "/nhan-vien";
                } else if ("remove".equals(action)) {
                    if (draft != null) draft.remove(parameter(request, "copyCode").toUpperCase(Locale.ROOT));
                } else if ("confirm".equals(action) && draft == null && session.getAttribute("libman.savedLoanId") != null) {
                    destination = "/phieu-muon?loanId=" + session.getAttribute("libman.savedLoanId");
                } else if ("add".equals(action) || "confirm".equals(action)) {
                    if (draft == null) throw new LoanValidationException("Lượt lập phiếu đã kết thúc. Hãy chọn lại bạn đọc.");
                    try (ReaderDAO readers = new ReaderDAO()) {
                        BorrowingContext borrowing = loadBorrowingContext(readers, draft.getReaderId());
                        if ("add".equals(action)) {
                            // SearchDocumentCopy.jsp posts the selected code, condition and note here.
                            DocumentCopy2 foundCopy = new DocumentCopyDAO(readers.connection()).findByCode(parameter(request, "copyCode"));
                            // Mỗi request có đối tượng xử lý riêng, không dùng field chung của JSP.
                            class LendDocument {
                                public void addSelectedCopy(DocumentCopy2 foundCopy, String conditionAtLoan,
                                                            String note) throws LoanValidationException {
                                    String error = copyError(foundCopy, draft, borrowing);
                                    if (!error.isEmpty()) throw new LoanValidationException(error);
                                    LoanSlipDAO.validateInspection(conditionAtLoan, note);
                                    if (!conditions(foundCopy).contains(conditionAtLoan))
                                        throw new LoanValidationException("Chọn tình trạng từ danh sách.");
                                    draft.add(foundCopy.withInspection(conditionAtLoan, note));
                                }
                            }
                            LendDocument form = new LendDocument();
                            form.addSelectedCopy(foundCopy, parameter(request, "condition"), parameter(request, "note"));
                        } else {
                            Librarian2 librarian = readers.getLibrarian(signedInMember.getUsername());
                            try (LoanSlipDAO loans = new LoanSlipDAO()) {
                                LoanSlip2 savedLoan = loans.saveLoan(borrowing.getCard(), borrowing.getPolicy(), librarian,
                                        draft.getCopies().toArray(DocumentCopy2[]::new));
                                session.setAttribute("libman.savedLoanId", savedLoan.getId());
                                session.removeAttribute("libman.loanDraft");
                                session.removeAttribute("libman.borrowing");
                                destination = "/phieu-muon?loanId=" + savedLoan.getId();
                            }
                        }
                    }
                } else { response.sendError(400, "Thao tác không hợp lệ."); return; }
            } catch (LoanValidationException error) {
                session.setAttribute("loanError", error.getMessage());
            } catch (SQLException error) {
                logSql(error);
                session.setAttribute("loanError", "Không lưu được phiếu. Một bản có thể vừa được mượn hoặc kết nối gặp lỗi. Danh sách được giữ để kiểm tra và thử lại.");
            }
            response.sendRedirect(response.encodeRedirectURL(request.getContextPath() + destination));
            return;
        }
        try (ReaderDAO readers = new ReaderDAO()) {
            request.setAttribute("librarian", readers.getLibrarian(signedInMember.getUsername()));
            if (draft == null) request.setAttribute("errorMessage", "Hãy chọn bạn đọc trước khi lập phiếu.");
            else {
                // Refresh the context on every GET; draft changes never reserve database stock.
                BorrowingContext borrowing = loadBorrowingContext(readers, draft.getReaderId());
                session.setAttribute("libman.borrowing", borrowing);
                request.setAttribute("borrowing", borrowing);
                request.setAttribute("remaining", Math.max(0, borrowing.getRemaining() - draft.getSize()));
                request.setAttribute("canAdd", borrowing.isEligible() && draft.getSize() < borrowing.getRemaining());
                request.setAttribute("canSave", borrowing.isEligible() && draft.getSize() > 0 && draft.getSize() <= borrowing.getRemaining());
            }
        } catch (SQLException error) {
            logSql(error);
            request.setAttribute("errorMessage", "Không thể đọc dữ liệu MySQL. Kiểm tra cấu hình kết nối rồi thử lại.");
        }

        request.setAttribute("draft", draft);
        request.setAttribute("hasDraft", draft != null && draft.getSize() > 0);
%>
<%@ include file="common/header.jspf" %>
<main class="shell">
<section id="lend-screen" aria-labelledby="lend-title" data-screen="lend">
      <div class="workspace">
        <div class="page-heading">
          <h1 class="screen-title" id="lend-title" tabindex="-1">Cho mượn tài liệu</h1>
        </div>
        <section class="panel reader-card" ${empty borrowing.reader ? 'hidden' : ''} aria-labelledby="chosen-reader">
          <div class="reader-details">
            <div class="reader-heading">
              <h2 id="chosen-reader"><c:out value="${borrowing.reader.fullName}" default="Chưa có thông tin" /></h2>
              <span class="reader-code" id="chosen-reader-code"><c:out value="${borrowing.reader.readerCode}" default="Chưa có thông tin" /></span>
            </div>
            <p class="card-detail" id="chosen-card"><span>Thẻ <strong id="chosen-card-code"><c:out value="${borrowing.card.cardNumber}" default="Chưa có thông tin" /></strong></span><span class="card-expiry" id="chosen-card-expiry"><span id="chosen-card-expiry-label"><c:out value="${'Hạn thẻ:'}" default="Chưa có thông tin" /></span> <strong><time id="chosen-card-expiry-date"><c:out value="${borrowing.card.expiryText}" default="Chưa có thông tin" /></time></strong></span></p>
          </div>
          <div class="reader-tools">
            <span class="badge ${borrowing.eligible ? 'ok' : 'blocked'}" id="reader-eligibility">${borrowing.eligible ? 'Đủ điều kiện mượn' : 'Chưa đủ điều kiện mượn'}</span>
            <form class="action-form" method="post" action="<c:url value='/cho-muon-tai-lieu' />" ${hasDraft ? 'data-confirm="Bỏ lượt đang lập"' : ''}><input type="hidden" name="csrf" value="<c:out value='${csrf}' />"><input type="hidden" name="draftId" value="<c:out value='${draft.token}' />"><input type="hidden" name="action" value="change"><button class="button secondary" id="change-reader" type="submit">Đổi bạn đọc</button></form>
          </div>
          <dl class="reader-stats">
            <div class="reader-stat"><dt>Đang mượn</dt><dd id="active-loan-count"><c:out value="${borrowing.activeCount}" default="Chưa có thông tin" />/<c:out value="${borrowing.policy.maximumCopies}" /> bản</dd></div>
            <div class="reader-stat"><dt>Thời hạn mượn</dt><dd id="loan-period"><c:out value="${borrowing.policy.loanPeriodDays}" default="Chưa có thông tin" /> ngày</dd></div>
            <div class="reader-stat"><dt>Tiền phạt chưa nộp</dt><dd id="unpaid-fine"><c:out value="${borrowing.unpaidFineText}" default="Chưa có thông tin" /></dd></div>
          </dl>
        </section>
        <p class="message" id="lend-message" role="alert" ${empty errorMessage and empty borrowing.error ? 'hidden' : ''}><c:out value="${not empty errorMessage ? errorMessage : borrowing.error}" /></p>

        <section class="table-section" aria-labelledby="draft-titles">
          <div class="section-head">
            <h2 id="draft-titles">Tài liệu đang chọn</h2>
            <button class="button secondary" id="open-copy-search" type="button" data-url="<c:url value='/tim-ban-tai-lieu' />" ${canAdd ? '' : 'disabled'}>
              <span class="plus" aria-hidden="true">+</span> Thêm tài liệu
            </button>
          </div>
          <p class="empty" id="draft-empty" ${not empty draft.copies ? 'hidden' : ''}>Chưa có tài liệu nào được chọn.</p>
          <div class="table-wrap" id="draft-table-wrap" ${empty draft.copies ? 'hidden' : ''}>
            <table aria-labelledby="draft-titles">
              <thead>
                <tr>
                  <th scope="col">Mã bản</th>
                  <th class="title-col" scope="col">Tên tài liệu</th>
                  <th scope="col">Tình trạng lúc mượn</th>
                  <th scope="col">Hạn trả dự kiến</th>
                  <th class="action-col" scope="col">Thao tác</th>
                </tr>
              </thead>
              <tbody id="draft-rows"><c:forEach var="copy" items="${draft.copies}">
                <tr><td class="code"><c:out value="${copy.copyCode}" /></td><td><c:out value="${copy.titleName}" /></td>
                <td><c:out value="${copy.physicalCondition}" /><c:if test="${not empty copy.note}"><p class="condition-note"><c:out value="${copy.note}" /></p></c:if></td>
                <td><c:out value="${borrowing.dueDateText}" /></td><td class="action-col"><form method="post" action="<c:url value='/cho-muon-tai-lieu' />"><input type="hidden" name="csrf" value="<c:out value='${csrf}' />"><input type="hidden" name="draftId" value="<c:out value='${draft.token}' />">
                <input type="hidden" name="action" value="remove"><input type="hidden" name="copyCode" value="<c:out value='${copy.copyCode}' />">
                <button class="table-action" type="submit">Loại bỏ</button></form></td></tr></c:forEach></tbody>
            </table>
          </div>
          <div class="summary" id="draft-summary" role="status" ${empty draft.copies ? 'hidden' : ''}>
            <span>Đã chọn <strong id="draft-total"><c:out value="${draft.size}" /> bản</strong></span>
            <span class="summary-divider" aria-hidden="true">·</span>
            <span id="remaining-total"><span id="remaining-label">Có thể thêm</span> <strong id="remaining-count"><c:out value="${remaining}" default="0" /> bản</strong></span>
          </div>
        </section>
        <div class="actions end">
          <form class="action-form" method="post" action="<c:url value='/cho-muon-tai-lieu' />" ${hasDraft ? 'data-confirm="Bỏ lượt đang lập"' : ''}><input type="hidden" name="csrf" value="<c:out value='${csrf}' />"><input type="hidden" name="draftId" value="<c:out value='${draft.token}' />"><input type="hidden" name="action" value="cancel"><button class="button neutral" id="discard-loan" type="submit">Hủy</button></form>
          <form class="action-form" method="post" action="<c:url value='/cho-muon-tai-lieu' />"><input type="hidden" name="csrf" value="<c:out value='${csrf}' />"><input type="hidden" name="draftId" value="<c:out value='${draft.token}' />"><input type="hidden" name="action" value="confirm"><button class="button primary" id="confirm-loan" type="submit" ${canSave ? '' : 'disabled'}>Xác nhận cho mượn</button></form>
        </div>
      </div>
    </section>

</main>
<%@ include file="common/ExitConfirmation.jspf" %>
<%@ include file="common/footer.jspf" %>

<% } %>
