<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="vi"><head><title>Chi tiết phim</title>
<%@ include file="/view/head.jsp" %></head>
<body style="${bodyStyle}"><%@ include file="/view/header.jsp" %>
<main id="main" style="${mainStyle}">
<div style="${businessPanelStyle}">
  <h1 style="font-size:21px;font-weight:600;margin:0 0 8px;text-align:center;flex-shrink:0;">Chi tiết phim</h1>
  <c:set var="detailLabelStyle" value="padding:8px 12px;text-align:left;vertical-align:top;white-space:nowrap;background:#f8fafc;border-bottom:1px solid #e2e8f0;font-weight:600;width:110px;"/>
  <c:set var="detailValueStyle" value="padding:8px 12px;text-align:left;vertical-align:top;border-bottom:1px solid #e2e8f0;overflow-wrap:anywhere;"/>
  <div id="movieDetailResults" style="${tableScrollStyle}">
    <table id="outMovieDetail" style="${tableStyle}min-width:540px;">
      <tbody>
        <tr>
          <td rowspan="10" style="padding:12px;text-align:left;vertical-align:top;width:clamp(110px,18vw,200px);border-right:1px solid #e2e8f0;border-bottom:1px solid #e2e8f0;">
            <c:url var="posterUrl" value="/images/${movie.poster}"/>
            <img id="outPoster" src="<c:out value='${posterUrl}'/>" alt="poster" style="display:block;width:100%;max-height:300px;object-fit:contain;border-radius:8px;" onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/movie-placeholder.svg';">
          </td>
          <th scope="row" style="${detailLabelStyle}">Tên phim</th>
          <td style="${detailValueStyle}"><c:out value="${movie.movieName}"/></td>
        </tr>
        <tr><th scope="row" style="${detailLabelStyle}">Đạo diễn</th><td style="${detailValueStyle}"><c:out value="${movie.director}"/></td></tr>
        <tr><th scope="row" style="${detailLabelStyle}">Diễn viên</th><td style="${detailValueStyle}"><c:out value="${movie.actors}"/></td></tr>
        <tr><th scope="row" style="${detailLabelStyle}">Thể loại</th><td style="${detailValueStyle}"><c:forEach var="mg" items="${movie.movieGenres}" varStatus="k"><c:out value="${mg.genre.genreName}"/><c:if test="${!k.last}">, </c:if></c:forEach></td></tr>
        <tr><th scope="row" style="${detailLabelStyle}">Khởi chiếu</th><td style="${detailValueStyle}"><fmt:formatDate value="${movie.releaseDate}" pattern="dd/MM/yyyy"/></td></tr>
        <tr><th scope="row" style="${detailLabelStyle}">Thời lượng</th><td style="${detailValueStyle}text-align:right;font-variant-numeric:tabular-nums;">${movie.duration} phút</td></tr>
        <tr><th scope="row" style="${detailLabelStyle}">Ngôn ngữ</th><td style="${detailValueStyle}"><c:out value="${movie.language}"/></td></tr>
        <tr><th scope="row" style="${detailLabelStyle}">Độ tuổi</th><td style="${detailValueStyle}"><c:out value="${movie.ageRating}"/></td></tr>
        <tr><th scope="row" style="${detailLabelStyle}">Định dạng</th><td style="${detailValueStyle}"><c:forEach var="f" items="${movie.formats}" varStatus="k"><c:out value="${f}"/><c:if test="${!k.last}">, </c:if></c:forEach></td></tr>
        <tr><td colspan="2" style="${detailValueStyle}"><button id="subBuyTicket" type="button" style="${buttonStyle}" onclick="alert('Mua vé thuộc UC BookTicketOnline7 (ngoài phạm vi module này)')">Mua vé</button></td></tr>
        <tr><td colspan="3" style="${detailValueStyle}"><c:if test="${not empty trailerUrl}"><a id="subTrailer" href="<c:out value='${trailerUrl}'/>" target="_blank" rel="noopener noreferrer" style="${linkStyle}">Xem trailer</a></c:if></td></tr>
        <tr><td colspan="3" style="${detailValueStyle}white-space:pre-line;"><c:out value="${movie.description}"/></td></tr>
      </tbody>
    </table>
  </div>
  <c:url var="backUrl" value="/searchMovie"><c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}"/></c:if></c:url>
  <a id="subBack" href="<c:out value='${backUrl}'/>" style="${secondaryStyle}">Quay lại</a>
</div></main><%@ include file="/view/footer.jsp" %></body></html>
