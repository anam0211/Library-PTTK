package vn.edu.library;

import java.net.URI;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.regex.Pattern;
import org.apache.catalina.startup.Tomcat;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

/** Gọi HTTP thật để kiểm tra Servlet, biên dịch JSP và JSTL cùng nhau. */
class WebFlowTest {
    private static Tomcat tomcat;
    private static String baseUrl;
    private static final HttpClient CLIENT = HttpClient.newHttpClient();

    @BeforeAll
    static void startServer() throws Exception {
        tomcat = Application.start(0);
        baseUrl = "http://localhost:" + tomcat.getConnector().getLocalPort();
    }

    @AfterAll
    static void stopServer() throws Exception {
        if (tomcat != null) {
            tomcat.stop();
            tomcat.destroy();
        }
    }

    private HttpResponse<String> get(String path) throws Exception {
        return CLIENT.send(HttpRequest.newBuilder(URI.create(baseUrl + path)).GET().build(),
                HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
    }

    @Test
    void trangChuCoLienKetTimKiem() throws Exception {
        var response = get("/");
        assertEquals(200, response.statusCode());
        assertTrue(response.body().contains("TRANG CHỦ BẠN ĐỌC"), response.body());
        assertTrue(response.body().contains("href=\"/tim-tai-lieu\""));
    }

    @Test
    void trangTimKiemBanDauHuongDanNhapTen() throws Exception {
        var response = get("/tim-tai-lieu");
        assertEquals(200, response.statusCode());
        assertTrue(response.body().contains("Nhập tên tài liệu và nhấn Tìm kiếm"));
    }

    @Test
    void timKiemVaXemChiTietGiuNguyenTuKhoa() throws Exception {
        String tuKhoa = URLEncoder.encode("cơ sở dữ liệu", StandardCharsets.UTF_8);
        var response = get("/tim-tai-lieu?tenTaiLieu=" + tuKhoa);
        assertEquals(200, response.statusCode());
        assertTrue(response.body().contains("DT001"));
        assertTrue(response.body().contains("DT003"));
        assertFalse(response.body().contains("DT002"));
        assertTrue(response.body().contains("Nguyễn Minh Hòa"));

        var detail = get("/chi-tiet-tai-lieu?ma=DT001&tenTaiLieu=" + tuKhoa);
        assertEquals(200, detail.statusCode());
        assertTrue(detail.body().contains("BT001"));
        assertTrue(detail.body().contains("BT003"));
        assertTrue(detail.body().contains("Đang được mượn"));
        assertTrue(detail.body().contains("Chưa có thông tin"));
        var link = Pattern.compile("href=\"(/tim-tai-lieu[^\"]*)\"").matcher(detail.body());
        assertTrue(link.find());
        assertEquals("/tim-tai-lieu?tenTaiLieu=cơ sở dữ liệu",
                URLDecoder.decode(link.group(1), StandardCharsets.UTF_8));
    }

    @Test
    void khongCoKetQuaHienThiThongBao() throws Exception {
        var response = get("/tim-tai-lieu?tenTaiLieu=xyz-khong-ton-tai");
        assertEquals(200, response.statusCode());
        assertTrue(response.body().contains("Không tìm thấy tài liệu phù hợp"));
    }

    @Test
    void maSaiVaThieuMaTraVe404() throws Exception {
        assertEquals(404, get("/chi-tiet-tai-lieu?ma=DT999").statusCode());
        assertEquals(404, get("/chi-tiet-tai-lieu").statusCode());
    }

    @Test
    void duLieuNhapDuocEscapeTruocKhiHienThi() throws Exception {
        String input = "\"><script>alert(1)</script>";
        var response = get("/tim-tai-lieu?tenTaiLieu=" + URLEncoder.encode(input, StandardCharsets.UTF_8));
        assertEquals(200, response.statusCode());
        assertFalse(response.body().contains("<script>"));
        assertTrue(response.body().contains("&lt;script&gt;"));
    }

    @Test
    void cssVaAnhBiaDuocPhucVu() throws Exception {
        assertEquals(200, get("/assets/css/style.css").statusCode());
        assertEquals(200, get("/assets/images/co-so-du-lieu.svg").statusCode());
        assertEquals(404, get("/WEB-INF/views/trang-chu.jsp").statusCode());
    }
}
