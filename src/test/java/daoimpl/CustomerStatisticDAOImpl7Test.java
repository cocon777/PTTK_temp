package daoimpl;

import java.util.Arrays;
import java.util.List;
import model.CustomerStatistic7;
import org.junit.Test;
import static org.junit.Assert.*;

public class CustomerStatisticDAOImpl7Test {
    @Test public void keepsWalkInAtEndAndDoesNotMutateOriginalList() {
        CustomerStatistic7 low = row("WEB1", 100);
        CustomerStatistic7 high = row("WEB2", 300);
        CustomerStatistic7 walkIn = row(null, 500);
        List<CustomerStatistic7> original = Arrays.asList(low, high, walkIn);
        CustomerStatisticDAOImpl7 dao = new CustomerStatisticDAOImpl7();
        assertEquals(Arrays.asList(high, low, walkIn), dao.sortByRevenue(original, "desc"));
        assertEquals(Arrays.asList(low, high, walkIn), dao.sortByRevenue(original, "asc"));
        assertEquals(Arrays.asList(low, high, walkIn), original);
    }

    private CustomerStatistic7 row(String code, float revenue) {
        CustomerStatistic7 row = new CustomerStatistic7();
        row.setCustomerCode(code);
        row.setTotalRevenue(revenue);
        return row;
    }
}
