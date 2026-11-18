# Kiểm thử CineMan7 — 16/11/2026

## Môi trường và nguồn dữ liệu

- JDK 21.0.10, Maven 3.9.14, Tomcat 9.0.89, MySQL local.
- Dựng **CSDL kiểm thử riêng** từ `sql/codeMySQL_CSDL.sql` trong dự án. Khi kiểm thử, thay tên schema và loại bỏ dòng DROP DATABASE; không import đè vào `cineman7` đang có.
- Dữ liệu seed: 6 người dùng, 6 phim; tài khoản `quanly / Test@123` và khách hàng mẫu xác thực được bằng BCrypt.
- Trình duyệt Chromium, viewport desktop 1440×1000 và mobile 390×844.

## Kiểm thử tự động Java

Lệnh: `mvn clean test package` (sau đó dùng `mvn test package` khi cập nhật bổ sung). Tổng **7 test**, 0 failure, 0 error:

| Test class | Nội dung |
|---|---|
| PasswordUtil7Test — 2 test | Hash có salt khác nhau; đúng/sai mật khẩu; hash lỗi/null; chặn cắt ngầm trên 72 byte, bao gồm Unicode |
| CustomerStatisticDAOImpl7Test — 1 test | Sắp xếp tăng/giảm, giữ vãng lai cuối, không sửa list gốc |
| AuthFilter7Test — 4 test | Guest không truy cập JSP quản lý trực tiếp; Customer/Sales bị 403; POST quản lý bắt buộc token đúng; tìm kiếm công khai và UTF-8 |

Kết quả chi tiết mỗi lần chạy có tại `target/surefire-reports`.

## Kiểm thử HTTP và trình duyệt

Đã chạy các luồng sau qua Tomcat và MySQL, thay vì chỉ kiểm tra compile Java:

1. Mở trang chủ, tìm kiếm, login, register: JSP biên dịch được, có đúng một header/footer; không có stylesheet ngoài hoặc thẻ style.
2. Tìm `avengers`: có bảng trong SearchMovieUI7; click chi tiết và quay lại vẫn giữ keyword, thực hiện lại truy vấn.
3. Tìm rỗng, không khớp, `%`, `_`, chuỗi SQL, chuỗi script: thông báo và escape đúng; không trả toàn bộ phim do wildcard.
4. Guest truy cập JSP manager được đưa đến login; quản lý seed đăng nhập được.
5. Mở menu báo cáo; mặc định đầu tháng hiện tại; xem thống kê 06/2025 → 11 vé, 1.407.500 VND; sắp xếp đổi hướng, vãng lai cuối; mở hóa đơn và quay lại giữ kết quả.
6. POST ngày 2025-02-30 hoặc đảo khoảng bị từ chối; cùng ngày hợp lệ; khoảng rỗng có tổng 0 và 0%.
7. POST logout thiếu token → 403; GET logout → 405; logout đúng hủy session và bảo vệ lại báo cáo.
8. Đăng ký tài khoản mới, thử mật khẩu sai, đăng nhập đúng; khách hàng bị 403 cả endpoint và JSP manager trực tiếp.
9. Trùng email, ngày sinh tương lai, mật khẩu dài hơn 72 byte bị từ chối. Có kiểm tra DB để xác nhận không tạo User mồ côi khi trùng email.
10. URL SearchResultUI7.jsp cũ không còn trong bản WAR sạch, trả 404.
11. Trang chủ, tìm kiếm và đăng ký vừa viewport 390px, bảng kết quả cuộn trong khung; không tràn ngang toàn trang.
12. Không có lỗi JavaScript trong các luồng đã chạy.

Đã kiểm tra lại sau khi khôi phục bố cục giao diện cũ: bỏ banner, thẻ giới thiệu, nhãn bổ sung, nút Làm mới và các khối tổng hợp ngoài bảng. Header/footer và trang tài khoản giữ nguyên. Kiểm tra computed style xác nhận tiêu đề cột và ô dữ liệu chữ/mã căn trái; TT, thời lượng, số vé, số tiền và phần trăm căn phải, kể cả dòng tổng. Thao tác mở chi tiết khách hàng bằng cách nhấn dòng như bản cũ.

Đã kiểm tra bổ sung đăng nhập Customer/Sales bằng dữ liệu seed, bảo vệ báo cáo, đăng ký trùng username, sai xác nhận, tên chứa HTML được escape, tìm hoa/thường/tiếng Việt, chi tiết sai id, lỗi ngày URL giao dịch và kiểm tra metadata CSDL theo script chuẩn.

## Kiểm tra bổ sung sau yêu cầu thu gọn màn hình

- Viewport desktop 1366×768 và mobile 390×844: tiêu đề/form thu gọn, header/footer và các nút ngoài bảng nằm trong màn hình; không cuộn cả trang. Trang đăng ký vẫn thấy đầy đủ nút đăng ký và link đăng nhập.
- Nhân thêm 50 dòng trong DOM của các bảng tìm phim/thống kê/giao dịch để kiểm tra tràn: chỉ searchResults/statResults/transactionResults cuộn; vị trí header/footer không đổi. Nội dung mô tả phim dài cũng chỉ cuộn trong movieDetailResults.
- MovieDetailUI7 dùng table#outMovieDetail thật, có poster, dữ liệu, nút, trailer, mô tả; quay lại giữ keyword.
- Kết quả tìm kiếm hiển thị từ khóa trong tiêu đề; tên khách là link xanh; giao dịch hiển thị hạng Bạc của Nguyễn Văn An. Khách mới chưa có thẻ hiển thị “chưa là thành viên”.
- Dùng trình duyệt locale en-US: hai ô thống kê vẫn hiển thị 01/06/2025 và 30/06/2025. Thay giá trị calendar native cập nhật đúng ô chữ; POST dd/MM/yyyy vẫn cho 11 vé / 1.407.500 VND trong tháng 06/2025.
- Ngày 30/02/2025, thiếu ngày, đảo khoảng: JavaScript và POST trực tiếp đều báo chuỗi lỗi trong outMessage; không có tooltip validation. Style tính toán của outMessage ở thống kê và tìm phim giống nhau; cùng ngày vẫn hợp lệ.
- Mã Java vẫn qua 7 test; CSDL kiểm thử tiếp tục tách biệt với dữ liệu người dùng.

## Tài liệu và giới hạn kiểm chứng

- Có 18 sơ đồ PlantUML, đã render PNG và SVG không lỗi cú pháp; thuộc tính Java và cấu trúc bảng được trích từ source/script chuẩn.
- Ảnh giao diện thật ở `screenshots`; có bản desktop và mobile. Trailer trong dữ liệu seed là URL minh họa; việc mở link không đảm bảo video thật tồn tại.
- Build/triển khai local đã kiểm tra bằng Maven/Cargo/Tomcat. **Chưa thao tác trực tiếp trên một phiên NetBeans**; hướng dẫn NetBeans dựa trên cấu trúc dự án và tài liệu chính thức.
- Chưa sửa file Word gốc; `DOI_CHIEU_BAO_CAO.md` chứa bảng thay thế từng mục/hình. Không xem việc có bộ sơ đồ thay thế là đã cập nhật nội dung DOCX.
- Chức năng chưa triển khai: cấp thẻ, mua vé/ghế/thanh toán, đổi mật khẩu, các thống kê khác. Không có test xác nhận các chức năng này hoạt động.
