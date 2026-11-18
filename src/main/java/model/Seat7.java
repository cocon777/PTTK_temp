package model;

/**
 * Seat7.java
 * This is a model class represents seat in a room
 */
public class Seat7 {
    private int id;
    private String seatCode;
    private SeatType7 seatType;

    public Seat7() {
    }

    public Seat7(int id, String seatCode, SeatType7 seatType) {
        super();
        this.id = id;
        this.seatCode = seatCode;
        this.seatType = seatType;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getSeatCode() {
        return seatCode;
    }

    public void setSeatCode(String seatCode) {
        this.seatCode = seatCode;
    }

    public SeatType7 getSeatType() {
        return seatType;
    }

    public void setSeatType(SeatType7 seatType) {
        this.seatType = seatType;
    }
}