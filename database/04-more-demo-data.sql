-- BỔ SUNG DỮ LIỆU MẪU CHO HAI MÔ ĐUN TÌM TÀI LIỆU VÀ CHO MƯỢN.
-- Chạy trên CSDL libman đã có schema/dữ liệu ban đầu, bằng mysql --batch, KHÔNG --force.
-- 40 đầu giả lập, 240 bản BT1001..BT1240, 30 bạn đọc BD0101..BD0130.
-- Metadata/tác giả là dữ liệu giả lập, không phải thông tin thư mục được xác minh.
-- Chỉ INSERT bản còn thiếu; không sửa/xóa dữ liệu hay reset trạng thái bản đã mượn.
-- Dùng kết nối mới mỗi lần chạy để các bảng tạm tự được giải phóng.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
SET time_zone = '+07:00';
SET @sampleToday = CURRENT_DATE;
CREATE TEMPORARY TABLE _moreTitles (
  seedCode VARCHAR(20) PRIMARY KEY, titleName VARCHAR(255), authorName VARCHAR(255),
  secondAuthor VARCHAR(255), typeName VARCHAR(100), publisherName VARCHAR(255),
  publicationYear INT, edition VARCHAR(50), language VARCHAR(50), pageCount INT,
  subject VARCHAR(255), description VARCHAR(255)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
CREATE TEMPORARY TABLE _moreAuthors (authorName VARCHAR(255) PRIMARY KEY)
 CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
CREATE TEMPORARY TABLE _moreReaders (
  readerCode VARCHAR(50) PRIMARY KEY, fullName VARCHAR(255), cardNumber VARCHAR(50),
  readerStatus VARCHAR(30), cardStatus VARCHAR(30), readerGroup VARCHAR(100), scenario VARCHAR(100)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
CREATE TEMPORARY TABLE _moreCopies (
  copyCode VARCHAR(255) PRIMARY KEY, seedCode VARCHAR(20), physicalCondition VARCHAR(255),
  copyStatus VARCHAR(30), usageType VARCHAR(50), area VARCHAR(100), shelf VARCHAR(50), compartment VARCHAR(50)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
CREATE TEMPORARY TABLE _moreLoans (
  slipNumber VARCHAR(50) PRIMARY KEY, readerCode VARCHAR(50), borrowedDaysAgo INT,
  returnedDaysAgo INT NULL, status VARCHAR(30)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
CREATE TEMPORARY TABLE _moreDetails (
  slipNumber VARCHAR(50), copyCode VARCHAR(255) PRIMARY KEY, conditionAtLoan VARCHAR(255), note VARCHAR(255)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
CREATE TEMPORARY TABLE _moreGuard (
  ok INT NOT NULL, CONSTRAINT ck_more_demo_conflict CHECK (ok=1)
);

INSERT INTO _moreTitles VALUES
('EXT-001', 'Thực hành SQL và cơ sở dữ liệu quan hệ', 'Nguyễn Minh Khôi', NULL, 'Giáo trình', 'Nhà xuất bản Giáo dục', 2022, '1', 'Tiếng Việt', 197, 'Công nghệ thông tin', 'Dữ liệu mẫu. Tài liệu giới thiệu thực hành sql và cơ sở dữ liệu quan hệ, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-002', 'Thiết kế cơ sở dữ liệu nâng cao', 'Trần Thanh Hà', NULL, 'Giáo trình', 'Nhà xuất bản Khoa học và Kỹ thuật', 2023, '2', 'Tiếng Việt', 214, 'Công nghệ thông tin', 'Dữ liệu mẫu. Tài liệu giới thiệu thiết kế cơ sở dữ liệu nâng cao, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-003', 'An toàn và bảo mật cơ sở dữ liệu', 'Lê Quang Vinh', NULL, 'Sách tham khảo', 'Nhà xuất bản Tổng hợp', 2024, '3', 'Tiếng Việt', 231, 'Công nghệ thông tin', 'Dữ liệu mẫu. Tài liệu giới thiệu an toàn và bảo mật cơ sở dữ liệu, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-004', 'Cơ sở dữ liệu phân tán', 'Phạm Ngọc Anh', NULL, 'Giáo trình', 'Nhà xuất bản Đại học (mẫu)', 2025, '1', 'Tiếng Việt', 248, 'Công nghệ thông tin', 'Dữ liệu mẫu. Tài liệu giới thiệu cơ sở dữ liệu phân tán, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-005', 'Phân tích dữ liệu với Python', 'Vũ Tuấn Dũng', NULL, 'Giáo trình', 'Nhà xuất bản Giáo dục', 2026, '2', 'Tiếng Việt', 265, 'Công nghệ thông tin', 'Dữ liệu mẫu. Tài liệu giới thiệu phân tích dữ liệu với python, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-006', 'Lập trình Java căn bản', 'Đặng Thu Trang', NULL, 'Sách tham khảo', 'Nhà xuất bản Khoa học và Kỹ thuật', 2022, '3', 'Tiếng Việt', 282, 'Công nghệ thông tin', 'Dữ liệu mẫu. Tài liệu giới thiệu lập trình java căn bản, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-007', 'Lập trình Java Web với JSP và JDBC', 'Bùi Hoàng Sơn', NULL, 'Giáo trình', 'Nhà xuất bản Tổng hợp', 2023, '1', 'Tiếng Việt', 299, 'Công nghệ thông tin', 'Dữ liệu mẫu. Tài liệu giới thiệu lập trình java web với jsp và jdbc, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-008', 'Kiểm thử phần mềm', 'Đỗ Minh Châu', NULL, 'Giáo trình', 'Nhà xuất bản Đại học (mẫu)', 2024, '2', 'Tiếng Việt', 316, 'Công nghệ thông tin', 'Dữ liệu mẫu. Tài liệu giới thiệu kiểm thử phần mềm, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-009', 'Công nghệ phần mềm ứng dụng', 'Hồ Quốc Bảo', NULL, 'Sách tham khảo', 'Nhà xuất bản Giáo dục', 2025, '3', 'Tiếng Việt', 333, 'Công nghệ thông tin', 'Dữ liệu mẫu. Tài liệu giới thiệu công nghệ phần mềm ứng dụng, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-010', 'Cấu trúc dữ liệu nâng cao', 'Nguyễn Phương Linh', 'Trần Đức Huy', 'Giáo trình', 'Nhà xuất bản Khoa học và Kỹ thuật', 2026, '1', 'Tiếng Việt', 350, 'Công nghệ thông tin', 'Dữ liệu mẫu. Tài liệu giới thiệu cấu trúc dữ liệu nâng cao, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-011', 'Giải thuật và lập trình thi đấu', 'Trần Đức Huy', NULL, 'Giáo trình', 'Nhà xuất bản Tổng hợp', 2022, '2', 'Tiếng Việt', 367, 'Công nghệ thông tin', 'Dữ liệu mẫu. Tài liệu giới thiệu giải thuật và lập trình thi đấu, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-012', 'Hệ điều hành', 'Lê Thanh Tùng', NULL, 'Sách tham khảo', 'Nhà xuất bản Đại học (mẫu)', 2023, '3', 'Tiếng Việt', 384, 'Công nghệ thông tin', 'Dữ liệu mẫu. Tài liệu giới thiệu hệ điều hành, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-013', 'Kiến trúc máy tính', 'Phạm Bảo Ngọc', NULL, 'Giáo trình', 'Nhà xuất bản Giáo dục', 2024, '1', 'Tiếng Việt', 401, 'Công nghệ thông tin', 'Dữ liệu mẫu. Tài liệu giới thiệu kiến trúc máy tính, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-014', 'Trí tuệ nhân tạo nhập môn', 'Vũ Hoàng Anh', NULL, 'Giáo trình', 'Nhà xuất bản Khoa học và Kỹ thuật', 2025, '2', 'Tiếng Việt', 418, 'Công nghệ thông tin', 'Dữ liệu mẫu. Tài liệu giới thiệu trí tuệ nhân tạo nhập môn, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-015', 'Học máy cơ bản', 'Đặng Quang Minh', NULL, 'Sách tham khảo', 'Nhà xuất bản Tổng hợp', 2026, '3', 'Tiếng Việt', 435, 'Công nghệ thông tin', 'Dữ liệu mẫu. Tài liệu giới thiệu học máy cơ bản, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-016', 'An toàn thông tin', 'Bùi Thu Hiền', NULL, 'Giáo trình', 'Nhà xuất bản Đại học (mẫu)', 2022, '1', 'Tiếng Việt', 452, 'Công nghệ thông tin', 'Dữ liệu mẫu. Tài liệu giới thiệu an toàn thông tin, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-017', 'Quản trị mạng máy tính', 'Đỗ Hải Đăng', NULL, 'Giáo trình', 'Nhà xuất bản Giáo dục', 2023, '2', 'Tiếng Việt', 469, 'Công nghệ thông tin', 'Dữ liệu mẫu. Tài liệu giới thiệu quản trị mạng máy tính, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-018', 'Điện toán đám mây', 'Hồ Thanh Mai', NULL, 'Sách tham khảo', 'Nhà xuất bản Khoa học và Kỹ thuật', 2024, '3', 'Tiếng Việt', 486, 'Công nghệ thông tin', 'Dữ liệu mẫu. Tài liệu giới thiệu điện toán đám mây, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-019', 'Phát triển ứng dụng Web', 'Nguyễn Quốc Thành', NULL, 'Giáo trình', 'Nhà xuất bản Tổng hợp', 2025, '1', 'Tiếng Việt', 503, 'Công nghệ thông tin', 'Dữ liệu mẫu. Tài liệu giới thiệu phát triển ứng dụng web, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-020', 'Thiết kế giao diện người dùng', 'Trần Khánh Vy', 'Nguyễn Minh Khôi', 'Giáo trình', 'Nhà xuất bản Đại học (mẫu)', 2026, '2', 'Tiếng Việt', 520, 'Công nghệ thông tin', 'Dữ liệu mẫu. Tài liệu giới thiệu thiết kế giao diện người dùng, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-021', 'Toán rời rạc', 'Nguyễn Minh Khôi', NULL, 'Sách tham khảo', 'Nhà xuất bản Giáo dục', 2022, '3', 'Tiếng Việt', 537, 'Toán và khoa học', 'Dữ liệu mẫu. Tài liệu giới thiệu toán rời rạc, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-022', 'Đại số tuyến tính', 'Trần Thanh Hà', NULL, 'Giáo trình', 'Nhà xuất bản Khoa học và Kỹ thuật', 2023, '1', 'Tiếng Việt', 554, 'Toán và khoa học', 'Dữ liệu mẫu. Tài liệu giới thiệu đại số tuyến tính, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-023', 'Giải tích một biến', 'Lê Quang Vinh', NULL, 'Giáo trình', 'Nhà xuất bản Tổng hợp', 2024, '2', 'Tiếng Việt', 571, 'Toán và khoa học', 'Dữ liệu mẫu. Tài liệu giới thiệu giải tích một biến, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-024', 'Xác suất và thống kê', 'Phạm Ngọc Anh', NULL, 'Sách tham khảo', 'Nhà xuất bản Đại học (mẫu)', 2025, '3', 'Tiếng Việt', 588, 'Toán và khoa học', 'Dữ liệu mẫu. Tài liệu giới thiệu xác suất và thống kê, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-025', 'Phương pháp nghiên cứu khoa học', 'Vũ Tuấn Dũng', NULL, 'Giáo trình', 'Nhà xuất bản Giáo dục', 2026, '1', 'Tiếng Việt', 185, 'Toán và khoa học', 'Dữ liệu mẫu. Tài liệu giới thiệu phương pháp nghiên cứu khoa học, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-026', 'Kỹ năng viết báo cáo học thuật', 'Đặng Thu Trang', NULL, 'Giáo trình', 'Nhà xuất bản Khoa học và Kỹ thuật', 2022, '2', 'Tiếng Việt', 202, 'Ngoại ngữ và kỹ năng', 'Dữ liệu mẫu. Tài liệu giới thiệu kỹ năng viết báo cáo học thuật, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-027', 'Tiếng Anh chuyên ngành Công nghệ thông tin', 'Bùi Hoàng Sơn', NULL, 'Sách tham khảo', 'Nhà xuất bản Tổng hợp', 2023, '3', 'Tiếng Việt – Tiếng Anh', 219, 'Ngoại ngữ và kỹ năng', 'Dữ liệu mẫu. Tài liệu giới thiệu tiếng anh chuyên ngành công nghệ thông tin, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-028', 'Giao tiếp tiếng Anh cơ bản', 'Đỗ Minh Châu', NULL, 'Giáo trình', 'Nhà xuất bản Đại học (mẫu)', 2024, '1', 'Tiếng Việt – Tiếng Anh', 236, 'Ngoại ngữ và kỹ năng', 'Dữ liệu mẫu. Tài liệu giới thiệu giao tiếp tiếng anh cơ bản, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-029', 'Kinh tế học đại cương', 'Hồ Quốc Bảo', NULL, 'Giáo trình', 'Nhà xuất bản Giáo dục', 2025, '2', 'Tiếng Việt', 253, 'Kinh tế và quản lý', 'Dữ liệu mẫu. Tài liệu giới thiệu kinh tế học đại cương, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-030', 'Quản trị học', 'Nguyễn Phương Linh', 'Trần Đức Huy', 'Sách tham khảo', 'Nhà xuất bản Khoa học và Kỹ thuật', 2026, '3', 'Tiếng Việt', 270, 'Kinh tế và quản lý', 'Dữ liệu mẫu. Tài liệu giới thiệu quản trị học, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-031', 'Kế toán căn bản', 'Trần Đức Huy', NULL, 'Giáo trình', 'Nhà xuất bản Tổng hợp', 2022, '1', 'Tiếng Việt', 287, 'Kinh tế và quản lý', 'Dữ liệu mẫu. Tài liệu giới thiệu kế toán căn bản, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-032', 'Marketing căn bản', 'Lê Thanh Tùng', NULL, 'Giáo trình', 'Nhà xuất bản Đại học (mẫu)', 2023, '2', 'Tiếng Việt', 304, 'Kinh tế và quản lý', 'Dữ liệu mẫu. Tài liệu giới thiệu marketing căn bản, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-033', 'Khởi nghiệp đổi mới sáng tạo', 'Phạm Bảo Ngọc', NULL, 'Sách tham khảo', 'Nhà xuất bản Giáo dục', 2024, '3', 'Tiếng Việt', 321, 'Kinh tế và quản lý', 'Dữ liệu mẫu. Tài liệu giới thiệu khởi nghiệp đổi mới sáng tạo, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-034', 'Quản lý dự án', 'Vũ Hoàng Anh', NULL, 'Giáo trình', 'Nhà xuất bản Khoa học và Kỹ thuật', 2025, '1', 'Tiếng Việt', 338, 'Kinh tế và quản lý', 'Dữ liệu mẫu. Tài liệu giới thiệu quản lý dự án, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-035', 'Logistics và quản lý chuỗi cung ứng', 'Đặng Quang Minh', NULL, 'Giáo trình', 'Nhà xuất bản Tổng hợp', 2026, '2', 'Tiếng Việt', 355, 'Kinh tế và quản lý', 'Dữ liệu mẫu. Tài liệu giới thiệu logistics và quản lý chuỗi cung ứng, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-036', 'Tài chính doanh nghiệp', 'Bùi Thu Hiền', NULL, 'Sách tham khảo', 'Nhà xuất bản Đại học (mẫu)', 2022, '3', 'Tiếng Việt', 372, 'Kinh tế và quản lý', 'Dữ liệu mẫu. Tài liệu giới thiệu tài chính doanh nghiệp, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-037', 'Vật lý đại cương', 'Đỗ Hải Đăng', NULL, 'Giáo trình', 'Nhà xuất bản Giáo dục', 2023, '1', 'Tiếng Việt', 389, 'Toán và khoa học', 'Dữ liệu mẫu. Tài liệu giới thiệu vật lý đại cương, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-038', 'Điện tử cơ bản', 'Hồ Thanh Mai', NULL, 'Giáo trình', 'Nhà xuất bản Khoa học và Kỹ thuật', 2024, '2', 'Tiếng Việt', 406, 'Toán và khoa học', 'Dữ liệu mẫu. Tài liệu giới thiệu điện tử cơ bản, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-039', 'Internet vạn vật', 'Nguyễn Quốc Thành', NULL, 'Sách tham khảo', 'Nhà xuất bản Tổng hợp', 2025, '3', 'Tiếng Việt', 423, 'Công nghệ thông tin', 'Dữ liệu mẫu. Tài liệu giới thiệu internet vạn vật, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.'),
('EXT-040', 'Chuyển đổi số trong tổ chức', 'Trần Khánh Vy', 'Nguyễn Minh Khôi', 'Giáo trình', 'Nhà xuất bản Đại học (mẫu)', 2026, '1', 'Tiếng Việt', 440, 'Công nghệ thông tin', 'Dữ liệu mẫu. Tài liệu giới thiệu chuyển đổi số trong tổ chức, gồm kiến thức nền tảng, ví dụ minh họa và bài tập thực hành.');

INSERT INTO _moreAuthors VALUES
('Nguyễn Minh Khôi'),
('Trần Thanh Hà'),
('Lê Quang Vinh'),
('Phạm Ngọc Anh'),
('Vũ Tuấn Dũng'),
('Đặng Thu Trang'),
('Bùi Hoàng Sơn'),
('Đỗ Minh Châu'),
('Hồ Quốc Bảo'),
('Nguyễn Phương Linh'),
('Trần Đức Huy'),
('Lê Thanh Tùng'),
('Phạm Bảo Ngọc'),
('Vũ Hoàng Anh'),
('Đặng Quang Minh'),
('Bùi Thu Hiền'),
('Đỗ Hải Đăng'),
('Hồ Thanh Mai'),
('Nguyễn Quốc Thành'),
('Trần Khánh Vy');

INSERT INTO _moreReaders VALUES
('BD0101', 'Nguyễn Minh Anh', 'TD0101', 'Hoạt động', 'Hoạt động', 'Bạn đọc', 'Đủ điều kiện, chưa mượn'),
('BD0102', 'Trần Thu Hà', 'TD0102', 'Hoạt động', 'Hoạt động', 'Bạn đọc', 'Đang mượn 2 bản'),
('BD0103', 'Lê Hoàng Nam', 'TD0103', 'Hoạt động', 'Hoạt động', 'Bạn đọc', 'Có lịch sử trả 2 bản'),
('BD0104', 'Phạm Ngọc Linh', 'TD0104', 'Hoạt động', 'Hoạt động', 'Bạn đọc', 'Đủ điều kiện, chưa mượn'),
('BD0105', 'Vũ Đức Minh', 'TD0105', 'Hoạt động', 'Hoạt động', 'Bạn đọc', 'Đủ điều kiện, chưa mượn'),
('BD0106', 'Đặng Phương Thảo', 'TD0106', 'Hoạt động', 'Hoạt động', 'Bạn đọc', 'Đủ điều kiện, chưa mượn'),
('BD0107', 'Bùi Quang Huy', 'TD0107', 'Hoạt động', 'Hoạt động', 'Bạn đọc', 'Đủ điều kiện, chưa mượn'),
('BD0108', 'Đỗ Khánh Ly', 'TD0108', 'Hoạt động', 'Hoạt động', 'Bạn đọc', 'Đủ điều kiện, chưa mượn'),
('BD0109', 'Hồ Gia Bảo', 'TD0109', 'Hoạt động', 'Hoạt động', 'Bạn đọc', 'Đủ điều kiện, chưa mượn'),
('BD0110', 'Nguyễn Hải Yến', 'TD0110', 'Hoạt động', 'Hoạt động', 'Bạn đọc', 'Đủ điều kiện, chưa mượn'),
('BD0111', 'Trần Tuấn Kiệt', 'TD0111', 'Hoạt động', 'Hoạt động', 'Bạn đọc', 'Đủ điều kiện, chưa mượn'),
('BD0112', 'Lê Mỹ Duyên', 'TD0112', 'Hoạt động', 'Hoạt động', 'Bạn đọc', 'Đủ điều kiện, chưa mượn'),
('BD0113', 'Phạm Thành Đạt', 'TD0113', 'Hoạt động', 'Hoạt động', 'Bạn đọc', 'Đủ điều kiện, chưa mượn'),
('BD0114', 'Vũ Ngọc Mai', 'TD0114', 'Hoạt động', 'Hoạt động', 'Bạn đọc', 'Đủ điều kiện, chưa mượn'),
('BD0115', 'Đặng Minh Khang', 'TD0115', 'Hoạt động', 'Hoạt động', 'Bạn đọc', 'Đủ điều kiện, chưa mượn'),
('BD0116', 'Bùi Thanh Trúc', 'TD0116', 'Hoạt động', 'Hoạt động', 'Bạn đọc', 'Đủ điều kiện, chưa mượn'),
('BD0117', 'Đỗ Nhật Minh', 'TD0117', 'Hoạt động', 'Hoạt động', 'Bạn đọc', 'Đủ điều kiện, chưa mượn'),
('BD0118', 'Hồ Bảo Ngọc', 'TD0118', 'Hoạt động', 'Hoạt động', 'Bạn đọc', 'Đủ điều kiện, chưa mượn'),
('BD0119', 'Nguyễn Quốc Hưng', 'TD0119', 'Hoạt động', 'Hoạt động', 'Bạn đọc', 'Đủ điều kiện, chưa mượn'),
('BD0120', 'Trần Thùy Dương', 'TD0120', 'Hoạt động', 'Hoạt động', 'Bạn đọc', 'Đủ điều kiện, chưa mượn'),
('BD0121', 'Lê Hoàng Phúc', 'TD0121', 'Hoạt động', 'Hết hạn', 'Bạn đọc', 'Thẻ hết hạn'),
('BD0122', 'Phạm Anh Thư', 'TD0122', 'Hoạt động', 'Bị khóa', 'Bạn đọc', 'Thẻ bị khóa'),
('BD0123', 'Vũ Minh Tâm', 'TD0123', 'Bị khóa', 'Hoạt động', 'Bạn đọc', 'Hồ sơ bị khóa'),
('BD0124', 'Đặng Quốc Việt', 'TD0124', 'Hoạt động', 'Hoạt động', 'Bạn đọc mẫu kiểm tra', 'Đã đủ 5 bản'),
('BD0125', 'Bùi Hồng Nhung', 'TD0125', 'Hoạt động', 'Hoạt động', 'Bạn đọc mẫu kiểm tra', 'Có lượt quá hạn'),
('BD0126', 'Đỗ Minh Quân', 'TD0126', 'Hoạt động', 'Hoạt động', 'Bạn đọc mẫu kiểm tra', 'Còn phạt 75.000 đồng'),
('BD0127', 'Hồ Thanh Bình', 'TD0127', 'Hoạt động', 'Hoạt động', 'Bạn đọc', 'Đủ điều kiện, chưa mượn'),
('BD0128', 'Nguyễn Khánh An', 'TD0128', 'Hoạt động', 'Hoạt động', 'Bạn đọc', 'Đủ điều kiện, chưa mượn'),
('BD0129', 'Trần Gia Hân', 'TD0129', 'Hoạt động', 'Hoạt động', 'Bạn đọc', 'Đủ điều kiện, chưa mượn'),
('BD0130', 'Lê Tuấn Anh', 'TD0130', 'Hoạt động', 'Hoạt động', 'Bạn đọc', 'Đủ điều kiện, chưa mượn');

INSERT INTO _moreCopies VALUES
('BT1001', 'EXT-001', 'Tốt', 'Đang được mượn', 'Mượn về', 'C1', 'K1', 'N1'),
('BT1002', 'EXT-001', 'Tốt', 'Đang được mượn', 'Mượn về', 'C1', 'K1', 'N1'),
('BT1003', 'EXT-001', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C1', 'K1', 'N1'),
('BT1004', 'EXT-001', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C1', 'K1', 'N1'),
('BT1005', 'EXT-001', 'Hư hỏng nhẹ', 'Sẵn sàng', 'Mượn về', 'C1', 'K1', 'N1'),
('BT1006', 'EXT-001', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C1', 'K1', 'N1'),
('BT1007', 'EXT-002', 'Tốt', 'Đang được mượn', 'Mượn về', 'C1', 'K1', 'N2'),
('BT1008', 'EXT-002', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C1', 'K1', 'N2'),
('BT1009', 'EXT-002', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C1', 'K1', 'N2'),
('BT1010', 'EXT-002', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C1', 'K1', 'N2'),
('BT1011', 'EXT-002', 'Hư hỏng nhẹ', 'Sẵn sàng', 'Mượn về', 'C1', 'K1', 'N2'),
('BT1012', 'EXT-002', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C1', 'K1', 'N2'),
('BT1013', 'EXT-003', 'Tốt', 'Đang được mượn', 'Mượn về', 'C1', 'K2', 'N1'),
('BT1014', 'EXT-003', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C1', 'K2', 'N1'),
('BT1015', 'EXT-003', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C1', 'K2', 'N1'),
('BT1016', 'EXT-003', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C1', 'K2', 'N1'),
('BT1017', 'EXT-003', 'Hư hỏng nhẹ', 'Sẵn sàng', 'Mượn về', 'C1', 'K2', 'N1'),
('BT1018', 'EXT-003', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C1', 'K2', 'N1'),
('BT1019', 'EXT-004', 'Tốt', 'Đang được mượn', 'Mượn về', 'C1', 'K2', 'N2'),
('BT1020', 'EXT-004', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C1', 'K2', 'N2'),
('BT1021', 'EXT-004', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C1', 'K2', 'N2'),
('BT1022', 'EXT-004', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C1', 'K2', 'N2'),
('BT1023', 'EXT-004', 'Hư hỏng nhẹ', 'Sẵn sàng', 'Mượn về', 'C1', 'K2', 'N2'),
('BT1024', 'EXT-004', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C1', 'K2', 'N2'),
('BT1025', 'EXT-005', 'Tốt', 'Đang được mượn', 'Mượn về', 'C1', 'K3', 'N1'),
('BT1026', 'EXT-005', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C1', 'K3', 'N1'),
('BT1027', 'EXT-005', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C1', 'K3', 'N1'),
('BT1028', 'EXT-005', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C1', 'K3', 'N1'),
('BT1029', 'EXT-005', 'Hư hỏng nhẹ', 'Sẵn sàng', 'Mượn về', 'C1', 'K3', 'N1'),
('BT1030', 'EXT-005', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C1', 'K3', 'N1'),
('BT1031', 'EXT-006', 'Tốt', 'Đang được mượn', 'Mượn về', 'C1', 'K3', 'N2'),
('BT1032', 'EXT-006', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C1', 'K3', 'N2'),
('BT1033', 'EXT-006', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C1', 'K3', 'N2'),
('BT1034', 'EXT-006', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C1', 'K3', 'N2'),
('BT1035', 'EXT-006', 'Hư hỏng nhẹ', 'Sẵn sàng', 'Mượn về', 'C1', 'K3', 'N2'),
('BT1036', 'EXT-006', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C1', 'K3', 'N2'),
('BT1037', 'EXT-007', 'Tốt', 'Đang được mượn', 'Mượn về', 'C1', 'K4', 'N1'),
('BT1038', 'EXT-007', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C1', 'K4', 'N1'),
('BT1039', 'EXT-007', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C1', 'K4', 'N1'),
('BT1040', 'EXT-007', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C1', 'K4', 'N1'),
('BT1041', 'EXT-007', 'Hư hỏng nhẹ', 'Ngừng phục vụ', 'Mượn về', 'C1', 'K4', 'N1'),
('BT1042', 'EXT-007', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C1', 'K4', 'N1'),
('BT1043', 'EXT-008', 'Hư hỏng nhẹ', 'Sẵn sàng', 'Mượn về', 'C1', 'K4', 'N2'),
('BT1044', 'EXT-008', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C1', 'K4', 'N2'),
('BT1045', 'EXT-008', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C1', 'K4', 'N2'),
('BT1046', 'EXT-008', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C1', 'K4', 'N2'),
('BT1047', 'EXT-008', 'Hư hỏng nhẹ', 'Sẵn sàng', 'Mượn về', 'C1', 'K4', 'N2'),
('BT1048', 'EXT-008', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C1', 'K4', 'N2'),
('BT1049', 'EXT-009', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C1', 'K5', 'N1'),
('BT1050', 'EXT-009', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C1', 'K5', 'N1'),
('BT1051', 'EXT-009', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C1', 'K5', 'N1'),
('BT1052', 'EXT-009', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C1', 'K5', 'N1'),
('BT1053', 'EXT-009', 'Hư hỏng nhẹ', 'Sẵn sàng', 'Mượn về', 'C1', 'K5', 'N1'),
('BT1054', 'EXT-009', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C1', 'K5', 'N1'),
('BT1055', 'EXT-010', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C1', 'K5', 'N2'),
('BT1056', 'EXT-010', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C1', 'K5', 'N2'),
('BT1057', 'EXT-010', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C1', 'K5', 'N2'),
('BT1058', 'EXT-010', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C1', 'K5', 'N2'),
('BT1059', 'EXT-010', 'Hư hỏng nhẹ', 'Sẵn sàng', 'Mượn về', 'C1', 'K5', 'N2'),
('BT1060', 'EXT-010', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C1', 'K5', 'N2'),
('BT1061', 'EXT-011', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C2', 'K1', 'N1'),
('BT1062', 'EXT-011', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C2', 'K1', 'N1'),
('BT1063', 'EXT-011', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C2', 'K1', 'N1'),
('BT1064', 'EXT-011', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C2', 'K1', 'N1'),
('BT1065', 'EXT-011', 'Hư hỏng nhẹ', 'Sẵn sàng', 'Mượn về', 'C2', 'K1', 'N1'),
('BT1066', 'EXT-011', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C2', 'K1', 'N1'),
('BT1067', 'EXT-012', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C2', 'K1', 'N2'),
('BT1068', 'EXT-012', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C2', 'K1', 'N2'),
('BT1069', 'EXT-012', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C2', 'K1', 'N2'),
('BT1070', 'EXT-012', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C2', 'K1', 'N2'),
('BT1071', 'EXT-012', 'Hư hỏng nhẹ', 'Sẵn sàng', 'Mượn về', 'C2', 'K1', 'N2'),
('BT1072', 'EXT-012', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C2', 'K1', 'N2'),
('BT1073', 'EXT-013', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C2', 'K2', 'N1'),
('BT1074', 'EXT-013', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C2', 'K2', 'N1'),
('BT1075', 'EXT-013', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C2', 'K2', 'N1'),
('BT1076', 'EXT-013', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C2', 'K2', 'N1'),
('BT1077', 'EXT-013', 'Hư hỏng nhẹ', 'Sẵn sàng', 'Mượn về', 'C2', 'K2', 'N1'),
('BT1078', 'EXT-013', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C2', 'K2', 'N1'),
('BT1079', 'EXT-014', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C2', 'K2', 'N2'),
('BT1080', 'EXT-014', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C2', 'K2', 'N2'),
('BT1081', 'EXT-014', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C2', 'K2', 'N2'),
('BT1082', 'EXT-014', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C2', 'K2', 'N2'),
('BT1083', 'EXT-014', 'Hư hỏng nhẹ', 'Ngừng phục vụ', 'Mượn về', 'C2', 'K2', 'N2'),
('BT1084', 'EXT-014', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C2', 'K2', 'N2'),
('BT1085', 'EXT-015', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C2', 'K3', 'N1'),
('BT1086', 'EXT-015', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C2', 'K3', 'N1'),
('BT1087', 'EXT-015', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C2', 'K3', 'N1'),
('BT1088', 'EXT-015', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C2', 'K3', 'N1'),
('BT1089', 'EXT-015', 'Hư hỏng nhẹ', 'Sẵn sàng', 'Mượn về', 'C2', 'K3', 'N1'),
('BT1090', 'EXT-015', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C2', 'K3', 'N1'),
('BT1091', 'EXT-016', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C2', 'K3', 'N2'),
('BT1092', 'EXT-016', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C2', 'K3', 'N2'),
('BT1093', 'EXT-016', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C2', 'K3', 'N2'),
('BT1094', 'EXT-016', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C2', 'K3', 'N2'),
('BT1095', 'EXT-016', 'Hư hỏng nhẹ', 'Sẵn sàng', 'Mượn về', 'C2', 'K3', 'N2'),
('BT1096', 'EXT-016', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C2', 'K3', 'N2'),
('BT1097', 'EXT-017', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C2', 'K4', 'N1'),
('BT1098', 'EXT-017', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C2', 'K4', 'N1'),
('BT1099', 'EXT-017', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C2', 'K4', 'N1'),
('BT1100', 'EXT-017', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C2', 'K4', 'N1'),
('BT1101', 'EXT-017', 'Hư hỏng nhẹ', 'Sẵn sàng', 'Mượn về', 'C2', 'K4', 'N1'),
('BT1102', 'EXT-017', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C2', 'K4', 'N1'),
('BT1103', 'EXT-018', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C2', 'K4', 'N2'),
('BT1104', 'EXT-018', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C2', 'K4', 'N2'),
('BT1105', 'EXT-018', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C2', 'K4', 'N2'),
('BT1106', 'EXT-018', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C2', 'K4', 'N2'),
('BT1107', 'EXT-018', 'Hư hỏng nhẹ', 'Sẵn sàng', 'Mượn về', 'C2', 'K4', 'N2'),
('BT1108', 'EXT-018', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C2', 'K4', 'N2'),
('BT1109', 'EXT-019', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C2', 'K5', 'N1'),
('BT1110', 'EXT-019', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C2', 'K5', 'N1'),
('BT1111', 'EXT-019', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C2', 'K5', 'N1'),
('BT1112', 'EXT-019', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C2', 'K5', 'N1'),
('BT1113', 'EXT-019', 'Hư hỏng nhẹ', 'Sẵn sàng', 'Mượn về', 'C2', 'K5', 'N1'),
('BT1114', 'EXT-019', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C2', 'K5', 'N1'),
('BT1115', 'EXT-020', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C2', 'K5', 'N2'),
('BT1116', 'EXT-020', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C2', 'K5', 'N2'),
('BT1117', 'EXT-020', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C2', 'K5', 'N2'),
('BT1118', 'EXT-020', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C2', 'K5', 'N2'),
('BT1119', 'EXT-020', 'Hư hỏng nhẹ', 'Sẵn sàng', 'Mượn về', 'C2', 'K5', 'N2'),
('BT1120', 'EXT-020', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C2', 'K5', 'N2'),
('BT1121', 'EXT-021', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C3', 'K1', 'N1'),
('BT1122', 'EXT-021', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C3', 'K1', 'N1'),
('BT1123', 'EXT-021', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C3', 'K1', 'N1'),
('BT1124', 'EXT-021', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C3', 'K1', 'N1'),
('BT1125', 'EXT-021', 'Hư hỏng nhẹ', 'Ngừng phục vụ', 'Mượn về', 'C3', 'K1', 'N1'),
('BT1126', 'EXT-021', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C3', 'K1', 'N1'),
('BT1127', 'EXT-022', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C3', 'K1', 'N2'),
('BT1128', 'EXT-022', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C3', 'K1', 'N2'),
('BT1129', 'EXT-022', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C3', 'K1', 'N2'),
('BT1130', 'EXT-022', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C3', 'K1', 'N2'),
('BT1131', 'EXT-022', 'Hư hỏng nhẹ', 'Sẵn sàng', 'Mượn về', 'C3', 'K1', 'N2'),
('BT1132', 'EXT-022', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C3', 'K1', 'N2'),
('BT1133', 'EXT-023', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C3', 'K2', 'N1'),
('BT1134', 'EXT-023', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C3', 'K2', 'N1'),
('BT1135', 'EXT-023', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C3', 'K2', 'N1'),
('BT1136', 'EXT-023', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C3', 'K2', 'N1'),
('BT1137', 'EXT-023', 'Hư hỏng nhẹ', 'Sẵn sàng', 'Mượn về', 'C3', 'K2', 'N1'),
('BT1138', 'EXT-023', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C3', 'K2', 'N1'),
('BT1139', 'EXT-024', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C3', 'K2', 'N2'),
('BT1140', 'EXT-024', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C3', 'K2', 'N2'),
('BT1141', 'EXT-024', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C3', 'K2', 'N2'),
('BT1142', 'EXT-024', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C3', 'K2', 'N2'),
('BT1143', 'EXT-024', 'Hư hỏng nhẹ', 'Sẵn sàng', 'Mượn về', 'C3', 'K2', 'N2'),
('BT1144', 'EXT-024', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C3', 'K2', 'N2'),
('BT1145', 'EXT-025', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C3', 'K3', 'N1'),
('BT1146', 'EXT-025', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C3', 'K3', 'N1'),
('BT1147', 'EXT-025', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C3', 'K3', 'N1'),
('BT1148', 'EXT-025', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C3', 'K3', 'N1'),
('BT1149', 'EXT-025', 'Hư hỏng nhẹ', 'Sẵn sàng', 'Mượn về', 'C3', 'K3', 'N1'),
('BT1150', 'EXT-025', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C3', 'K3', 'N1'),
('BT1151', 'EXT-026', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C3', 'K3', 'N2'),
('BT1152', 'EXT-026', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C3', 'K3', 'N2'),
('BT1153', 'EXT-026', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C3', 'K3', 'N2'),
('BT1154', 'EXT-026', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C3', 'K3', 'N2'),
('BT1155', 'EXT-026', 'Hư hỏng nhẹ', 'Sẵn sàng', 'Mượn về', 'C3', 'K3', 'N2'),
('BT1156', 'EXT-026', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C3', 'K3', 'N2'),
('BT1157', 'EXT-027', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C3', 'K4', 'N1'),
('BT1158', 'EXT-027', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C3', 'K4', 'N1'),
('BT1159', 'EXT-027', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C3', 'K4', 'N1'),
('BT1160', 'EXT-027', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C3', 'K4', 'N1'),
('BT1161', 'EXT-027', 'Hư hỏng nhẹ', 'Sẵn sàng', 'Mượn về', 'C3', 'K4', 'N1'),
('BT1162', 'EXT-027', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C3', 'K4', 'N1'),
('BT1163', 'EXT-028', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C3', 'K4', 'N2'),
('BT1164', 'EXT-028', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C3', 'K4', 'N2'),
('BT1165', 'EXT-028', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C3', 'K4', 'N2'),
('BT1166', 'EXT-028', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C3', 'K4', 'N2'),
('BT1167', 'EXT-028', 'Hư hỏng nhẹ', 'Ngừng phục vụ', 'Mượn về', 'C3', 'K4', 'N2'),
('BT1168', 'EXT-028', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C3', 'K4', 'N2'),
('BT1169', 'EXT-029', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C3', 'K5', 'N1'),
('BT1170', 'EXT-029', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C3', 'K5', 'N1'),
('BT1171', 'EXT-029', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C3', 'K5', 'N1'),
('BT1172', 'EXT-029', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C3', 'K5', 'N1'),
('BT1173', 'EXT-029', 'Hư hỏng nhẹ', 'Sẵn sàng', 'Mượn về', 'C3', 'K5', 'N1'),
('BT1174', 'EXT-029', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C3', 'K5', 'N1'),
('BT1175', 'EXT-030', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C3', 'K5', 'N2'),
('BT1176', 'EXT-030', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C3', 'K5', 'N2'),
('BT1177', 'EXT-030', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C3', 'K5', 'N2'),
('BT1178', 'EXT-030', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C3', 'K5', 'N2'),
('BT1179', 'EXT-030', 'Hư hỏng nhẹ', 'Sẵn sàng', 'Mượn về', 'C3', 'K5', 'N2'),
('BT1180', 'EXT-030', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C3', 'K5', 'N2'),
('BT1181', 'EXT-031', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C4', 'K1', 'N1'),
('BT1182', 'EXT-031', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C4', 'K1', 'N1'),
('BT1183', 'EXT-031', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C4', 'K1', 'N1'),
('BT1184', 'EXT-031', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C4', 'K1', 'N1'),
('BT1185', 'EXT-031', 'Hư hỏng nhẹ', 'Sẵn sàng', 'Mượn về', 'C4', 'K1', 'N1'),
('BT1186', 'EXT-031', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C4', 'K1', 'N1'),
('BT1187', 'EXT-032', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C4', 'K1', 'N2'),
('BT1188', 'EXT-032', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C4', 'K1', 'N2'),
('BT1189', 'EXT-032', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C4', 'K1', 'N2'),
('BT1190', 'EXT-032', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C4', 'K1', 'N2'),
('BT1191', 'EXT-032', 'Hư hỏng nhẹ', 'Sẵn sàng', 'Mượn về', 'C4', 'K1', 'N2'),
('BT1192', 'EXT-032', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C4', 'K1', 'N2'),
('BT1193', 'EXT-033', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C4', 'K2', 'N1'),
('BT1194', 'EXT-033', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C4', 'K2', 'N1'),
('BT1195', 'EXT-033', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C4', 'K2', 'N1'),
('BT1196', 'EXT-033', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C4', 'K2', 'N1'),
('BT1197', 'EXT-033', 'Hư hỏng nhẹ', 'Sẵn sàng', 'Mượn về', 'C4', 'K2', 'N1'),
('BT1198', 'EXT-033', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C4', 'K2', 'N1'),
('BT1199', 'EXT-034', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C4', 'K2', 'N2'),
('BT1200', 'EXT-034', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C4', 'K2', 'N2'),
('BT1201', 'EXT-034', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C4', 'K2', 'N2'),
('BT1202', 'EXT-034', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C4', 'K2', 'N2'),
('BT1203', 'EXT-034', 'Hư hỏng nhẹ', 'Sẵn sàng', 'Mượn về', 'C4', 'K2', 'N2'),
('BT1204', 'EXT-034', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C4', 'K2', 'N2'),
('BT1205', 'EXT-035', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C4', 'K3', 'N1'),
('BT1206', 'EXT-035', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C4', 'K3', 'N1'),
('BT1207', 'EXT-035', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C4', 'K3', 'N1'),
('BT1208', 'EXT-035', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C4', 'K3', 'N1'),
('BT1209', 'EXT-035', 'Hư hỏng nhẹ', 'Ngừng phục vụ', 'Mượn về', 'C4', 'K3', 'N1'),
('BT1210', 'EXT-035', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C4', 'K3', 'N1'),
('BT1211', 'EXT-036', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C4', 'K3', 'N2'),
('BT1212', 'EXT-036', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C4', 'K3', 'N2'),
('BT1213', 'EXT-036', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C4', 'K3', 'N2'),
('BT1214', 'EXT-036', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C4', 'K3', 'N2'),
('BT1215', 'EXT-036', 'Hư hỏng nhẹ', 'Sẵn sàng', 'Mượn về', 'C4', 'K3', 'N2'),
('BT1216', 'EXT-036', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C4', 'K3', 'N2'),
('BT1217', 'EXT-037', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C4', 'K4', 'N1'),
('BT1218', 'EXT-037', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C4', 'K4', 'N1'),
('BT1219', 'EXT-037', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C4', 'K4', 'N1'),
('BT1220', 'EXT-037', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C4', 'K4', 'N1'),
('BT1221', 'EXT-037', 'Hư hỏng nhẹ', 'Sẵn sàng', 'Mượn về', 'C4', 'K4', 'N1'),
('BT1222', 'EXT-037', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C4', 'K4', 'N1'),
('BT1223', 'EXT-038', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C4', 'K4', 'N2'),
('BT1224', 'EXT-038', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C4', 'K4', 'N2'),
('BT1225', 'EXT-038', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C4', 'K4', 'N2'),
('BT1226', 'EXT-038', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C4', 'K4', 'N2'),
('BT1227', 'EXT-038', 'Hư hỏng nhẹ', 'Sẵn sàng', 'Mượn về', 'C4', 'K4', 'N2'),
('BT1228', 'EXT-038', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C4', 'K4', 'N2'),
('BT1229', 'EXT-039', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C4', 'K5', 'N1'),
('BT1230', 'EXT-039', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C4', 'K5', 'N1'),
('BT1231', 'EXT-039', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C4', 'K5', 'N1'),
('BT1232', 'EXT-039', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C4', 'K5', 'N1'),
('BT1233', 'EXT-039', 'Hư hỏng nhẹ', 'Sẵn sàng', 'Mượn về', 'C4', 'K5', 'N1'),
('BT1234', 'EXT-039', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C4', 'K5', 'N1'),
('BT1235', 'EXT-040', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C4', 'K5', 'N2'),
('BT1236', 'EXT-040', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C4', 'K5', 'N2'),
('BT1237', 'EXT-040', 'Tốt', 'Sẵn sàng', 'Mượn về', 'C4', 'K5', 'N2'),
('BT1238', 'EXT-040', 'Cũ', 'Sẵn sàng', 'Mượn về', 'C4', 'K5', 'N2'),
('BT1239', 'EXT-040', 'Hư hỏng nhẹ', 'Sẵn sàng', 'Mượn về', 'C4', 'K5', 'N2'),
('BT1240', 'EXT-040', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'C4', 'K5', 'N2');

INSERT INTO _moreLoans VALUES
('DEMO-EXT-BD0102', 'BD0102', 2, NULL, 'Đang mượn'),
('DEMO-EXT-BD0103', 'BD0103', 25, 12, 'Đã trả'),
('DEMO-EXT-BD0124', 'BD0124', 3, NULL, 'Đang mượn'),
('DEMO-EXT-BD0125', 'BD0125', 30, NULL, 'Đang mượn'),
('DEMO-EXT-BD0126', 'BD0126', 35, 20, 'Đã trả');

INSERT INTO _moreDetails VALUES
('DEMO-EXT-BD0102', 'BT1001', 'Tốt', 'Dữ liệu mẫu bổ sung: đang mượn'),
('DEMO-EXT-BD0102', 'BT1002', 'Tốt', 'Dữ liệu mẫu bổ sung: đang mượn'),
('DEMO-EXT-BD0103', 'BT1049', 'Tốt', 'Dữ liệu mẫu bổ sung: lịch sử đã trả'),
('DEMO-EXT-BD0103', 'BT1050', 'Tốt', 'Dữ liệu mẫu bổ sung: lịch sử đã trả'),
('DEMO-EXT-BD0124', 'BT1007', 'Tốt', 'Dữ liệu mẫu bổ sung: đang mượn'),
('DEMO-EXT-BD0124', 'BT1013', 'Tốt', 'Dữ liệu mẫu bổ sung: đang mượn'),
('DEMO-EXT-BD0124', 'BT1019', 'Tốt', 'Dữ liệu mẫu bổ sung: đang mượn'),
('DEMO-EXT-BD0124', 'BT1025', 'Tốt', 'Dữ liệu mẫu bổ sung: đang mượn'),
('DEMO-EXT-BD0124', 'BT1031', 'Tốt', 'Dữ liệu mẫu bổ sung: đang mượn'),
('DEMO-EXT-BD0125', 'BT1037', 'Tốt', 'Dữ liệu mẫu bổ sung: lượt quá hạn'),
('DEMO-EXT-BD0126', 'BT1043', 'Tốt', 'Dữ liệu mẫu bổ sung: lượt đã trả, phạt chưa nộp');

-- Kiểm tra mã tham chiếu và xung đột trước khi ghi bảng nghiệp vụ.
SET @moreStaff = (SELECT m.id FROM tblMember m JOIN tblStaff s ON s.memberId=m.id
 WHERE m.username='NV001' AND m.role='Librarian' AND s.employmentStatus='Đang làm việc');
SET @moreSupplier = (SELECT MIN(id) FROM tblSupplier WHERE supplierName='LIBMAN-DEMO-SUPPLIER');
INSERT INTO _moreGuard VALUES (IF(@moreStaff IS NOT NULL AND @moreSupplier IS NOT NULL,1,0));
INSERT INTO _moreGuard SELECT IF(COUNT(*)>0,1,0) FROM tblBorrowingPolicy
 WHERE readerGroup='Bạn đọc' AND effectiveFrom<=@sampleToday AND (effectiveTo IS NULL OR effectiveTo>=@sampleToday);
INSERT INTO _moreGuard
SELECT IF(COUNT(*)=0,1,0) FROM _moreReaders d JOIN tblReader r ON r.readerCode=d.readerCode
 JOIN tblMember m ON m.id=r.memberId WHERE BINARY m.fullName<>BINARY d.fullName OR r.readerGroup<>d.readerGroup;
INSERT INTO _moreGuard
SELECT IF(COUNT(*)=0,1,0) FROM _moreReaders d JOIN tblMember m ON m.username=CONCAT('demo.more.',d.readerCode)
 LEFT JOIN tblReader r ON r.memberId=m.id WHERE r.readerCode IS NULL OR r.readerCode<>d.readerCode;
INSERT INTO _moreGuard
SELECT IF(COUNT(*)=0,1,0) FROM _moreReaders d JOIN tblLibraryCard c ON c.cardNumber=d.cardNumber
 JOIN tblCardApplication a ON a.id=c.cardApplicationId JOIN tblReader r ON r.memberId=a.readerId
 WHERE r.readerCode<>d.readerCode;
INSERT INTO _moreGuard
SELECT IF(COUNT(*)=0,1,0) FROM (
 SELECT d.seedCode FROM _moreTitles d JOIN tblDocumentTitle t
 ON t.titleName=d.titleName AND t.publicationYear=d.publicationYear AND t.edition=d.edition
 JOIN tblPublisher p ON p.id=t.publisherId AND p.publisherName=d.publisherName
 JOIN tblDocumentType ty ON ty.id=t.documentTypeId AND ty.typeName=d.typeName
 GROUP BY d.seedCode HAVING COUNT(*)>1
) ambiguous;
INSERT INTO _moreGuard
SELECT IF(COUNT(*)=0,1,0) FROM _moreCopies d JOIN _moreTitles b ON b.seedCode=d.seedCode
 JOIN tblDocumentCopy c ON c.copyCode=d.copyCode JOIN tblDocumentTitle t ON t.id=c.documentTitleId
 LEFT JOIN tblPublisher p ON p.id=t.publisherId LEFT JOIN tblDocumentType ty ON ty.id=t.documentTypeId
 WHERE BINARY t.titleName<>BINARY b.titleName OR NOT(t.publicationYear<=>b.publicationYear)
 OR NOT(t.edition<=>b.edition) OR NOT(p.publisherName<=>b.publisherName) OR NOT(ty.typeName<=>b.typeName);
INSERT INTO _moreGuard
SELECT IF(COUNT(*)=0,1,0) FROM _moreLoans d JOIN tblLoanSlip l ON l.slipNumber=d.slipNumber
 JOIN tblLibraryCard c ON c.id=l.libraryCardId JOIN tblCardApplication a ON a.id=c.cardApplicationId
 JOIN tblReader r ON r.memberId=a.readerId WHERE r.readerCode<>d.readerCode;
INSERT INTO _moreGuard
SELECT IF(COUNT(*)=0,1,0) FROM tblBorrowingPolicy WHERE dueDateRule='DEMO-EXT: ngày mượn + loanPeriodDays'
 AND (readerGroup<>'Bạn đọc mẫu kiểm tra' OR maximumCopies<>5 OR loanPeriodDays<>14
      OR NOT(borrowingRestriction<=>'BLOCK_OVERDUE,BLOCK_UNPAID_FINE'));

START TRANSACTION;
INSERT INTO tblBorrowingPolicy (maximumCopies,loanPeriodDays,dueDateRule,borrowingRestriction,effectiveFrom,readerGroup)
SELECT 5,14,'DEMO-EXT: ngày mượn + loanPeriodDays','BLOCK_OVERDUE,BLOCK_UNPAID_FINE',DATE_SUB(@sampleToday,INTERVAL 2 YEAR),'Bạn đọc mẫu kiểm tra'
WHERE NOT EXISTS (SELECT 1 FROM tblBorrowingPolicy WHERE dueDateRule='DEMO-EXT: ngày mượn + loanPeriodDays');

INSERT INTO tblMember (fullName,username,authenticationInfo,accountStatus,role,email,note)
SELECT d.fullName,CONCAT('demo.more.',d.readerCode),'DEMO-NO-LOGIN','Disabled','Reader',
 CONCAT(LOWER(d.readerCode),'@example.test'),CONCAT('Dữ liệu mẫu bổ sung: ',d.scenario)
FROM _moreReaders d WHERE NOT EXISTS (SELECT 1 FROM tblReader r WHERE r.readerCode=d.readerCode);
INSERT INTO tblReader (memberId,readerCode,readerStatus,institutionCode,readerGroup,unitOrClass,registeredAt)
SELECT m.id,d.readerCode,d.readerStatus,CONCAT('SV-MAU-',d.readerCode),d.readerGroup,
 'Lớp mẫu LibMan',DATE_SUB(@sampleToday,INTERVAL 2 YEAR)
FROM _moreReaders d JOIN tblMember m ON m.username=CONCAT('demo.more.',d.readerCode)
WHERE NOT EXISTS (SELECT 1 FROM tblReader r WHERE r.readerCode=d.readerCode);
INSERT INTO tblCardApplication (applicationType,submittedAt,status,processedAt,requestReason,outcome,librarianId,readerId)
SELECT 'Cấp mới',TIMESTAMP(DATE_SUB(@sampleToday,INTERVAL 2 YEAR),'08:00:00'),'Đã duyệt',
 TIMESTAMP(DATE_SUB(@sampleToday,INTERVAL 2 YEAR),'08:00:00'),CONCAT('DEMO-EXT-CARD-',d.cardNumber),'Đã cấp thẻ mẫu',@moreStaff,r.memberId
FROM _moreReaders d JOIN tblReader r ON r.readerCode=d.readerCode
WHERE NOT EXISTS (SELECT 1 FROM tblLibraryCard c WHERE c.cardNumber=d.cardNumber)
 AND NOT EXISTS (SELECT 1 FROM tblCardApplication a WHERE a.readerId=r.memberId AND a.requestReason=CONCAT('DEMO-EXT-CARD-',d.cardNumber));
INSERT INTO tblLibraryCard (issuedAt,cardNumber,expiresAt,status,lockOrReplacementReason,statusChangedAt,cardApplicationId)
SELECT DATE_SUB(@sampleToday,INTERVAL 2 YEAR),d.cardNumber,
 IF(d.cardStatus='Hết hạn',DATE_SUB(@sampleToday,INTERVAL 1 DAY),DATE_ADD(@sampleToday,INTERVAL 2 YEAR)),d.cardStatus,
 IF(d.cardStatus='Bị khóa','Thẻ mẫu bị khóa để kiểm tra điều kiện',NULL),CURRENT_TIMESTAMP,
 (SELECT MIN(a.id) FROM tblCardApplication a WHERE a.readerId=r.memberId AND a.requestReason=CONCAT('DEMO-EXT-CARD-',d.cardNumber))
FROM _moreReaders d JOIN tblReader r ON r.readerCode=d.readerCode
WHERE NOT EXISTS (SELECT 1 FROM tblLibraryCard c WHERE c.cardNumber=d.cardNumber);

INSERT INTO tblDocumentType (typeName,description)
SELECT DISTINCT d.typeName,'Danh mục mẫu bổ sung cho tra cứu' FROM _moreTitles d
WHERE NOT EXISTS (SELECT 1 FROM tblDocumentType t WHERE t.typeName=d.typeName);
INSERT INTO tblPublisher (publisherName,address,contactInformation)
SELECT DISTINCT d.publisherName,'Chưa có thông tin - dữ liệu mẫu','Dữ liệu mẫu'
FROM _moreTitles d WHERE NOT EXISTS (SELECT 1 FROM tblPublisher p WHERE p.publisherName=d.publisherName);
INSERT INTO tblAuthor (authorName,description)
SELECT d.authorName,'Tên tác giả giả lập cho dữ liệu mẫu' FROM _moreAuthors d
WHERE NOT EXISTS (SELECT 1 FROM tblAuthor a WHERE a.authorName=d.authorName);
INSERT INTO tblDocumentTitle (titleName,publicationYear,edition,language,pageCount,subject,description,catalogStatus,publisherId,documentTypeId)
SELECT d.titleName,d.publicationYear,d.edition,d.language,d.pageCount,d.subject,d.description,'Đang lưu hành',
 (SELECT MIN(id) FROM tblPublisher WHERE publisherName=d.publisherName),
 (SELECT MIN(id) FROM tblDocumentType WHERE typeName=d.typeName)
FROM _moreTitles d WHERE NOT EXISTS (
 SELECT 1 FROM tblDocumentTitle t JOIN tblPublisher p ON p.id=t.publisherId JOIN tblDocumentType ty ON ty.id=t.documentTypeId
 WHERE t.titleName=d.titleName AND t.publicationYear=d.publicationYear AND t.edition=d.edition
 AND p.publisherName=d.publisherName AND ty.typeName=d.typeName);
CREATE TEMPORARY TABLE _moreTitleIds (seedCode VARCHAR(20) PRIMARY KEY,id INT NOT NULL)
 CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
INSERT INTO _moreTitleIds
SELECT d.seedCode,t.id FROM _moreTitles d JOIN tblDocumentTitle t ON t.titleName=d.titleName
 AND t.publicationYear=d.publicationYear AND t.edition=d.edition
 JOIN tblPublisher p ON p.id=t.publisherId AND p.publisherName=d.publisherName
 JOIN tblDocumentType ty ON ty.id=t.documentTypeId AND ty.typeName=d.typeName;
INSERT INTO tblAuthorship (contributionRole,authorOrder,documentTitleId,authorId)
SELECT 'Tác giả',1,m.id,(SELECT MIN(id) FROM tblAuthor WHERE authorName=d.authorName)
FROM _moreTitles d JOIN _moreTitleIds m ON m.seedCode=d.seedCode
WHERE NOT EXISTS (SELECT 1 FROM tblAuthorship au JOIN tblAuthor a ON a.id=au.authorId WHERE au.documentTitleId=m.id AND a.authorName=d.authorName);
INSERT INTO tblAuthorship (contributionRole,authorOrder,documentTitleId,authorId)
SELECT 'Đồng tác giả',2,m.id,(SELECT MIN(id) FROM tblAuthor WHERE authorName=d.secondAuthor)
FROM _moreTitles d JOIN _moreTitleIds m ON m.seedCode=d.seedCode WHERE d.secondAuthor IS NOT NULL
 AND NOT EXISTS (SELECT 1 FROM tblAuthorship au JOIN tblAuthor a ON a.id=au.authorId WHERE au.documentTitleId=m.id AND a.authorName=d.secondAuthor);
INSERT INTO tblStorageLocation (area,shelf,compartment,description)
SELECT DISTINCT d.area,d.shelf,d.compartment,'Vị trí mẫu bổ sung' FROM _moreCopies d
WHERE NOT EXISTS (SELECT 1 FROM tblStorageLocation s WHERE s.area=d.area AND s.shelf=d.shelf AND s.compartment=d.compartment);
INSERT INTO tblGoodsReceipt (createdAt,confirmedAt,status,note,supplierId,librarianId)
SELECT TIMESTAMP(DATE_SUB(@sampleToday,INTERVAL 60 DAY),'08:00:00'),TIMESTAMP(DATE_SUB(@sampleToday,INTERVAL 60 DAY),'08:30:00'),
 'Đã xác nhận','DEMO-EXT-RECEIPT-20261120',@moreSupplier,@moreStaff
WHERE NOT EXISTS (SELECT 1 FROM tblGoodsReceipt WHERE note='DEMO-EXT-RECEIPT-20261120')
 AND EXISTS (SELECT 1 FROM _moreCopies d WHERE NOT EXISTS (SELECT 1 FROM tblDocumentCopy c WHERE c.copyCode=d.copyCode));
SET @moreReceipt = (SELECT MIN(id) FROM tblGoodsReceipt WHERE note='DEMO-EXT-RECEIPT-20261120');
INSERT INTO tblGoodsReceiptDetail (unitPrice,conditionAtReceipt,note,quantity,goodsReceiptId,documentTitleId)
SELECT 0,d.physicalCondition,'DEMO-EXT: đơn giá mẫu chưa được cung cấp',COUNT(*),@moreReceipt,m.id
FROM _moreCopies d JOIN _moreTitleIds m ON m.seedCode=d.seedCode
WHERE NOT EXISTS (SELECT 1 FROM tblDocumentCopy c WHERE c.copyCode=d.copyCode)
 AND NOT EXISTS (SELECT 1 FROM tblGoodsReceiptDetail g WHERE g.goodsReceiptId=@moreReceipt AND g.documentTitleId=m.id AND g.conditionAtReceipt=d.physicalCondition)
GROUP BY m.id,d.physicalCondition;
INSERT INTO tblDocumentCopy (copyCode,physicalCondition,copyStatus,note,deactivationReason,deactivatedAt,usageType,acquiredAt,goodsReceiptDetailId,storageLocationId,documentTitleId)
SELECT d.copyCode,d.physicalCondition,d.copyStatus,'Dữ liệu mẫu bổ sung cho tìm và mượn sách',
 IF(d.copyStatus='Ngừng phục vụ','Bản mẫu cần sửa chữa',NULL),IF(d.copyStatus='Ngừng phục vụ',CURRENT_TIMESTAMP,NULL),
 d.usageType,DATE_SUB(@sampleToday,INTERVAL 60 DAY),
 (SELECT MIN(g.id) FROM tblGoodsReceiptDetail g WHERE g.goodsReceiptId=@moreReceipt AND g.documentTitleId=m.id AND g.conditionAtReceipt=d.physicalCondition),s.id,m.id
FROM _moreCopies d JOIN _moreTitleIds m ON m.seedCode=d.seedCode
JOIN tblStorageLocation s ON s.area=d.area AND s.shelf=d.shelf AND s.compartment=d.compartment
WHERE NOT EXISTS (SELECT 1 FROM tblDocumentCopy c WHERE c.copyCode=d.copyCode);

-- Chính sách thực sự áp dụng theo nhóm của từng bạn đọc, không dùng id cố định.
INSERT INTO tblLoanSlip (slipNumber,borrowedAt,status,libraryCardId,borrowingPolicyId,librarianId)
SELECT d.slipNumber,TIMESTAMP(DATE_SUB(@sampleToday,INTERVAL d.borrowedDaysAgo DAY),'09:00:00'),d.status,c.id,
 (SELECT p.id FROM tblBorrowingPolicy p WHERE p.readerGroup=r.readerGroup
 AND p.effectiveFrom<=DATE_SUB(@sampleToday,INTERVAL d.borrowedDaysAgo DAY)
 AND (p.effectiveTo IS NULL OR p.effectiveTo>=DATE_SUB(@sampleToday,INTERVAL d.borrowedDaysAgo DAY))
 ORDER BY p.effectiveFrom DESC,p.id DESC LIMIT 1),@moreStaff
FROM _moreLoans d JOIN _moreReaders mr ON mr.readerCode=d.readerCode
 JOIN tblReader r ON r.readerCode=d.readerCode JOIN tblLibraryCard c ON c.cardNumber=mr.cardNumber
WHERE NOT EXISTS (SELECT 1 FROM tblLoanSlip l WHERE l.slipNumber=d.slipNumber);
INSERT INTO tblLoanDetail (dueDate,conditionAtLoan,returnedAt,conditionAtReturn,loanStatus,note,documentCopyId,loanSlipId)
SELECT DATE_ADD(DATE(l.borrowedAt),INTERVAL p.loanPeriodDays DAY),d.conditionAtLoan,
 IF(source.returnedDaysAgo IS NULL,NULL,TIMESTAMP(DATE_SUB(@sampleToday,INTERVAL source.returnedDaysAgo DAY),'10:00:00')),
 IF(source.returnedDaysAgo IS NULL,NULL,c.physicalCondition),source.status,d.note,c.id,l.id
FROM _moreDetails d JOIN _moreLoans source ON source.slipNumber=d.slipNumber
JOIN tblLoanSlip l ON l.slipNumber=d.slipNumber JOIN tblBorrowingPolicy p ON p.id=l.borrowingPolicyId
JOIN tblDocumentCopy c ON c.copyCode=d.copyCode
WHERE NOT EXISTS (SELECT 1 FROM tblLoanDetail ld WHERE ld.loanSlipId=l.id AND ld.documentCopyId=c.id);
INSERT INTO tblFineSlip (issuedAt,violationType,violationDescription,assessmentBasis,fineAmount,status,note,loanDetailId)
SELECT ld.returnedAt,'Hư hỏng','Hư hỏng bìa - tình huống dữ liệu mẫu','Mức phạt giả lập',75000,'Chờ nộp',
 'DEMO-EXT-UNPAID-BD0126',ld.id
FROM tblLoanDetail ld JOIN tblLoanSlip l ON l.id=ld.loanSlipId JOIN tblDocumentCopy c ON c.id=ld.documentCopyId
WHERE l.slipNumber='DEMO-EXT-BD0126' AND c.copyCode='BT1043'
 AND NOT EXISTS (SELECT 1 FROM tblFineSlip f WHERE f.loanDetailId=ld.id AND f.note='DEMO-EXT-UNPAID-BD0126');
COMMIT;

-- Tóm tắt dữ liệu mới và các mã có thể dùng thử ngay.
SELECT 'Đầu tài liệu bổ sung' AS category,COUNT(*) AS total FROM _moreTitleIds;
SELECT copyStatus,usageType,COUNT(*) AS total FROM tblDocumentCopy WHERE copyCode BETWEEN 'BT1001' AND 'BT1240' GROUP BY copyStatus,usageType;
SELECT d.readerCode,d.fullName,d.cardNumber,d.scenario FROM _moreReaders d ORDER BY d.readerCode;
