package dao;

import java.util.List;
import model.Movie7;

public interface MovieDAO7 {
    List<Movie7> getMoviesByKeyword(String keyword);

    Movie7 getMovieDetail(Movie7 movie);
}