# CineMan7

Ứng dụng Java JSP/Servlet, Maven WAR, MySQL và Tomcat 9.

- Tìm kiếm: `/searchMovie`, form và kết quả cùng trang.
- Tài khoản: `/register`, `/login`, POST `/logout`.
- Thống kê: chỉ tài khoản quản lý, bắt đầu tại `/view/manager/ManagerMainUI7.jsp`.
- Giao diện dùng CSS inline, header/footer chung, không cần Bootstrap CDN.

## Chạy local

1. Dùng CSDL hiện có hoặc dựng CSDL demo từ **`sql/codeMySQL_CSDL.sql`**. File này có `DROP DATABASE` nên chỉ chạy toàn bộ khi muốn dựng lại dữ liệu.
2. Chép `.env.example` thành `.env`, điền thông tin MySQL.
3. Chạy `./run.ps1` trong PowerShell với JDK và Maven đã có trên PATH.
4. Mở `http://localhost:8080/CineMan7/`.

Demo: `quanly / Test@123` cho quản lý; `chien / Test@123` cho khách hàng. Dữ liệu giao dịch mẫu nằm trong tháng 05–06/2025.

Build/test: `mvn clean test package`. WAR: `target/CineMan7.war`.

## Tài liệu bàn giao

- [Từng bước mở và chạy bằng NetBeans](docs/NETBEANS.md)
- [Các mục và từng hình trong báo cáo phải sửa](docs/DOI_CHIEU_BAO_CAO.md)
- [Sơ đồ thay thế — PNG, SVG và nguồn PlantUML](docs/diagrams/README.md)
- [Kết quả kiểm thử](docs/KIEM_THU.md)
- [Ảnh màn hình để cập nhật báo cáo](docs/screenshots)

Đăng ký web tạo tài khoản khách hàng, chưa cấp thẻ thành viên. Đặt vé, thanh toán và các loại thống kê khác chưa được cài đặt. File Word gốc chưa bị chỉnh sửa.
