package controller;

import dao.CustomerStatisticDAO7;
import daoimpl.CustomerStatisticDAOImpl7;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.CustomerStatistic7;

@SuppressWarnings("unchecked")
@WebServlet(urlPatterns = { "/statOpen", "/statView", "/statSort", "/statShow" })
public class CustomerRevenueStatServlet7 extends BaseServlet7 {
    private static final long serialVersionUID = 1L;
    private static final String PAGE_STAT = "/view/manager/CustomerRevenueStatUI7.jsp";
    private CustomerStatisticDAO7 statisticDAO;

    public void init() {
        statisticDAO = new CustomerStatisticDAOImpl7();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();
        switch (action) {
            case "/statView":
                viewStat(request, response);
                break;
            case "/statSort":
                sortStat(request, response);
                break;
            case "/statShow":
                showList(request, response);
                break;
            default:
                openPage(request, response);
                break;
        }
    }

    private void openPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        session.removeAttribute("listStat");
        session.removeAttribute("criteria");
        session.removeAttribute("sortOrder");
        LocalDate today = LocalDate.now(java.time.ZoneId.of("Asia/Ho_Chi_Minh"));
        CustomerStatistic7 criteria = new CustomerStatistic7();
        criteria.setStartDate(java.sql.Date.valueOf(today.withDayOfMonth(1)));
        criteria.setEndDate(java.sql.Date.valueOf(today));
        request.setAttribute("criteria", criteria);
        forward(request, response, PAGE_STAT);
    }

    private void viewStat(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CustomerStatistic7 criteria = new CustomerStatistic7();
        request.setAttribute("startInput", request.getParameter("startDate"));
        request.setAttribute("endInput", request.getParameter("endDate"));
        LocalDate startDate;
        LocalDate endDate;
        try {
            startDate = parseDate(request.getParameter("startDate"));
            endDate = parseDate(request.getParameter("endDate"));
            criteria.setStartDate(java.sql.Date.valueOf(startDate));
            criteria.setEndDate(java.sql.Date.valueOf(endDate));
        } catch (java.time.format.DateTimeParseException | NullPointerException ex) {
            request.setAttribute("message", "Vui lòng nhập ngày hợp lệ theo định dạng dd/mm/yyyy");
            openPage(request, response);
            return;
        }
        java.time.format.DateTimeFormatter displayFormat = java.time.format.DateTimeFormatter.ofPattern("dd/MM/uuuu");
        request.setAttribute("startInput", startDate.format(displayFormat));
        request.setAttribute("endInput", endDate.format(displayFormat));
        if (criteria.getEndDate().before(criteria.getStartDate())) {
            request.setAttribute("message", "Ngày kết thúc không được trước ngày bắt đầu");
            request.setAttribute("criteria", criteria);
            forward(request, response, PAGE_STAT);
            return;
        }
        HttpSession session = request.getSession();
        session.setAttribute("listStat", statisticDAO.getCustomerRevenueStat(criteria));
        session.setAttribute("criteria", criteria);
        session.setAttribute("sortOrder", "desc");
        showList(request, response);
    }

    private LocalDate parseDate(String value) {
        if (value != null && value.contains("/")) {
            return LocalDate.parse(value, java.time.format.DateTimeFormatter.ofPattern("dd/MM/uuuu")
                    .withResolverStyle(java.time.format.ResolverStyle.STRICT));
        }
        return LocalDate.parse(value);
    }

    private void sortStat(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<CustomerStatistic7> list = (List<CustomerStatistic7>) session.getAttribute("listStat");
        if (list == null) {
            openPage(request, response);
            return;
        }
        String order = "asc".equals(session.getAttribute("sortOrder")) ? "desc" : "asc";
        session.setAttribute("listStat", statisticDAO.sortByRevenue(list, order));
        session.setAttribute("sortOrder", order);
        showList(request, response);
    }

    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<CustomerStatistic7> list = (List<CustomerStatistic7>) session.getAttribute("listStat");
        if (list == null) {
            openPage(request, response);
            return;
        }
        int sumTickets = 0;
        float sumRevenue = 0;
        for (CustomerStatistic7 cs : list) {
            sumTickets += cs.getTotalTickets();
            sumRevenue += cs.getTotalRevenue();
        }
        request.setAttribute("listStat", list);
        request.setAttribute("sumTickets", sumTickets);
        request.setAttribute("sumRevenue", sumRevenue);
        request.setAttribute("sortOrder", session.getAttribute("sortOrder"));
        request.setAttribute("criteria", session.getAttribute("criteria"));
        forward(request, response, PAGE_STAT);
    }
}
