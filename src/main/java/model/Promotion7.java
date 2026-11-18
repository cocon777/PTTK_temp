package model;

/**
 * Promotion7.java
 * This is a model class represents promotion; discountValue is a percentage
 */
public class Promotion7 {
    private int id;
    private String programName;
    private String condition;
    private float discountValue;

    public Promotion7() {
    }

    public Promotion7(int id, String programName, String condition, float discountValue) {
        super();
        this.id = id;
        this.programName = programName;
        this.condition = condition;
        this.discountValue = discountValue;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getProgramName() {
        return programName;
    }

    public void setProgramName(String programName) {
        this.programName = programName;
    }

    public String getCondition() {
        return condition;
    }

    public void setCondition(String condition) {
        this.condition = condition;
    }

    public float getDiscountValue() {
        return discountValue;
    }

    public void setDiscountValue(float discountValue) {
        this.discountValue = discountValue;
    }
}