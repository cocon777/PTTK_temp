<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="vi"><head><title>Đăng ký · CineMan7</title>
<%@ include file="/view/head.jsp" %></head>
<body style="${bodyStyle}"><%@ include file="/view/header.jsp" %>
<main id="main" style="${mainStyle}">

<section style="${panelStyle}max-width:660px;margin:0 auto;padding:12px;">
  <span style="${tagStyle}">THAM GIA CINEMAN7</span><h1 style="${titleStyle}margin-top:4px;">Tạo tài khoản của bạn</h1><p style="${mutedStyle}margin:6px 0 8px;">Điền thông tin bên dưới để đăng ký tài khoản khách hàng.</p>
  <c:if test="${not empty message}"><p role="alert" style="${alertStyle}"><c:out value="${message}"/></p></c:if>
  <form action="<c:url value='/register'/>" method="post" style="margin-top:8px;">
    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
    <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,140px),1fr));gap:6px;"><div><label for="fullName" style="${labelStyle}">Họ và tên</label><input id="fullName" name="fullName" type="text" value="<c:out value='${form.fullName}'/>" required minlength="2" maxlength="100" autocomplete="name" style="${inputStyle}padding:7px 9px;"></div>
<div><label for="username" style="${labelStyle}">Tên đăng nhập</label><input id="username" name="username" type="text" value="<c:out value='${form.username}'/>" required minlength="3" maxlength="50" pattern="[A-Za-z0-9_]{3,50}" autocomplete="username" style="${inputStyle}padding:7px 9px;"></div>
<div><label for="email" style="${labelStyle}">Email</label><input id="email" name="email" type="email" value="<c:out value='${form.email}'/>" required maxlength="255" autocomplete="email" style="${inputStyle}padding:7px 9px;"></div>
<div><label for="phone" style="${labelStyle}">Số điện thoại (không bắt buộc)</label><input id="phone" name="phone" type="tel" value="<c:out value='${form.phone}'/>" maxlength="15" pattern="[+]?[0-9]{9,14}" autocomplete="tel" style="${inputStyle}padding:7px 9px;"></div>
<div><label for="dob" style="${labelStyle}">Ngày sinh</label><input id="dob" name="dob" type="date" value="<c:out value='${form.dob}'/>" required autocomplete="bday" style="${inputStyle}padding:7px 9px;"></div>
      <div><label for="password" style="${labelStyle}">Mật khẩu</label><input id="password" name="password" type="password" required minlength="8" autocomplete="new-password" aria-describedby="password-help" style="${inputStyle}padding:7px 9px;"></div>
      <div><label for="confirmPassword" style="${labelStyle}">Xác nhận mật khẩu</label><input id="confirmPassword" name="confirmPassword" type="password" required minlength="8" autocomplete="new-password" style="${inputStyle}padding:7px 9px;"></div>
    </div>
    <p id="password-help" style="${mutedStyle}font-size:12px;margin:6px 0;">Tên đăng nhập: 3–50 chữ cái không dấu, số hoặc dấu _. Mật khẩu: ít nhất 8 ký tự, tối đa 72 byte UTF-8.</p>
    <button type="submit" style="${buttonStyle}width:100%;margin-top:4px;">Tạo tài khoản →</button>
  </form>
  <p style="${mutedStyle}text-align:center;margin:8px 0 0;">Đã có tài khoản? <a href="<c:url value='/login'/>" style="${linkStyle}">Đăng nhập</a></p>
</section>
</main><%@ include file="/view/footer.jsp" %></body></html>
