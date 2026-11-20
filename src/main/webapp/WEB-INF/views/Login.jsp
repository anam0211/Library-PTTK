<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="common/auth-form.jspf" %>
<%
    request.setAttribute("tieuDe", "Đăng nhập");
    request.setAttribute("pageId", "login");
    String username = request.getParameter("username");
    request.setAttribute("username", username == null ? "" : username);
    if ("POST".equals(request.getMethod())) synchronized (session) {
        String password = request.getParameter("password");
        Long blockedUntil = (Long) session.getAttribute("loginBlockedUntil");
        if (!session.getAttribute("csrf").equals(request.getParameter("csrf"))) {
            request.setAttribute("errorMessage", "Phiên đã hết hạn. Vui lòng thử lại.");
        } else if (blockedUntil != null && blockedUntil > System.currentTimeMillis()) {
            request.setAttribute("errorMessage", "Bạn đã thử đăng nhập nhiều lần. Vui lòng thử lại sau 30 giây.");
        } else if (username == null || username.isBlank() || username.length()>100 || password == null || password.isEmpty() || password.length()>128) {
            request.setAttribute("errorMessage", "Nhập tên đăng nhập và mật khẩu hợp lệ.");
        } else try (MemberDAO members = new MemberDAO()) {
            Member2 member = members.authenticate(username.trim(), password);
            if (member == null) {
                int attempts = session.getAttribute("loginAttempts") == null ? 1 : (Integer) session.getAttribute("loginAttempts") + 1;
                session.setAttribute("loginAttempts", attempts);
                if (attempts>=5) { session.setAttribute("loginBlockedUntil", System.currentTimeMillis()+30_000); session.setAttribute("loginAttempts", 0); }
                request.setAttribute("errorMessage", "Tên đăng nhập hoặc mật khẩu không đúng.");
            } else {
                // Discard the anonymous session, draft and tokens to prevent session fixation.
                session.invalidate();
                jakarta.servlet.http.HttpSession signedInSession = request.getSession(true);
                signedInSession.setMaxInactiveInterval(30*60);
                signedInSession.setAttribute("signedInMember", member);
                signedInSession.setAttribute("csrf", UUID.randomUUID().toString());
                response.sendRedirect(request.getContextPath() + member.getHomePath());
                return;
            }
        } catch (SQLException error) {
            application.log("Login SQLState=" + error.getSQLState());
            request.setAttribute("errorMessage", "Chưa thể kết nối hệ thống. Vui lòng thử lại sau.");
        }
    }
%>
<%@ include file="common/header.jspf" %>
<main class="auth-main">
  <section class="auth-card" aria-labelledby="login-title">
    <div class="auth-heading"><h1 id="login-title">Đăng nhập</h1><p>Sử dụng tài khoản thư viện của bạn.</p></div>
    <form id="login-form" class="auth-form" method="post" action="<c:url value='/dang-nhap' />">
      <input type="hidden" name="csrf" value="<c:out value='${csrf}' />">
      <c:if test="${not empty errorMessage}"><p class="auth-notice error" role="alert"><c:out value="${errorMessage}" /></p></c:if>
      <div class="auth-field"><label for="login-username">Tên đăng nhập</label>
        <input id="login-username" name="username" type="text" autocomplete="username" maxlength="100" value="<c:out value='${username}' />" required autofocus></div>
      <div class="auth-field"><label for="login-password">Mật khẩu</label>
        <div class="password-input"><input id="login-password" name="password" type="password" autocomplete="current-password" maxlength="128" required>
        <button type="button" class="password-toggle" data-password="login-password" aria-controls="login-password" aria-pressed="false">Hiện</button></div></div>
      <button id="login-submit" class="button primary auth-submit" type="submit">Đăng nhập</button>
    </form>
    <p class="auth-switch">Liên hệ thư viện để được cấp tài khoản.</p>
  </section>
</main>
<%@ include file="common/footer.jspf" %>
