package vn.edu.library.model;

import java.util.List;

/** Thông tin chung của một đầu tài liệu và danh sách các bản của nó. */
public class TaiLieu {
    private final String maTaiLieu;
    private final String tenTaiLieu;
    private final String loai;
    private final String tacGia;
    private final String nhaXuatBan;
    private final int namXuatBan;
    private final int lanXuatBan;
    private final String ngonNgu;
    private final int soTrang;
    private final String isbn;
    private final String moTa;
    private final List<BanTaiLieu> danhSachBan;

    public TaiLieu(String maTaiLieu, String tenTaiLieu, String loai, String tacGia,
                   String nhaXuatBan, int namXuatBan, int lanXuatBan,
                   String ngonNgu, int soTrang, String isbn, String moTa,
                   List<BanTaiLieu> danhSachBan) {
        this.maTaiLieu = maTaiLieu;
        this.tenTaiLieu = tenTaiLieu;
        this.loai = loai;
        this.tacGia = tacGia;
        this.nhaXuatBan = nhaXuatBan;
        this.namXuatBan = namXuatBan;
        this.lanXuatBan = lanXuatBan;
        this.ngonNgu = ngonNgu;
        this.soTrang = soTrang;
        this.isbn = isbn;
        this.moTa = moTa;
        this.danhSachBan = List.copyOf(danhSachBan);
    }

    public String getMaTaiLieu() { return maTaiLieu; }
    public String getTenTaiLieu() { return tenTaiLieu; }
    public String getLoai() { return loai; }
    public String getTacGia() { return tacGia; }
    public String getNhaXuatBan() { return nhaXuatBan; }
    public int getNamXuatBan() { return namXuatBan; }
    public int getLanXuatBan() { return lanXuatBan; }
    public String getNgonNgu() { return ngonNgu; }
    public int getSoTrang() { return soTrang; }
    public String getIsbn() { return isbn; }
    public String getMoTa() { return moTa; }
    public List<BanTaiLieu> getDanhSachBan() { return danhSachBan; }

    public int getSoBanCoTheMuon() {
        int soBan = 0;
        for (BanTaiLieu ban : danhSachBan) {
            if (ban.isSanSang()) {
                soBan++;
            }
        }
        return soBan;
    }
}
