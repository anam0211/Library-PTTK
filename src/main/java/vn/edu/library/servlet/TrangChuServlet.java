package vn.edu.library.servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class TrangChuServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("tieuDe", "Trang chủ bạn đọc");
        request.getRequestDispatcher("/WEB-INF/views/trang-chu.jsp").forward(request, response);
    }
}
