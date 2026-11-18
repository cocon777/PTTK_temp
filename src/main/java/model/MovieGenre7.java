package model;

/**
 * MovieGenre7.java
 * This is a model class represents link between a movie and a genre (n-n)
 */
public class MovieGenre7 {
    private int id;
    private Genre7 genre;

    public MovieGenre7() {
    }

    public MovieGenre7(int id, Genre7 genre) {
        this.id = id;
        this.genre = genre;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Genre7 getGenre() {
        return genre;
    }

    public void setGenre(Genre7 genre) {
        this.genre = genre;
    }
}