<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.SQLException,vn.edu.library.dao.*,vn.edu.library.model.*" %>
<%@ include file="common/reader-access.jspf" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setHeader("Cache-Control", "no-store");
    if (!"GET".equals(request.getMethod())) { response.sendError(405); return; }
    request.setAttribute("tieuDe", "Tìm kiếm tài liệu");
    request.setAttribute("demoRole", "reader");
    request.setAttribute("pageId", "search");
    String keyword = request.getParameter("keyword");
    if (keyword == null) keyword = request.getParameter("tenTaiLieu");
    request.setAttribute("keyword", keyword == null ? "" : keyword);
    request.setAttribute("searched", keyword != null);
    if (keyword != null) {
        if (keyword.isBlank()) request.setAttribute("errorMessage", "Nhập tên tài liệu cần tìm.");
        else if (keyword.length() > 200) request.setAttribute("errorMessage", "Tên tài liệu tối đa 200 ký tự.");
        else try (DocumentTitleDAO dao = new DocumentTitleDAO()) {
            request.setAttribute("titles", dao.searchByName(keyword));
        } catch (SQLException error) {
            application.log("Document search SQLState=" + error.getSQLState());
            request.setAttribute("errorMessage", "Không thể đọc dữ liệu MySQL. Kiểm tra kết nối rồi tìm lại.");
        }
    }
%>
<%@ include file="common/header.jspf" %>
<main class="shell">
<section id="search-screen" aria-labelledby="search-title" data-screen="search">
      <div class="workspace">
        <div class="page-heading">
          <h1 class="screen-title" id="search-title" tabindex="-1">Tìm kiếm tài liệu</h1>
        </div>
        <form class="panel search-form" id="book-form" method="get" action="<c:url value='/tim-tai-lieu' />" role="search" aria-label="Tìm kiếm tài liệu theo tên">
          <label for="book-query">Tên tài liệu</label>
          <div class="search-controls">
            <div class="search-input">
              <span class="lens" aria-hidden="true"></span>
              <input id="book-query" name="keyword" value="<c:out value='${keyword}' />" type="search" placeholder="Nhập tên tài liệu, ví dụ: Cơ sở dữ liệu" autocomplete="off" maxlength="200" required>
            </div>
            <button class="button primary" type="submit">Tìm kiếm</button>
          </div>
        </form>
        <section class="table-section" id="search-results" aria-labelledby="results-title" ${not searched ? 'hidden' : ''}>
          <div class="section-head">
            <h2 id="results-title">Kết quả tìm kiếm</h2>
          </div>
          <div class="table-wrap" id="result-table-wrap" ${empty titles ? 'hidden' : ''} tabindex="0" role="region" aria-label="Bảng kết quả tìm kiếm">
            <table aria-labelledby="results-title">
              <thead>
                <tr>
                  <th scope="col">Mã đầu</th>
                  <th class="title-col" scope="col">Tên tài liệu</th>
                  <th scope="col">Tác giả</th>
                  <th class="availability-col" scope="col">Có thể mượn</th>
                  <th class="action-col" scope="col">Thao tác</th>
                </tr>
              </thead>
              <tbody id="result-rows">
              <c:forEach var="title" items="${titles}">
                <c:url var="detailUrl" value="/chi-tiet-tai-lieu"><c:param name="titleId" value="${title.id}" /><c:param name="keyword" value="${keyword}" /></c:url>
                <tr><td class="code"><c:out value="${title.code}" /></td><td><c:out value="${title.titleName}" /></td>
                  <td><c:out value="${title.authors}" default="Chưa có thông tin" /></td>
                  <td class="availability-col"><span class="result-state ${title.availableCopyCount == 0 ? 'unavailable' : ''}"><c:out value="${title.availableCopyCount}" /></span></td>
                  <td class="action-col"><button id="view-<c:out value='${title.code}' />" type="button" class="table-action" data-url="<c:out value='${detailUrl}' />">Xem chi tiết</button></td></tr>
              </c:forEach>
              </tbody>
            </table>
          </div>
          <p class="empty" id="search-empty" ${not empty titles ? 'hidden' : ''}>Không tìm thấy tài liệu phù hợp.</p>
          <c:if test="${not empty errorMessage}"><p class="message" role="alert"><c:out value="${errorMessage}" /></p></c:if>
        </section>
        <div class="actions">
          <button class="button neutral" type="button" data-home>Quay lại</button>
        </div>
      </div>
    </section>

</main>
<%@ include file="common/footer.jspf" %>
