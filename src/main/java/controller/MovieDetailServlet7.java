package controller;

import dao.MovieDAO7;
import daoimpl.MovieDAOImpl7;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Movie7;

@WebServlet("/movieDetail")
public class MovieDetailServlet7 extends BaseServlet7 {
    private static final long serialVersionUID = 1L;
    private MovieDAO7 movieDAO;

    public void init() {
        movieDAO = new MovieDAOImpl7();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Movie7 movie = null;
        try {
            Movie7 selected = new Movie7();
            selected.setId(Integer.parseInt(request.getParameter("idMovie")));
            movie = movieDAO.getMovieDetail(selected);
        } catch (NumberFormatException e) {
            movie = null;
        }
        if (movie == null) {
            response.sendRedirect(request.getContextPath() + "/searchMovie");
            return;
        }
        request.setAttribute("movie", movie);
        String keyword = request.getParameter("keyword");
        request.setAttribute("keyword", keyword == null ? "" : keyword.trim());
        try {
            java.net.URI uri = java.net.URI.create(movie.getTrailer() == null ? "" : movie.getTrailer());
            if (("https".equalsIgnoreCase(uri.getScheme()) || "http".equalsIgnoreCase(uri.getScheme()))
                    && uri.getHost() != null) request.setAttribute("trailerUrl", uri.toString());
        } catch (IllegalArgumentException ignored) { /* Không hiển thị URL trailer không hợp lệ. */ }
        forward(request, response, "/view/customer/MovieDetailUI7.jsp");
    }
}
