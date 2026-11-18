package model;

import java.util.Date;

/**
 * Showtime7.java
 * This is a model class represents showtime of a movie in a room
 */
public class Showtime7 {
    private int id;
    private Date startTime;
    private Date endTimeExpected;
    private float ticketPrice;
    private String format;
    private Movie7 movie;
    private Room7 room;
    private Promotion7 promotion;

    public Showtime7() {
    }

    public Showtime7(int id, Date startTime, Date endTimeExpected, float ticketPrice, String format, Movie7 movie,
            Room7 room, Promotion7 promotion) {
        super();
        this.id = id;
        this.startTime = startTime;
        this.endTimeExpected = endTimeExpected;
        this.ticketPrice = ticketPrice;
        this.format = format;
        this.movie = movie;
        this.room = room;
        this.promotion = promotion;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getStartTime() {
        return startTime;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    public Date getEndTimeExpected() {
        return endTimeExpected;
    }

    public void setEndTimeExpected(Date endTimeExpected) {
        this.endTimeExpected = endTimeExpected;
    }

    public float getTicketPrice() {
        return ticketPrice;
    }

    public void setTicketPrice(float ticketPrice) {
        this.ticketPrice = ticketPrice;
    }

    public String getFormat() {
        return format;
    }

    public void setFormat(String format) {
        this.format = format;
    }

    public Movie7 getMovie() {
        return movie;
    }

    public void setMovie(Movie7 movie) {
        this.movie = movie;
    }

    public Room7 getRoom() {
        return room;
    }

    public void setRoom(Room7 room) {
        this.room = room;
    }

    public Promotion7 getPromotion() {
        return promotion;
    }

    public void setPromotion(Promotion7 promotion) {
        this.promotion = promotion;
    }
}