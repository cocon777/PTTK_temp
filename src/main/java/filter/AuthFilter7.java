package filter;

import java.io.IOException;
import java.util.UUID;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter("/*")
public class AuthFilter7 implements Filter {
    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        req.setCharacterEncoding("UTF-8");
        res.setCharacterEncoding("UTF-8");
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        String path = request.getServletPath();
        HttpSession session = request.getSession();
        if (session.getAttribute("csrfToken") == null)
            session.setAttribute("csrfToken", UUID.randomUUID().toString());
        if ("POST".equals(request.getMethod())
                && !session.getAttribute("csrfToken").equals(request.getParameter("csrfToken"))) {
            response.sendError(403, "Phiên làm việc đã thay đổi. Vui lòng tải lại trang.");
            return;
        }
        boolean managerPage = path.startsWith("/view/manager/") || path.equals("/statOpen")
                || path.equals("/statView") || path.equals("/statSort") || path.equals("/statShow")
                || path.equals("/customerTransaction");
        if (managerPage && session.getAttribute("currentUser") == null) {
            // Chỉ lưu URL nội bộ do filter xác định, không nhận URL chuyển hướng từ form.
            session.setAttribute("afterLogin", "/view/manager/ManagerMainUI7.jsp");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (managerPage && !"MANAGER".equals(session.getAttribute("role"))) {
            response.sendError(403);
            return;
        }
        if (managerPage || path.equals("/login") || path.equals("/register")
                || path.equals("/logout") || path.startsWith("/view/auth/")) {
            response.setHeader("Cache-Control", "no-store");
        }
        chain.doFilter(req, res);
    }
}
