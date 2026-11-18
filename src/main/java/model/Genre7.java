package model;

/**
 * Genre7.java
 * This is a model class represents movie genre
 */
public class Genre7 {
    private int id;
    private String genreName;
    private String description;

    public Genre7() {
    }

    public Genre7(int id, String genreName, String description) {
        super();
        this.id = id;
        this.genreName = genreName;
        this.description = description;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getGenreName() {
        return genreName;
    }

    public void setGenreName(String genreName) {
        this.genreName = genreName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}