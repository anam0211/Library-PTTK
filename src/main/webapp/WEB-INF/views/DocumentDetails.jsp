<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.SQLException,vn.edu.library.dao.*,vn.edu.library.model.*" %>
<%@ include file="common/reader-access.jspf" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setHeader("Cache-Control", "no-store");
    if (!"GET".equals(request.getMethod())) { response.sendError(405); return; }
    request.setAttribute("tieuDe", "Chi tiết tài liệu");
    request.setAttribute("demoRole", "reader");
    request.setAttribute("pageId", "detail");
    request.setAttribute("keyword", request.getParameter("keyword"));
    String value = request.getParameter("titleId");
    if (value == null) value = request.getParameter("ma");
    try {
        int titleId = Integer.parseInt(value == null ? "0" : value.replaceFirst("^DT", ""));
        if (titleId <= 0) throw new NumberFormatException();
        try (DocumentTitleDAO dao = new DocumentTitleDAO()) {
            DocumentTitle2 document = dao.getDetails(titleId);
            request.setAttribute("document", document);
            if (document != null)
                request.setAttribute("copies", new DocumentCopyDAO(dao.connection()).getCopiesByTitle(titleId));
        }
    } catch (NumberFormatException error) {
        request.setAttribute("errorMessage", "Không tìm thấy tài liệu bạn yêu cầu. Vui lòng quay lại danh sách.");
    } catch (SQLException error) {
        application.log("Document details SQLState=" + error.getSQLState());
        request.setAttribute("errorMessage", "Không thể đọc dữ liệu MySQL. Vui lòng thử lại.");
    }
    if (request.getAttribute("document") == null && request.getAttribute("errorMessage") == null)
        request.setAttribute("errorMessage", "Không tìm thấy tài liệu bạn yêu cầu. Vui lòng quay lại danh sách.");
%>
<%@ include file="common/header.jspf" %>
<main class="shell">
<section id="detail-screen" aria-labelledby="detail-title" data-screen="detail">
      <div class="workspace">
        <div class="page-heading with-action">
          <h1 class="screen-title" id="detail-title" tabindex="-1">Chi tiết tài liệu</h1>
          <c:url var="backUrl" value="/tim-tai-lieu"><c:param name="keyword" value="${keyword}" /></c:url>
          <button class="button neutral" id="back-to-results" type="button" data-url="<c:out value='${backUrl}' />">Quay lại danh sách</button>
        </div>
        <p class="message demo-error" id="detail-message" role="alert" ${empty errorMessage ? 'hidden' : ''}><c:out value="${errorMessage}" /></p>
        <section ${empty document ? 'hidden' : ''} class="document-overview" aria-labelledby="document-name">
          <div class="document-cover ${not empty document.coverImage ? 'has-cover' : ''}" role="img" id="document-cover" aria-label="Bìa minh họa tài liệu">
            <c:choose><c:when test="${not empty document.coverImage}">
              <c:url var="coverUrl" value="${document.coverImage}" />
              <img class="cover-image" src="<c:out value='${coverUrl}' />" alt="<c:out value='${document.titleName}' />">
            </c:when><c:otherwise>
            <span class="cover-brand">LIBMAN</span>
            <span class="cover-rule" aria-hidden="true"></span>
            <span class="cover-title" id="cover-title"><c:out value="${document.titleName}" default="Chưa có thông tin" /></span>
            <span class="cover-author" id="cover-author"><c:out value="${document.authors}" default="Chưa có thông tin" /></span>
            <span class="cover-footer">TÀI LIỆU THƯ VIỆN</span>
            </c:otherwise></c:choose>
          </div>
          <div class="document-information">
            <h2 id="document-name"><c:out value="${document.titleName}" default="Chưa có thông tin" /></h2>
            <dl class="document-facts">
              <div><dt>Mã đầu</dt><dd class="code" id="document-code"><c:out value="${document.code}" default="Chưa có thông tin" /></dd></div>
              <div><dt>Lần xuất bản</dt><dd id="document-edition"><c:out value="${document.edition}" default="Chưa có thông tin" /></dd></div>
              <div><dt>Loại tài liệu</dt><dd id="document-type"><c:out value="${document.typeName}" default="Chưa có thông tin" /></dd></div>
              <div><dt>Ngôn ngữ</dt><dd id="document-language"><c:out value="${document.language}" default="Chưa có thông tin" /></dd></div>
              <div><dt>Tác giả</dt><dd id="document-author"><c:out value="${document.authors}" default="Chưa có thông tin" /></dd></div>
              <div><dt>Số trang</dt><dd id="document-pages"><c:out value="${document.pageCount}" default="Chưa có thông tin" /></dd></div>
              <div><dt>Nhà xuất bản</dt><dd id="document-publisher"><c:out value="${document.publisherName}" default="Chưa có thông tin" /></dd></div>
              <div><dt>ISBN</dt><dd id="document-isbn"><c:out value="${document.isbn}" default="Chưa có thông tin" /></dd></div>
              <div><dt>Năm xuất bản</dt><dd id="document-year"><c:out value="${document.publicationYear}" default="Chưa có thông tin" /></dd></div>
            </dl>
          </div>
        </section>
        <section ${empty document ? 'hidden' : ''} class="document-description" aria-labelledby="description-title">
          <h2 id="description-title">Mô tả nội dung</h2>
          <p id="document-description"><c:out value="${document.description}" default="Chưa có thông tin" /></p>
        </section>
        <section ${empty document ? 'hidden' : ''} class="table-section" aria-labelledby="copies-title">
          <div class="section-head">
            <h2 id="copies-title">Danh sách bản tài liệu</h2>
            <span class="quantity" id="available-total" role="status">Có thể mượn về: <c:out value="${document.availableCopyCount}" /> bản</span>
          </div>
          <div class="table-wrap" id="copies-table-wrap" ${empty copies ? 'hidden' : ''} tabindex="0" role="region" aria-label="Danh sách bản tài liệu">
            <table class="document-copies" aria-labelledby="copies-title">
              <thead>
                <tr>
                  <th scope="col">Mã bản</th>
                  <th scope="col">Vị trí</th>
                  <th scope="col">Tình trạng</th>
                  <th scope="col">Trạng thái</th>
                  <th scope="col">Hình thức</th>
                </tr>
              </thead>
              <tbody id="copies-rows"><c:forEach var="copy" items="${copies}">
                <tr><td class="code"><c:out value="${copy.copyCode}" /></td><td class="code"><c:out value="${copy.location}" /></td>
                <td><c:out value="${copy.physicalCondition}" /></td><td><span class="result-state ${copy.copyStatus == 'Sẵn sàng' ? '' : 'unavailable'}"><c:out value="${copy.copyStatus}" /></span></td>
                <td><c:out value="${copy.usageType}" /></td></tr></c:forEach></tbody>
            </table>
          </div>
          <p class="empty" id="copies-empty" ${not empty copies ? 'hidden' : ''}>Chưa có bản tài liệu nào trong danh mục.</p>
        </section>
      </div>
    </section>

</main>
<%@ include file="common/footer.jspf" %>
