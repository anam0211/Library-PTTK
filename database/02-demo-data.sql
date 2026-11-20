-- LibMan demo seed; self-contained sample data for search and lending.
-- Run with mysql in BATCH mode WITHOUT --force; disconnect on any error.
-- Existing records are preserved. Conflicting demo identifiers abort before writes.
-- No fixed auto-increment IDs; DTxxx exists only in this session's mapping.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;
CREATE TEMPORARY TABLE _libman_demo_titles (
  code VARCHAR(50) PRIMARY KEY, titleName VARCHAR(255), authorName VARCHAR(255),
  typeName VARCHAR(100), publisherName VARCHAR(255), publicationYear INT,
  edition VARCHAR(50), language VARCHAR(50), pageCount INT, isbn VARCHAR(20),
  description VARCHAR(255)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
CREATE TEMPORARY TABLE _libman_demo_readers (
  readerCode VARCHAR(50) PRIMARY KEY, fullName VARCHAR(255), cardNumber VARCHAR(50),
  expiresAt DATE, activeCount INT
) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
CREATE TEMPORARY TABLE _libman_demo_copies (
  copyCode VARCHAR(255) PRIMARY KEY, titleCode VARCHAR(50), physicalCondition VARCHAR(255),
  copyStatus VARCHAR(30), usageType VARCHAR(50), area VARCHAR(100), shelf VARCHAR(50),
  compartment VARCHAR(50), holderCode VARCHAR(50) NULL
) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
CREATE TEMPORARY TABLE _libman_seed_guard (
  ok INT NOT NULL, CONSTRAINT ck_seed_identity_conflict CHECK (ok = 1)
);

INSERT INTO _libman_demo_titles VALUES
('DT001', 'Cơ sở dữ liệu', 'Nguyễn Minh Hòa', 'Giáo trình', 'Nhà xuất bản An A', 2024, 2, 'Tiếng Việt', 320, NULL, 'Mô hình dữ liệu quan hệ, thiết kế cơ sở dữ liệu và truy vấn. Nội dung gồm chuẩn hóa dữ liệu, ngôn ngữ SQL và các bài tập thực hành.'),
('DT002', 'Lập trình hướng đối tượng', 'Trần Quang Huy', 'Giáo trình', 'Nhà xuất bản Giáo dục', 2023, 1, 'Tiếng Việt', 288, NULL, 'Các nguyên lý lập trình hướng đối tượng: lớp, đối tượng, đóng gói, kế thừa và đa hình. Các ví dụ đi từ thiết kế lớp đến xây dựng một chương trình hoàn chỉnh.'),
('DT003', 'Mạng máy tính', 'Phạm Minh Tuấn', 'Giáo trình', 'Nhà xuất bản Khoa học và Kỹ thuật', 2022, 3, 'Tiếng Việt', 360, NULL, 'Kiến trúc mạng máy tính, mô hình phân tầng, các giao thức truyền thông và nguyên lý định tuyến. Tài liệu giới thiệu cách thiết kế, vận hành và bảo vệ một mạng cơ bản.'),
('DT004', 'Phân tích và thiết kế hệ thống', 'Nguyễn Thu Hà', 'Giáo trình', 'Nhà xuất bản Giáo dục', 2024, 2, 'Tiếng Việt', 304, NULL, 'Khảo sát hiện trạng, phân tích yêu cầu và thiết kế hệ thống thông tin. Nội dung trình bày các mô hình UML, thiết kế dữ liệu và thiết kế giao diện qua những tình huống thực tế.'),
('DT005', 'Cấu trúc dữ liệu và giải thuật', 'Lê Quốc Bảo', 'Giáo trình', 'Nhà xuất bản Khoa học và Kỹ thuật', 2023, 2, 'Tiếng Việt', 416, NULL, 'Các cấu trúc dữ liệu cơ bản, kỹ thuật tìm kiếm, sắp xếp và tổ chức dữ liệu. Mỗi chủ đề có phần phân tích độ phức tạp và bài tập áp dụng.'),
('DT006', 'Từ điển thuật ngữ tin học', 'Nhóm biên soạn Khoa Công nghệ thông tin', 'Tài liệu tham khảo', 'Nhà xuất bản Tổng hợp', 2021, 1, 'Tiếng Việt', 520, NULL, 'Tra cứu các thuật ngữ thường dùng trong công nghệ thông tin, từ phần cứng và phần mềm đến mạng máy tính, cơ sở dữ liệu và an toàn thông tin.'),
('DT007', 'Nhập môn công nghệ phần mềm', 'Bùi Minh Đức', 'Giáo trình', 'Nhà xuất bản Giáo dục', 2024, 1, 'Tiếng Việt', 336, NULL, 'Tổng quan vòng đời phát triển phần mềm, phân tích yêu cầu, thiết kế, kiểm thử và bảo trì. Tài liệu giới thiệu cách tổ chức một dự án phần mềm và quản lý chất lượng.'),
('DT008', 'Hệ quản trị cơ sở dữ liệu', 'Trần Quốc Bình', 'Giáo trình', 'Nhà xuất bản Khoa học và Kỹ thuật', 2023, 1, 'Tiếng Việt', 352, NULL, 'Kiến trúc hệ quản trị cơ sở dữ liệu, tổ chức lưu trữ, xử lý truy vấn và quản lý giao dịch. Nội dung bao gồm điều khiển tương tranh, sao lưu và phục hồi dữ liệu.');

INSERT INTO _libman_demo_readers VALUES
('BD001', 'Nguyễn Văn An', 'TD001', STR_TO_DATE(CONCAT(GREATEST(YEAR(CURDATE()), 2026) + 0, '-12-31'), '%Y-%m-%d'), 1),
('BD0017', 'Nguyễn Văn An', 'TD017', STR_TO_DATE(CONCAT(GREATEST(YEAR(CURDATE()), 2026) + 1, '-06-30'), '%Y-%m-%d'), 0),
('BD003', 'Phạm Thu Hà', 'TD003', '2020-12-31', 0),
('BD004', 'Lê Minh Đức', 'TD004', STR_TO_DATE(CONCAT(GREATEST(YEAR(CURDATE()), 2026) + 0, '-12-31'), '%Y-%m-%d'), 5);

-- Six additional copies represent the active counts (1 and 5) without borrowing BT001..BT040.

INSERT INTO _libman_demo_copies VALUES
('BT001', 'DT001', 'Hư hỏng nhẹ', 'Sẵn sàng', 'Mượn về', 'A1', 'K2', 'N1', NULL),
('BT002', 'DT002', 'Tốt', 'Sẵn sàng', 'Mượn về', 'A1', 'K2', 'N2', NULL),
('BT003', 'DT003', 'Tốt', 'Sẵn sàng', 'Mượn về', 'A1', 'K3', 'N1', NULL),
('BT004', 'DT004', 'Tốt', 'Sẵn sàng', 'Mượn về', 'A2', 'K1', 'N1', NULL),
('BT005', 'DT005', 'Cũ', 'Sẵn sàng', 'Mượn về', 'A2', 'K1', 'N2', NULL),
('BT006', 'DT006', 'Tốt', 'Sẵn sàng', 'Đọc tại chỗ', 'B1', 'K1', 'N1', NULL),
('BT007', 'DT007', 'Tốt', 'Sẵn sàng', 'Mượn về', 'A2', 'K2', 'N1', NULL),
('BT008', 'DT001', 'Tốt', 'Sẵn sàng', 'Mượn về', 'A1', 'K2', 'N1', NULL),
('BT009', 'DT001', 'Tốt', 'Sẵn sàng', 'Mượn về', 'A1', 'K2', 'N1', NULL),
('BT010', 'DT001', 'Tốt', 'Sẵn sàng', 'Mượn về', 'A1', 'K2', 'N1', NULL),
('BT011', 'DT001', 'Tốt', 'Sẵn sàng', 'Mượn về', 'A1', 'K2', 'N1', NULL),
('BT012', 'DT001', 'Tốt', 'Sẵn sàng', 'Mượn về', 'A1', 'K2', 'N1', NULL),
('BT013', 'DT001', 'Tốt', 'Sẵn sàng', 'Mượn về', 'A1', 'K2', 'N1', NULL),
('BT014', 'DT001', 'Tốt', 'Sẵn sàng', 'Mượn về', 'A1', 'K2', 'N1', NULL),
('BT015', 'DT002', 'Tốt', 'Sẵn sàng', 'Mượn về', 'A1', 'K2', 'N2', NULL),
('BT016', 'DT002', 'Tốt', 'Sẵn sàng', 'Mượn về', 'A1', 'K2', 'N2', NULL),
('BT017', 'DT002', 'Tốt', 'Sẵn sàng', 'Mượn về', 'A1', 'K2', 'N2', NULL),
('BT018', 'DT002', 'Tốt', 'Sẵn sàng', 'Mượn về', 'A1', 'K2', 'N2', NULL),
('BT019', 'DT003', 'Tốt', 'Sẵn sàng', 'Mượn về', 'A1', 'K3', 'N1', NULL),
('BT020', 'DT003', 'Tốt', 'Sẵn sàng', 'Mượn về', 'A1', 'K3', 'N1', NULL),
('BT021', 'DT003', 'Tốt', 'Sẵn sàng', 'Mượn về', 'A1', 'K3', 'N1', NULL),
('BT022', 'DT003', 'Tốt', 'Sẵn sàng', 'Mượn về', 'A1', 'K3', 'N1', NULL),
('BT023', 'DT003', 'Tốt', 'Sẵn sàng', 'Mượn về', 'A1', 'K3', 'N1', NULL),
('BT024', 'DT004', 'Tốt', 'Sẵn sàng', 'Mượn về', 'A2', 'K1', 'N1', NULL),
('BT025', 'DT004', 'Tốt', 'Sẵn sàng', 'Mượn về', 'A2', 'K1', 'N1', NULL),
('BT026', 'DT004', 'Tốt', 'Sẵn sàng', 'Mượn về', 'A2', 'K1', 'N1', NULL),
('BT027', 'DT005', 'Tốt', 'Sẵn sàng', 'Mượn về', 'A2', 'K1', 'N2', NULL),
('BT028', 'DT005', 'Tốt', 'Sẵn sàng', 'Mượn về', 'A2', 'K1', 'N2', NULL),
('BT029', 'DT005', 'Tốt', 'Sẵn sàng', 'Mượn về', 'A2', 'K1', 'N2', NULL),
('BT030', 'DT005', 'Tốt', 'Sẵn sàng', 'Mượn về', 'A2', 'K1', 'N2', NULL),
('BT031', 'DT005', 'Tốt', 'Sẵn sàng', 'Mượn về', 'A2', 'K1', 'N2', NULL),
('BT032', 'DT005', 'Tốt', 'Sẵn sàng', 'Mượn về', 'A2', 'K1', 'N2', NULL),
('BT033', 'DT007', 'Tốt', 'Sẵn sàng', 'Mượn về', 'A2', 'K2', 'N1', NULL),
('BT034', 'DT007', 'Tốt', 'Sẵn sàng', 'Mượn về', 'A2', 'K2', 'N1', NULL),
('BT035', 'DT007', 'Tốt', 'Sẵn sàng', 'Mượn về', 'A2', 'K2', 'N1', NULL),
('BT036', 'DT007', 'Tốt', 'Sẵn sàng', 'Mượn về', 'A2', 'K2', 'N1', NULL),
('BT037', 'DT008', 'Tốt', 'Sẵn sàng', 'Mượn về', 'A1', 'K2', 'N3', NULL),
('BT038', 'DT008', 'Tốt', 'Sẵn sàng', 'Mượn về', 'A1', 'K2', 'N3', NULL),
('BT039', 'DT008', 'Tốt', 'Sẵn sàng', 'Mượn về', 'A1', 'K2', 'N3', NULL),
('BT040', 'DT008', 'Tốt', 'Sẵn sàng', 'Mượn về', 'A1', 'K2', 'N3', NULL),
('DEMO-HOLD-BD001-01', 'DT001', 'Tốt', 'Đang mượn', 'Mượn về', 'A1', 'K2', 'N1', 'BD001'),
('DEMO-HOLD-BD004-01', 'DT001', 'Tốt', 'Đang mượn', 'Mượn về', 'A1', 'K2', 'N1', 'BD004'),
('DEMO-HOLD-BD004-02', 'DT001', 'Tốt', 'Đang mượn', 'Mượn về', 'A1', 'K2', 'N1', 'BD004'),
('DEMO-HOLD-BD004-03', 'DT001', 'Tốt', 'Đang mượn', 'Mượn về', 'A1', 'K2', 'N1', 'BD004'),
('DEMO-HOLD-BD004-04', 'DT001', 'Tốt', 'Đang mượn', 'Mượn về', 'A1', 'K2', 'N1', 'BD004'),
('DEMO-HOLD-BD004-05', 'DT001', 'Tốt', 'Đang mượn', 'Mượn về', 'A1', 'K2', 'N1', 'BD004');

-- All checks run before persistent DML. Names are NOT made globally unique.
INSERT INTO _libman_seed_guard
SELECT IF(COUNT(*) = 0, 1, 0) FROM _libman_demo_readers d
JOIN tblReader r ON r.readerCode = d.readerCode JOIN tblMember m ON m.id = r.memberId
WHERE BINARY m.fullName <> BINARY d.fullName;
INSERT INTO _libman_seed_guard
SELECT IF(COUNT(*) = 0, 1, 0) FROM _libman_demo_readers d
JOIN tblLibraryCard c ON c.cardNumber = d.cardNumber
JOIN tblCardApplication a ON a.id = c.cardApplicationId JOIN tblReader r ON r.memberId = a.readerId
WHERE r.readerCode <> d.readerCode;
INSERT INTO _libman_seed_guard
SELECT IF(COUNT(*) = 0, 1, 0) FROM _libman_demo_readers d
JOIN tblMember m ON m.username = CONCAT('demo.reader.', d.readerCode)
LEFT JOIN tblReader r ON r.memberId = m.id
WHERE r.readerCode IS NULL OR r.readerCode <> d.readerCode;
INSERT INTO _libman_seed_guard
SELECT IF(COUNT(*) = 0, 1, 0) FROM tblMember
WHERE username = 'NV001' AND (BINARY fullName <> BINARY 'Trần Thị Lan' OR role <> 'Librarian');
INSERT INTO _libman_seed_guard
SELECT IF(COUNT(*) = 0, 1, 0) FROM _libman_demo_readers d
JOIN tblLoanSlip l ON l.slipNumber = CONCAT('DEMO-PM-', d.readerCode)
JOIN tblLibraryCard c ON c.id = l.libraryCardId
WHERE c.cardNumber <> d.cardNumber;
INSERT INTO _libman_seed_guard
SELECT IF(COUNT(*) = 0, 1, 0) FROM tblBorrowingPolicy
WHERE dueDateRule = 'LibMan demo: 14 ngày kể từ ngày mượn'
 AND (maximumCopies <> 5 OR loanPeriodDays <> 14 OR readerGroup <> 'Bạn đọc');
-- Avoid choosing an arbitrary ID if an existing name/edition lookup is ambiguous.
INSERT INTO _libman_seed_guard
SELECT IF(COUNT(*) = 0, 1, 0) FROM (
 SELECT d.code FROM _libman_demo_titles d JOIN tblDocumentTitle t
 ON t.titleName = d.titleName AND t.publicationYear = d.publicationYear AND t.edition = d.edition
 JOIN tblPublisher p ON p.id = t.publisherId AND p.publisherName = d.publisherName
 JOIN tblDocumentType ty ON ty.id = t.documentTypeId AND ty.typeName = d.typeName
 GROUP BY d.code HAVING COUNT(*) > 1
) ambiguous;
INSERT INTO _libman_seed_guard
SELECT IF(COUNT(*) = 0, 1, 0) FROM _libman_demo_copies d
JOIN _libman_demo_titles b ON b.code = d.titleCode
JOIN tblDocumentCopy c ON c.copyCode = d.copyCode
JOIN tblDocumentTitle t ON t.id = c.documentTitleId
LEFT JOIN tblPublisher p ON p.id = t.publisherId LEFT JOIN tblDocumentType ty ON ty.id = t.documentTypeId
WHERE BINARY t.titleName <> BINARY b.titleName OR NOT (t.publicationYear <=> b.publicationYear)
 OR NOT (t.edition <=> b.edition) OR NOT (p.publisherName <=> b.publisherName)
 OR NOT (ty.typeName <=> b.typeName);

START TRANSACTION;
INSERT INTO tblMember (fullName, username, authenticationInfo, accountStatus, role, note)
SELECT 'Trần Thị Lan', 'NV001', 'DEMO-NO-LOGIN', 'Disabled', 'Librarian', 'LibMan demo staff NV001'
WHERE NOT EXISTS (SELECT 1 FROM tblMember WHERE username = 'NV001');
SET @demoStaff = (SELECT id FROM tblMember WHERE username = 'NV001');
INSERT INTO tblStaff (memberId, position, employmentStatus)
SELECT @demoStaff, 'Nhân viên thư viện', 'Đang làm việc'
WHERE NOT EXISTS (SELECT 1 FROM tblStaff WHERE memberId = @demoStaff);

INSERT INTO tblMember (fullName, username, authenticationInfo, accountStatus, role, note)
SELECT d.fullName, CONCAT('demo.reader.', d.readerCode), 'DEMO-NO-LOGIN', 'Disabled', 'Reader', 'LibMan demo reader'
FROM _libman_demo_readers d
WHERE NOT EXISTS (SELECT 1 FROM tblReader r WHERE r.readerCode = d.readerCode);
INSERT INTO tblReader (memberId, readerCode, readerStatus, readerGroup, registeredAt)
SELECT m.id, d.readerCode, 'Hoạt động', 'Bạn đọc', '2019-01-01'
FROM _libman_demo_readers d JOIN tblMember m ON m.username = CONCAT('demo.reader.', d.readerCode)
WHERE NOT EXISTS (SELECT 1 FROM tblReader r WHERE r.readerCode = d.readerCode);

INSERT INTO tblCardApplication (applicationType, submittedAt, status, processedAt, requestReason, outcome, librarianId, readerId)
SELECT 'Cấp mới', '2019-01-01 08:00:00', 'Đã duyệt', '2019-01-01 08:00:00',
 CONCAT('LibMan demo card ', d.cardNumber), 'Đã cấp thẻ', @demoStaff, r.memberId
FROM _libman_demo_readers d JOIN tblReader r ON r.readerCode = d.readerCode
WHERE NOT EXISTS (SELECT 1 FROM tblLibraryCard c WHERE c.cardNumber = d.cardNumber)
 AND NOT EXISTS (SELECT 1 FROM tblCardApplication a WHERE a.readerId = r.memberId
   AND a.requestReason = CONCAT('LibMan demo card ', d.cardNumber));
INSERT INTO tblLibraryCard (issuedAt, cardNumber, expiresAt, status, cardApplicationId)
SELECT '2019-01-01', d.cardNumber, d.expiresAt,
 IF(d.expiresAt < CURDATE(), 'Hết hạn', 'Hoạt động'),
 (SELECT MIN(a.id) FROM tblCardApplication a WHERE a.readerId = r.memberId
   AND a.requestReason = CONCAT('LibMan demo card ', d.cardNumber))
FROM _libman_demo_readers d JOIN tblReader r ON r.readerCode = d.readerCode
WHERE NOT EXISTS (SELECT 1 FROM tblLibraryCard c WHERE c.cardNumber = d.cardNumber);

INSERT INTO tblBorrowingPolicy (maximumCopies, loanPeriodDays, dueDateRule, effectiveFrom, readerGroup)
SELECT 5, 14, 'LibMan demo: 14 ngày kể từ ngày mượn', '2019-01-01', 'Bạn đọc'
WHERE NOT EXISTS (SELECT 1 FROM tblBorrowingPolicy WHERE dueDateRule = 'LibMan demo: 14 ngày kể từ ngày mượn');
SET @demoPolicy = (SELECT MIN(id) FROM tblBorrowingPolicy
 WHERE dueDateRule = 'LibMan demo: 14 ngày kể từ ngày mượn');

INSERT INTO tblStorageLocation (area, shelf, compartment)
SELECT DISTINCT d.area, d.shelf, d.compartment FROM _libman_demo_copies d
WHERE NOT EXISTS (SELECT 1 FROM tblStorageLocation s WHERE s.area = d.area AND s.shelf = d.shelf AND s.compartment = d.compartment);
INSERT INTO tblDocumentType (typeName, description)
SELECT DISTINCT d.typeName, 'Dữ liệu mẫu từ demo-data.js' FROM _libman_demo_titles d
WHERE NOT EXISTS (SELECT 1 FROM tblDocumentType t WHERE t.typeName = d.typeName);
INSERT INTO tblPublisher (publisherName, address, contactInformation)
SELECT DISTINCT d.publisherName, 'Chưa có thông tin', 'Chưa có thông tin' FROM _libman_demo_titles d
WHERE NOT EXISTS (SELECT 1 FROM tblPublisher p WHERE p.publisherName = d.publisherName);
INSERT INTO tblAuthor (authorName, description)
SELECT DISTINCT d.authorName, 'Dữ liệu mẫu từ demo-data.js' FROM _libman_demo_titles d
WHERE NOT EXISTS (SELECT 1 FROM tblAuthor a WHERE a.authorName = d.authorName);
INSERT INTO tblDocumentTitle (titleName, publicationYear, edition, language, pageCount, isbn, description, catalogStatus, publisherId, documentTypeId)
SELECT d.titleName, d.publicationYear, d.edition, d.language, d.pageCount, d.isbn, d.description, 'Đang lưu hành',
 (SELECT MIN(id) FROM tblPublisher WHERE publisherName = d.publisherName),
 (SELECT MIN(id) FROM tblDocumentType WHERE typeName = d.typeName)
FROM _libman_demo_titles d WHERE NOT EXISTS (
 SELECT 1 FROM tblDocumentTitle t JOIN tblPublisher p ON p.id = t.publisherId
 JOIN tblDocumentType ty ON ty.id = t.documentTypeId
 WHERE t.titleName = d.titleName AND t.publicationYear = d.publicationYear AND t.edition = d.edition
 AND p.publisherName = d.publisherName AND ty.typeName = d.typeName);
CREATE TEMPORARY TABLE _libman_title_ids (code VARCHAR(50) PRIMARY KEY, id INT NOT NULL)
 CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
INSERT INTO _libman_title_ids
SELECT d.code, t.id FROM _libman_demo_titles d JOIN tblDocumentTitle t
 ON t.titleName = d.titleName AND t.publicationYear = d.publicationYear AND t.edition = d.edition
JOIN tblPublisher p ON p.id = t.publisherId AND p.publisherName = d.publisherName
JOIN tblDocumentType ty ON ty.id = t.documentTypeId AND ty.typeName = d.typeName;
INSERT INTO tblAuthorship (contributionRole, authorOrder, documentTitleId, authorId)
SELECT 'Tác giả', 1, m.id, (SELECT MIN(id) FROM tblAuthor WHERE authorName = d.authorName)
FROM _libman_demo_titles d JOIN _libman_title_ids m ON m.code = d.code
WHERE NOT EXISTS (SELECT 1 FROM tblAuthorship a JOIN tblAuthor au ON au.id = a.authorId
 WHERE a.documentTitleId = m.id AND au.authorName = d.authorName);

INSERT INTO tblSupplier (supplierName, cooperationStatus)
SELECT 'LIBMAN-DEMO-SUPPLIER', 'Đang hợp tác'
WHERE NOT EXISTS (SELECT 1 FROM tblSupplier WHERE supplierName = 'LIBMAN-DEMO-SUPPLIER');
SET @demoSupplier = (SELECT MIN(id) FROM tblSupplier WHERE supplierName = 'LIBMAN-DEMO-SUPPLIER');
INSERT INTO tblGoodsReceipt (createdAt, confirmedAt, status, note, supplierId, librarianId)
SELECT CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Đã xác nhận', 'LIBMAN-DEMO-RECEIPT', @demoSupplier, @demoStaff
WHERE NOT EXISTS (SELECT 1 FROM tblGoodsReceipt WHERE note = 'LIBMAN-DEMO-RECEIPT')
 AND EXISTS (SELECT 1 FROM _libman_demo_copies d
   WHERE NOT EXISTS (SELECT 1 FROM tblDocumentCopy c WHERE c.copyCode = d.copyCode));
SET @demoReceipt = (SELECT MIN(id) FROM tblGoodsReceipt WHERE note = 'LIBMAN-DEMO-RECEIPT');
INSERT INTO tblGoodsReceiptDetail (unitPrice, conditionAtReceipt, note, quantity, goodsReceiptId, documentTitleId)
SELECT 0, d.physicalCondition, 'LibMan demo; đơn giá chưa được cung cấp', COUNT(*), @demoReceipt, m.id
FROM _libman_demo_copies d JOIN _libman_title_ids m ON m.code = d.titleCode
WHERE NOT EXISTS (SELECT 1 FROM tblDocumentCopy c WHERE c.copyCode = d.copyCode)
 AND NOT EXISTS (SELECT 1 FROM tblGoodsReceiptDetail g WHERE g.goodsReceiptId = @demoReceipt
 AND g.documentTitleId = m.id AND g.conditionAtReceipt = d.physicalCondition)
GROUP BY m.id, d.physicalCondition;
INSERT INTO tblDocumentCopy (copyCode, physicalCondition, copyStatus, usageType, acquiredAt, goodsReceiptDetailId, storageLocationId, documentTitleId, note)
SELECT d.copyCode, d.physicalCondition, d.copyStatus, d.usageType, CURRENT_DATE,
 (SELECT MIN(g.id) FROM tblGoodsReceiptDetail g WHERE g.goodsReceiptId = @demoReceipt
  AND g.documentTitleId = m.id AND g.conditionAtReceipt = d.physicalCondition),
 s.id, m.id, IF(d.holderCode IS NULL, 'Dữ liệu mẫu từ demo-data.js', 'Bản bổ sung để thể hiện số đang mượn trong demo')
FROM _libman_demo_copies d JOIN _libman_title_ids m ON m.code = d.titleCode
JOIN tblStorageLocation s ON s.area = d.area AND s.shelf = d.shelf AND s.compartment = d.compartment
WHERE NOT EXISTS (SELECT 1 FROM tblDocumentCopy c WHERE c.copyCode = d.copyCode);

-- Demo current loans: 1 for BD001, 5 for BD004; BD0017 remains free to borrow BT001/BT002.
INSERT INTO tblLoanSlip (slipNumber, borrowedAt, status, libraryCardId, borrowingPolicyId, librarianId)
SELECT CONCAT('DEMO-PM-', d.readerCode), CURRENT_DATE, 'Đang mượn', c.id, @demoPolicy, @demoStaff
FROM _libman_demo_readers d JOIN tblLibraryCard c ON c.cardNumber = d.cardNumber
WHERE d.activeCount > 0 AND NOT EXISTS (SELECT 1 FROM tblLoanSlip l WHERE l.slipNumber = CONCAT('DEMO-PM-', d.readerCode));
INSERT INTO tblLoanDetail (dueDate, conditionAtLoan, loanStatus, note, documentCopyId, loanSlipId)
SELECT DATE_ADD(DATE(l.borrowedAt), INTERVAL 14 DAY), d.physicalCondition, 'Đang mượn', 'LibMan demo active count', c.id, l.id
FROM _libman_demo_copies d JOIN tblDocumentCopy c ON c.copyCode = d.copyCode
JOIN tblLoanSlip l ON l.slipNumber = CONCAT('DEMO-PM-', d.holderCode)
WHERE d.holderCode IS NOT NULL
 AND NOT EXISTS (SELECT 1 FROM tblLoanDetail ld WHERE ld.loanSlipId = l.id AND ld.documentCopyId = c.id);
-- Initial demo has no unpaid fines; no fine/payment rows are inserted.
COMMIT;
