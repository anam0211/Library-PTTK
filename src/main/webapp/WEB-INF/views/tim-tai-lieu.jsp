<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="common/header.jspf" %>
<main class="panel search-panel">
    <div class="section-heading"><h1>TÌM KIẾM TÀI LIỆU</h1></div>
    <form class="search-form" action="<c:url value='/tim-tai-lieu' />" method="get">
        <div class="search-field">
            <label for="tenTaiLieu">Tên tài liệu</label>
            <input id="tenTaiLieu" name="tenTaiLieu" type="search"
                   value="<c:out value='${tuKhoa}' />" placeholder="Nhập tên tài liệu">
        </div>
        <button class="button button-primary search-button" type="submit">Tìm kiếm</button>
    </form>

    <section class="search-results" aria-labelledby="ketQuaHeading">
        <h2 id="ketQuaHeading">Kết quả tìm kiếm</h2>
        <c:choose>
            <c:when test="${daTim}">
                <div class="table-scroll">
                    <table class="result-table">
                        <caption class="visually-hidden">Danh sách tài liệu tìm được theo tên</caption>
                        <thead><tr><th scope="col">Mã đầu</th><th scope="col">Tên tài liệu</th><th scope="col">Tác giả</th><th scope="col">Có thể mượn</th><th scope="col">Thao tác</th></tr></thead>
                        <tbody>
                        <c:forEach var="taiLieu" items="${ketQua}">
                            <c:url var="chiTietUrl" value="/chi-tiet-tai-lieu">
                                <c:param name="ma" value="${taiLieu.maTaiLieu}" />
                                <c:param name="tenTaiLieu" value="${tuKhoa}" />
                            </c:url>
                            <tr>
                                <td><c:out value="${taiLieu.maTaiLieu}" /></td>
                                <td><c:out value="${taiLieu.tenTaiLieu}" /></td>
                                <td><c:out value="${taiLieu.tacGia}" /></td>
                                <td><c:out value="${taiLieu.soBanCoTheMuon}" /></td>
                                <td><a class="detail-link" href="<c:out value='${chiTietUrl}' />">Xem chi tiết<span class="visually-hidden"> <c:out value="${taiLieu.tenTaiLieu}" /></span></a></td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty ketQua}">
                            <tr><td colspan="5" class="empty-message">Không tìm thấy tài liệu phù hợp. Vui lòng thử tên khác.</td></tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise><p class="search-hint">Nhập tên tài liệu và nhấn Tìm kiếm. Để trống để xem tất cả tài liệu.</p></c:otherwise>
        </c:choose>
    </section>
    <a class="button button-secondary back-button" href="<c:url value='/trang-chu' />">Quay lại</a>
</main>
<%@ include file="common/footer.jspf" %>
