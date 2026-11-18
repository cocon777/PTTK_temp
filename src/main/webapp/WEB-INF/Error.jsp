<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="vi"><head><title>Thông báo · CineMan7</title>
<%@ include file="/view/head.jsp" %></head>
<body style="${bodyStyle}"><%@ include file="/view/header.jsp" %>
<main id="main" style="${mainStyle}">

<section style="${panelStyle}text-align:center;max-width:680px;margin:30px auto;">
  <span style="${tagStyle}">CINEMAN7 · THÔNG BÁO</span><h1 style="${titleStyle}margin-top:20px;">${requestScope['javax.servlet.error.status_code'] == 403 ? 'Bạn chưa có quyền truy cập' : requestScope['javax.servlet.error.status_code'] == 404 ? 'Không tìm thấy trang' : 'Chưa thể xử lý yêu cầu'}</h1>
  <p style="${mutedStyle}">${requestScope['javax.servlet.error.status_code'] == 403 ? 'Vui lòng đăng nhập bằng tài khoản phù hợp hoặc tải lại trang để làm mới phiên làm việc.' : 'Vui lòng quay lại trang chủ hoặc thử lại sau.'}</p>
  <div style="display:flex;gap:12px;justify-content:center;flex-wrap:wrap;margin-top:24px;"><a style="${buttonStyle}" href="<c:url value='/'/>">Về trang chủ</a><a style="${secondaryStyle}" href="<c:url value='/login'/>">Đăng nhập</a></div>
</section>
</main><%@ include file="/view/footer.jsp" %></body></html>
