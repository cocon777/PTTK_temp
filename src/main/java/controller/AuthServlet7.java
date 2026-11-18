package controller;

import dao.UserDAO7;
import daoimpl.UserDAOImpl7;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeParseException;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Customer7;
import model.Manager7;
import model.SalesStaff7;
import model.User7;
import util.PasswordUtil7;

@WebServlet(urlPatterns = {"/login", "/register", "/logout"})
public class AuthServlet7 extends BaseServlet7 {
    private UserDAO7 userDAO;

    @Override
    public void init() { userDAO = new UserDAOImpl7(); }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if ("/logout".equals(request.getServletPath())) {
            response.sendError(405);
            return;
        }
        if (request.getSession().getAttribute("currentUser") != null) {
            response.sendRedirect(request.getContextPath() + home(request.getSession()));
            return;
        }
        forward(request, response, "/view/auth/" + ("/register".equals(request.getServletPath())
                ? "RegisterUI7.jsp" : "LoginUI7.jsp"));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/logout".equals(path)) {
            request.getSession().invalidate();
            response.sendRedirect(request.getContextPath() + "/login?loggedOut=1");
            return;
        }
        if (request.getSession().getAttribute("currentUser") != null) {
            response.sendRedirect(request.getContextPath() + home(request.getSession()));
            return;
        }
        if ("/register".equals(path)) register(request, response);
        else login(request, response);
    }

    private void login(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = read(request, "username");
        String password = request.getParameter("password");
        try {
            User7 user = username.length() <= 50 && password != null && !password.isEmpty()
                    ? userDAO.authenticate(username, password) : null;
            if (user == null) {
                request.setAttribute("message", "Tên đăng nhập hoặc mật khẩu chưa đúng.");
                forward(request, response, "/view/auth/LoginUI7.jsp");
                return;
            }
            HttpSession oldSession = request.getSession();
            String next = (String) oldSession.getAttribute("afterLogin");
            oldSession.invalidate();
            HttpSession session = request.getSession(true);
            session.setAttribute("currentUser", user);
            session.setAttribute("role", user instanceof Manager7 ? "MANAGER"
                    : user instanceof SalesStaff7 ? "SALES" : "CUSTOMER");
            session.setAttribute("csrfToken", UUID.randomUUID().toString());
            response.sendRedirect(request.getContextPath() + (user instanceof Manager7 && next != null
                    ? next : home(session)));
        } catch (SQLException | RuntimeException ex) {
            getServletContext().log("Đăng nhập thất bại do lỗi dữ liệu", ex);
            request.setAttribute("message", "Chưa thể đăng nhập. Vui lòng thử lại sau.");
            response.setStatus(503);
            forward(request, response, "/view/auth/LoginUI7.jsp");
        }
    }

    private void register(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Customer7 customer = new Customer7();
        customer.setUsername(read(request, "username"));
        customer.setFullName(read(request, "fullName"));
        customer.setEmail(read(request, "email"));
        customer.setPhone(read(request, "phone"));
        customer.setPassword(request.getParameter("password"));
        String message = null;
        if (!customer.getUsername().matches("[A-Za-z0-9_]{3,50}"))
            message = "Tên đăng nhập gồm 3–50 chữ cái không dấu, chữ số hoặc dấu gạch dưới.";
        else if (customer.getFullName().length() < 2 || customer.getFullName().length() > 100)
            message = "Họ tên cần từ 2 đến 100 ký tự.";
        else if (customer.getEmail().length() > 255 || !customer.getEmail().matches("[^\\s@]+@[^\\s@]+\\.[^\\s@]+"))
            message = "Vui lòng nhập email hợp lệ.";
        else if (!customer.getPhone().isEmpty() && !customer.getPhone().matches("\\+?[0-9]{9,14}"))
            message = "Số điện thoại cần từ 9 đến 14 chữ số, có thể bắt đầu bằng +.";
        else if (!PasswordUtil7.isValid(customer.getPassword()))
            message = "Mật khẩu cần ít nhất 8 ký tự và tối đa 72 byte UTF-8.";
        else if (!customer.getPassword().equals(request.getParameter("confirmPassword")))
            message = "Mật khẩu xác nhận chưa khớp.";
        try {
            LocalDate dob = LocalDate.parse(read(request, "dob"));
            if (dob.isAfter(LocalDate.now(ZoneId.of("Asia/Ho_Chi_Minh"))))
                message = "Ngày sinh không được ở tương lai.";
            customer.setDob(java.sql.Date.valueOf(dob));
        } catch (DateTimeParseException ex) {
            message = "Vui lòng nhập ngày sinh hợp lệ.";
        }
        if (message == null) {
            try {
                userDAO.registerCustomer(customer);
                response.sendRedirect(request.getContextPath() + "/login?registered=1");
                return;
            } catch (SQLException ex) {
                if ("23000".equals(ex.getSQLState())) message = "Tên đăng nhập hoặc email đã được sử dụng.";
                else {
                    getServletContext().log("Không thể đăng ký tài khoản", ex);
                    message = "Chưa thể đăng ký. Vui lòng thử lại sau.";
                    response.setStatus(503);
                }
            } catch (RuntimeException ex) {
                getServletContext().log("Không thể đăng ký tài khoản", ex);
                message = "Chưa thể đăng ký. Vui lòng thử lại sau.";
                response.setStatus(503);
            }
        }
        customer.setPassword(null);
        request.setAttribute("form", customer);
        request.setAttribute("message", message);
        forward(request, response, "/view/auth/RegisterUI7.jsp");
    }

    private String read(HttpServletRequest request, String name) {
        String value = request.getParameter(name);
        return value == null ? "" : value.trim();
    }

    private String home(HttpSession session) {
        return "MANAGER".equals(session.getAttribute("role"))
                ? "/view/manager/ManagerMainUI7.jsp" : "/";
    }
}
