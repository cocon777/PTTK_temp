<%@ page pageEncoding="UTF-8"%>
<header style="background:#fff;border-bottom:1px solid #e2e8f0;flex-shrink:0;">
  <div style="width:min(1180px,calc(100% - 24px));margin:auto;display:flex;align-items:center;justify-content:space-between;gap:10px;flex-wrap:wrap;padding:10px 0;">
    <a href="<c:url value='/'/>" aria-label="CineMan7 - Trang chủ" style="display:flex;align-items:center;gap:11px;text-decoration:none;color:#0f172a;">
      <span aria-hidden="true" style="width:42px;height:42px;display:grid;place-items:center;background:linear-gradient(135deg,#0284c7,#22d3ee);border-radius:13px;color:white;font-size:24px;">▤</span>
      <span><strong style="display:block;font-size:20px;letter-spacing:-.6px;">CineMan<span style="color:#0284c7;">7</span></strong><span style="display:block;font-size:10px;letter-spacing:1.4px;color:#64748b;">KHÔNG GIAN ĐIỆN ẢNH</span></span>
    </a>
    <nav aria-label="Điều hướng chính" style="display:flex;gap:6px;align-items:center;flex-wrap:wrap;font-size:13px;">
      <a href="<c:url value='/'/>" style="${linkStyle}padding:6px;">Trang chủ</a>
      <a href="<c:url value='/searchMovie'/>" style="${linkStyle}padding:6px;">Tìm phim</a>
      <c:if test="${sessionScope.role == 'MANAGER'}"><a href="<c:url value='/view/manager/ManagerMainUI7.jsp'/>" style="${linkStyle}padding:6px;">Quản lý</a></c:if>
      <c:choose><c:when test="${empty sessionScope.currentUser}">
        <a href="<c:url value='/login'/>" style="${secondaryStyle}padding:7px 10px;font-size:13px;">Đăng nhập</a>
        <a href="<c:url value='/register'/>" style="${buttonStyle}padding:7px 10px;font-size:13px;">Đăng ký</a>
      </c:when><c:otherwise>
        <span style="font-size:13px;color:#475569;max-width:240px;overflow-wrap:anywhere;">Xin chào, <strong><c:out value="${sessionScope.currentUser.fullName}"/></strong><br><span style="font-size:11px;">${sessionScope.role == 'MANAGER' ? 'Nhân viên quản lý' : sessionScope.role == 'SALES' ? 'Nhân viên bán hàng' : 'Khách hàng'}</span></span>
        <form action="<c:url value='/logout'/>" method="post" style="margin:0;">
          <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
          <button type="submit" style="${secondaryStyle}padding:7px 10px;font-size:13px;">Đăng xuất</button>
        </form>
      </c:otherwise></c:choose>
    </nav>
  </div>
</header>
