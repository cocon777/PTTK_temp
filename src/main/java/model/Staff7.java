package model;

/**
 * Staff7.java
 * This is a model class represents abstract staff member
 */
public abstract class Staff7 extends User7 {
    private String staffCode;
    private String position;

    public Staff7() {
    }

    public Staff7(String staffCode, String position) {
        super();
        this.staffCode = staffCode;
        this.position = position;
    }

    public String getStaffCode() {
        return staffCode;
    }

    public void setStaffCode(String staffCode) {
        this.staffCode = staffCode;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }
}