<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="vi"><head><title>Thống kê khách hàng theo doanh thu</title>
<%@ include file="/view/head.jsp" %></head>
<body style="${bodyStyle}"><%@ include file="/view/header.jsp" %>
<main id="main" style="${mainStyle}">
<div style="${businessPanelStyle}">
<h1 style="font-size:21px;font-weight:600;margin:0 0 12px;flex-shrink:0;text-align:center;">Thống kê khách hàng theo doanh thu</h1>

<fmt:formatDate var="startStr" value="${criteria.startDate}" pattern="dd/MM/yyyy"/>
<fmt:formatDate var="endStr" value="${criteria.endDate}" pattern="dd/MM/yyyy"/>
<form id="statForm" action="<c:url value='/statView'/>" method="post" novalidate style="display:flex;gap:10px;align-items:center;flex-wrap:wrap;flex-shrink:0;">
  <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
  <label for="s" style="font-weight:600;color:#475569;">Từ ngày:</label>
  <span style="display:inline-flex;position:relative;width:156px;max-width:100%;">
    <input type="text" id="s" name="startDate" value="<c:out value='${startInput != null ? startInput : startStr}'/>" placeholder="dd/mm/yyyy" inputmode="numeric" maxlength="10" autocomplete="off" style="${inputStyle}padding-right:32px;">
    <button type="button" aria-label="Chọn ngày bắt đầu" onclick="document.getElementById('startPicker').showPicker()" style="position:absolute;right:3px;top:3px;bottom:3px;width:28px;border:0;background:transparent;color:#475569;cursor:pointer;font-size:18px;">▦</button>
    <input type="date" id="startPicker" tabindex="-1" aria-label="Lịch ngày bắt đầu" style="position:absolute;right:0;bottom:0;width:1px;height:1px;opacity:0;pointer-events:none;">
  </span>
  <label for="e" style="font-weight:600;color:#475569;">Đến ngày:</label>
  <span style="display:inline-flex;position:relative;width:156px;max-width:100%;">
    <input type="text" id="e" name="endDate" value="<c:out value='${endInput != null ? endInput : endStr}'/>" placeholder="dd/mm/yyyy" inputmode="numeric" maxlength="10" autocomplete="off" style="${inputStyle}padding-right:32px;">
    <button type="button" aria-label="Chọn ngày kết thúc" onclick="document.getElementById('endPicker').showPicker()" style="position:absolute;right:3px;top:3px;bottom:3px;width:28px;border:0;background:transparent;color:#475569;cursor:pointer;font-size:18px;">▦</button>
    <input type="date" id="endPicker" tabindex="-1" aria-label="Lịch ngày kết thúc" style="position:absolute;right:0;bottom:0;width:1px;height:1px;opacity:0;pointer-events:none;">
  </span>
  <button type="submit" id="btn" style="${buttonStyle}">Xem thống kê</button>
</form>
<div id="outMessage" role="status" style="${alertStyle}${empty message ? 'display:none;' : ''}"><c:out value="${message}"/></div>
<c:if test="${listStat != null}">
<div id="statResults" style="${tableScrollStyle}">
  <table id="outsubCustomerRevenueList" style="${tableStyle}">
    <thead><tr>
      <th scope="col" style="${thStyle}text-align:right;">TT</th>
      <th scope="col" style="${thStyle}text-align:left;">Mã KH</th>
      <th scope="col" style="${thStyle}text-align:left;">Họ tên</th>
      <th scope="col" style="${thStyle}text-align:left;">Hạng thành viên</th>
      <th scope="col" style="${thStyle}text-align:right;">Tổng số vé</th>
      <th scope="col" style="${thStyle}text-align:right;"><a href="<c:url value='/statSort'/>" style="${linkStyle}">Tổng doanh thu ${sortOrder == 'asc' ? '▲' : '▼'}</a></th>
      <th scope="col" style="${thStyle}text-align:right;">% doanh thu</th>
    </tr></thead>
    <tbody>
      <c:set var="stt" value="0"/>
      <c:forEach var="cs" items="${listStat}">
        <c:choose><c:when test="${cs.customerCode == null}">
          <tr>
            <td style="${tdStyle}text-align:right;">-</td><td style="${tdStyle}text-align:left;">Khách vãng lai</td><td style="${tdStyle}text-align:left;">-</td><td style="${tdStyle}text-align:left;">-</td>
        </c:when><c:otherwise>
          <c:set var="stt" value="${stt+1}"/>
          <fmt:formatDate var="rowStart" value="${cs.startDate}" pattern="yyyy-MM-dd"/>
          <fmt:formatDate var="rowEnd" value="${cs.endDate}" pattern="yyyy-MM-dd"/>
          <c:url var="detailUrl" value="/customerTransaction"><c:param name="idCustomer" value="${cs.id}"/><c:param name="startDate" value="${rowStart}"/><c:param name="endDate" value="${rowEnd}"/><c:param name="back" value="/statShow"/></c:url>
          <tr style="cursor:pointer;" tabindex="0" onclick="location.href='${detailUrl}'" onkeydown="if(event.key==='Enter'){location.href='${detailUrl}';}">
            <td style="${tdStyle}text-align:right;font-variant-numeric:tabular-nums;">${stt}</td>
            <td style="${tdStyle}text-align:left;"><c:out value="${cs.customerCode}"/></td>
            <td style="${tdStyle}text-align:left;min-width:140px;"><a href="<c:out value='${detailUrl}'/>" style="${linkStyle}"><c:out value="${cs.fullName}"/></a></td>
            <td style="${tdStyle}text-align:left;"><c:choose><c:when test="${cs.memberCard == null}">(chưa là thành viên)</c:when><c:otherwise><c:out value="${cs.memberCard.tier.tierName}"/></c:otherwise></c:choose></td>
        </c:otherwise></c:choose>
            <td style="${tdStyle}text-align:right;font-variant-numeric:tabular-nums;">${cs.totalTickets}</td>
            <td style="${tdStyle}text-align:right;font-variant-numeric:tabular-nums;"><fmt:formatNumber value="${cs.totalRevenue}" pattern="#,##0"/></td>
            <td style="${tdStyle}text-align:right;font-variant-numeric:tabular-nums;"><fmt:formatNumber value="${cs.revenuePercent}" pattern="0.0"/>%</td>
          </tr>
      </c:forEach>
    </tbody>
    <tfoot><tr style="background:#f1f5f9;font-weight:600;">
      <td colspan="4" style="${tdStyle}text-align:left;position:sticky;bottom:0;background:#f1f5f9;">Tổng cộng</td>
      <td style="${tdStyle}text-align:right;font-variant-numeric:tabular-nums;position:sticky;bottom:0;background:#f1f5f9;">${sumTickets}</td>
      <td style="${tdStyle}text-align:right;font-variant-numeric:tabular-nums;"><fmt:formatNumber value="${sumRevenue}" pattern="#,##0"/></td>
      <td style="${tdStyle}text-align:right;position:sticky;bottom:0;background:#f1f5f9;">${sumRevenue > 0 ? '100%' : '0%'}</td>
    </tr></tfoot>
  </table>
</div>
</c:if>
<a href="<c:url value='/view/manager/SelectStatisticUI7.jsp'/>" style="${secondaryStyle}">Quay lại</a>
<script>
(() => {
  const form = document.getElementById('statForm');
  const message = document.getElementById('outMessage');
  const start = document.getElementById('s'), end = document.getElementById('e');
  const invalidDate = 'Vui lòng nhập ngày hợp lệ theo định dạng dd/mm/yyyy';
  function isoDate(value) {
    const match = /^(\d{2})\/(\d{2})\/(\d{4})$/.exec(value);
    if (!match) return null;
    const day = Number(match[1]), month = Number(match[2]), year = Number(match[3]);
    const date = new Date(0);
    date.setUTCFullYear(year, month - 1, day);
    date.setUTCHours(0, 0, 0, 0);
    if (year < 1 || date.getUTCFullYear() !== year || date.getUTCMonth() !== month - 1 || date.getUTCDate() !== day) return null;
    return match[3] + '-' + match[2] + '-' + match[1];
  }
  function showMessage(text) {
    message.textContent = text;
    message.style.display = text ? 'block' : 'none';
    start.setAttribute('aria-invalid', isoDate(start.value) ? 'false' : 'true');
    end.setAttribute('aria-invalid', isoDate(end.value) ? 'false' : 'true');
  }
  function validate() {
    const from = isoDate(start.value), to = isoDate(end.value);
    const text = !from || !to ? invalidDate : to < from ? 'Ngày kết thúc không được trước ngày bắt đầu' : '';
    showMessage(text);
    return !text;
  }
  [[start, 'startPicker'], [end, 'endPicker']].forEach(([input, pickerId]) => {
    const picker = document.getElementById(pickerId);
    picker.value = isoDate(input.value) || '';
    picker.addEventListener('change', () => {
      if (picker.value) {
        const parts = picker.value.split('-');
        input.value = parts[2] + '/' + parts[1] + '/' + parts[0];
        validate();
      }
    });
    input.addEventListener('change', () => { picker.value = isoDate(input.value) || ''; validate(); });
  });
  form.addEventListener('submit', event => { if (!validate()) event.preventDefault(); });
})();
</script>

</div></main><%@ include file="/view/footer.jsp" %></body></html>
