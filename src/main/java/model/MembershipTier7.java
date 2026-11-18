package model;

/**
 * MembershipTier7.java
 * This is a model class represents membership tier; maxPoint is null for the
 * highest tier
 */
public class MembershipTier7 {
    private int id;
    private String tierName;
    private int minPoint;
    private Integer maxPoint;
    private float discountPercent;

    public MembershipTier7() {
    }

    public MembershipTier7(int id, String tierName, int minPoint, Integer maxPoint, float discountPercent) {
        super();
        this.id = id;
        this.tierName = tierName;
        this.minPoint = minPoint;
        this.maxPoint = maxPoint;
        this.discountPercent = discountPercent;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTierName() {
        return tierName;
    }

    public void setTierName(String tierName) {
        this.tierName = tierName;
    }

    public int getMinPoint() {
        return minPoint;
    }

    public void setMinPoint(int minPoint) {
        this.minPoint = minPoint;
    }

    public Integer getMaxPoint() {
        return maxPoint;
    }

    public void setMaxPoint(Integer maxPoint) {
        this.maxPoint = maxPoint;
    }

    public float getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(float discountPercent) {
        this.discountPercent = discountPercent;
    }
}