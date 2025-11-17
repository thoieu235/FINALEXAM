🎬 CINEMAT – HỆ THỐNG WEBSITE ĐÁNH GIÁ REVIEW VÀ QUẢN LÝ PHIM 

📌 1. Giới thiệu
CINEMAT là hệ thống website cho phép người dùng khám phá phim, xem thông tin chi tiết, chấm điểm, viết đánh giá, bình luận và yêu thích phim. Ngoài ra, người dùng có thể gửi yêu cầu đề xuất phim mới.
 Hệ thống cung cấp giao diện dành cho Admin nhằm quản lý phim, người dùng, đánh giá, bình luận và xử lý yêu cầu thêm phim.

📌 2. CÔNG NGHỆ SỬ DỤNG

Backend: PHP
Frontend: HTML, CSS, JavaScript
Database: MySQL
Server: Apache (XAMPP)

✨ 3. TÍNH NĂNG CHÍNH

🎥 3.1. Người dùng (User)

Đăng ký / Đăng nhập

Xem phim (truy cập trang phim)

Đánh giá phim

Tìm kiếm, bộ lọc phim

Thêm/xóa danh sách yêu thích

Yêu cầu thêm phim

 🛠 3.2. Admin
 
Đăng nhập admin 

Quản lý phim (đăng, sửa, chặn phim) 

Quản lý đánh giá (chặn đánh giá) 

Quản lý người dùng (xem, chặn người dùng) 

Quản lý thể loại (thêm thể loại) - Quản lý yêu cầu thêm phim

🗄️4. CƠ SỞ DỮ LIỆU

Các bảng chính:

phim 

the_loai

quoc_gia

phim_the_loai

yeu_thich

yeu_cau_them_phim

binh_luan

nguoi_dung

danh_gia

📂5. Cấu trúc thư mục

/cinemat

│── index.php

│── dangnhap.php

│── dangki.php

│── dangxuat.php

│── danhsachphim.php

│── kiemtra.php

│── yeuthich.php

│── test.php

│── cinemat.sql

│── README.md

│

├── admin/

│   ├── comments/

│   │   └── admin_comment.php

│   │

│   ├── layouts/

│   │   └── header.php

│   │

│   ├── movies/

│   │   ├── admin_movie.php

│   │   ├── admin_movie_edit.php

│   │   └── admin_movie_post.php

│   │

│   ├── requires/

│   │   └── require.php

│   │

│   └── users/

│       └── admin_user.php

│

├── chitietphim/

│   ├── chitietphim.php

│   ├── danhgia.php

│   └── log_vote.txt

│

├── config/

│   ├── config.php

│   ├── database.php

│   └── function.php

│

├── layouts/

│   ├── header.php

│   └── footer.php

│

├── photo/

│   └── ... (ảnh poster, banner, avatar,…)



🧩 6. Mô tả chi tiết một số chức năng

⭐ 6.1. Đăng nhập

Kiểm tra tên đăng nhập

Kiểm tra mật khẩu

Duy trì session người dùng

❤️ 6.2. Yêu thích phim

Chỉ cho phép thao tác khi người dùng đã đăng nhập

Lưu yêu thích vào bảng favorites

Hiển thị danh sách phim yêu thích riêng

🔍 6.3. Tìm kiếm & Lọc phim

Tìm theo tên phim, mô tả

Lọc theo thể loại/quốc gia

Kết hợp nhiều tiêu chí

📝 6.4. Đánh giá phim

Chấm điểm 1–5 sao

Like/Dislike đánh giá

Hiển thị danh sách review

➕ 6.5. Admin thêm phim

Upload poster

Chọn nhiều thể loại

Kiểm tra trùng yêu cầu thêm phim

Tự động cập nhật trạng thái yêu cầu khi phim được thêm

📈 7. Kết quả đạt được

Giao diện thân thiện, dễ dùng

Hệ thống chạy ổn định

Đáp ứng đầy đủ yêu cầu bài tập lớn

Có nền tảng để phát triển thêm thành website xem phim thực thụ

⚠️ 8. Hạn chế & Hướng phát triển

Hạn chế:

UI chưa tối ưu cho mobile

Một số poster chưa chuẩn kích thước

Chưa có bảo mật nâng cao

Chưa có phân quyền nhiều cấp cho admin

Hướng phát triển:

Tích hợp đề xuất phim theo AI

Thêm hệ thống bình luận nâng cao

Tối ưu bảo mật (mã hoá mật khẩu, 2FA)

Tích hợp xem phim trực tuyến

🏁 9. Kết luận

Dự án CINEMAT là một website đầy đủ chức năng giúp người dùng đánh giá và tương tác về phim, đồng thời cung cấp công cụ quản trị mạnh mẽ cho admin.

 Dự án giúp sinh viên làm quen với quy trình phát triển web thực tế từ phân tích – thiết kế – lập trình – triển khai – thử nghiệm.





