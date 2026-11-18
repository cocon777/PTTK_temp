# Bộ sơ đồ CineMan7

Nguồn chuẩn: Java trong `src/main/java` và CSDL `sql/codeMySQL_CSDL.sql`. Không có SearchResultUI7 riêng. Các sơ đồ lớp 01–04 ẩn constructor và getter/setter/addTicket của model; xem Java cho toàn bộ accessor. Các trường trong hộp JSP là thành phần giao diện hoặc thuộc tính request, không phải field Java.

Mở SVG để phóng to hoặc chèn vào Word; PNG dành cho phần mềm cần ảnh bitmap. Mỗi sơ đồ đều có nguồn PlantUML để sửa tiếp.

| Sơ đồ | SVG | PNG | Nguồn |
|---|---|---|---|
| Lớp thực thể — thuộc tính đúng theo model Java | [SVG](01-entity-classes.svg) | [PNG](01-entity-classes.png) | [PlantUML](01-entity-classes.puml) |
| Lớp thiết kế — tìm kiếm phim | [SVG](02-search-design.svg) | [PNG](02-search-design.png) | [PlantUML](02-search-design.puml) |
| Lớp thiết kế — thống kê khách hàng | [SVG](03-statistics-design.svg) | [PNG](03-statistics-design.png) | [PlantUML](03-statistics-design.puml) |
| Lớp thiết kế — tài khoản và phân quyền | [SVG](04-auth-design.svg) | [PNG](04-auth-design.png) | [PlantUML](04-auth-design.puml) |
| Trạng thái giao diện — tìm kiếm đã gộp | [SVG](05-search-state.svg) | [PNG](05-search-state.png) | [PlantUML](05-search-state.puml) |
| Hoạt động — form và kết quả cùng SearchMovieUI7.jsp | [SVG](06-search-activity.svg) | [PNG](06-search-activity.png) | [PlantUML](06-search-activity.puml) |
| Tuần tự thiết kế — tìm kiếm và xem chi tiết | [SVG](07-search-sequence.svg) | [PNG](07-search-sequence.png) | [PlantUML](07-search-sequence.puml) |
| Hoạt động — thống kê, phân quyền và giữ kết quả | [SVG](08-statistics-activity.svg) | [PNG](08-statistics-activity.png) | [PlantUML](08-statistics-activity.puml) |
| Tuần tự thiết kế — thống kê và chi tiết giao dịch | [SVG](09-statistics-sequence.svg) | [PNG](09-statistics-sequence.png) | [PlantUML](09-statistics-sequence.puml) |
| Tuần tự — đăng ký tài khoản khách hàng | [SVG](10-register-sequence.svg) | [PNG](10-register-sequence.png) | [PlantUML](10-register-sequence.puml) |
| Tuần tự — đăng nhập và xác định vai trò | [SVG](11-login-sequence.svg) | [PNG](11-login-sequence.png) | [PlantUML](11-login-sequence.puml) |
| Tuần tự — đăng xuất và bảo vệ báo cáo | [SVG](12-logout-sequence.svg) | [PNG](12-logout-sequence.png) | [PlantUML](12-logout-sequence.puml) |
| Hoạt động — đăng ký, đăng nhập, đăng xuất | [SVG](13-auth-activity.svg) | [PNG](13-auth-activity.png) | [PlantUML](13-auth-activity.puml) |
| Thiết kế gói — đúng cấu trúc thư mục | [SVG](14-packages.svg) | [PNG](14-packages.png) | [PlantUML](14-packages.puml) |
| Use case — phạm vi đã cài đặt | [SVG](15-implemented-usecases.svg) | [PNG](15-implemented-usecases.png) | [PlantUML](15-implemented-usecases.puml) |
| CSDL — bảng và khóa ngoại từ script SQL | [SVG](16-database.svg) | [PNG](16-database.png) | [PlantUML](16-database.puml) |
| Giao tiếp — tìm kiếm theo cấu trúc MVC hiện tại | [SVG](17-search-communication.svg) | [PNG](17-search-communication.png) | [PlantUML](17-search-communication.puml) |
| Giao tiếp — thống kê theo cấu trúc MVC hiện tại | [SVG](18-statistics-communication.svg) | [PNG](18-statistics-communication.png) | [PlantUML](18-statistics-communication.puml) |

## Tạo lại từ source

```powershell
python tools/generate-diagrams.py
mvn dependency:get '-Dartifact=net.sourceforge.plantuml:plantuml:1.2025.10'
java -jar "$env:USERPROFILE/.m2/repository/net/sourceforge/plantuml/plantuml/1.2025.10/plantuml-1.2025.10.jar" -charset UTF-8 -tsvg "docs/diagrams/*.puml"
java -jar "$env:USERPROFILE/.m2/repository/net/sourceforge/plantuml/plantuml/1.2025.10/plantuml-1.2025.10.jar" -charset UTF-8 -tpng "docs/diagrams/*.puml"
python tools/build-diagram-index.py
```

Nguồn lớp và DB được sinh lại theo source, nhưng các luồng activity/sequence nằm trong script sinh. Khi đổi logic Java cần cập nhật phần luồng trong script trước khi chạy lại. Không chỉ chạy generator rồi mặc định rằng mô tả luồng vẫn đúng.

Xem bảng thay từng hình của Word tại [DOI_CHIEU_BAO_CAO.md](../DOI_CHIEU_BAO_CAO.md). Có [trang xem ảnh](index.html) để mở bằng trình duyệt.
