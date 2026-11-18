package model;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;

/**
 * Invoice7.java
 * This is a model class represents invoice; discountApplied is a percentage
 */
public class Invoice7 {
    private int id;
    private String invoiceCode;
    private Date transactionTime;
    private String paymentMethod;
    private float totalAmount;
    private float discountApplied;
    private String guestName;
    private String guestPhone;
    private Customer7 customer;
    private SalesStaff7 salesStaff;
    private List<Ticket7> tickets = new ArrayList<>();

    public Invoice7() {
    }

    public Invoice7(int id, Date transactionTime, String paymentMethod, float totalAmount, float discountApplied,
            String guestName, String guestPhone, Customer7 customer, SalesStaff7 salesStaff) {
        super();
        this.id = id;
        this.transactionTime = transactionTime;
        this.paymentMethod = paymentMethod;
        this.totalAmount = totalAmount;
        this.discountApplied = discountApplied;
        this.guestName = guestName;
        this.guestPhone = guestPhone;
        this.customer = customer;
        this.salesStaff = salesStaff;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getInvoiceCode() {
        return invoiceCode;
    }

    public void setInvoiceCode(String invoiceCode) {
        this.invoiceCode = invoiceCode;
    }

    public Date getTransactionTime() {
        return transactionTime;
    }

    public void setTransactionTime(Date transactionTime) {
        this.transactionTime = transactionTime;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public float getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(float totalAmount) {
        this.totalAmount = totalAmount;
    }

    public float getDiscountApplied() {
        return discountApplied;
    }

    public void setDiscountApplied(float discountApplied) {
        this.discountApplied = discountApplied;
    }

    public String getGuestName() {
        return guestName;
    }

    public void setGuestName(String guestName) {
        this.guestName = guestName;
    }

    public String getGuestPhone() {
        return guestPhone;
    }

    public void setGuestPhone(String guestPhone) {
        this.guestPhone = guestPhone;
    }

    public Customer7 getCustomer() {
        return customer;
    }

    public void setCustomer(Customer7 customer) {
        this.customer = customer;
    }

    public SalesStaff7 getSalesStaff() {
        return salesStaff;
    }

    public void setSalesStaff(SalesStaff7 salesStaff) {
        this.salesStaff = salesStaff;
    }

    public List<Ticket7> getTickets() {
        return Collections.unmodifiableList(tickets);
    }

    public void setTickets(List<Ticket7> tickets) {
        this.tickets = (tickets != null) ? new ArrayList<>(tickets) : new ArrayList<>();
    }

    public void addTicket(Ticket7 ticket) {
        this.tickets.add(ticket);
    }
}