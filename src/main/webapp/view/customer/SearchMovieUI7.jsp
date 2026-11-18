<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="vi"><head><title>Tìm kiếm phim</title>
<%@ include file="/view/head.jsp" %></head>
<body style="${bodyStyle}"><%@ include file="/view/header.jsp" %>
<main id="main" style="${mainStyle}">
<div style="${businessPanelStyle}">
<h1 style="font-size:21px;font-weight:600;margin:0 0 12px;flex-shrink:0;text-align:center;">Tìm kiếm phim</h1>

<form action="<c:url value='/searchMovie'/>" method="get" style="display:flex;gap:12px;align-items:center;flex-wrap:wrap;margin:0;flex-shrink:0;">
  <label for="keyword" style="font-weight:600;color:#475569;">Từ khóa:</label>
  <input type="text" id="keyword" name="keyword" value="<c:out value='${keyword}'/>" maxlength="200" style="${inputStyle}width:320px;max-width:100%;">
  <button type="submit" style="${buttonStyle}">Tìm kiếm</button>
</form>
<div id="outMessage" role="status" style="${alertStyle}${empty message ? 'display:none;' : ''}"><c:out value="${message}"/></div>
<c:if test="${not empty listMovie}">
  <h2 style="font-size:18px;font-weight:600;margin:14px 0 0;flex-shrink:0;">Kết quả tìm kiếm: cho từ khóa <span style="color:#0369a1;overflow-wrap:anywhere;">[<c:out value="${keyword}"/>]</span></h2>
  <div id="searchResults" style="${tableScrollStyle}">
    <table id="outsubMovieList" style="${tableStyle}">
      <thead><tr>
        <th scope="col" style="${thStyle}text-align:right;">TT</th>
        <th scope="col" style="${thStyle}text-align:left;">Poster</th>
        <th scope="col" style="${thStyle}text-align:left;">Tên phim</th>
        <th scope="col" style="${thStyle}text-align:left;">Thể loại</th>
        <th scope="col" style="${thStyle}text-align:right;">Thời lượng</th>
        <th scope="col" style="${thStyle}text-align:left;">Định dạng</th>
        <th scope="col" style="${thStyle}text-align:left;">Khởi chiếu</th>
      </tr></thead>
      <tbody><c:forEach var="m" items="${listMovie}" varStatus="row">
        <c:url var="detailUrl" value="/movieDetail"><c:param name="idMovie" value="${m.id}"/><c:param name="keyword" value="${keyword}"/></c:url>
        <c:url var="posterUrl" value="/images/${m.poster}"/>
        <tr>
          <td style="${tdStyle}text-align:right;font-variant-numeric:tabular-nums;">${row.count}</td>
          <td style="${tdStyle}text-align:left;"><img src="<c:out value='${posterUrl}'/>" width="60" alt="poster" style="display:block;border-radius:7px;" onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/movie-placeholder.svg';"></td>
          <td style="${tdStyle}text-align:left;min-width:150px;"><a href="<c:out value='${detailUrl}'/>" style="${linkStyle}"><c:out value="${m.movieName}"/></a></td>
          <td style="${tdStyle}text-align:left;"><c:forEach var="mg" items="${m.movieGenres}" varStatus="k"><c:out value="${mg.genre.genreName}"/><c:if test="${!k.last}">, </c:if></c:forEach></td>
          <td style="${tdStyle}text-align:right;white-space:nowrap;font-variant-numeric:tabular-nums;">${m.duration} phút</td>
          <td style="${tdStyle}text-align:left;"><c:forEach var="f" items="${m.formats}" varStatus="k"><c:out value="${f}"/><c:if test="${!k.last}">, </c:if></c:forEach></td>
          <td style="${tdStyle}text-align:left;white-space:nowrap;"><fmt:formatDate value="${m.releaseDate}" pattern="dd-MM-yyyy"/></td>
        </tr>
      </c:forEach></tbody>
    </table>
  </div>
</c:if>
<a href="<c:url value='/view/customer/CustomerMainUI7.jsp'/>" style="${secondaryStyle}">Về trang chính</a>

</div></main><%@ include file="/view/footer.jsp" %></body></html>
