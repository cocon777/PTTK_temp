package model;

/**
 * SeatType7.java
 * This is a model class represents seat type with its extra fee (Thường, VIP,
 * Đôi)
 */
public class SeatType7 {
    private int id;
    private String typeName;
    private float extraFee;

    public SeatType7() {
    }

    public SeatType7(int id, String typeName, float extraFee) {
        super();
        this.id = id;
        this.typeName = typeName;
        this.extraFee = extraFee;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public float getExtraFee() {
        return extraFee;
    }

    public void setExtraFee(float extraFee) {
        this.extraFee = extraFee;
    }
}