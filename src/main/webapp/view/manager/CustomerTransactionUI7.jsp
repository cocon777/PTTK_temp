<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="vi"><head><title>Chi tiết giao dịch của khách hàng</title>
<%@ include file="/view/head.jsp" %></head>
<body style="${bodyStyle}"><%@ include file="/view/header.jsp" %>
<main id="main" style="${mainStyle}">
<div style="${businessPanelStyle}">
<h1 style="font-size:21px;font-weight:600;margin:0 0 12px;flex-shrink:0;text-align:center;">Chi tiết giao dịch của khách hàng</h1>

<p style="margin:0 0 6px;flex-shrink:0;"><b>Mã KH:</b> <c:out value="${customerStat.customerCode}"/> &nbsp;&nbsp; <b>Họ tên:</b> <c:out value="${customerStat.fullName}"/> &nbsp;&nbsp; <b>Hạng thành viên:</b> <c:choose><c:when test="${customerStat.memberCard != null}"><c:out value="${customerStat.memberCard.tier.tierName}"/></c:when><c:otherwise>(chưa là thành viên)</c:otherwise></c:choose></p>
<c:if test="${customerStat.startDate != null && customerStat.endDate != null}"><p style="margin:0;flex-shrink:0;"><b>Từ ngày:</b> <fmt:formatDate value="${customerStat.startDate}" pattern="dd/MM/yyyy"/> &nbsp;&nbsp; <b>Đến ngày:</b> <fmt:formatDate value="${customerStat.endDate}" pattern="dd/MM/yyyy"/></p></c:if>
<div id="transactionResults" style="${tableScrollStyle}">
<table id="outTransactionList" style="${tableStyle}">
  <thead><tr>
    <th scope="col" style="${thStyle}text-align:right;">TT</th>
    <th scope="col" style="${thStyle}text-align:left;">Mã hóa đơn</th>
    <th scope="col" style="${thStyle}text-align:left;">Ngày giờ</th>
    <th scope="col" style="${thStyle}text-align:left;">Phim</th>
    <th scope="col" style="${thStyle}text-align:left;">Suất chiếu</th>
    <th scope="col" style="${thStyle}text-align:right;">Số vé</th>
    <th scope="col" style="${thStyle}text-align:right;">Số tiền</th>
    <th scope="col" style="${thStyle}text-align:right;">Giảm giá</th>
  </tr></thead>
  <tbody><c:forEach var="inv" items="${listInvoice}" varStatus="row"><tr>
    <td style="${tdStyle}text-align:right;font-variant-numeric:tabular-nums;">${row.count}</td>
    <td style="${tdStyle}text-align:left;"><c:out value="${inv.invoiceCode}"/></td>
    <td style="${tdStyle}text-align:left;white-space:nowrap;"><fmt:formatDate value="${inv.transactionTime}" pattern="dd/MM/yyyy HH:mm"/></td>
    <td style="${tdStyle}text-align:left;"><c:set var="seen1" value=","/><c:forEach var="t" items="${inv.tickets}"><c:set var="key" value="${',' += t.showtime.id += ','}"/><c:if test="${!fn:contains(seen1,key)}"><c:set var="seen1" value="${seen1 += t.showtime.id += ','}"/><c:out value="${t.showtime.movie.movieName}"/><br></c:if></c:forEach></td>
    <td style="${tdStyle}text-align:left;white-space:nowrap;"><c:set var="seen2" value=","/><c:forEach var="t" items="${inv.tickets}"><c:set var="key" value="${',' += t.showtime.id += ','}"/><c:if test="${!fn:contains(seen2,key)}"><c:set var="seen2" value="${seen2 += t.showtime.id += ','}"/><fmt:formatDate value="${t.showtime.startTime}" pattern="HH:mm dd/MM/yyyy"/>-<c:out value="${t.showtime.room.roomName}"/><br></c:if></c:forEach></td>
    <td style="${tdStyle}text-align:right;font-variant-numeric:tabular-nums;">${fn:length(inv.tickets)}</td>
    <td style="${tdStyle}text-align:right;font-variant-numeric:tabular-nums;"><fmt:formatNumber value="${inv.totalAmount}" pattern="#,##0"/></td>
    <td style="${tdStyle}text-align:right;font-variant-numeric:tabular-nums;"><fmt:formatNumber value="${inv.discountApplied}" pattern="0"/>%</td>
  </tr></c:forEach></tbody>
  <tfoot><tr style="background:#f1f5f9;font-weight:600;">
    <td colspan="5" style="${tdStyle}text-align:left;position:sticky;bottom:0;background:#f1f5f9;">Tổng cộng</td>
    <td style="${tdStyle}text-align:right;font-variant-numeric:tabular-nums;position:sticky;bottom:0;background:#f1f5f9;">${sumTickets}</td>
    <td style="${tdStyle}text-align:right;font-variant-numeric:tabular-nums;"><fmt:formatNumber value="${sumAmount}" pattern="#,##0"/></td>
    <td style="${tdStyle}text-align:right;"></td>
  </tr></tfoot>
</table>
</div>
<a href="<c:url value='${backUrl}'/>" style="${secondaryStyle}">Quay lại</a>

</div></main><%@ include file="/view/footer.jsp" %></body></html>
