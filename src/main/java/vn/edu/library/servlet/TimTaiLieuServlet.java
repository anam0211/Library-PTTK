package vn.edu.library.servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.library.dao.TaiLieuDAO;

public class TimTaiLieuServlet extends HttpServlet {
    private final TaiLieuDAO taiLieuDAO = new TaiLieuDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String tuKhoa = request.getParameter("tenTaiLieu");
        request.setAttribute("tieuDe", "Tìm kiếm tài liệu");
        request.setAttribute("tuKhoa", tuKhoa == null ? "" : tuKhoa);
        request.setAttribute("daTim", tuKhoa != null);
        if (tuKhoa != null) {
            request.setAttribute("ketQua", taiLieuDAO.timTheoTen(tuKhoa));
        }
        request.getRequestDispatcher("/WEB-INF/views/tim-tai-lieu.jsp").forward(request, response);
    }
}
