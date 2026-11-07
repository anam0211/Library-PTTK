package vn.edu.library.dao;

import java.text.Normalizer;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import vn.edu.library.model.BanTaiLieu;
import vn.edu.library.model.TaiLieu;

/** Dữ liệu mẫu trong bộ nhớ. Có thể thay phần này bằng JDBC khi học CSDL. */
public class TaiLieuDAO {
    private static final List<TaiLieu> DANH_SACH = List.of(
        new TaiLieu("DT001", "Cơ sở dữ liệu", "Giáo trình", "Nguyễn Minh Hòa",
            "Nhà xuất bản A", 2024, 2, "Tiếng Việt", 320, null,
            "Mô hình dữ liệu quan hệ, thiết kế cơ sở dữ liệu và truy vấn.",
            List.of(
                new BanTaiLieu("BT001", "A1-K2-N1", "Tốt", true, "Mượn về"),
                new BanTaiLieu("BT003", "A1-K2-N1", "Tốt", false, "Mượn về")
            )),
        new TaiLieu("DT002", "Lập trình Java", "Giáo trình", "Lê Thu An",
            "Nhà xuất bản B", 2023, 1, "Tiếng Việt", 280, null,
            "Lập trình hướng đối tượng và xây dựng ứng dụng cơ bản bằng Java.",
            List.of(
                new BanTaiLieu("BT002", "A2-K1-N2", "Tốt", true, "Mượn về"),
                new BanTaiLieu("BT004", "A2-K1-N2", "Tốt", true, "Mượn về")
            )),
        new TaiLieu("DT003", "Hệ quản trị cơ sở dữ liệu", "Sách tham khảo", "Trần Quốc Bình",
            "Nhà xuất bản C", 2024, 1, "Tiếng Việt", 360, null,
            "Quản trị cơ sở dữ liệu, ngôn ngữ SQL, sao lưu và phục hồi dữ liệu.",
            List.of(new BanTaiLieu("BT005", "A1-K2-N2", "Tốt", false, "Mượn về")))
    );

    public List<TaiLieu> timTheoTen(String tuKhoa) {
        String tenCanTim = chuanHoa(tuKhoa);
        List<TaiLieu> ketQua = new ArrayList<>();
        for (TaiLieu taiLieu : DANH_SACH) {
            if (chuanHoa(taiLieu.getTenTaiLieu()).contains(tenCanTim)) {
                ketQua.add(taiLieu);
            }
        }
        return ketQua;
    }

    public TaiLieu timTheoMa(String maTaiLieu) {
        for (TaiLieu taiLieu : DANH_SACH) {
            if (taiLieu.getMaTaiLieu().equals(maTaiLieu)) {
                return taiLieu;
            }
        }
        return null;
    }

    // Tìm không phân biệt chữ hoa/thường, dấu tiếng Việt và khoảng trắng thừa.
    private String chuanHoa(String chuoi) {
        if (chuoi == null) {
            return "";
        }
        String ketQua = Normalizer.normalize(chuoi, Normalizer.Form.NFD);
        return ketQua.replaceAll("\\p{M}", "")
                .toLowerCase(Locale.ROOT).replace('đ', 'd')
                .trim().replaceAll("\\s+", " ");
    }
}
