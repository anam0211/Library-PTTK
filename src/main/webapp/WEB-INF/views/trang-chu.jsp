<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="common/header.jspf" %>
<main class="panel home-panel">
    <div class="section-heading"><h1>TRANG CHỦ BẠN ĐỌC</h1></div>
    <section class="feature-card" aria-label="Tra cứu tài liệu">
        <div class="book-icon" aria-hidden="true">
            <svg viewBox="0 0 64 48" fill="none">
                <path d="M30 40H9V7h21v33Zm4 0h21V7H34v33Z" fill="white" stroke="currentColor" stroke-width="2"/>
                <path d="M32 7v36" stroke="currentColor" stroke-width="2"/>
            </svg>
        </div>
        <p>Tra cứu thông tin tài liệu trong thư viện</p>
        <a class="button button-primary home-button" href="<c:url value='/tim-tai-lieu' />">Tìm kiếm tài liệu</a>
    </section>
</main>
<%@ include file="common/footer.jspf" %>
