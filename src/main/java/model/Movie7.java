package model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Movie7.java
 * This is a model class represents movie
 */
public class Movie7 {
    private int id;
    private String movieName;
    private int duration;
    private String director;
    private String actors;
    private String description;
    private String poster;
    private String trailer;
    private Date releaseDate;
    private String language;
    private String ageRating;
    private List<MovieGenre7> movieGenres = new ArrayList<>();
    private List<String> formats = new ArrayList<>();

    public Movie7() {
    }

    public Movie7(int id, String movieName, int duration, String director, String actors, String description,
            String poster, String trailer, Date releaseDate, String language, String ageRating) {
        super();
        this.id = id;
        this.movieName = movieName;
        this.duration = duration;
        this.director = director;
        this.actors = actors;
        this.description = description;
        this.poster = poster;
        this.trailer = trailer;
        this.releaseDate = releaseDate;
        this.language = language;
        this.ageRating = ageRating;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public List<MovieGenre7> getMovieGenres() {
        return movieGenres;
    }

    public void setMovieGenres(List<MovieGenre7> movieGenres) {
        this.movieGenres = movieGenres;
    }

    public List<String> getFormats() {
        return formats;
    }

    public void setFormats(List<String> formats) {
        this.formats = formats;
    }

    public String getMovieName() {
        return movieName;
    }

    public void setMovieName(String movieName) {
        this.movieName = movieName;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public String getDirector() {
        return director;
    }

    public void setDirector(String director) {
        this.director = director;
    }

    public String getActors() {
        return actors;
    }

    public void setActors(String actors) {
        this.actors = actors;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPoster() {
        return poster;
    }

    public void setPoster(String poster) {
        this.poster = poster;
    }

    public String getTrailer() {
        return trailer;
    }

    public void setTrailer(String trailer) {
        this.trailer = trailer;
    }

    public Date getReleaseDate() {
        return releaseDate;
    }

    public void setReleaseDate(Date releaseDate) {
        this.releaseDate = releaseDate;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public String getAgeRating() {
        return ageRating;
    }

    public void setAgeRating(String ageRating) {
        this.ageRating = ageRating;
    }
}