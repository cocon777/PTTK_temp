<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="vi"><head><title>CINEMAN</title>
<%@ include file="/view/head.jsp" %></head>
<body style="${bodyStyle}"><%@ include file="/view/header.jsp" %>
<main id="main" style="${mainStyle}">
<div style="${panelStyle}text-align:center;">
<h1 style="font-size:21px;font-weight:600;margin:0 0 12px;flex-shrink:0;text-align:center;">CINEMAN</h1>

<p style="${mutedStyle}margin:0 0 16px;">Khám phá điện ảnh, tận hưởng từng khoảnh khắc.</p>
<a href="<c:url value='/searchMovie'/>" style="${buttonStyle}">Tìm thông tin phim</a>

</div></main><%@ include file="/view/footer.jsp" %></body></html>
