package vn.edu.library.model;

/** Một cuốn/bản cụ thể của tài liệu được thư viện quản lý. */
public class BanTaiLieu {
    private final String maBan;
    private final String viTri;
    private final String tinhTrang;
    private final boolean sanSang;
    private final String hinhThuc;

    public BanTaiLieu(String maBan, String viTri, String tinhTrang,
                      boolean sanSang, String hinhThuc) {
        this.maBan = maBan;
        this.viTri = viTri;
        this.tinhTrang = tinhTrang;
        this.sanSang = sanSang;
        this.hinhThuc = hinhThuc;
    }

    public String getMaBan() { return maBan; }
    public String getViTri() { return viTri; }
    public String getTinhTrang() { return tinhTrang; }
    public boolean isSanSang() { return sanSang; }
    public String getTrangThai() { return sanSang ? "Sẵn sàng" : "Đang được mượn"; }
    public String getHinhThuc() { return hinhThuc; }
}
