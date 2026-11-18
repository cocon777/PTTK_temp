package model;

import java.util.Date;

/**
 * MemberCard7.java
 * This is a model class represents member card of a customer
 */
public class MemberCard7 {
    private int id;
    private String cardCode;
    private Date issueDate;
    private int loyaltyPoints;
    private MembershipTier7 tier;

    public MemberCard7() {
    }

    public MemberCard7(int id, String cardCode, Date issueDate, int loyaltyPoints, MembershipTier7 tier) {
        super();
        this.id = id;
        this.cardCode = cardCode;
        this.issueDate = issueDate;
        this.loyaltyPoints = loyaltyPoints;
        this.tier = tier;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCardCode() {
        return cardCode;
    }

    public void setCardCode(String cardCode) {
        this.cardCode = cardCode;
    }

    public Date getIssueDate() {
        return issueDate;
    }

    public void setIssueDate(Date issueDate) {
        this.issueDate = issueDate;
    }

    public int getLoyaltyPoints() {
        return loyaltyPoints;
    }

    public void setLoyaltyPoints(int loyaltyPoints) {
        this.loyaltyPoints = loyaltyPoints;
    }

    public MembershipTier7 getTier() {
        return tier;
    }

    public void setTier(MembershipTier7 tier) {
        this.tier = tier;
    }
}