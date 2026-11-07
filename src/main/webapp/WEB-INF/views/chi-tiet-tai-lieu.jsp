<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="common/header.jspf" %>
<c:url var="danhSachUrl" value="/tim-tai-lieu">
    <c:param name="tenTaiLieu" value="${tuKhoa}" />
</c:url>
<main class="panel detail-panel">
    <div class="section-heading detail-heading">
        <h1>CHI TIẾT TÀI LIỆU</h1>
        <a class="button button-secondary" href="<c:out value='${danhSachUrl}' />">Quay lại danh sách</a>
    </div>
    <section class="document-overview" aria-labelledby="tenTaiLieuHeading">
        <c:choose>
            <c:when test="${taiLieu.maTaiLieu == 'DT001'}">
                <img class="book-cover" src="<c:url value='/assets/images/co-so-du-lieu.svg' />" alt="Bìa minh họa giáo trình Cơ sở dữ liệu" width="140" height="200">
            </c:when>
            <c:otherwise>
                <div class="book-cover generic-cover" aria-label="Bìa minh họa tài liệu">
                    <span>LIBMAN</span><strong><c:out value="${taiLieu.tenTaiLieu}" /></strong><small>THƯ VIỆN</small>
                </div>
            </c:otherwise>
        </c:choose>
        <div class="document-info">
            <h2 id="tenTaiLieuHeading"><c:out value="${taiLieu.tenTaiLieu}" /></h2>
            <div class="metadata-columns">
                <dl>
                    <div><dt>Mã đầu:</dt><dd><c:out value="${taiLieu.maTaiLieu}" /></dd></div>
                    <div><dt>Loại:</dt><dd><c:out value="${taiLieu.loai}" /></dd></div>
                    <div><dt>Tác giả:</dt><dd><c:out value="${taiLieu.tacGia}" /></dd></div>
                    <div><dt>Nhà xuất bản:</dt><dd><c:out value="${taiLieu.nhaXuatBan}" /></dd></div>
                    <div><dt>Năm xuất bản:</dt><dd><c:out value="${taiLieu.namXuatBan}" /></dd></div>
                </dl>
                <dl>
                    <div><dt>Lần xuất bản:</dt><dd><c:out value="${taiLieu.lanXuatBan}" /></dd></div>
                    <div><dt>Ngôn ngữ:</dt><dd><c:out value="${taiLieu.ngonNgu}" /></dd></div>
                    <div><dt>Số trang:</dt><dd><c:out value="${taiLieu.soTrang}" /></dd></div>
                    <div><dt>ISBN:</dt><dd><c:out value="${taiLieu.isbn}" default="Chưa có thông tin" /></dd></div>
                </dl>
            </div>
        </div>
    </section>
    <section class="description" aria-labelledby="moTaHeading">
        <h2 id="moTaHeading">Mô tả nội dung</h2>
        <p><c:out value="${taiLieu.moTa}" /></p>
    </section>
    <section aria-labelledby="danhSachBanHeading">
        <div class="copies-heading">
            <h2 id="danhSachBanHeading">Danh sách bản tài liệu</h2>
            <p>Số bản có thể mượn: <strong><c:out value="${taiLieu.soBanCoTheMuon}" /></strong></p>
        </div>
        <div class="table-scroll">
            <table>
                <caption class="visually-hidden">Các bản tài liệu và tình trạng cho mượn</caption>
                <thead><tr><th scope="col">Mã bản</th><th scope="col">Vị trí</th><th scope="col">Tình trạng</th><th scope="col">Trạng thái</th><th scope="col">Hình thức</th></tr></thead>
                <tbody>
                <c:forEach var="ban" items="${taiLieu.danhSachBan}">
                    <tr>
                        <td><c:out value="${ban.maBan}" /></td>
                        <td><c:out value="${ban.viTri}" /></td>
                        <td><c:out value="${ban.tinhTrang}" /></td>
                        <td><c:out value="${ban.trangThai}" /></td>
                        <td><c:out value="${ban.hinhThuc}" /></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </section>
</main>
<%@ include file="common/footer.jspf" %>
