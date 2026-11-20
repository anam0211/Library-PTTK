# LibMan — Tìm kiếm và cho mượn tài liệu

Java 17+, JSP, JDBC và MySQL; chạy bằng Maven với Tomcat embedded.
Luồng xử lý: JSP → DAO → MySQL. JavaScript chỉ xử lý giao diện và in phiếu.

## Chạy trên Windows

```powershell
cd D:\Library-PTTK
.\run.bat
```

Mặc định dùng cổng 8080; đổi cổng bằng `.\run.bat 8081`. Dừng bằng Ctrl+C.
MySQL82 phải đang chạy; cấu hình hiện tại dùng CSDL `libman` tại `localhost:3306`.

- Đăng nhập: http://localhost:8080/dang-nhap
- Bạn đọc: http://localhost:8080/ban-doc
- Nhân viên: http://localhost:8080/nhan-vien

Bạn đọc đăng nhập để tra cứu; nhân viên đăng nhập để lập và in phiếu mượn.
Tài khoản demo: `BD0101` và `NV001`, dùng mật khẩu ứng dụng đã được cấp.

## Cấu hình và dữ liệu

- Mẫu JDBC: `config/database.properties.example`. Sao chép thành `config/database.properties` rồi điền thông tin MySQL cục bộ; file này được Git bỏ qua.
- Có thể cấu hình ngoài bằng `LIBMAN_DB_HOST`, `LIBMAN_DB_PORT`, `LIBMAN_DB_NAME`, `LIBMAN_DB_USER`, `LIBMAN_DB_PASSWORD`; chọn file khác bằng `LIBMAN_DB_CONFIG`.
- Nếu chưa có file cấu hình, `run.bat` hỏi tài khoản và mật khẩu MySQL khi chạy.
- Với CSDL mới, chạy SQL theo thứ tự: `01-schema.sql` → `02-demo-data.sql` → `04-more-demo-data.sql` → `06-book-covers.sql` trong thư mục `database/`. CSDL hiện tại đã có dữ liệu, không cần nạp lại.
- Kích hoạt tài khoản mẫu trên CSDL mới: đặt `LIBMAN_ACCOUNT_USERNAME`, `LIBMAN_ACCOUNT_PASSWORD`, rồi chạy `mvn compile exec:java "-Dexec.mainClass=vn.edu.library.db.AccountSetup"`.
- Ảnh bìa nằm trong `src/main/webapp/assets/images/books/`; nguồn ảnh ghi trong `sources.txt`.

## Cấu trúc chính

| Thư mục | Nội dung |
|---|---|
| `src/main/java/vn/edu/library/` | Chạy Tomcat, DAO, model, JDBC và mật khẩu |
| `src/main/webapp/WEB-INF/views/` | JSP và các phần dùng chung |
| `src/main/webapp/assets/` | CSS, JavaScript và ảnh đang sử dụng |
| `src/test/` | Kiểm thử Java/JSP/JDBC |
| `database/` | Cấu trúc CSDL và dữ liệu mẫu |
| `docs/` | Báo cáo thiết kế gốc |

## Build và kiểm tra

```powershell
mvn verify
mvn compile exec:java "-Dexec.mainClass=vn.edu.library.db.JdbcSmokeCheck"
```

WAR được tạo tại `target/Library-PTTK.war`; `target/` chứa file sinh tự động.
`JdbcSmokeCheck` kiểm tra kết nối MySQL bằng truy vấn chỉ đọc.
Kiểm thử tích hợp JDBC cần `LIBMAN_DB_INTEGRATION=true`; kiểm thử JSP có đăng nhập cần `LIBMAN_TEST_PASSWORD` (mật khẩu ứng dụng demo).
