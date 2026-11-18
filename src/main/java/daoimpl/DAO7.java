package daoimpl;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public abstract class DAO7 {
    private String jdbcURL = read("DB_URL",
            "jdbc:mysql://localhost:3306/cineman7?useSSL=false&allowPublicKeyRetrieval=true&characterEncoding=UTF-8&serverTimezone=Asia/Ho_Chi_Minh");
    private String jdbcUsername = read("DB_USER", "root");
    private String jdbcPassword = read("DB_PASSWORD", null); // bắt buộc, không có mặc định

    // Ưu tiên biến môi trường, sau đó đến -D system property, cuối cùng là giá trị
    // mặc định
    private static String read(String key, String defaultValue) {
        String v = System.getenv(key);
        if (v == null || v.isEmpty())
            v = System.getProperty(key);
        return (v == null || v.isEmpty()) ? defaultValue : v;
    }

    protected Connection getConnection() {
        if (jdbcPassword == null) {
            throw new RuntimeException("Chưa cấu hình biến môi trường DB_PASSWORD");
        }
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
        } catch (SQLException | ClassNotFoundException e) {
            throw new RuntimeException("Không kết nối được CSDL: " + e.getMessage(), e);
        }
    }

    protected void printSQLException(SQLException ex) {
        for (Throwable e : ex) {
            if (e instanceof SQLException) {
                e.printStackTrace(System.err);
                System.err.println("SQLState: " + ((SQLException) e).getSQLState());
                System.err.println("Error Code: " + ((SQLException) e).getErrorCode());
                System.err.println("Message: " + e.getMessage());
            }
        }
    }
}