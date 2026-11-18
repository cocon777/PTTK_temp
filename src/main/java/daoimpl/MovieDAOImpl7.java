package daoimpl;

import dao.MovieDAO7;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Genre7;
import model.Movie7;
import model.MovieGenre7;

public class MovieDAOImpl7 extends DAO7 implements MovieDAO7 {
    private static final String SELECT_MOVIES_BY_KEYWORD = "SELECT * FROM tblMovie7 WHERE LOWER(movieName) LIKE ? ESCAPE '!' ORDER BY releaseDate, id";
    private static final String SELECT_MOVIE_BY_ID = "SELECT * FROM tblMovie7 WHERE id = ?";
    private static final String SELECT_GENRES_BY_MOVIE = "SELECT mg.id AS idMovieGenre, g.id, g.genreName FROM tblMovieGenre7 mg "
            + "JOIN tblGenre7 g ON g.id = mg.tblGenre7id WHERE mg.tblMovie7id = ? ORDER BY g.genreName";
    private static final String SELECT_FORMATS_BY_MOVIE = "SELECT DISTINCT format FROM tblShowtime7 WHERE tblMovie7id = ? ORDER BY format";

    @Override
    public List<Movie7> getMoviesByKeyword(String keyword) {
        List<Movie7> list = new ArrayList<>();
        try (Connection connection = getConnection();
                PreparedStatement ps = connection.prepareStatement(SELECT_MOVIES_BY_KEYWORD)) {
            String literal = keyword.toLowerCase(java.util.Locale.ROOT)
                    .replace("!", "!!").replace("%", "!%").replace("_", "!_");
            ps.setString(1, "%" + literal + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Movie7 movie = new Movie7();
                fillMovie(rs, movie);
                list.add(movie);
            }
            for (Movie7 movie : list)
                loadGenresAndFormats(connection, movie);
        } catch (SQLException e) {
            printSQLException(e);
            throw new IllegalStateException("Không thể truy vấn phim", e);
        }
        return list;
    }

    @Override
    public Movie7 getMovieDetail(Movie7 movie) {
        try (Connection connection = getConnection();
                PreparedStatement ps = connection.prepareStatement(SELECT_MOVIE_BY_ID)) {
            ps.setInt(1, movie.getId());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                fillMovie(rs, movie);
                loadGenresAndFormats(connection, movie);
                return movie;
            }
        } catch (SQLException e) {
            printSQLException(e);
            throw new IllegalStateException("Không thể lấy chi tiết phim", e);
        }
        return null;
    }

    private void fillMovie(ResultSet rs, Movie7 m) throws SQLException {
        m.setId(rs.getInt("id"));
        m.setMovieName(rs.getString("movieName"));
        m.setDuration(rs.getInt("duration"));
        m.setDirector(rs.getString("director"));
        m.setActors(rs.getString("actors"));
        m.setDescription(rs.getString("description"));
        m.setPoster(rs.getString("poster"));
        m.setTrailer(rs.getString("trailer"));
        m.setReleaseDate(rs.getDate("releaseDate"));
        m.setLanguage(rs.getString("language"));
        m.setAgeRating(rs.getString("ageRating"));
    }

    private void loadGenresAndFormats(Connection connection, Movie7 movie) throws SQLException {
        List<MovieGenre7> movieGenres = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(SELECT_GENRES_BY_MOVIE)) {
            ps.setInt(1, movie.getId());
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Genre7 g = new Genre7();
                g.setId(rs.getInt("id"));
                g.setGenreName(rs.getString("genreName"));
                MovieGenre7 mg = new MovieGenre7();
                mg.setId(rs.getInt("idMovieGenre"));
                mg.setGenre(g);
                movieGenres.add(mg);
            }
        }
        movie.setMovieGenres(movieGenres);
        List<String> formats = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(SELECT_FORMATS_BY_MOVIE)) {
            ps.setInt(1, movie.getId());
            ResultSet rs = ps.executeQuery();
            while (rs.next())
                formats.add(rs.getString("format"));
        }
        movie.setFormats(formats);
    }
}
