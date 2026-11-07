package vn.edu.library.servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.library.dao.TaiLieuDAO;
import vn.edu.library.model.TaiLieu;

public class ChiTietTaiLieuServlet extends HttpServlet {
    private final TaiLieuDAO taiLieuDAO = new TaiLieuDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        TaiLieu taiLieu = taiLieuDAO.timTheoMa(request.getParameter("ma"));
        request.setAttribute("tuKhoa", request.getParameter("tenTaiLieu"));
        if (taiLieu == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            request.setAttribute("tieuDe", "Không tìm thấy tài liệu");
            request.getRequestDispatcher("/WEB-INF/views/khong-tim-thay.jsp").forward(request, response);
            return;
        }
        request.setAttribute("tieuDe", "Chi tiết tài liệu");
        request.setAttribute("taiLieu", taiLieu);
        request.getRequestDispatcher("/WEB-INF/views/chi-tiet-tai-lieu.jsp").forward(request, response);
    }
}
