package dao;

import java.util.List;
import model.CustomerStatistic7;

public interface CustomerStatisticDAO7 {
    List<CustomerStatistic7> getCustomerRevenueStat(CustomerStatistic7 criteria);
    CustomerStatistic7 getCustomerInfo(CustomerStatistic7 customerStat);
    List<CustomerStatistic7> sortByRevenue(List<CustomerStatistic7> list, String order);
}