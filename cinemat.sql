-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th10 18, 2025 lúc 09:12 AM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `cinemat`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `danh_gia`
--

CREATE TABLE `danh_gia` (
  `id_danh_gia` int(11) NOT NULL,
  `id_nguoi_dung` int(11) DEFAULT NULL,
  `id_phim` int(11) DEFAULT NULL,
  `diem` int(11) DEFAULT NULL CHECK (`diem` between 1 and 5),
  `nhan_xet` text DEFAULT NULL,
  `thoi_gian` datetime DEFAULT current_timestamp(),
  `parent_id` int(11) DEFAULT NULL,
  `is_blocked` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `danh_gia`
--

INSERT INTO `danh_gia` (`id_danh_gia`, `id_nguoi_dung`, `id_phim`, `diem`, `nhan_xet`, `thoi_gian`, `parent_id`, `is_blocked`) VALUES
(1, 2, 2, 5, 'xuất sắc', '2025-06-20 09:14:14', NULL, 1),
(2, 2, 1, 5, 'hay', '2025-06-20 11:04:20', NULL, 0),
(3, 2, 10, 5, 'Hay nha', '2025-06-20 11:31:09', NULL, 0),
(4, 2, 8, 5, 'Hay', '2025-06-20 11:31:33', NULL, 0),
(5, 5, 6, 5, 'hay', '2025-06-20 11:34:14', NULL, 0),
(6, 5, 2, NULL, 'hài v', '2025-06-20 14:53:47', 1, 0),
(7, 5, 2, NULL, 'hay mà', '2025-06-20 14:55:21', 6, 0),
(8, 2, 17, 5, 'hay', '2025-06-20 15:20:50', NULL, 1),
(9, 3, 2, 5, 'Phim hay lắm. Bản Việt không hay bằng đâu', '2025-06-20 15:42:53', NULL, 0),
(10, 4, 2, NULL, 'Hay mà nhỉ', '2025-06-20 15:44:47', 9, 0),
(11, 2, 20, 5, 'siêu phẩm', '2025-06-20 16:14:01', NULL, 0),
(12, 3, 20, 5, 'Năm cày 2 lần đều đều', '2025-06-20 16:15:10', NULL, 0),
(13, 6, 20, 5, 'Phim này hay lắm rcm ae nghỉ hè cày full bộ nhé', '2025-06-20 16:33:56', NULL, 0),
(14, 6, 20, NULL, 'Tôi cũng thế bà ơi =)))', '2025-06-20 16:35:46', 12, 0),
(15, 5, 20, 5, 'siêu siêu hay', '2025-06-20 16:36:49', NULL, 0),
(16, 5, 20, NULL, 'bà này xem nhiều thế', '2025-06-20 16:37:10', 14, 0),
(17, 5, 20, NULL, 'tui cũng thế =)))', '2025-06-20 16:37:33', 14, 0),
(18, 5, 20, NULL, 'Hay ác', '2025-06-20 16:37:50', 12, 0),
(19, 3, 19, 5, 'phim này xem 10 lần rồi', '2025-11-05 14:41:30', NULL, 0),
(20, 3, 10, 5, 'HAY', '2025-11-05 14:46:15', NULL, 0),
(21, 3, 10, NULL, 'OKE', '2025-11-05 14:46:41', 3, 0);

--
-- Bẫy `danh_gia`
--
DELIMITER $$
CREATE TRIGGER `trg_after_insert_danh_gia` AFTER INSERT ON `danh_gia` FOR EACH ROW BEGIN
  IF NEW.parent_id IS NULL AND NEW.is_blocked = 0 THEN
    UPDATE phim
    SET diem_trung_binh = (
      SELECT ROUND(AVG(diem), 1)
      FROM danh_gia
      WHERE id_phim = NEW.id_phim AND parent_id IS NULL AND is_blocked = 0
    )
    WHERE id_phim = NEW.id_phim;
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_after_update_danh_gia` AFTER UPDATE ON `danh_gia` FOR EACH ROW BEGIN
  IF OLD.id_phim IS NOT NULL THEN
    UPDATE phim
    SET diem_trung_binh = (
      SELECT ROUND(AVG(diem), 1)
      FROM danh_gia
      WHERE id_phim = OLD.id_phim AND parent_id IS NULL AND is_blocked = 0
    )
    WHERE id_phim = OLD.id_phim;
  END IF;
  
  IF NEW.id_phim IS NOT NULL AND NEW.id_phim != OLD.id_phim THEN
    UPDATE phim
    SET diem_trung_binh = (
      SELECT ROUND(AVG(diem), 1)
      FROM danh_gia
      WHERE id_phim = NEW.id_phim AND parent_id IS NULL AND is_blocked = 0
    )
    WHERE id_phim = NEW.id_phim;
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_danh_gia_after_insert` AFTER INSERT ON `danh_gia` FOR EACH ROW BEGIN
  IF NEW.parent_id IS NULL AND NEW.is_blocked = 0 THEN
    UPDATE phim
    SET luot_danh_gia = (
      SELECT COUNT(*) FROM danh_gia
      WHERE id_phim = NEW.id_phim AND parent_id IS NULL AND is_blocked = 0
    )
    WHERE id_phim = NEW.id_phim;
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_danh_gia_after_update` AFTER UPDATE ON `danh_gia` FOR EACH ROW BEGIN
  -- Cập nhật cho phim cũ
  IF OLD.id_phim IS NOT NULL THEN
    UPDATE phim
    SET luot_danh_gia = (
      SELECT COUNT(*) FROM danh_gia
      WHERE id_phim = OLD.id_phim AND parent_id IS NULL AND is_blocked = 0
    )
    WHERE id_phim = OLD.id_phim;
  END IF;

  -- Nếu đánh giá chuyển sang phim khác, cập nhật phim mới luôn
  IF NEW.id_phim IS NOT NULL AND NEW.id_phim != OLD.id_phim THEN
    UPDATE phim
    SET luot_danh_gia = (
      SELECT COUNT(*) FROM danh_gia
      WHERE id_phim = NEW.id_phim AND parent_id IS NULL AND is_blocked = 0
    )
    WHERE id_phim = NEW.id_phim;
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `nguoi_dung`
--

CREATE TABLE `nguoi_dung` (
  `id_nguoi_dung` int(11) NOT NULL,
  `ten_nguoi_dung` varchar(50) NOT NULL,
  `matkhau` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `role` enum('admin','user') DEFAULT 'user',
  `is_blocked` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `nguoi_dung`
--

INSERT INTO `nguoi_dung` (`id_nguoi_dung`, `ten_nguoi_dung`, `matkhau`, `email`, `role`, `is_blocked`, `created_at`, `updated_at`) VALUES
(1, 'anhtho', 'anhtho2005', 'danganhtho2395@gmail.com', 'user', 0, '2025-05-29 15:54:59', '2025-05-29 15:54:59'),
(2, 'admin', '123123', 'admin123@gmail.com', 'admin', 0, '2025-05-29 15:55:31', '2025-05-29 15:55:31'),
(3, 'anhtho1', '123123', 'thod9840@gmail.com', 'user', 0, '2025-05-30 07:28:10', '2025-06-14 08:56:44'),
(4, 'anhtho2', '123123', 'nguyenthitohoai16072000@gmail.com', 'user', 0, '2025-06-18 03:09:30', '2025-06-18 03:09:30'),
(5, 'anhtho3', '123123', 'thoo@gmail.com', 'user', 0, '2025-06-19 02:14:10', '2025-06-19 02:14:10'),
(6, 'anhtho4', '123123', 't@gmail.com', 'user', 0, '2025-06-19 03:00:15', '2025-06-19 03:00:15');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `phim`
--

CREATE TABLE `phim` (
  `id_phim` int(11) NOT NULL,
  `ten_phim` varchar(255) NOT NULL,
  `mo_ta` text DEFAULT NULL,
  `poster` varchar(255) DEFAULT NULL,
  `id_quoc_gia` int(11) DEFAULT NULL,
  `trang_thai` enum('hien','an') DEFAULT 'hien',
  `diem_trung_binh` decimal(3,1) DEFAULT NULL,
  `luot_danh_gia` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `phim`
--

INSERT INTO `phim` (`id_phim`, `ten_phim`, `mo_ta`, `poster`, `id_quoc_gia`, `trang_thai`, `diem_trung_binh`, `luot_danh_gia`) VALUES
(1, 'Khi cuộc đời cho bạn quả quýt', 'Bộ phim kể về cuộc đời phiêu lưu và những thử thách của Ae-sun, một cô gái nghèo sinh ra ở Jeju năm 1951, mang ước mơ trở thành nhà thơ, và Gwan-sik, một chàng trai trẻ luôn trân trọng và yêu thương cô.', '1749981262_684e984ee3520.jpeg', 1, 'hien', 5.0, 1),
(2, 'Lấy danh nghĩa là người nhà', 'Ba đứa trẻ Lý Tiêm Tiêm, Lăng Tiêu, Hạ Tử Thu không cùng huyết thống lớn lên trong hoàn cảnh khác nhau, trải qua những vấn đề cuộc sống khó khăn, nhưng lại tình cờ ở chung một chỗ và trở thành anh em. Anh cả Lăng Tiêu (Tống Uy Long) – bố mẹ đẻ Lăng Hòa Bình và Trần Đình ly hôn từ lúc anh còn nhỏ, bố thiếu sự quan tâm, mẹ lấy chồng mới, sinh con khác, ít gặp; anh hai Tử Thu (Trương Tân Thành) – bố mẹ cũng đã ly hôn, mẹ là Hạ Mai đặt con theo họ mình vì đã sinh ra và một mình nuôi Tử Thu, rồi để anh lại cho người quen là Lý Hải Triều, đi làm ăn xa; em út Lý Tiêm Tiêm (Đàm Tùng Vận) – con gái của Lý Hải Triều, mẹ mất sớm, bố gà trống nuôi con. Cả ba người được hai người cha là Lý Hải Triều và Lăng Hòa Bình cùng nuôi nấng. Bọn họ nương tựa lẫn nhau, trưởng thành cùng nhau. Sau khi tốt nghiệp trung học, hai người anh trở về gia đình vốn có của mình. Một bên là người nhà đã nhận định, đã quý trọng lẫn nhau. Một bên là cha mẹ ruột nhưng quan hệ lại hết sức lạnh nhạt, thậm chí mâu thuẫn. Bối cảnh tạo nên sự khó lựa chọn trong đời sống gia đình.', '1749982187_684e9beb71f54.jpg', 3, 'hien', 5.0, 1),
(3, 'Avengers: Hồi Kết', 'Sau sự kiện hủy diệt tàn khốc, vũ trụ chìm trong cảnh hoang tàn. Với sự trợ giúp của những đồng minh còn sống sót, biệt đội siêu anh hùng Avengers tập hợp một lần nữa để đảo ngược hành động của Thanos và khôi phục lại trật tự của vũ trụ.', '1749982284_684e9c4c8ce1a.jpg', 5, 'hien', NULL, 0),
(5, 'Inception', 'Một tên trộm có khả năng xâm nhập vào giấc mơ của người khác để đánh cắp bí mật. Anh ta nhận được nhiệm vụ cấy ý tưởng vào tiềm thức một người.', '1750410291_685524330c249.jpg', 5, 'hien', NULL, 0),
(6, 'Interstellar', 'Trong bối cảnh Trái Đất sắp diệt vong, một nhóm phi hành gia du hành qua hố sâu không gian để tìm kiếm hành tinh mới cho loài người.', '1750410385_6855249173f5b.jpg', 5, 'hien', 5.0, 1),
(7, 'Parasite', 'Các chủ đề chính của Ký sinh trùng là xung đột giai cấp, bất bình đẳng xã hội và bất bình đẳng kinh tế.[14][15][16] Các nhà phê bình phim và chính Bong Joon-ho đã coi bộ phim là sự phản ánh của chủ nghĩa tư bản hiện đại trần trụi,[17][18] và một số người đã liên kết nó với thuật ngữ \"Hell Joseon\", một cụm từ đã trở nên phổ biến, đặc biệt là với giới trẻ, vào cuối những năm 2010 để mô tả những khó khăn của cuộc sống ở Hàn Quốc. Thuật ngữ này ra đời do tỷ lệ thất nghiệp ở thanh niên đang có xu hướng cao, nhu cầu học cao hơn, sự khủng hoảng về khả năng chi trả cho nhà ở và khoảng cách kinh tế xã hội ngày càng tăng giữa người giàu và người nghèo.[19][20][21] Trong cuốn sách Coronavirus Capitalism Goes to the Cinema (tạm dịch: Khi chủ nghĩa COVID-19 xâm nhập vào điện ảnh), Eugene Nulman viết rằng từ nguyên của từ \'ký sinh trùng\' ban đầu dùng để chỉ \"người ăn trên bàn của người khác\", được trình bày trong một trong những cảnh của bộ phim.', '1749953421_684e2b8d3cf0c.jpeg', 1, 'hien', NULL, 0),
(8, 'La La Land', 'Hai người trẻ theo đuổi đam mê âm nhạc và diễn xuất tại Los Angeles đã gặp nhau và cùng đi qua một chuyện tình rực rỡ nhưng cũng đầy thăng trầm.', '1750410436_685524c4555f1.jpg', 5, 'hien', 5.0, 1),
(10, 'The Dark Knight', 'Batman phải đối đầu với tên tội phạm nguy hiểm Joker, kẻ muốn đẩy Gotham vào hỗn loạn và thử thách giới hạn đạo đức của anh.', '1750409866_6855228a82477.jpg', 5, 'hien', 5.0, 2),
(17, 'Vigilante - Cảnh giác', 'Khi Kim Ji Yong còn nhỏ, mẹ anh đã bị đánh chết trên đường phố. Thủ phạm chỉ nhận ba năm rưỡi tù. Kim Ji Yong – bây giờ đã trưởng thành – thấy rằng kẻ giết mẹ mình không thay đổi chút nào. Ji Yong tự mình giải quyết vấn đề và đánh đập anh ta một cách tàn nhẫn.Sau đó, Kim Ji Yong bắt đầu sống hai cuộc sống hoàn toàn khác nhau. Vào các ngày trong tuần, anh ấy là một sinh viên gương mẫu tại trường đại học cảnh sát. Vnsub.net ,Trong những ngày cuối tuần, anh ta trừng phạt những tên tội phạm đã nhận bản án nhẹ và tiếp tục thực hiện các hành vi phạm tội. Bây giờ được gọi là Vigilante, Ji Yong nhận được sự giúp đỡ từ người ngưỡng mộ Cho Kang Ok. Trong khi đó, thám tử Cho Heon đuổi theo người đàn ông được gọi là Vigilante.', '1750216446_68522efe152c9.jpg', 1, 'hien', NULL, 0),
(18, 'Bố già', 'Bố già (tiếng Anh: Dad, I\'m Sorry) là một bộ phim điện ảnh Việt Nam thuộc thể loại hài – chính kịch ra mắt năm 2021 do Trấn Thành và Vũ Ngọc Đãng đồng đạo diễn, với phần kịch bản do Trấn Thành, Bùi An Nhi, Lương Nghiêm Huy và Hồ Thúc An chấp bút. Phim được dựa trên bộ web drama cùng tên năm 2020, với sự tham gia diễn xuất của các diễn viên gồm Trấn Thành, Tuấn Trần, Ngân Chi, Ngọc Giàu, Lê Giang, Hoàng Mèo, Lan Phương, La Thành và Quốc Khánh. Lấy bối cảnh tại Thành phố Hồ Chí Minh, nội dung phim xoay quanh mối quan hệ giữa ông Sang – một người luôn lo chuyện bao đồng và giúp đỡ người khác – và con trai ông là Quắn – một cậu thanh niên kiếm tiền bằng Youtube rất yêu thương ba và em gái – cùng những rắc rối mà cả hai gặp phải với những người thân trong gia đình mình.', '1750259249_6852d63109d3a.jpg', 2, 'hien', NULL, 0),
(19, 'Harry Potter và tên tù nhân ngục Azkaban', 'Xe buýt Hiệp sĩ đưa Harry đến quán Cái vạc Lủng, nơi Bộ trưởng Bộ Pháp thuật Cornelius Fudge đảm bảo với Harry rằng cậu sẽ không bị trừng phạt. Đoàn tụ với những người bạn thân nhất của mình là Ron Weasley và Hermione Granger, Harry biết rằng Sirius Black, một kẻ bị kết án ủng hộ Chúa tể Voldemort, đã trốn thoát khỏi nhà tù Azkaban và có ý định giết cậu. Trong cuộc hành trình đến Hogwarts, bọn Giám ngục lên tàu tốc hành Hogwarts, những tên giám ngục ma quái đang tìm kiếm Black. Một kẻ bước vào khoang của Harry, khiến cậu ngất xỉu, nhưng giáo viên Phòng thủ mới chống lại Nghệ thuật Hắc ám, Remus Lupin đẩy lùi nó bằng Bùa hộ mệnh. Tại Hogwarts, Hiệu trưởng Albus Dumbledore thông báo rằng các Giám ngục sẽ tuần tra trường cho đến khi Black bị bắt.', '1750410660_685525a4a23f0.jpg', 5, 'hien', 5.0, 1),
(20, 'Harry Potter và Chiếc cốc lửa', 'Sau năm học thứ 3, Harry nghỉ hè cùng gia đình Weasley. Nhưng cậu luôn có một giấc mơ kỳ lạ cả mùa hè. Cậu thấy Voldemort trong cơ thể tàn tạ tại dinh thự Riddle, đang bàn với thuộc hạ gồm Peter Pettigrew cùng một tên lạ mặt khác về việc giết cậu và hồi sinh cho hắn. Rồi cậu choàng tỉnh khi Hermione gọi cậu dậy xem trận chung kết Quidditch World Cup cùng nhà Weasley và nhà Diggory. Sau khi trận đấu kết thúc, khi tất cả đang ăn mừng chức vô địch của Ireland, một đám Tử thần Thực tử, tay sai của Voldemort bất ngờ tấn công và phóng hỏa khu cắm trại. May mắn là Harry cùng bạn bè của cậu đều bình an.', '1750410802_68552632442a1.jpg', 5, 'hien', 5.0, 4),
(21, 'Người hùng yếu đuối', 'người hùng', '1763390443_691b33eb1a47a.png', 1, 'an', NULL, 0);

--
-- Bẫy `phim`
--
DELIMITER $$
CREATE TRIGGER `trg_update_yeu_cau_them_phim` AFTER INSERT ON `phim` FOR EACH ROW BEGIN
    UPDATE yeu_cau_them_phim
    SET trang_thai = 'da_xu_ly'
    WHERE ten_phim = NEW.ten_phim;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_update_yeu_cau_them_phim_on_update` AFTER UPDATE ON `phim` FOR EACH ROW BEGIN
    UPDATE yeu_cau_them_phim
    SET trang_thai = 'da_xu_ly'
    WHERE ten_phim = NEW.ten_phim;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `phim_the_loai`
--

CREATE TABLE `phim_the_loai` (
  `id_phim` int(11) NOT NULL,
  `id_the_loai` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `phim_the_loai`
--

INSERT INTO `phim_the_loai` (`id_phim`, `id_the_loai`) VALUES
(1, 2),
(1, 3),
(1, 4),
(2, 2),
(2, 4),
(2, 7),
(3, 1),
(3, 6),
(5, 1),
(5, 3),
(5, 5),
(5, 8),
(5, 14),
(6, 3),
(6, 6),
(7, 2),
(7, 3),
(7, 14),
(7, 16),
(8, 3),
(8, 13),
(10, 1),
(10, 3),
(10, 6),
(10, 14),
(17, 1),
(17, 3),
(17, 14),
(17, 15),
(18, 3),
(18, 4),
(18, 16),
(19, 6),
(19, 14),
(20, 6),
(20, 14),
(21, 5),
(21, 16);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `quoc_gia`
--

CREATE TABLE `quoc_gia` (
  `id_quoc_gia` int(11) NOT NULL,
  `ten_quoc_gia` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `quoc_gia`
--

INSERT INTO `quoc_gia` (`id_quoc_gia`, `ten_quoc_gia`) VALUES
(1, 'Hàn Quốc'),
(2, 'Việt Nam'),
(3, 'Trung Quốc'),
(4, 'Tây Ban Nha'),
(5, 'Mỹ');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `the_loai`
--

CREATE TABLE `the_loai` (
  `id_the_loai` int(11) NOT NULL,
  `ten_the_loai` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `the_loai`
--

INSERT INTO `the_loai` (`id_the_loai`, `ten_the_loai`) VALUES
(1, 'Hành Động\r\n'),
(2, 'Tâm lý\r\n'),
(3, 'Chính Kịch\r\n'),
(4, 'Hài\r\n'),
(5, 'Bạo Lực\r\n'),
(6, 'Khoa học'),
(7, 'Học đường'),
(8, 'Kinh dị'),
(11, 'Cổ trang'),
(12, 'Anime'),
(13, 'Lãng mạn'),
(14, 'Giật gân'),
(15, 'hình sự'),
(16, 'Gia đình');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `yeu_cau_them_phim`
--

CREATE TABLE `yeu_cau_them_phim` (
  `id_yeu_cau` int(11) NOT NULL,
  `id_nguoi_dung` int(11) DEFAULT NULL,
  `ten_phim` varchar(255) DEFAULT NULL,
  `the_loai` text DEFAULT NULL,
  `trang_thai` enum('cho_duyet','da_xu_ly') DEFAULT 'cho_duyet',
  `thoi_gian` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `yeu_cau_them_phim`
--

INSERT INTO `yeu_cau_them_phim` (`id_yeu_cau`, `id_nguoi_dung`, `ten_phim`, `the_loai`, `trang_thai`, `thoi_gian`) VALUES
(2, 4, 'Bố già', 'Gia đình', 'da_xu_ly', '2025-06-18 11:40:44');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `yeu_thich`
--

CREATE TABLE `yeu_thich` (
  `id_yeu_thich` int(11) NOT NULL,
  `id_nguoi_dung` int(11) NOT NULL,
  `id_phim` int(11) NOT NULL,
  `thoi_gian` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `yeu_thich`
--

INSERT INTO `yeu_thich` (`id_yeu_thich`, `id_nguoi_dung`, `id_phim`, `thoi_gian`) VALUES
(8, 2, 3, '2025-06-15 14:43:38'),
(15, 2, 2, '2025-06-15 17:22:47'),
(16, 2, 5, '2025-06-15 17:22:50'),
(17, 2, 6, '2025-06-15 17:22:52'),
(18, 2, 7, '2025-06-15 17:22:54'),
(19, 2, 8, '2025-06-15 17:22:56'),
(22, 2, 10, '2025-06-15 17:23:05'),
(34, 4, 1, '2025-06-18 03:10:15'),
(35, 4, 3, '2025-06-18 03:10:22'),
(36, 4, 10, '2025-06-18 03:10:38'),
(37, 4, 2, '2025-06-18 03:14:58'),
(39, 2, 1, '2025-06-18 18:41:49'),
(41, 5, 2, '2025-06-20 04:32:15'),
(42, 5, 10, '2025-06-20 04:33:56'),
(43, 5, 8, '2025-06-20 04:33:57'),
(44, 5, 6, '2025-06-20 04:34:09'),
(45, 3, 1, '2025-06-20 08:42:14'),
(46, 3, 2, '2025-06-20 08:42:16'),
(47, 2, 20, '2025-06-20 09:13:49'),
(48, 3, 20, '2025-06-20 09:14:28'),
(50, 2, 18, '2025-11-05 07:30:18'),
(51, 3, 10, '2025-11-05 07:55:10');

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `danh_gia`
--
ALTER TABLE `danh_gia`
  ADD PRIMARY KEY (`id_danh_gia`),
  ADD KEY `id_nguoi_dung` (`id_nguoi_dung`),
  ADD KEY `id_phim` (`id_phim`),
  ADD KEY `parent_id` (`parent_id`);

--
-- Chỉ mục cho bảng `nguoi_dung`
--
ALTER TABLE `nguoi_dung`
  ADD PRIMARY KEY (`id_nguoi_dung`),
  ADD UNIQUE KEY `ten_nguoi_dung` (`ten_nguoi_dung`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Chỉ mục cho bảng `phim`
--
ALTER TABLE `phim`
  ADD PRIMARY KEY (`id_phim`),
  ADD KEY `id_quoc_gia` (`id_quoc_gia`);

--
-- Chỉ mục cho bảng `phim_the_loai`
--
ALTER TABLE `phim_the_loai`
  ADD PRIMARY KEY (`id_phim`,`id_the_loai`),
  ADD KEY `id_the_loai` (`id_the_loai`);

--
-- Chỉ mục cho bảng `quoc_gia`
--
ALTER TABLE `quoc_gia`
  ADD PRIMARY KEY (`id_quoc_gia`);

--
-- Chỉ mục cho bảng `the_loai`
--
ALTER TABLE `the_loai`
  ADD PRIMARY KEY (`id_the_loai`);

--
-- Chỉ mục cho bảng `yeu_cau_them_phim`
--
ALTER TABLE `yeu_cau_them_phim`
  ADD PRIMARY KEY (`id_yeu_cau`),
  ADD KEY `id_nguoi_dung` (`id_nguoi_dung`);

--
-- Chỉ mục cho bảng `yeu_thich`
--
ALTER TABLE `yeu_thich`
  ADD PRIMARY KEY (`id_yeu_thich`),
  ADD UNIQUE KEY `unique_favorite` (`id_nguoi_dung`,`id_phim`),
  ADD KEY `favorites_ibfk_2` (`id_phim`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `danh_gia`
--
ALTER TABLE `danh_gia`
  MODIFY `id_danh_gia` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT cho bảng `nguoi_dung`
--
ALTER TABLE `nguoi_dung`
  MODIFY `id_nguoi_dung` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT cho bảng `phim`
--
ALTER TABLE `phim`
  MODIFY `id_phim` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT cho bảng `quoc_gia`
--
ALTER TABLE `quoc_gia`
  MODIFY `id_quoc_gia` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `the_loai`
--
ALTER TABLE `the_loai`
  MODIFY `id_the_loai` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT cho bảng `yeu_cau_them_phim`
--
ALTER TABLE `yeu_cau_them_phim`
  MODIFY `id_yeu_cau` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `yeu_thich`
--
ALTER TABLE `yeu_thich`
  MODIFY `id_yeu_thich` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `danh_gia`
--
ALTER TABLE `danh_gia`
  ADD CONSTRAINT `danh_gia_ibfk_1` FOREIGN KEY (`id_nguoi_dung`) REFERENCES `nguoi_dung` (`id_nguoi_dung`),
  ADD CONSTRAINT `danh_gia_ibfk_2` FOREIGN KEY (`id_phim`) REFERENCES `phim` (`id_phim`) ON DELETE CASCADE,
  ADD CONSTRAINT `danh_gia_ibfk_3` FOREIGN KEY (`parent_id`) REFERENCES `danh_gia` (`id_danh_gia`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `phim`
--
ALTER TABLE `phim`
  ADD CONSTRAINT `phim_ibfk_1` FOREIGN KEY (`id_quoc_gia`) REFERENCES `quoc_gia` (`id_quoc_gia`);

--
-- Các ràng buộc cho bảng `phim_the_loai`
--
ALTER TABLE `phim_the_loai`
  ADD CONSTRAINT `fk_phimtheloai_phim` FOREIGN KEY (`id_phim`) REFERENCES `phim` (`id_phim`) ON DELETE CASCADE,
  ADD CONSTRAINT `phim_the_loai_ibfk_1` FOREIGN KEY (`id_phim`) REFERENCES `phim` (`id_phim`) ON DELETE CASCADE,
  ADD CONSTRAINT `phim_the_loai_ibfk_2` FOREIGN KEY (`id_the_loai`) REFERENCES `the_loai` (`id_the_loai`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `yeu_cau_them_phim`
--
ALTER TABLE `yeu_cau_them_phim`
  ADD CONSTRAINT `yeu_cau_them_phim_ibfk_1` FOREIGN KEY (`id_nguoi_dung`) REFERENCES `nguoi_dung` (`id_nguoi_dung`);

--
-- Các ràng buộc cho bảng `yeu_thich`
--
ALTER TABLE `yeu_thich`
  ADD CONSTRAINT `fk_yeuthich_phim` FOREIGN KEY (`id_phim`) REFERENCES `phim` (`id_phim`) ON DELETE CASCADE,
  ADD CONSTRAINT `yeu_thich_ibfk_1` FOREIGN KEY (`id_nguoi_dung`) REFERENCES `nguoi_dung` (`id_nguoi_dung`),
  ADD CONSTRAINT `yeu_thich_ibfk_2` FOREIGN KEY (`id_phim`) REFERENCES `phim` (`id_phim`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
