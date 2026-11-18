<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="vi"><head><title>CINEMAN - Trang chủ nhân viên quản lí</title>
<%@ include file="/view/head.jsp" %></head>
<body style="${bodyStyle}"><%@ include file="/view/header.jsp" %>
<main id="main" style="${mainStyle}">
<div style="${panelStyle}text-align:center;">
<h1 style="font-size:21px;font-weight:600;margin:0 0 12px;flex-shrink:0;text-align:center;">CINEMAN - Trang chủ nhân viên quản lí</h1>

<a href="<c:url value='/view/manager/SelectStatisticUI7.jsp'/>" style="${buttonStyle}">Xem báo cáo thống kê</a>

</div></main><%@ include file="/view/footer.jsp" %></body></html>
