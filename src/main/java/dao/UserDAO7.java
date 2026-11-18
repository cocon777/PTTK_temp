package dao;

import java.sql.SQLException;
import model.Customer7;
import model.User7;

public interface UserDAO7 {
    User7 authenticate(String username, String password) throws SQLException;
    void registerCustomer(Customer7 customer) throws SQLException;
}
