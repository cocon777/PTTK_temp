package daoimpl;

import dao.CustomerStatisticDAO7;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import model.CustomerStatistic7;
import model.MemberCard7;
import model.MembershipTier7;

public class CustomerStatisticDAOImpl7 extends DAO7 implements CustomerStatisticDAO7 {
    private static final String SELECT_CUSTOMER_REVENUE = "SELECT x.cid, x.totalTickets, x.totalRevenue, c.customerCode, u.fullName, mt.tierName "
            + "FROM (SELECT y.cid, SUM(y.soVe) AS totalTickets, SUM(y.amount) AS totalRevenue "
            + "      FROM (SELECT i.tblCustomer7id AS cid, i.totalAmount AS amount, "
            + "                   (SELECT COUNT(*) FROM tblTicket7 t WHERE t.tblInvoice7id = i.id) AS soVe "
            + "            FROM tblInvoice7 i WHERE i.transactionTime >= ? AND i.transactionTime < ?) y "
            + "      GROUP BY y.cid) x "
            + "LEFT JOIN tblCustomer7 c ON c.tblUser7id = x.cid "
            + "LEFT JOIN tblUser7 u ON u.id = x.cid "
            + "LEFT JOIN tblMemberCard7 mc ON mc.tblCustomer7id = x.cid "
            + "LEFT JOIN tblMembershipTier7 mt ON mt.id = mc.tblMembershipTier7id "
            + "ORDER BY x.totalRevenue DESC";

    @Override
    public List<CustomerStatistic7> getCustomerRevenueStat(CustomerStatistic7 criteria) {
        List<CustomerStatistic7> list = new ArrayList<>();
        CustomerStatistic7 walkIn = null;
        try (Connection connection = getConnection();
                PreparedStatement ps = connection.prepareStatement(SELECT_CUSTOMER_REVENUE)) {
            ps.setTimestamp(1, new Timestamp(criteria.getStartDate().getTime()));
            ps.setTimestamp(2, new Timestamp(criteria.getEndDate().getTime() + 24L * 60 * 60 * 1000));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int cid = rs.getInt("cid");
                boolean isWalkIn = rs.wasNull();
                CustomerStatistic7 cs = new CustomerStatistic7();
                cs.setStartDate(criteria.getStartDate());
                cs.setEndDate(criteria.getEndDate());
                cs.setTotalTickets(rs.getInt("totalTickets"));
                cs.setTotalRevenue(rs.getFloat("totalRevenue"));
                if (isWalkIn) {
                    walkIn = cs;
                    continue;
                }
                cs.setId(cid);
                cs.setCustomerCode(rs.getString("customerCode"));
                cs.setFullName(rs.getString("fullName"));
                String tierName = rs.getString("tierName");
                if (tierName != null) {
                    MembershipTier7 tier = new MembershipTier7();
                    tier.setTierName(tierName);
                    MemberCard7 card = new MemberCard7();
                    card.setTier(tier);
                    cs.setMemberCard(card);
                }
                list.add(cs);
            }
        } catch (SQLException e) {
            printSQLException(e);
            throw new IllegalStateException("Không thể lấy thống kê khách hàng", e);
        }
        if (list.isEmpty() && walkIn == null)
            return list;
        if (walkIn == null) {
            walkIn = new CustomerStatistic7();
            walkIn.setStartDate(criteria.getStartDate());
            walkIn.setEndDate(criteria.getEndDate());
        }
        float total = walkIn.getTotalRevenue();
        for (CustomerStatistic7 cs : list)
            total += cs.getTotalRevenue();
        for (CustomerStatistic7 cs : list)
            cs.setRevenuePercent(total > 0 ? cs.getTotalRevenue() * 100 / total : 0);
        walkIn.setRevenuePercent(total > 0 ? walkIn.getTotalRevenue() * 100 / total : 0);
        list.add(walkIn);
        return list;
    }

    @Override
    public List<CustomerStatistic7> sortByRevenue(List<CustomerStatistic7> list, String order) {
        List<CustomerStatistic7> rows = new ArrayList<>();
        CustomerStatistic7 walkIn = null;
        for (CustomerStatistic7 cs : list) {
            if (cs.getCustomerCode() == null)
                walkIn = cs;
            else
                rows.add(cs);
        }
        Collections.sort(rows, (a, b) -> Float.compare(a.getTotalRevenue(), b.getTotalRevenue()));
        if ("desc".equals(order))
            Collections.reverse(rows);
        if (walkIn != null)
            rows.add(walkIn);
        return rows;
    }
    
    private static final String SELECT_CUSTOMER_BY_ID = "SELECT u.fullName, c.customerCode, mt.tierName FROM tblCustomer7 c "
            + "JOIN tblUser7 u ON u.id = c.tblUser7id "
            + "LEFT JOIN tblMemberCard7 mc ON mc.tblCustomer7id = c.tblUser7id "
            + "LEFT JOIN tblMembershipTier7 mt ON mt.id = mc.tblMembershipTier7id WHERE c.tblUser7id = ?";

    @Override
    public CustomerStatistic7 getCustomerInfo(CustomerStatistic7 customerStat) {
        try (Connection connection = getConnection();
                PreparedStatement ps = connection.prepareStatement(SELECT_CUSTOMER_BY_ID)) {
            ps.setInt(1, customerStat.getId());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                customerStat.setCustomerCode(rs.getString("customerCode"));
                customerStat.setFullName(rs.getString("fullName"));
                customerStat.setMemberCard(null);
                if (rs.getString("tierName") != null) {
                    MembershipTier7 tier = new MembershipTier7();
                    tier.setTierName(rs.getString("tierName"));
                    MemberCard7 card = new MemberCard7();
                    card.setTier(tier);
                    customerStat.setMemberCard(card);
                }
                return customerStat;
            }
        } catch (SQLException e) {
            printSQLException(e);
            throw new IllegalStateException("Không thể lấy thông tin khách hàng", e);
        }
        return null;
    }
}
