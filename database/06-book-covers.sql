-- Chỉ cập nhật ảnh bìa của 3 đầu tài liệu demo, không xóa hay nạp lại dữ liệu.
-- Chạy sau 02-demo-data.sql trên CSDL libman hiện có.
-- Nguồn và thông tin ấn bản ảnh: src/main/webapp/assets/images/books/sources.txt
USE libman;
SET NAMES utf8mb4;
START TRANSACTION;
UPDATE tblDocumentTitle
SET coverImage = '/assets/images/books/co-so-du-lieu.webp'
WHERE id = 1 AND titleName = 'Cơ sở dữ liệu';
UPDATE tblDocumentTitle
SET coverImage = '/assets/images/books/lap-trinh-huong-doi-tuong.png'
WHERE id = 2 AND titleName = 'Lập trình hướng đối tượng';
UPDATE tblDocumentTitle
SET coverImage = '/assets/images/books/mang-may-tinh.jpg'
WHERE id = 3 AND titleName = 'Mạng máy tính';
COMMIT;
SELECT id, titleName, coverImage FROM tblDocumentTitle WHERE id IN (1, 2, 3);
