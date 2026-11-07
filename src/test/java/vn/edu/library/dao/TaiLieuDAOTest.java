package vn.edu.library.dao;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class TaiLieuDAOTest {
    private final TaiLieuDAO dao = new TaiLieuDAO();

    @Test
    void timCoSoDuLieuTraVeHaiDauTaiLieu() {
        var ketQua = dao.timTheoTen("cơ sở dữ liệu");
        assertEquals(2, ketQua.size());
        assertEquals("DT001", ketQua.get(0).getMaTaiLieu());
        assertEquals("DT003", ketQua.get(1).getMaTaiLieu());
    }

    @Test
    void timKhongDauKhongPhanBietHoaThuongVaKhoangTrangThua() {
        assertEquals(2, dao.timTheoTen("  CO   SO DU LIEU  ").size());
    }

    @Test
    void tuKhoaTrongHienThiTatCaTaiLieu() {
        assertEquals(3, dao.timTheoTen("").size());
        assertEquals(3, dao.timTheoTen(null).size());
    }

    @Test
    void tuKhoaKhongKhopTraVeDanhSachRong() {
        assertTrue(dao.timTheoTen("không có tài liệu này").isEmpty());
    }

    @Test
    void chiDemNhungBanSanSangChoMuon() {
        assertEquals(1, dao.timTheoMa("DT001").getSoBanCoTheMuon());
        assertEquals(2, dao.timTheoMa("DT002").getSoBanCoTheMuon());
        assertEquals(0, dao.timTheoMa("DT003").getSoBanCoTheMuon());
    }

    @Test
    void maKhongTonTaiKhongTraVeTaiLieu() {
        assertNull(dao.timTheoMa("DT999"));
        assertNull(dao.timTheoMa(null));
    }
}
