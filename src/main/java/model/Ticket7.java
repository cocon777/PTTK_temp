package model;

/**
 * Ticket7.java
 * This is a model class represents ticket for a (showtime, seat) pair
 */
public class Ticket7 {
    private int id;
    private float actualPrice;
    private Showtime7 showtime;
    private Seat7 seat;

    public Ticket7() {
    }

    public Ticket7(int id, float actualPrice, Showtime7 showtime, Seat7 seat) {
        super();
        this.id = id;
        this.actualPrice = actualPrice;
        this.showtime = showtime;
        this.seat = seat;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public float getActualPrice() {
        return actualPrice;
    }

    public void setActualPrice(float actualPrice) {
        this.actualPrice = actualPrice;
    }

    public Showtime7 getShowtime() {
        return showtime;
    }

    public void setShowtime(Showtime7 showtime) {
        this.showtime = showtime;
    }

    public Seat7 getSeat() {
        return seat;
    }

    public void setSeat(Seat7 seat) {
        this.seat = seat;
    }
}