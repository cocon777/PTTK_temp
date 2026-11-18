<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="vi"><head><title>Đăng nhập · CineMan7</title>
<%@ include file="/view/head.jsp" %></head>
<body style="${bodyStyle}"><%@ include file="/view/header.jsp" %>
<main id="main" style="${mainStyle}">

<section style="${panelStyle}max-width:440px;margin:0 auto;">
  <span style="${tagStyle}">TÀI KHOẢN CINEMAN7</span><h1 style="${titleStyle}margin-top:16px;">Chào mừng trở lại</h1><p style="${mutedStyle}">Đăng nhập để tiếp tục trải nghiệm CineMan7.</p>
  <c:if test="${param.registered == '1'}"><p role="status" style="padding:12px;border-radius:11px;background:#ecfdf5;color:#047857;">Tạo tài khoản thành công. Bạn có thể đăng nhập ngay.</p></c:if>
  <c:if test="${param.loggedOut == '1'}"><p role="status" style="padding:12px;border-radius:11px;background:#e0f2fe;color:#0369a1;">Bạn đã đăng xuất.</p></c:if>
  <c:if test="${not empty message}"><p role="alert" style="${alertStyle}"><c:out value="${message}"/></p></c:if>
  <form action="<c:url value='/login'/>" method="post" style="display:grid;gap:12px;margin-top:14px;">
    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
    <div><label for="username" style="${labelStyle}">Tên đăng nhập</label><input id="username" name="username" value="<c:out value='${param.username}'/>" required maxlength="50" autocomplete="username" style="${inputStyle}"></div>
    <div><label for="password" style="${labelStyle}">Mật khẩu</label><input type="password" id="password" name="password" required autocomplete="current-password" style="${inputStyle}"></div>
    <button type="submit" style="${buttonStyle}">Đăng nhập →</button>
  </form>
  <p style="${mutedStyle}text-align:center;margin-top:12px;">Chưa có tài khoản? <a href="<c:url value='/register'/>" style="${linkStyle}">Đăng ký ngay</a></p>
</section>
</main><%@ include file="/view/footer.jsp" %></body></html>
