package model;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Room7.java
 * This is a model class represents screening room
 */
public class Room7 {
    private int id;
    private String roomName;
    private int capacity;
    private String description;
    private int bufferMinutes;
    private List<Seat7> seats = new ArrayList<>();

    public Room7() {
    }

    public Room7(int id, String roomName, int capacity, String description, int bufferMinutes) {
        super();
        this.id = id;
        this.roomName = roomName;
        this.capacity = capacity;
        this.description = description;
        this.bufferMinutes = bufferMinutes;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getRoomName() {
        return roomName;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getBufferMinutes() {
        return bufferMinutes;
    }

    public void setBufferMinutes(int bufferMinutes) {
        this.bufferMinutes = bufferMinutes;
    }

    public List<Seat7> getSeats() {
        return Collections.unmodifiableList(seats);
    }

    public void setSeats(List<Seat7> seats) {
        this.seats = (seats != null) ? new ArrayList<>(seats) : new ArrayList<>();
    }

    public void addSeat(Seat7 seat) {
        this.seats.add(seat);
    }
}