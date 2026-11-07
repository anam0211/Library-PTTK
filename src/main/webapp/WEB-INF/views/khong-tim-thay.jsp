<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="common/header.jspf" %>
<main class="panel">
    <div class="section-heading"><h1>KHÔNG TÌM THẤY TÀI LIỆU</h1></div>
    <p class="not-found-message">Tài liệu hoặc trang bạn yêu cầu không tồn tại. Vui lòng quay lại tìm kiếm.</p>
    <c:url var="quayLaiUrl" value="/tim-tai-lieu">
        <c:if test="${tuKhoa != null}"><c:param name="tenTaiLieu" value="${tuKhoa}" /></c:if>
    </c:url>
    <a class="button button-secondary" href="<c:out value='${quayLaiUrl}' />">Quay lại tìm kiếm</a>
</main>
<%@ include file="common/footer.jspf" %>
