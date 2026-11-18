package model;

import java.util.Date;
/**
 * CustomerStatistic7.java
 * This is a model class represents customer revenue statistic row (walk-in row
 * has customerCode == null)
 */
public class CustomerStatistic7 extends Customer7 {
    private int totalTickets;
    private float totalRevenue;
    private float revenuePercent;
    private Date startDate;
    private Date endDate;

    public CustomerStatistic7() {
    }

    public CustomerStatistic7(int totalTickets, float totalRevenue, float revenuePercent) {
        super();
        this.totalTickets = totalTickets;
        this.totalRevenue = totalRevenue;
        this.revenuePercent = revenuePercent;
    }

    public int getTotalTickets() {
        return totalTickets;
    }

    public void setTotalTickets(int totalTickets) {
        this.totalTickets = totalTickets;
    }

    public float getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(float totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public float getRevenuePercent() {
        return revenuePercent;
    }

    public void setRevenuePercent(float revenuePercent) {
        this.revenuePercent = revenuePercent;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date enDate) {
        this.endDate = enDate;
    }
}