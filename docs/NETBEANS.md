# Chuyển CineMan7 sang Apache NetBeans

## 1. Cấu hình phù hợp với mã nguồn

Dự án đã là Maven Web Application (`packaging=war`). Mở trực tiếp thư mục chứa `pom.xml`; không cần tạo dự án Ant mới hoặc chép từng file Java/JSP. NetBeans nhận diện dự án Maven hiện có theo [tài liệu Maven của Apache NetBeans](https://netbeans.apache.org/wiki/main/wiki/MavenBestPractices/).

| Thành phần | Dùng cho dự án này |
|---|---|
| Java của dự án/Tomcat | JDK 21 trên máy hiện tại; Maven biên dịch với `release=11` |
| Web server | Apache Tomcat **9.x**, Servlet 4.0, JSP 2.3 |
| CSDL | MySQL; script mới nhất: `sql/codeMySQL_CSDL.sql` |
| Build | Maven, cấu hình tại `pom.xml` |
| Context path | `/CineMan7` |
| URL | `http://localhost:8080/CineMan7/` nếu Tomcat dùng cổng 8080 |

Code đang import `javax.servlet.*`. Tomcat 10 trở lên dùng `jakarta.*`, nên chọn Tomcat 9 khi giữ nguyên code này. [Hướng dẫn chuyển đổi của Apache Tomcat](https://tomcat.apache.org/migration-10.html) giải thích thay đổi namespace này.

JDK để khởi động chính NetBeans cần đáp ứng yêu cầu của phiên bản IDE bạn cài; có thể khác JDK dùng biên dịch dự án/chạy Tomcat ở bảng trên. Không cần đổi mức Java của mã nguồn chỉ vì IDE cần JDK mới hơn.

## 2. Chuẩn bị thư mục

1. Giữ toàn bộ thư mục `D:\ky 7 ptit\PTTKHTTT\CineMan7`, gồm `pom.xml`, `src`, `sql`, `docs`, `tools`, `run.ps1`.
2. File `.env` là cấu hình riêng của máy. Khi chuyển sang máy khác, chép `.env.example` thành `.env`, rồi sửa mật khẩu MySQL. Không đưa mật khẩu vào Java hoặc `pom.xml`.
3. `target` là kết quả build; Maven sẽ tạo lại. Không sửa Java/JSP trong `target`.
4. Đóng tiến trình Cargo/Tomcat đang dùng cổng 8080 trước khi chạy Tomcat của NetBeans.

Ánh xạ thư mục khi mở trong NetBeans:

| Thư mục thật | Mục thường hiển thị trong Projects |
|---|---|
| `src/main/java` | Source Packages |
| `src/main/webapp` | Web Pages |
| `src/main/webapp/WEB-INF/web.xml` | Configuration Files / Web Pages → WEB-INF |
| `src/test/java` | Test Packages |
| thư viện trong `pom.xml` | Dependencies |
| `sql`, `docs`, `tools` | xem ở tab Files nếu Projects không liệt kê |

## 3. Kiểm tra MySQL

Nếu CSDL `cineman7` hiện tại đã được tạo từ bản mới nhất và đang có dữ liệu cần giữ, dùng CSDL đó, không chạy lại toàn bộ script khởi tạo.

`sql/codeMySQL_CSDL.sql` **bắt đầu bằng `DROP DATABASE IF EXISTS cineman7`**. Chỉ chạy toàn bộ file khi chủ động dựng lại CSDL demo trên máy mới hoặc CSDL có thể xóa. Có thể dùng MySQL Workbench → Open SQL Script → chọn đúng file → Execute.

Kiểm tra trước khi chạy ứng dụng:

```sql
USE cineman7;
SHOW TABLES;
SHOW COLUMNS FROM tblInvoice7 LIKE 'invoiceCode';
SHOW TRIGGERS LIKE 'tblInvoice7';
SELECT username, fullName FROM tblUser7;
```

Tài khoản demo của script này:

| Vai trò | Tên đăng nhập | Mật khẩu |
|---|---|---|
| Quản lý | `quanly` | `Test@123` |
| Khách hàng | `chien`, `bich`, `an`, `linh` | `Test@123` |
| Bán hàng | `nv_sales1` | `Test@123` |

Tài khoản bán hàng đăng nhập được nhưng chưa có module bán vé riêng trong bản triển khai này. Tài khoản đăng ký từ web chỉ là khách hàng; không được tự chọn quyền quản lý.

## 4. Mở dự án

1. Mở NetBeans, bật hỗ trợ **Java Web and EE** nếu chưa có (Tools → Plugins; tên mục có thể khác theo phiên bản).
2. Vào File → Open Project (`Ctrl+Shift+O`).
3. Chọn thư mục `D:\ky 7 ptit\PTTKHTTT\CineMan7` có `pom.xml` → Open Project.
4. Chờ Maven tải Dependencies. Không thêm thủ công `servlet-api.jar`, JSTL, MySQL Connector hoặc BCrypt vào thư mục web.
5. Tools → Java Platforms: đăng ký JDK 21 đang có tại `C:\Program Files\Java\jdk-21.0.10` nếu IDE chưa nhận diện.
6. Trong Properties của dự án, chọn Java Platform tương ứng nếu mục này xuất hiện. Giữ `<maven.compiler.release>11</maven.compiler.release>` trong POM.

## 5. Đăng ký Tomcat trong NetBeans

1. Cài/giải nén Tomcat 9 ở thư mục riêng, ví dụ `D:\Servers\apache-tomcat-9`. Không đặt bản server dùng lâu dài trong `target`, vì Clean sẽ xóa thư mục này.
2. Trong NetBeans: Services (`Ctrl+5`) → Servers → Add Server → Apache Tomcat.
3. Chọn thư mục Tomcat Home vừa giải nén. Chọn JDK đã cấu hình nếu được hỏi.
4. Nếu IDE hỏi tài khoản triển khai, cấu hình tài khoản Tomcat có role `manager-script` theo hướng dẫn trong hộp thoại. Đây là tài khoản triển khai của server, khác tài khoản `quanly` của CineMan7.
5. Chuột phải dự án → Properties → Run: chọn Tomcat 9, context path `/CineMan7`, relative URL `/` nếu các trường này xuất hiện.

Các thao tác đăng ký server và chạy ứng dụng có trong [hướng dẫn Web Application của Apache NetBeans](https://netbeans.apache.org/tutorial/main/kb/docs/web/quickstart-webapps/). Giao diện cụ thể có thể khác giữa các phiên bản IDE.

## 6. Cấp cấu hình DB cho tiến trình Tomcat

`DAO7` đọc **biến môi trường của tiến trình**, sau đó mới đến Java system property `-D`. Java hiện không tự đọc file `.env`. Chỉ tạo `.env` rồi nhấn Run trong một NetBeans đang mở sẵn sẽ không đủ.

Cách dùng `.env` với NetBeans:

1. Sửa `.env` theo `.env.example`, ví dụ `DB_USER=root`, `DB_PASSWORD=mật_khẩu_MySQL_thật`; `DB_URL` có thể dùng giá trị mẫu.
2. Thoát hoàn toàn NetBeans và Tomcat do IDE đã khởi động.
3. Mở PowerShell tại thư mục dự án, chạy script đã chuẩn bị:

```powershell
.\tools\start-netbeans.ps1 -NetBeansPath 'D:\NetBeans\netbeans\bin\netbeans64.exe'
```

Thay đường dẫn ví dụ bằng đường dẫn `netbeans64.exe` thực tế. Script đọc `.env` vào môi trường của tiến trình rồi mở IDE. NetBeans và Tomcat khởi động từ IDE sẽ kế thừa các biến này. Sau khi IDE mở, thực hiện File → Open Project như bước 4.

Một cách khác là cấu hình Java Options **cho JVM của Tomcat** trong Services → Servers → Tomcat → Properties → Platform/Java Options, nếu phiên bản NetBeans có mục này:

```text
-DDB_USER=root
-DDB_PASSWORD=mat_khau_MySQL_thuc_te
-DDB_URL=jdbc:mysql://localhost:3306/cineman7?useSSL=false&allowPublicKeyRetrieval=true&characterEncoding=UTF-8&serverTimezone=Asia/Ho_Chi_Minh
```

Không đặt các giá trị trên vào Maven compiler options: DAO chạy trong JVM của Tomcat. Nếu máy đã có biến `DB_PASSWORD` cũ, biến môi trường được ưu tiên hơn `-D`; sửa hoặc bỏ biến cũ rồi khởi động lại IDE/server.

## 7. Build và Run

1. Chuột phải CineMan7 → Clean and Build. Các test phải qua; WAR được tạo tại `target/CineMan7.war`.
2. Chuột phải → Run (`F6` nếu dự án là main project). NetBeans sẽ khởi động server và triển khai ứng dụng.
3. Mở `http://localhost:8080/CineMan7/` (đổi cổng nếu server của bạn dùng cổng khác).
4. Mở `/login`, đăng nhập `quanly / Test@123`, kiểm tra trang Quản lý → Xem báo cáo thống kê → Khách hàng theo doanh thu.
5. Chọn **01/06/2025–30/06/2025** để thấy dữ liệu demo. Ngày mặc định là tháng hiện tại nên có thể không có giao dịch.
6. Đăng xuất, tạo tài khoản mới ở `/register`, đăng nhập rồi thử `/statOpen`: tài khoản khách hàng phải nhận thông báo không có quyền.

Khi chỉ muốn chạy bằng terminal, vẫn dùng được:

```powershell
.\run.ps1
```

Không chạy Cargo và Tomcat của NetBeans cùng cổng. Với cách terminal, `run.ps1` đã đọc `.env` và gọi Maven `clean package cargo:run`.

## 8. Lỗi thường gặp

| Hiện tượng | Cách kiểm tra |
|---|---|
| Không thấy Add Server / Apache Tomcat | Bật Java Web and EE; kiểm tra hỗ trợ Tomcat của bản IDE đang dùng |
| `javax.servlet` không tồn tại hoặc servlet không chạy | Dùng Tomcat 9 và Dependencies từ POM; không đổi sang Tomcat 10 chỉ trong IDE |
| `Chưa cấu hình ... DB_PASSWORD` | Khởi động lại NetBeans bằng script ở bước 6; kiểm tra đúng môi trường JVM của server |
| Lỗi kết nối MySQL | Kiểm tra MySQL đang chạy, cổng 3306, DB_USER/DB_PASSWORD/DB_URL và schema `cineman7`; xem server log |
| Access denied / public key retrieval | Kiểm tra tài khoản MySQL; dùng DB_URL mẫu có `allowPublicKeyRetrieval=true` cho môi trường local này |
| Cổng 8080 đã sử dụng | Dừng Cargo/server cũ hoặc đổi port của Tomcat trong NetBeans |
| URL 404 | Kiểm tra Deployment thành công và đúng context `/CineMan7`, không phải `/CineMan7-1.0` |
| Vẫn thấy giao diện cũ / `SearchResultUI7.jsp` | Stop server, Clean and Build, Deploy lại; không chạy WAR/exploded cũ |
| Thống kê rỗng | Chọn đúng khoảng demo 05–06/2025, không dùng các số liệu minh họa 08/2026 trong báo cáo cũ |
| Phim khác không có poster | Script có nhiều tên ảnh nhưng repo chỉ có ảnh Avengers; giao diện dùng ảnh thay thế khi thiếu |
| Đăng ký thành công nhưng chưa có thẻ | Đăng ký tài khoản tạo User + Customer; nghiệp vụ cấp thẻ thành viên chưa triển khai |

## 9. Những phần không cần chuyển đổi

Giữ nguyên package `controller`, `dao`, `daoimpl`, `model`, `filter`, `util`; giữ annotation `@WebServlet`, `@WebFilter`, web.xml, JSTL và cấu trúc Maven. Không cần đổi tên lớp, thêm hậu tố khác, tạo `build.xml`, đổi `javax` thành `jakarta`, hay thêm database vào thư mục source. Chuyển sang NetBeans chủ yếu là mở POM, đăng ký server và cấp cấu hình runtime.
