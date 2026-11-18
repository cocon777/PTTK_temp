<%@ page pageEncoding="UTF-8"%>
<footer style="background:white;border-top:1px solid #e2e8f0;flex-shrink:0;">
  <div style="width:min(1180px,calc(100% - 24px));margin:auto;padding:8px 0;display:flex;justify-content:space-between;gap:8px;flex-wrap:wrap;">
    <div><strong style="font-size:17px;">CineMan7</strong><p style="${mutedStyle}margin:5px 0;">Khám phá câu chuyện tiếp theo của bạn.</p><small style="color:#94a3b8;">© 2026 CineMan7 · Hệ thống quản lý rạp chiếu phim</small></div>
    <nav aria-label="Liên kết cuối trang" style="display:flex;gap:18px;align-items:center;flex-wrap:wrap;">
      <a style="${linkStyle}font-size:13px;" href="<c:url value='/searchMovie'/>">Tra cứu phim</a>
      <a style="${linkStyle}font-size:13px;" href="<c:url value='/login'/>">Tài khoản</a>
      <a style="${linkStyle}font-size:13px;" href="<c:url value='/'/>">Trang chủ</a>
    </nav>
  </div>
</footer>
