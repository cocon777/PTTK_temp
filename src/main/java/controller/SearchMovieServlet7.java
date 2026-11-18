package controller;

import dao.MovieDAO7;
import daoimpl.MovieDAOImpl7;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Movie7;

@WebServlet("/searchMovie")
public class SearchMovieServlet7 extends BaseServlet7 {
    private static final long serialVersionUID = 1L;
    private MovieDAO7 movieDAO;

    public void init() {
        movieDAO = new MovieDAOImpl7();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        if (keyword == null) {
            forward(request, response, "/view/customer/SearchMovieUI7.jsp");
            return;
        }
        keyword = keyword.trim();
        request.setAttribute("keyword", keyword);
        request.setAttribute("searched", true);
        if (keyword.isEmpty() || keyword.length() > 200) {
            request.setAttribute("message", keyword.isEmpty() ? "Vui lòng nhập từ khóa tìm kiếm"
                    : "Từ khóa tối đa 200 ký tự.");
            forward(request, response, "/view/customer/SearchMovieUI7.jsp");
            return;
        }
        List<Movie7> listMovie = movieDAO.getMoviesByKeyword(keyword);
        if (listMovie.isEmpty()) request.setAttribute("message", "Không tìm thấy phim phù hợp");
        request.setAttribute("listMovie", listMovie);
        forward(request, response, "/view/customer/SearchMovieUI7.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        doGet(request, response);
    }
}
