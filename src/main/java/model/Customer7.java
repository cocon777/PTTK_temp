package model;

/**
 * Customer7.java
 * This is a model class represents customer; has at most one member card
 */
public class Customer7 extends User7 {
    private String customerCode;
    private MemberCard7 memberCard;

    public Customer7() {
    }

    public Customer7(String customerCode, MemberCard7 memberCard) {
        super();
        this.customerCode = customerCode;
        this.memberCard = memberCard;
    }

    public String getCustomerCode() {
        return customerCode;
    }

    public void setCustomerCode(String customerCode) {
        this.customerCode = customerCode;
    }

    public MemberCard7 getMemberCard() {
        return memberCard;
    }

    public void setMemberCard(MemberCard7 memberCard) {
        this.memberCard = memberCard;
    }
}