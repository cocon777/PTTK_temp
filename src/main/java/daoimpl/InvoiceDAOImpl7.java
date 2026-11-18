package daoimpl;

import dao.InvoiceDAO7;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import model.CustomerStatistic7;
import model.Invoice7;
import model.Movie7;
import model.Room7;
import model.Showtime7;
import model.Ticket7;

public class InvoiceDAOImpl7 extends DAO7 implements InvoiceDAO7 {
    private static final String SELECT_TRANSACTIONS_BY_CUSTOMER = "SELECT i.id AS idInvoice, i.invoiceCode, i.transactionTime, i.totalAmount, i.discountApplied, "
            + "t.id AS idTicket, t.actualPrice, s.id AS idShowtime, s.startTime, "
            + "r.id AS idRoom, r.roomName, m.id AS idMovie, m.movieName "
            + "FROM tblInvoice7 i JOIN tblTicket7 t ON t.tblInvoice7id = i.id "
            + "JOIN tblShowtime7 s ON s.id = t.tblShowtime7id "
            + "JOIN tblRoom7 r ON r.id = s.tblRoom7id "
            + "JOIN tblMovie7 m ON m.id = s.tblMovie7id "
            + "WHERE i.tblCustomer7id = ? AND i.transactionTime >= ? AND i.transactionTime < ? "
            + "ORDER BY i.transactionTime, i.id, t.id";

    @Override
    public List<Invoice7> getTransactionsByCustomer(CustomerStatistic7 customerStat) {
        List<Invoice7> list = new ArrayList<>();
        Date start = customerStat.getStartDate() != null ? customerStat.getStartDate() : new Date(0);
        Date end = customerStat.getEndDate() != null ? customerStat.getEndDate() : new Date();
        try (Connection connection = getConnection();
                PreparedStatement ps = connection.prepareStatement(SELECT_TRANSACTIONS_BY_CUSTOMER)) {
            ps.setInt(1, customerStat.getId());
            ps.setTimestamp(2, new Timestamp(start.getTime()));
            ps.setTimestamp(3, new Timestamp(end.getTime() + 24L * 60 * 60 * 1000));
            ResultSet rs = ps.executeQuery();
            Invoice7 current = null;
            while (rs.next()) {
                int idInvoice = rs.getInt("idInvoice");
                if (current == null || current.getId() != idInvoice) {
                    current = new Invoice7();
                    current.setId(idInvoice);
                    current.setInvoiceCode(rs.getString("invoiceCode"));
                    current.setTransactionTime(rs.getTimestamp("transactionTime"));
                    current.setTotalAmount(rs.getFloat("totalAmount"));
                    current.setDiscountApplied(rs.getFloat("discountApplied"));
                    current.setCustomer(customerStat);
                    list.add(current);
                }
                Movie7 m = new Movie7();
                m.setId(rs.getInt("idMovie"));
                m.setMovieName(rs.getString("movieName"));
                Room7 r = new Room7();
                r.setId(rs.getInt("idRoom"));
                r.setRoomName(rs.getString("roomName"));
                Showtime7 st = new Showtime7();
                st.setId(rs.getInt("idShowtime"));
                st.setStartTime(rs.getTimestamp("startTime"));
                st.setMovie(m);
                st.setRoom(r);
                Ticket7 tk = new Ticket7();
                tk.setId(rs.getInt("idTicket"));
                tk.setActualPrice(rs.getFloat("actualPrice"));
                tk.setShowtime(st);
                
                current.addTicket(tk);
            }
        } catch (SQLException e) {
            printSQLException(e);
            throw new IllegalStateException("Không thể lấy giao dịch khách hàng", e);
        }
        return list;
    }
}
