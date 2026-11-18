package dao;

import java.util.List;
import model.CustomerStatistic7;
import model.Invoice7;

public interface InvoiceDAO7 {
    List<Invoice7> getTransactionsByCustomer(CustomerStatistic7 customerStat);
}