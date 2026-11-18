package daoimpl;

import dao.UserDAO7;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import model.Customer7;
import model.Manager7;
import model.SalesStaff7;
import model.Staff7;
import model.User7;
import util.PasswordUtil7;

public class UserDAOImpl7 extends DAO7 implements UserDAO7 {
    private static final String SELECT_USER = "SELECT u.*, c.customerCode, s.staffCode, s.position, "
            + "m.tblUser7id AS managerId, ss.tblUser7id AS salesId FROM tblUser7 u "
            + "LEFT JOIN tblCustomer7 c ON c.tblUser7id=u.id "
            + "LEFT JOIN tblStaff7 s ON s.tblUser7id=u.id "
            + "LEFT JOIN tblManager7 m ON m.tblUser7id=u.id "
            + "LEFT JOIN tblSalesStaff7 ss ON ss.tblUser7id=u.id WHERE u.username=?";

    @Override
    public User7 authenticate(String username, String password) throws SQLException {
        try (Connection connection = getConnection();
                PreparedStatement ps = connection.prepareStatement(SELECT_USER)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next() || !PasswordUtil7.verify(password, rs.getString("password"))) return null;
                User7 user;
                if (rs.getObject("managerId") != null) user = new Manager7();
                else if (rs.getObject("salesId") != null) user = new SalesStaff7();
                else if (rs.getString("customerCode") != null) user = new Customer7();
                else return null;
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setFullName(rs.getString("fullName"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setDob(rs.getDate("dob"));
                if (user instanceof Customer7) ((Customer7) user).setCustomerCode(rs.getString("customerCode"));
                if (user instanceof Staff7) {
                    ((Staff7) user).setStaffCode(rs.getString("staffCode"));
                    ((Staff7) user).setPosition(rs.getString("position"));
                }
                // Không đưa mật khẩu/hash vào session.
                return user;
            }
        }
    }

    @Override
    public void registerCustomer(Customer7 customer) throws SQLException {
        String passwordHash = PasswordUtil7.hash(customer.getPassword());
        try (Connection connection = getConnection()) {
            connection.setAutoCommit(false);
            try {
                try (PreparedStatement ps = connection.prepareStatement(
                        "INSERT INTO tblUser7(username,password,fullName,phone,email,dob) VALUES(?,?,?,?,?,?)",
                        Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, customer.getUsername());
                    ps.setString(2, passwordHash);
                    ps.setString(3, customer.getFullName());
                    ps.setString(4, customer.getPhone());
                    ps.setString(5, customer.getEmail());
                    ps.setDate(6, new java.sql.Date(customer.getDob().getTime()));
                    ps.executeUpdate();
                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        if (!keys.next()) throw new SQLException("Không tạo được mã tài khoản.");
                        customer.setId(keys.getInt(1));
                    }
                }
                // Tiền tố riêng tránh trùng mã KH của dữ liệu đã nhập trước đó.
                customer.setCustomerCode("WEB" + customer.getId());
                try (PreparedStatement ps = connection.prepareStatement(
                        "INSERT INTO tblCustomer7(customerCode,tblUser7id) VALUES(?,?)")) {
                    ps.setString(1, customer.getCustomerCode());
                    ps.setInt(2, customer.getId());
                    ps.executeUpdate();
                }
                connection.commit();
                customer.setPassword(null);
            } catch (SQLException | RuntimeException ex) {
                connection.rollback();
                throw ex;
            }
        }
    }
}
