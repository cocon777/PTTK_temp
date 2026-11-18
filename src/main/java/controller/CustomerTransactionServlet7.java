package controller;

import dao.CustomerStatisticDAO7;
import dao.InvoiceDAO7;
import daoimpl.CustomerStatisticDAOImpl7;
import daoimpl.InvoiceDAOImpl7;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.CustomerStatistic7;
import model.Invoice7;

@WebServlet("/customerTransaction")
public class CustomerTransactionServlet7 extends BaseServlet7 {
    private static final long serialVersionUID = 1L;
    private CustomerStatisticDAO7 statisticDAO;
    private InvoiceDAO7 invoiceDAO;

    public void init() {
        statisticDAO = new CustomerStatisticDAOImpl7();
        invoiceDAO = new InvoiceDAOImpl7();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CustomerStatistic7 customerStat = null;
        try {
            customerStat = statisticDAO.getCustomerInfo(readCustomerStat(request));
        } catch (IllegalArgumentException | NullPointerException | java.time.format.DateTimeParseException e) {
            customerStat = null;
        }
        if (customerStat == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        List<Invoice7> listInvoice = invoiceDAO.getTransactionsByCustomer(customerStat);
        int sumTickets = 0;
        float sumAmount = 0;
        for (Invoice7 inv : listInvoice) {
            sumTickets += inv.getTickets().size();
            sumAmount += inv.getTotalAmount();
        }
        String back = request.getParameter("back");
        if (!"/statShow".equals(back)) back = "/statOpen";
        request.setAttribute("customerStat", customerStat);
        request.setAttribute("listInvoice", listInvoice);
        request.setAttribute("sumTickets", sumTickets);
        request.setAttribute("sumAmount", sumAmount);
        request.setAttribute("backUrl", back);
        forward(request, response, "/view/manager/CustomerTransactionUI7.jsp");
    }

    private CustomerStatistic7 readCustomerStat(HttpServletRequest request) {
        CustomerStatistic7 customerStat = new CustomerStatistic7();
        customerStat.setId(Integer.parseInt(request.getParameter("idCustomer")));
        customerStat.setStartDate(java.sql.Date.valueOf(java.time.LocalDate.parse(request.getParameter("startDate"))));
        customerStat.setEndDate(java.sql.Date.valueOf(java.time.LocalDate.parse(request.getParameter("endDate"))));
        if (customerStat.getEndDate().before(customerStat.getStartDate()))
            throw new IllegalArgumentException("Khoảng ngày không hợp lệ");
        return customerStat;
    }
}
