-- CineMan7
DROP DATABASE IF EXISTS cineman7;
CREATE DATABASE cineman7 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE cineman7;

CREATE TABLE tblUser7 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,           
    fullName VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(255) UNIQUE,           
    dob DATE NOT NULL
);

CREATE TABLE tblCustomer7 (
    customerCode VARCHAR(20) NOT NULL UNIQUE,
    tblUser7id INT PRIMARY KEY,
    FOREIGN KEY (tblUser7id) REFERENCES tblUser7(id)
);

CREATE TABLE tblStaff7 (
    staffCode VARCHAR(20) NOT NULL UNIQUE,
    `position` VARCHAR(50) NOT NULL,
    tblUser7id INT PRIMARY KEY,
    FOREIGN KEY (tblUser7id) REFERENCES tblUser7(id)
);

CREATE TABLE tblManager7 (
    tblUser7id INT PRIMARY KEY,
    FOREIGN KEY (tblUser7id) REFERENCES tblStaff7(tblUser7id)
);

CREATE TABLE tblSalesStaff7 (
    tblUser7id INT PRIMARY KEY,
    FOREIGN KEY (tblUser7id) REFERENCES tblStaff7(tblUser7id)
);

CREATE TABLE tblMembershipTier7 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tierName VARCHAR(50) NOT NULL UNIQUE,
    minPoint INT NOT NULL,
    maxPoint INT NULL,                        
    discountPercent DECIMAL(5,2) NOT NULL,   
    CONSTRAINT chk_tier_point CHECK (minPoint >= 0 AND (maxPoint IS NULL OR minPoint <= maxPoint)),
    CONSTRAINT chk_tier_discount CHECK (discountPercent BETWEEN 0 AND 100)
);

CREATE TABLE tblMemberCard7 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cardCode VARCHAR(20) NOT NULL UNIQUE,
    issueDate DATE NOT NULL DEFAULT (CURRENT_DATE),
    loyaltyPoints INT NOT NULL DEFAULT 0,
    tblCustomer7id INT NOT NULL UNIQUE,       
    tblMembershipTier7id INT NOT NULL,
    FOREIGN KEY (tblCustomer7id) REFERENCES tblCustomer7(tblUser7id),
    FOREIGN KEY (tblMembershipTier7id) REFERENCES tblMembershipTier7(id),
    CONSTRAINT chk_card_points CHECK (loyaltyPoints >= 0)
);

CREATE TABLE tblMovie7 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    movieName VARCHAR(200) NOT NULL,
    duration INT NOT NULL,       -- don vi: phut
    director VARCHAR(100),
    actors TEXT,
    description TEXT,
    poster VARCHAR(500),
    trailer VARCHAR(500),
    releaseDate DATE NOT NULL,
    language VARCHAR(30) NOT NULL,
    ageRating ENUM('P','K','T13','T16','T18') NOT NULL,  
    CONSTRAINT chk_movie_duration CHECK (duration > 0)
);

CREATE TABLE tblGenre7 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    genreName VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255)
);

CREATE TABLE tblMovieGenre7 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tblMovie7id INT NOT NULL,
    tblGenre7id INT NOT NULL,
    FOREIGN KEY (tblMovie7id) REFERENCES tblMovie7(id),
    FOREIGN KEY (tblGenre7id) REFERENCES tblGenre7(id),
    UNIQUE (tblMovie7id, tblGenre7id)         
);

CREATE TABLE tblRoom7 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    roomName VARCHAR(50) NOT NULL UNIQUE,
    capacity INT NOT NULL,
    description VARCHAR(255),
    bufferMinutes INT NOT NULL DEFAULT 15,    
    CONSTRAINT chk_room_capacity CHECK (capacity > 0),
    CONSTRAINT chk_room_buffer CHECK (bufferMinutes >= 0)
);

CREATE TABLE tblSeatType7 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    typeName VARCHAR(20) NOT NULL UNIQUE,     
    extraFee DECIMAL(12,0) NOT NULL DEFAULT 0, 
    CONSTRAINT chk_seattype_fee CHECK (extraFee >= 0)
);

CREATE TABLE tblSeat7 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    seatCode VARCHAR(10) NOT NULL,
    tblRoom7id INT NOT NULL,
    tblSeatType7id INT NOT NULL,
    FOREIGN KEY (tblRoom7id) REFERENCES tblRoom7(id),
    FOREIGN KEY (tblSeatType7id) REFERENCES tblSeatType7(id),
    UNIQUE (tblRoom7id, seatCode)             -- trong 1 phong khong co 2 ghe cung ma
);

CREATE TABLE tblPromotion7 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    programName VARCHAR(100) NOT NULL UNIQUE,
    `condition` VARCHAR(255) NOT NULL,        -- khung gio / ngay ap dung (dang van ban)
    discountValue DECIMAL(5,2) NOT NULL,      -- phan tram giam gia
    CONSTRAINT chk_promo_discount CHECK (discountValue BETWEEN 0 AND 100)
);

CREATE TABLE tblShowtime7 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    startTime DATETIME NOT NULL,
    endTimeExpected DATETIME NOT NULL,
    ticketPrice DECIMAL(12,0) NOT NULL,
    format ENUM('2D','3D','4DX','IMAX') NOT NULL,  
    tblRoom7id INT NOT NULL,
    tblMovie7id INT NOT NULL,
    tblPromotion7id INT NULL,
    FOREIGN KEY (tblRoom7id) REFERENCES tblRoom7(id),
    FOREIGN KEY (tblMovie7id) REFERENCES tblMovie7(id),
    FOREIGN KEY (tblPromotion7id) REFERENCES tblPromotion7(id),
    UNIQUE (tblRoom7id, startTime),           
    CONSTRAINT chk_showtime_time CHECK (endTimeExpected > startTime),
    CONSTRAINT chk_showtime_price CHECK (ticketPrice >= 0)
);

CREATE TABLE tblInvoice7 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    invoiceCode VARCHAR(20) NOT NULL DEFAULT '' UNIQUE,  -- tu sinh boi trigger: HD + yyMMdd + 4 so
    transactionTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    paymentMethod ENUM('Tiền mặt','Thẻ ngân hàng','Ví điện tử','Chuyển khoản') NOT NULL,  
    totalAmount DECIMAL(12,0) NOT NULL,
    discountApplied DECIMAL(5,2) NOT NULL DEFAULT 0,  
    guestName VARCHAR(100),
    guestPhone VARCHAR(15),
    tblCustomer7id INT NULL,                  -- NULL = khach vang lai
    tblSalesStaff7id INT NULL,                -- NULL = khach tu mua truc tuyen
    FOREIGN KEY (tblCustomer7id) REFERENCES tblCustomer7(tblUser7id),
    FOREIGN KEY (tblSalesStaff7id) REFERENCES tblSalesStaff7(tblUser7id),
    CONSTRAINT chk_invoice_amount CHECK (totalAmount >= 0),
    CONSTRAINT chk_invoice_discount CHECK (discountApplied BETWEEN 0 AND 100)
);

CREATE TABLE tblTicket7 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    actualPrice DECIMAL(12,0) NOT NULL,       -- gia chot tai thoi diem ban
    tblInvoice7id INT NOT NULL,
    tblSeat7id INT NOT NULL,
    tblShowtime7id INT NOT NULL,
    FOREIGN KEY (tblInvoice7id) REFERENCES tblInvoice7(id),
    FOREIGN KEY (tblSeat7id) REFERENCES tblSeat7(id),
    FOREIGN KEY (tblShowtime7id) REFERENCES tblShowtime7(id),
    UNIQUE (tblSeat7id, tblShowtime7id),      -- 1 ghe o 1 suat chieu chi ban toi da 1 ve
    CONSTRAINT chk_ticket_price CHECK (actualPrice >= 0)
);


CREATE TABLE tblInvoiceCounter7 (
    counterDate DATE PRIMARY KEY,
    lastNumber INT NOT NULL
);

DELIMITER //
CREATE TRIGGER trgInvoice7BeforeInsert BEFORE INSERT ON tblInvoice7
FOR EACH ROW
BEGIN
    DECLARE n INT;
    IF NEW.invoiceCode = '' THEN
        INSERT INTO tblInvoiceCounter7 (counterDate, lastNumber)
            VALUES (DATE(NEW.transactionTime), 1)
            ON DUPLICATE KEY UPDATE lastNumber = lastNumber + 1;
        SELECT lastNumber INTO n FROM tblInvoiceCounter7 WHERE counterDate = DATE(NEW.transactionTime);
        SET NEW.invoiceCode = CONCAT('HD', DATE_FORMAT(NEW.transactionTime, '%y%m%d'), LPAD(n, 4, '0'));
    END IF;
END//
DELIMITER ;




-- =============================================
--  CineMan7 – DỮ LIỆU MẪU ĐẦY ĐỦ
--  Bao quát: Tìm kiếm phim + Thống kê KH doanh thu
--  Mật khẩu tất cả user: Test@123
-- =============================================
USE cineman7;

SET @pw = '$2a$10$BNIuobzc7RrlnJeQKPEp7.pjkbfskOxbcODj0HP.QioX7qvM12Qdy';

-- ══════════════════════════════════════════════
-- 1. USER  (4 customer + 1 sales staff + 1 manager)
-- ══════════════════════════════════════════════
INSERT INTO tblUser7 (username, password, fullName, phone, email, dob) VALUES
('chien',     @pw, 'Lê Văn Chiến',    '0900000001', 'chien@test.vn',    '1995-03-10'),
('bich',      @pw, 'Trần Thị Bích',   '0900000002', 'bich@test.vn',     '1998-07-21'),
('an',        @pw, 'Nguyễn Văn An',   '0900000003', 'an@test.vn',       '2000-01-05'),
('linh',      @pw, 'Phạm Thị Linh',   '0900000004', 'linh@test.vn',     '2001-09-14'),
('nv_sales1', @pw, 'Trần Quốc Bảo',   '0900000010', 'bao@cinema.vn',    '1993-04-22'),
('quanly',    @pw, 'Quản Lý Test',    '0900000009', 'quanly@cinema.vn', '1990-05-15');

-- ══════════════════════════════════════════════
-- 2. CUSTOMER
-- ══════════════════════════════════════════════
INSERT INTO tblCustomer7 (customerCode, tblUser7id)
SELECT 'KH0012', id FROM tblUser7 WHERE username = 'chien'
UNION ALL SELECT 'KH0045', id FROM tblUser7 WHERE username = 'bich'
UNION ALL SELECT 'KH0078', id FROM tblUser7 WHERE username = 'an'
UNION ALL SELECT 'KH0099', id FROM tblUser7 WHERE username = 'linh';

-- ══════════════════════════════════════════════
-- 3. STAFF  (Sales + Manager)
-- ══════════════════════════════════════════════
INSERT INTO tblStaff7 (staffCode, `position`, tblUser7id)
SELECT 'NV001', 'Nhân viên bán vé', id FROM tblUser7 WHERE username = 'nv_sales1'
UNION ALL SELECT 'QL001', 'Quản lý', id FROM tblUser7 WHERE username = 'quanly';

INSERT INTO tblSalesStaff7 (tblUser7id)
SELECT id FROM tblUser7 WHERE username = 'nv_sales1';

INSERT INTO tblManager7 (tblUser7id)
SELECT id FROM tblUser7 WHERE username = 'quanly';

-- ══════════════════════════════════════════════
-- 4. MEMBERSHIP TIER
-- ══════════════════════════════════════════════
INSERT INTO tblMembershipTier7 (tierName, minPoint, maxPoint, discountPercent) VALUES
('Đồng',      0,    499,  0.00),
('Bạc',       500,  1499, 5.00),
('Vàng',      1500, 2999, 10.00),
('Kim cương', 3000, NULL, 15.00);

-- ══════════════════════════════════════════════
-- 5. MEMBER CARD  (mỗi customer 1 thẻ, điểm khác nhau để cover đủ 4 hạng)
-- ══════════════════════════════════════════════
INSERT INTO tblMemberCard7 (cardCode, issueDate, loyaltyPoints, tblCustomer7id, tblMembershipTier7id)
SELECT 'MC2024001', '2024-01-10', 3200,
       (SELECT tblUser7id FROM tblCustomer7 WHERE customerCode='KH0012'),
       (SELECT id FROM tblMembershipTier7 WHERE tierName='Kim cương')
UNION ALL
SELECT 'MC2024002', '2024-03-05', 1600,
       (SELECT tblUser7id FROM tblCustomer7 WHERE customerCode='KH0045'),
       (SELECT id FROM tblMembershipTier7 WHERE tierName='Vàng')
UNION ALL
SELECT 'MC2024003', '2024-06-20', 520,
       (SELECT tblUser7id FROM tblCustomer7 WHERE customerCode='KH0078'),
       (SELECT id FROM tblMembershipTier7 WHERE tierName='Bạc')
UNION ALL
SELECT 'MC2024004', '2025-01-01', 0,
       (SELECT tblUser7id FROM tblCustomer7 WHERE customerCode='KH0099'),
       (SELECT id FROM tblMembershipTier7 WHERE tierName='Đồng');

-- ══════════════════════════════════════════════
-- 6. GENRE
-- ══════════════════════════════════════════════
INSERT INTO tblGenre7 (genreName, description) VALUES
('Hành động',            'Phim nhiều cảnh chiến đấu, rượt đuổi'),
('Hài hước',             'Phim mang lại tiếng cười'),
('Kinh dị',              'Phim gây sợ hãi, ám ảnh'),
('Tình cảm',             'Phim lãng mạn, tình yêu'),
('Hoạt hình',            'Phim dành cho mọi lứa tuổi'),
('Khoa học viễn tưởng',  'Phim sci-fi, tương lai'),
('Tâm lý',               'Phim khai thác nội tâm nhân vật');

-- ══════════════════════════════════════════════
-- 7. MOVIE  (6 phim – đủ ageRating, ngôn ngữ, thể loại)
-- ══════════════════════════════════════════════
INSERT INTO tblMovie7 (movieName, duration, director, actors, description, poster, trailer, releaseDate, language, ageRating) VALUES
('Avengers: Doomsday',      155, 'Russo Brothers',
 'Robert Downey Jr., Chris Evans, Scarlett Johansson',
 'Các siêu anh hùng hợp sức đối đầu kẻ thù mạnh nhất vũ trụ.',
 'avengers_doomsday.jpg', 'https://youtube.com/watch?v=avengers',
 '2025-05-01', 'Lồng tiếng', 'T13'),

('Lật Mặt 8',               120, 'Lý Hải',
 'Lý Hải, Minh Hà, Quang Tèo',
 'Bom tấn hài – hành động Việt Nam phần tiếp theo.',
 'lat_mat_8.jpg', 'https://youtube.com/watch?v=latmat8',
 '2025-04-30', 'Tiếng Việt', 'T16'),

('Inside Out 3',             105, 'Pete Docter',
 'Amy Poehler, Mindy Kaling',
 'Hành trình cảm xúc của Riley bước vào tuổi trưởng thành.',
 'inside_out_3.jpg', 'https://youtube.com/watch?v=insideout3',
 '2025-06-15', 'Lồng tiếng', 'P'),

('Joker: Folie à Deux',     138, 'Todd Phillips',
 'Joaquin Phoenix, Lady Gaga',
 'Arthur Fleck đối mặt với phiên toà và tình yêu điên loạn.',
 'joker2.jpg', 'https://youtube.com/watch?v=joker2',
 '2024-10-04', 'Phụ đề', 'T18'),

('Dune: Part Three',         160, 'Denis Villeneuve',
 'Timothée Chalamet, Zendaya',
 'Paul Atreides dẫn dắt cuộc chiến cuối cùng trên hành tinh Arrakis.',
 'dune3.jpg', 'https://youtube.com/watch?v=dune3',
 '2026-03-20', 'Phụ đề', 'T13'),

('Ma Da',                     95, 'Nguyễn Hữu Hoàng',
 'Ninh Dương Lan Ngọc, Will',
 'Bí ẩn kinh hoàng xuất hiện tại một ngôi làng ven sông.',
 'ma_da.jpg', 'https://youtube.com/watch?v=mada',
 '2024-07-19', 'Tiếng Việt', 'T16');

-- ══════════════════════════════════════════════
-- 8. MOVIE – GENRE  (nhiều-nhiều, test tìm kiếm theo thể loại)
-- ══════════════════════════════════════════════
INSERT INTO tblMovieGenre7 (tblMovie7id, tblGenre7id)
SELECT m.id, g.id FROM tblMovie7 m JOIN tblGenre7 g
  ON (m.movieName='Avengers: Doomsday'  AND g.genreName IN ('Hành động','Khoa học viễn tưởng'))
  OR (m.movieName='Lật Mặt 8'           AND g.genreName IN ('Hành động','Hài hước'))
  OR (m.movieName='Inside Out 3'        AND g.genreName IN ('Hoạt hình','Tâm lý'))
  OR (m.movieName='Joker: Folie à Deux' AND g.genreName IN ('Tâm lý','Tình cảm'))
  OR (m.movieName='Dune: Part Three'    AND g.genreName IN ('Khoa học viễn tưởng','Hành động'))
  OR (m.movieName='Ma Da'               AND g.genreName IN ('Kinh dị'));

-- ══════════════════════════════════════════════
-- 9. ROOM
-- ══════════════════════════════════════════════
INSERT INTO tblRoom7 (roomName, capacity, description, bufferMinutes) VALUES
('Phòng 1',  120, 'Phòng tiêu chuẩn 2D',           15),
('Phòng 2',  100, 'Phòng 3D cao cấp',               20),
('Phòng 3',   80, 'Phòng IMAX',                     25),
('Phòng 4',   60, 'Phòng 4DX trải nghiệm đặc biệt', 30);

-- ══════════════════════════════════════════════
-- 10. SEAT TYPE
-- ══════════════════════════════════════════════
INSERT INTO tblSeatType7 (typeName, extraFee) VALUES
('Thường',    0),
('VIP',       50000),
('Sweetbox',  100000);

-- ══════════════════════════════════════════════
-- 11. SEAT  (A1-A5 Thường / B1-B3 VIP / C1-C2 Sweetbox cho cả 4 phòng)
-- ══════════════════════════════════════════════
INSERT INTO tblSeat7 (seatCode, tblRoom7id, tblSeatType7id)
SELECT s.code,
       r.id,
       (SELECT id FROM tblSeatType7 WHERE typeName = s.stype)
FROM tblRoom7 r
JOIN (
    SELECT 'A1' code,'Thường'   stype UNION ALL SELECT 'A2','Thường' UNION ALL
    SELECT 'A3','Thường'              UNION ALL SELECT 'A4','Thường' UNION ALL
    SELECT 'A5','Thường'              UNION ALL SELECT 'B1','VIP'    UNION ALL
    SELECT 'B2','VIP'                 UNION ALL SELECT 'B3','VIP'    UNION ALL
    SELECT 'C1','Sweetbox'            UNION ALL SELECT 'C2','Sweetbox'
) s ON 1=1
WHERE r.roomName IN ('Phòng 1','Phòng 2','Phòng 3','Phòng 4');

-- ══════════════════════════════════════════════
-- 12. PROMOTION
-- ══════════════════════════════════════════════
INSERT INTO tblPromotion7 (programName, `condition`, discountValue) VALUES
('Happy Hour sáng',     'Suất chiếu 8:00–11:00 các ngày trong tuần', 20.00),
('Thứ 4 vui vẻ',        'Tất cả suất chiếu thứ 4 hàng tuần',         30.00),
('Cuối tuần đặc biệt',  'Thứ 7 & Chủ nhật, ghế VIP và Sweetbox',     10.00);

-- ══════════════════════════════════════════════
-- 13. SHOWTIME
-- ══════════════════════════════════════════════
SET @r1 = (SELECT id FROM tblRoom7 WHERE roomName='Phòng 1');
SET @r2 = (SELECT id FROM tblRoom7 WHERE roomName='Phòng 2');
SET @r3 = (SELECT id FROM tblRoom7 WHERE roomName='Phòng 3');
SET @r4 = (SELECT id FROM tblRoom7 WHERE roomName='Phòng 4');

SET @m1 = (SELECT id FROM tblMovie7 WHERE movieName='Avengers: Doomsday');
SET @m2 = (SELECT id FROM tblMovie7 WHERE movieName='Lật Mặt 8');
SET @m3 = (SELECT id FROM tblMovie7 WHERE movieName='Inside Out 3');
SET @m4 = (SELECT id FROM tblMovie7 WHERE movieName='Joker: Folie à Deux');
SET @m5 = (SELECT id FROM tblMovie7 WHERE movieName='Dune: Part Three');
SET @m6 = (SELECT id FROM tblMovie7 WHERE movieName='Ma Da');

SET @promo1 = (SELECT id FROM tblPromotion7 WHERE programName='Happy Hour sáng');
SET @promo2 = (SELECT id FROM tblPromotion7 WHERE programName='Thứ 4 vui vẻ');
SET @promo3 = (SELECT id FROM tblPromotion7 WHERE programName='Cuối tuần đặc biệt');

INSERT INTO tblShowtime7 (startTime, endTimeExpected, ticketPrice, format, tblRoom7id, tblMovie7id, tblPromotion7id) VALUES
-- Avengers – Phòng 1 – 2D (3 suất: sáng/trưa/tối)
('2025-06-01 09:00:00','2025-06-01 11:35:00',  90000,'2D',  @r1,@m1,@promo1),
('2025-06-01 13:00:00','2025-06-01 15:35:00',  90000,'2D',  @r1,@m1,NULL),
('2025-06-01 19:00:00','2025-06-01 21:35:00', 110000,'2D',  @r1,@m1,NULL),
-- Avengers – Phòng 2 – 3D
('2025-06-01 15:00:00','2025-06-01 17:35:00', 130000,'3D',  @r2,@m1,NULL),
('2025-06-07 14:00:00','2025-06-07 16:35:00', 130000,'3D',  @r2,@m1,@promo3),
-- Lật Mặt 8 – Phòng 1 – 2D
('2025-06-02 10:00:00','2025-06-02 12:00:00',  85000,'2D',  @r1,@m2,NULL),
('2025-06-02 15:30:00','2025-06-02 17:30:00',  85000,'2D',  @r1,@m2,NULL),
('2025-06-04 10:00:00','2025-06-04 12:00:00',  85000,'2D',  @r1,@m2,@promo2), -- Thứ 4
-- Inside Out 3 – Phòng 3 – IMAX
('2025-06-03 09:30:00','2025-06-03 11:15:00', 150000,'IMAX',@r3,@m3,@promo1),
('2025-06-03 14:00:00','2025-06-03 15:45:00', 150000,'IMAX',@r3,@m3,NULL),
-- Joker – Phòng 2 – 3D
('2025-06-05 20:00:00','2025-06-05 22:18:00', 120000,'3D',  @r2,@m4,NULL),
-- Dune – Phòng 3 – IMAX
('2025-06-06 18:00:00','2025-06-06 20:40:00', 160000,'IMAX',@r3,@m5,NULL),
-- Ma Da – Phòng 4 – 4DX
('2025-06-07 20:30:00','2025-06-07 22:05:00', 200000,'4DX', @r4,@m6,@promo3),
('2025-06-08 20:30:00','2025-06-08 22:05:00', 200000,'4DX', @r4,@m6,NULL),
-- Suất quá khứ tháng 5 (test thống kê theo khoảng ngày)
('2025-05-10 19:00:00','2025-05-10 21:35:00', 110000,'2D',  @r1,@m1,NULL),
('2025-05-15 15:00:00','2025-05-15 17:00:00',  85000,'2D',  @r1,@m2,NULL),
('2025-05-20 09:30:00','2025-05-20 11:15:00', 150000,'IMAX',@r3,@m3,@promo1);

-- ══════════════════════════════════════════════
-- 14. INVOICE + TICKET
--     Bao quát: member/vãng lai, tại quầy/trực tuyến,
--               nhiều PTTT, nhiều hạng thẻ, giao dịch tháng 5 & 6
-- ══════════════════════════════════════════════
SET @cust_chien = (SELECT tblUser7id FROM tblCustomer7 WHERE customerCode='KH0012');
SET @cust_bich  = (SELECT tblUser7id FROM tblCustomer7 WHERE customerCode='KH0045');
SET @cust_an    = (SELECT tblUser7id FROM tblCustomer7 WHERE customerCode='KH0078');
SET @cust_linh  = (SELECT tblUser7id FROM tblCustomer7 WHERE customerCode='KH0099');
SET @sales1     = (SELECT tblUser7id FROM tblSalesStaff7 LIMIT 1);

-- ── HĐ 1: Chiến (Kim cương -15%) – 2 vé Avengers 2D tối – tại quầy
SET @show1 = (SELECT id FROM tblShowtime7 WHERE startTime='2025-06-01 19:00:00' AND tblRoom7id=@r1);
INSERT INTO tblInvoice7 (transactionTime, paymentMethod, totalAmount, discountApplied, tblCustomer7id, tblSalesStaff7id)
VALUES ('2025-06-01 18:30:00','Thẻ ngân hàng', 187000, 15.00, @cust_chien, @sales1);
SET @inv1 = LAST_INSERT_ID();
INSERT INTO tblTicket7 (actualPrice, tblInvoice7id, tblSeat7id, tblShowtime7id)
SELECT 93500, @inv1, s.id, @show1 FROM tblSeat7 s JOIN tblRoom7 r ON s.tblRoom7id=r.id WHERE r.roomName='Phòng 1' AND s.seatCode='B1'
UNION ALL
SELECT 93500, @inv1, s.id, @show1 FROM tblSeat7 s JOIN tblRoom7 r ON s.tblRoom7id=r.id WHERE r.roomName='Phòng 1' AND s.seatCode='B2';

-- ── HĐ 2: Bích (Vàng -10%) – 1 vé Inside Out 3 IMAX – trực tuyến
SET @show2 = (SELECT id FROM tblShowtime7 WHERE startTime='2025-06-03 14:00:00');
INSERT INTO tblInvoice7 (transactionTime, paymentMethod, totalAmount, discountApplied, tblCustomer7id, tblSalesStaff7id)
VALUES ('2025-06-03 10:15:00','Ví điện tử', 135000, 10.00, @cust_bich, NULL);
SET @inv2 = LAST_INSERT_ID();
INSERT INTO tblTicket7 (actualPrice, tblInvoice7id, tblSeat7id, tblShowtime7id)
SELECT 135000, @inv2, s.id, @show2 FROM tblSeat7 s JOIN tblRoom7 r ON s.tblRoom7id=r.id WHERE r.roomName='Phòng 3' AND s.seatCode='A1';

-- ── HĐ 3: An (Bạc -5%) – 2 vé Lật Mặt 8 thứ 4 – tại quầy – tiền mặt
SET @show3 = (SELECT id FROM tblShowtime7 WHERE startTime='2025-06-04 10:00:00');
INSERT INTO tblInvoice7 (transactionTime, paymentMethod, totalAmount, discountApplied, tblCustomer7id, tblSalesStaff7id)
VALUES ('2025-06-04 09:45:00','Tiền mặt', 161500, 5.00, @cust_an, @sales1);
SET @inv3 = LAST_INSERT_ID();
INSERT INTO tblTicket7 (actualPrice, tblInvoice7id, tblSeat7id, tblShowtime7id)
SELECT 80750, @inv3, s.id, @show3 FROM tblSeat7 s JOIN tblRoom7 r ON s.tblRoom7id=r.id WHERE r.roomName='Phòng 1' AND s.seatCode='A1'
UNION ALL
SELECT 80750, @inv3, s.id, @show3 FROM tblSeat7 s JOIN tblRoom7 r ON s.tblRoom7id=r.id WHERE r.roomName='Phòng 1' AND s.seatCode='A2';

-- ── HĐ 4: Khách VÃNG LAI – 2 vé Avengers 3D cuối tuần – tại quầy
SET @show4 = (SELECT id FROM tblShowtime7 WHERE startTime='2025-06-07 14:00:00');
INSERT INTO tblInvoice7 (transactionTime, paymentMethod, totalAmount, discountApplied, guestName, guestPhone, tblCustomer7id, tblSalesStaff7id)
VALUES ('2025-06-07 13:30:00','Chuyển khoản', 234000, 10.00, 'Nguyễn Văn Khách','0912345678', NULL, @sales1);
SET @inv4 = LAST_INSERT_ID();
INSERT INTO tblTicket7 (actualPrice, tblInvoice7id, tblSeat7id, tblShowtime7id)
SELECT 117000, @inv4, s.id, @show4 FROM tblSeat7 s JOIN tblRoom7 r ON s.tblRoom7id=r.id WHERE r.roomName='Phòng 2' AND s.seatCode='A1'
UNION ALL
SELECT 117000, @inv4, s.id, @show4 FROM tblSeat7 s JOIN tblRoom7 r ON s.tblRoom7id=r.id WHERE r.roomName='Phòng 2' AND s.seatCode='A2';

-- ── HĐ 5: Linh (Đồng -0%) – 1 vé Sweetbox Ma Da 4DX – trực tuyến
SET @show5 = (SELECT id FROM tblShowtime7 WHERE startTime='2025-06-07 20:30:00');
INSERT INTO tblInvoice7 (transactionTime, paymentMethod, totalAmount, discountApplied, tblCustomer7id, tblSalesStaff7id)
VALUES ('2025-06-07 20:00:00','Ví điện tử', 300000, 0.00, @cust_linh, NULL);
SET @inv5 = LAST_INSERT_ID();
INSERT INTO tblTicket7 (actualPrice, tblInvoice7id, tblSeat7id, tblShowtime7id)
SELECT 300000, @inv5, s.id, @show5 FROM tblSeat7 s JOIN tblRoom7 r ON s.tblRoom7id=r.id WHERE r.roomName='Phòng 4' AND s.seatCode='C1';

-- ── HĐ 6: Chiến (Kim cương -15%) – 1 vé Joker 3D – trực tuyến
SET @show6 = (SELECT id FROM tblShowtime7 WHERE startTime='2025-06-05 20:00:00');
INSERT INTO tblInvoice7 (transactionTime, paymentMethod, totalAmount, discountApplied, tblCustomer7id, tblSalesStaff7id)
VALUES ('2025-06-05 15:00:00','Ví điện tử', 102000, 15.00, @cust_chien, NULL);
SET @inv6 = LAST_INSERT_ID();
INSERT INTO tblTicket7 (actualPrice, tblInvoice7id, tblSeat7id, tblShowtime7id)
SELECT 102000, @inv6, s.id, @show6 FROM tblSeat7 s JOIN tblRoom7 r ON s.tblRoom7id=r.id WHERE r.roomName='Phòng 2' AND s.seatCode='B1';

-- ── HĐ 7: Bích (Vàng -10%) – 2 vé Dune IMAX – tại quầy
SET @show7 = (SELECT id FROM tblShowtime7 WHERE startTime='2025-06-06 18:00:00');
INSERT INTO tblInvoice7 (transactionTime, paymentMethod, totalAmount, discountApplied, tblCustomer7id, tblSalesStaff7id)
VALUES ('2025-06-06 17:30:00','Thẻ ngân hàng', 288000, 10.00, @cust_bich, @sales1);
SET @inv7 = LAST_INSERT_ID();
INSERT INTO tblTicket7 (actualPrice, tblInvoice7id, tblSeat7id, tblShowtime7id)
SELECT 144000, @inv7, s.id, @show7 FROM tblSeat7 s JOIN tblRoom7 r ON s.tblRoom7id=r.id WHERE r.roomName='Phòng 3' AND s.seatCode='B1'
UNION ALL
SELECT 144000, @inv7, s.id, @show7 FROM tblSeat7 s JOIN tblRoom7 r ON s.tblRoom7id=r.id WHERE r.roomName='Phòng 3' AND s.seatCode='B2';

-- ── HĐ 8-10: Dữ liệu THÁNG 5 – test thống kê theo khoảng ngày
SET @past1 = (SELECT id FROM tblShowtime7 WHERE startTime='2025-05-10 19:00:00');
SET @past2 = (SELECT id FROM tblShowtime7 WHERE startTime='2025-05-15 15:00:00');
SET @past3 = (SELECT id FROM tblShowtime7 WHERE startTime='2025-05-20 09:30:00');

INSERT INTO tblInvoice7 (transactionTime, paymentMethod, totalAmount, discountApplied, tblCustomer7id, tblSalesStaff7id)
VALUES
('2025-05-10 18:30:00', 'Tiền mặt',      93500, 15.00, @cust_chien, @sales1),
('2025-05-15 14:45:00', 'Thẻ ngân hàng', 80750,  5.00, @cust_an,    @sales1),
('2025-05-20 09:00:00', 'Ví điện tử',   135000, 10.00, @cust_bich,  NULL);

SET @inv8  = (SELECT id FROM tblInvoice7 WHERE transactionTime='2025-05-10 18:30:00');
SET @inv9  = (SELECT id FROM tblInvoice7 WHERE transactionTime='2025-05-15 14:45:00');
SET @inv10 = (SELECT id FROM tblInvoice7 WHERE transactionTime='2025-05-20 09:00:00');

INSERT INTO tblTicket7 (actualPrice, tblInvoice7id, tblSeat7id, tblShowtime7id)
SELECT  93500, @inv8,  s.id, @past1 FROM tblSeat7 s JOIN tblRoom7 r ON s.tblRoom7id=r.id WHERE r.roomName='Phòng 1' AND s.seatCode='A3'
UNION ALL
SELECT  80750, @inv9,  s.id, @past2 FROM tblSeat7 s JOIN tblRoom7 r ON s.tblRoom7id=r.id WHERE r.roomName='Phòng 1' AND s.seatCode='A4'
UNION ALL
SELECT 135000, @inv10, s.id, @past3 FROM tblSeat7 s JOIN tblRoom7 r ON s.tblRoom7id=r.id WHERE r.roomName='Phòng 3' AND s.seatCode='A2';

-- ══════════════════════════════════════════════
-- QUERY TEST – Module 1: Tìm kiếm phim theo tên
-- ══════════════════════════════════════════════
-- Tìm theo từ khóa (VD: "ven")
SELECT m.id, m.movieName, m.duration, m.director, m.releaseDate, m.language, m.ageRating,
       GROUP_CONCAT(g.genreName ORDER BY g.genreName SEPARATOR ', ') AS genres
FROM tblMovie7 m
LEFT JOIN tblMovieGenre7 mg ON mg.tblMovie7id = m.id
LEFT JOIN tblGenre7      g  ON g.id = mg.tblGenre7id
WHERE m.movieName LIKE '%ven%'
GROUP BY m.id;

-- ══════════════════════════════════════════════
-- QUERY TEST – Module 2: Thống kê KH theo doanh thu (có khoảng ngày)
-- ══════════════════════════════════════════════
-- Bước 1: Danh sách khách hàng + tổng doanh thu
SELECT
    COALESCE(c.customerCode, 'Vãng lai')           AS maKH,
    COALESCE(u.fullName,     i.guestName)           AS hoTen,
    COALESCE(mt.tierName,    'Không có thẻ')        AS hangThe,
    COUNT(DISTINCT i.id)                            AS soHoaDon,
    SUM(i.totalAmount)                              AS tongDoanhThu
FROM tblInvoice7 i
LEFT JOIN tblCustomer7      c  ON i.tblCustomer7id      = c.tblUser7id
LEFT JOIN tblUser7          u  ON c.tblUser7id           = u.id
LEFT JOIN tblMemberCard7    mc ON mc.tblCustomer7id      = c.tblUser7id
LEFT JOIN tblMembershipTier7 mt ON mt.id                = mc.tblMembershipTier7id
WHERE i.transactionTime BETWEEN '2025-05-01 00:00:00' AND '2025-06-30 23:59:59'
GROUP BY i.tblCustomer7id, i.guestName, c.customerCode, u.fullName, mt.tierName
ORDER BY tongDoanhThu DESC;

-- Bước 2: Chi tiết giao dịch của 1 khách hàng (click vào xem)
SELECT
    i.invoiceCode       AS maHoaDon,
    i.transactionTime   AS thoiGian,
    i.paymentMethod     AS phuongThuc,
    i.discountApplied   AS giamGia,
    i.totalAmount       AS thanhTien,
    m.movieName         AS tenPhim,
    st.startTime        AS suatChieu,
    st.format           AS dinhDang,
    s.seatCode          AS maGhe,
    tp.typeName         AS loaiGhe,
    t.actualPrice       AS giaVe
FROM tblInvoice7    i
JOIN tblTicket7     t  ON t.tblInvoice7id  = i.id
JOIN tblSeat7       s  ON s.id             = t.tblSeat7id
JOIN tblSeatType7   tp ON tp.id            = s.tblSeatType7id
JOIN tblShowtime7   st ON st.id            = t.tblShowtime7id
JOIN tblMovie7      m  ON m.id             = st.tblMovie7id
WHERE i.tblCustomer7id = (SELECT tblUser7id FROM tblCustomer7 WHERE customerCode = 'KH0012')
ORDER BY i.transactionTime DESC;

-- ══════════════════════════════════════════════
-- KIỂM TRA SỐ LƯỢNG BẢN GHI
-- ══════════════════════════════════════════════
SELECT 'tblUser7'            tbl, COUNT(*) cnt FROM tblUser7            UNION ALL
SELECT 'tblCustomer7',            COUNT(*)     FROM tblCustomer7        UNION ALL
SELECT 'tblStaff7',               COUNT(*)     FROM tblStaff7           UNION ALL
SELECT 'tblMembershipTier7',      COUNT(*)     FROM tblMembershipTier7  UNION ALL
SELECT 'tblMemberCard7',          COUNT(*)     FROM tblMemberCard7      UNION ALL
SELECT 'tblMovie7',               COUNT(*)     FROM tblMovie7           UNION ALL
SELECT 'tblGenre7',               COUNT(*)     FROM tblGenre7           UNION ALL
SELECT 'tblMovieGenre7',          COUNT(*)     FROM tblMovieGenre7      UNION ALL
SELECT 'tblRoom7',                COUNT(*)     FROM tblRoom7            UNION ALL
SELECT 'tblSeat7',                COUNT(*)     FROM tblSeat7            UNION ALL
SELECT 'tblPromotion7',           COUNT(*)     FROM tblPromotion7       UNION ALL
SELECT 'tblShowtime7',            COUNT(*)     FROM tblShowtime7        UNION ALL
SELECT 'tblInvoice7',             COUNT(*)     FROM tblInvoice7         UNION ALL
SELECT 'tblInvoiceCounter7',      COUNT(*)     FROM tblInvoiceCounter7  UNION ALL
SELECT 'tblTicket7',              COUNT(*)     FROM tblTicket7;

-- Kiểm tra mã hóa đơn: 10 mã khác nhau, dạng HD + yyMMdd + 4 số
SELECT id, invoiceCode, transactionTime FROM tblInvoice7 ORDER BY id;