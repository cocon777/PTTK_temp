# Đối chiếu báo cáo và mã nguồn CineMan7

Tài liệu này chỉ rõ các nội dung cần sửa trong `D:\ky 7 ptit\PTTKHTTT\17B22DCCN677.docx`. File Word gốc được giữ nguyên. Dùng mục/tiêu đề và mô tả hình bên dưới để định vị; số trang sẽ thay đổi sau khi thay hình.

CSDL chuẩn là **`sql/codeMySQL_CSDL.sql` trong dự án**, theo xác nhận của người dùng. Bản này đã có `tblInvoice7.invoiceCode`, `tblInvoiceCounter7` và trigger `trgInvoice7BeforeInsert`. Không áp dụng nhận xét thiếu cột của bản SQL cũ cho bản chuẩn này; chức năng tài khoản mới không cần thay đổi schema.

Giao diện giữ nội dung và các thao tác cũ, thu gọn tiêu đề/form để ưu tiên kết quả; tìm kiếm vẫn gộp form/kết quả. Không có banner, thẻ giới thiệu, nhãn đếm phim, nút Làm mới hay các khối chỉ số ngoài bảng. Header/footer, trang tài khoản và các trang còn lại dùng khung vừa viewport; khi kết quả dài, chỉ khung chứa bảng cuộn, không cuộn cả trang. Trong bảng, chữ/mã/ngày căn trái; TT, thời lượng, số vé, số tiền và phần trăm căn phải, cả tiêu đề cột và dòng tổng.

Các yêu cầu giao diện đã cập nhật: trang chủ dùng tiêu đề **CINEMAN** và câu “Khám phá điện ảnh, tận hưởng từng khoảnh khắc.”; kết quả tìm kiếm có tiêu đề “Kết quả tìm kiếm: cho từ khóa [từ khóa]”; tên khách trong thống kê là link xanh; chi tiết giao dịch thêm hạng thành viên cạnh họ tên. Chi tiết phim dùng thẻ `<table id="outMovieDetail">` thật, gồm poster, các trường thông tin, nút Mua vé, trailer và mô tả để khớp `outMovieDetail : Table` trong báo cáo.

## 1. Phạm vi triển khai cuối cùng

| Nghiệp vụ | Code hiện tại |
|---|---|
| Tìm tên phim, không bắt buộc đăng nhập | Đã có; form + kết quả cùng `SearchMovieUI7.jsp` |
| Xem chi tiết phim và mở trailer | Đã có; chỉ mở URL trailer http/https hợp lệ |
| Đăng ký **tài khoản khách hàng** | Mới bổ sung; tạo `tblUser7` + `tblCustomer7` trong một transaction |
| Đăng nhập / đăng xuất | Mới bổ sung; BCrypt, session, xác định vai trò từ bảng kế thừa |
| Thống kê khách hàng theo doanh thu, sắp xếp, xem giao dịch | Đã có; yêu cầu role `MANAGER` ở server |
| Đăng ký/cấp thẻ thành viên | Chưa triển khai; **khác** đăng ký tài khoản |
| Đổi mật khẩu, đặt/mua vé, chọn ghế, thanh toán | Chưa triển khai |
| Danh sách suất chiếu mở bán trên chi tiết phim | Chưa triển khai; chỉ có danh sách **định dạng** lấy từ các suất chiếu trong DB |
| Thống kê phim, thống kê doanh thu khác | Giữ danh sách menu cũ với các mục “Sắp có” và link placeholder; chưa có endpoint nghiệp vụ |

Có thể giữ yêu cầu tổng thể của đề tài trong phần mô tả hệ thống, nhưng cần ghi rõ phạm vi các module đã cài đặt. Không viết các chức năng chưa cài đặt như thể đã chạy được khi mô tả sản phẩm hoặc kịch bản kiểm thử.

## 2. Bảng các mục phải sửa trong Word

| Phần / mục hiện có | Nội dung sửa |
|---|---|
| THU THẬP YÊU CẦU → 1. Bảng từ khóa, 1.1–1.2 | Thêm “Đăng ký tài khoản / RegisterAccount7”; phân biệt với thành viên có MemberCard7. “Xem chi tiết” trong phạm vi cài đặt không có suất chiếu mở bán, giá vé, chọn mua |
| 2.1 Mục đích, 2.2 Phạm vi | Bổ sung tài khoản mới; nêu tìm phim công khai, thống kê chỉ MANAGER. Nếu giữ toàn bộ hệ thống dự kiến, thêm đoạn phân biệt phạm vi dự kiến và phần đã cài đặt |
| 2.3.1 Hoạt động tìm kiếm | Thay “hiện giao diện kết quả” bằng “cập nhật danh sách ngay dưới form trong SearchMovieUI7.jsp”; giữ từ khóa; cho phép tìm lại và quay lại từ chi tiết |
| 2.3.2 Hoạt động thống kê | Thêm tiền điều kiện đăng nhập và AuthFilter7; giữ thao tác nhấn dòng khách hàng mở chi tiết; khoảng ngày cho phép cùng ngày |
| Bổ sung 2.3.3–2.3.5 | Đăng ký tài khoản, đăng nhập, đăng xuất; dùng các kịch bản ở mục 4 tài liệu này |
| 2.4 Thông tin đối tượng | `User7.password` là mật khẩu đầu vào trong form, lưu **BCrypt hash** trong DB; không lưu hash trong session. Không có thuộc tính Java/DB `role` mới |
| 2.5 Quan hệ đối tượng | Giữ kế thừa User/Customer/Staff/Manager/SalesStaff; tài khoản web tạo Customer nhưng không tự tạo MemberCard; bảng bộ đếm hóa đơn là bảng kỹ thuật |
| 3.1 Use case tổng quan | Bổ sung RegisterAccount7; Login7/Logout7 là chung cho các vai trò; chỉ Manager có thống kê. Tách sơ đồ phạm vi đã triển khai khỏi sơ đồ toàn bộ yêu cầu nếu vẫn giữ các UC tương lai |
| 3.2 Use case chi tiết tìm phim | EnterKeyword7 và ViewSearchResult7 vẫn là các hành vi có thể giữ; chúng cùng một giao diện. Xóa giả định mỗi UC tương ứng một trang riêng |
| 3.3 Use case chi tiết thống kê | Login7 dùng chung, không có AuthServlet/DAO riêng mang tên ManagerLogin7. Nếu giữ ManagerLogin7 như chuyên biệt ở mức nghiệp vụ, giải thích nó được thực thi bởi chính Login7/AuthServlet7 với kết quả Manager7 |
| PHÂN TÍCH YÊU CẦU → 1.1 Kịch bản tìm phim | Thay bảng kịch bản, cả bước chính, ngoại lệ và hình chi tiết; bỏ bước chuyển sang SearchResultUI7, bỏ nút Mua vé hoạt động |
| 1.2 Kịch bản thống kê | Giữ một màn chọn ngày + kết quả; ngày hiển thị/gửi từ form là dd/MM/yyyy; lịch chọn native đồng bộ vào ô chữ. Kiểm tra JavaScript/server đưa lỗi vào outMessage, không bật tooltip validation |
| 2.1 Mô tả hệ thống một đoạn văn | Điều chỉnh những khẳng định về phần đã cài đặt: tài khoản, tìm phim gộp, không có đặt vé/suất chiếu mở bán trong màn chi tiết |
| 2.2–2.3 Trích danh từ/lớp | Các lớp tài khoản thực thể đã có. AuthServlet7, AuthFilter7, UserDAO7, UserDAOImpl7, PasswordUtil7 là lớp xử lý/hạ tầng; không thêm chúng vào thực thể nghiệp vụ |
| 2.3 Các lớp thống kê | `MovieStatistic7` và `RevenueStatistic7` hiện không tồn tại trong source. Nếu để trong mô hình nghiệp vụ dự kiến thì đánh dấu dự kiến; bỏ khỏi sơ đồ khẳng định phản ánh bản code đang chạy |
| 2.4–2.5 Quan hệ thực thể | Đối chiếu kiểu và chiều tham chiếu Java với sơ đồ 01; tham chiếu Java không biểu diễn mọi FK. Ví dụ MovieGenre7 Java chỉ chứa Genre7 vì được chứa trong Movie7.movieGenres; DB vẫn có cả 2 FK |
| 3.1 Trích biên/điều khiển tìm phim | Xóa lớp biên SearchResultUI7, chuyển outsubMovieList/outMessage sang SearchMovieUI7; bổ sung SearchMovieServlet7, MovieDetailServlet7, DAO. Không gán hàm truy vấn cho Movie7 khi mô tả thiết kế chạy thật |
| 3.2 Trích biên/điều khiển thống kê | Bổ sung kiểm tra AuthFilter7; các hàm thống kê thuộc DAO/Servlet đúng mục 5; CustomerStatistic7 chỉ chứa tiêu chí và dữ liệu |
| Bổ sung phần trích lớp tài khoản | Biên LoginUI7/RegisterUI7/header; điều khiển AuthServlet7; UserDAO7/UserDAOImpl7; AuthFilter7; PasswordUtil7 |
| 4.1 Phân tích hoạt động tìm phim | Thay trạng thái, kịch bản V2 và giao tiếp: mọi kết quả quay về SearchMovieUI7; không JSP gọi trực tiếp Movie7 để truy vấn |
| 4.2 Phân tích hoạt động thống kê | Thêm rào phân quyền; giữ hành vi click dòng khách hàng; cập nhật ngày, validation, trạng thái rỗng, các lời gọi DAO |
| THIẾT KẾ → 1 Sơ đồ lớp thực thể | Dùng lớp/kiểu từ sơ đồ 01. Invoice7 có invoiceCode; CustomerStatistic7 có startDate/endDate; User7/Staff7 abstract; kiểu tiền hiện là float trong Java |
| THIẾT KẾ → 2 Sơ đồ CSDL | Dựa đúng script mới, gồm 18 bảng; invoiceCode unique, bộ đếm, trigger; không thêm cột role/ bảng thống kê/bảng tài khoản khác |
| THIẾT KẾ CHI TIẾT → 1 Tìm phim | Thay ảnh màn hình, lớp thiết kế, mô tả trường; 3 JSP nghiệp vụ: CustomerMainUI7, SearchMovieUI7, MovieDetailUI7. Một JSP tìm kiếm có nhiều trạng thái; MovieDetailUI7 có outMovieDetail : Table, SearchMovieUI7 có outsubMovieList : Table và outMessage : String |
| THIẾT KẾ CHI TIẾT → 2 Thống kê | Thay 4 ảnh trang, bổ sung filter và token POST; dùng giao diện mới và class diagram 03 |
| Bổ sung thiết kế chi tiết Tài khoản | 2 trang mới, POST logout trên header; diagram 04, 10–13; session và vai trò theo mục 6 |
| THIẾT KẾ HOẠT ĐỘNG → 1 Tìm phim | Thay activity, kịch bản V3, sequence; GET /searchMovie, forward cùng JSP; detail truyền keyword để quay lại |
| THIẾT KẾ HOẠT ĐỘNG → 2 Thống kê | Thay activity/sequence và thêm filter; POST /statView có csrfToken; GET sort/show giữ kết quả session |
| Biểu đồ thiết kế gói cuối báo cáo | Bổ sung view.auth, filter, util; controller khai báo DAO interface nhưng khởi tạo DAOImpl; DAOImpl extends DAO7 |
| Các danh mục hình/bảng, phụ lục mã, hướng dẫn chạy, kết luận | Cập nhật số hình, tên trang, ảnh mới, module đã cài đặt, Maven/Tomcat/NetBeans, DB chuẩn; cập nhật mục lục tự động trong Word sau cùng |

## 3. Bảng thay từng hình đang nhúng trong báo cáo

Tên `imageN` bên dưới là tên ảnh nhúng bên trong DOCX, dùng để phân biệt các hình có caption trùng nhau; không phải số hình in trong Word. Nguồn `.puml`, ảnh `.svg` và `.png` tương ứng nằm tại `docs/diagrams`.

| Ảnh cũ / vị trí | Thay hoặc đối chiếu bằng |
|---|---|
| image1.png — Hình 1 use case tổng quan | `15-implemented-usecases` cho phạm vi đã cài đặt; nếu giữ toàn hệ thống, thêm RegisterAccount7 và chú thích UC tương lai |
| image2.png — Hình 2 UC chi tiết tìm phim | Giữ include nhập/xem kết quả và extend xem chi tiết; ghi chú chung SearchMovieUI7.jsp, tham khảo 15 |
| image3.png — Hình 3 UC thống kê | Login7 dùng chung, MANAGER là tiền điều kiện; tham khảo 15 |
| image4.png — lớp thực thể phân tích | `01-entity-classes`; bỏ/đánh dấu lớp thống kê dự kiến không tồn tại |
| image5.png — lớp phân tích tìm phim | `02-search-design`; rút gọn thuộc tính hạ tầng nếu cần nhưng giữ cùng các lớp và phân công xử lý |
| image6.png — lớp phân tích thống kê | `03-statistics-design`; bổ sung liên quan tài khoản theo 04 |
| image7.png — trạng thái tìm phim | `05-search-state`: danh sách là trạng thái của cùng SearchMovieUI7 |
| image8.png — giao tiếp tìm phim | `17-search-communication`, chi tiết theo 07 |
| image9.png — trạng thái thống kê | Luồng trong `08-statistics-activity`; thêm kiểm tra session/role và link quay lại |
| image10.png — giao tiếp thống kê | `18-statistics-communication`, chi tiết theo 09 |
| image11.png — lớp thực thể thiết kế | `01-entity-classes` |
| image12.png — CSDL | `16-database` + ràng buộc/trigger trong `sql/codeMySQL_CSDL.sql` |
| image13.png — ảnh giao diện tìm phim | screenshots `01-home`, `02-search-initial`, `03-search-results`, `04-movie-detail`; ảnh 02/03 là 2 trạng thái cùng một JSP |
| image14.jpeg — lớp thiết kế tìm phim | `02-search-design` |
| image15.png — ảnh giao diện thống kê | screenshots `07-manager-home` đến `10-customer-transactions` |
| image16.jpeg — lớp thiết kế thống kê | `03-statistics-design` |
| image17.png — hoạt động tìm phim | `06-search-activity` |
| image18.jpeg — tuần tự tìm phim | `07-search-sequence` |
| image19.png — hoạt động thống kê | `08-statistics-activity` |
| image20.jpeg — tuần tự thống kê | `09-statistics-sequence` |
| image21.png — gói hệ thống | `14-packages` |
| Hình mới cho tài khoản | `04-auth-design`, `10-register-sequence`, `11-login-sequence`, `12-logout-sequence`, `13-auth-activity`; screenshots 05/06 |

Với sơ đồ lớp/tuần tự lớn, ưu tiên chèn SVG để phóng to không vỡ. Dùng trang landscape hoặc chia một sơ đồ tuần tự thành các phần mở trang/tìm/xem chi tiết, giữ đúng các thông điệp và thứ tự; tránh thu nhỏ cả sơ đồ đến mức không đọc được. Có thể chỉnh `.puml` và xuất lại ảnh.

## 4. Kịch bản thay thế có thể đưa vào báo cáo

### 4.1 SearchMovie7

Actor: khách truy cập hoặc người dùng đã đăng nhập. Tiền điều kiện: không bắt buộc đăng nhập.

1. Tại `CustomerMainUI7.jsp`, người dùng chọn “Tìm thông tin phim”. Trình duyệt gửi `GET /searchMovie`.
2. `SearchMovieServlet7.doGet()` forward `SearchMovieUI7.jsp`. Trang gồm tiêu đề Tìm kiếm phim, ô Từ khóa, nút Tìm kiếm và Về trang chính; chưa có bảng khi chưa tìm.
3. Người dùng nhập tên hoặc một phần tên phim rồi nhấn Tìm kiếm. Form gửi `GET /searchMovie?keyword=...`.
4. Servlet trim từ khóa, kiểm tra độ dài 1–200 ký tự; gọi `MovieDAO7.getMoviesByKeyword(keyword)` do `MovieDAOImpl7` cài đặt.
5. DAO tìm tên chứa từ khóa, không phân biệt hoa/thường, lấy thể loại và định dạng. `%`, `_`, `!` được xử lý như ký tự literal trong LIKE. Kết quả sắp theo `releaseDate`, sau đó `id`.
6. Servlet đặt `keyword`, `searched`, `listMovie` và thông báo nếu cần vào request, forward **lại SearchMovieUI7.jsp**. Form giữ từ khóa; tiêu đề kết quả có “cho từ khóa [từ khóa]”; bảng bên dưới có TT, poster, tên phim, thể loại, thời lượng, định dạng, khởi chiếu. Bảng mang id outsubMovieList và cuộn trong khung riêng khi dài.
7. Người dùng nhấn tên phim. Link gửi `GET /movieDetail?idMovie=...&keyword=...`.
8. `MovieDetailServlet7` đóng gói id trong Movie7, gọi `getMovieDetail(Movie7)`, đặt `movie`, `keyword`, `trailerUrl` hợp lệ vào request rồi forward `MovieDetailUI7.jsp`.
9. Trang chi tiết dùng bảng `outMovieDetail`: cột poster bên trái, các dòng tên/đạo diễn/diễn viên/thể loại/khởi chiếu/thời lượng/ngôn ngữ/độ tuổi/định dạng bên phải, nút Mua vé, hàng trailer và mô tả. Nút Mua vé chỉ hiện alert thông báo ngoài phạm vi module như bản gốc, chưa có nghiệp vụ đặt vé. Nút Quay lại nằm ngoài vùng cuộn bảng.
10. Nhấn “Quay lại” gửi GET với từ khóa cũ, thực hiện lại truy vấn và hiển thị danh sách cùng form. Không thêm nút Làm mới hoặc khối nội dung giới thiệu.

Ngoại lệ: rỗng → “Vui lòng nhập từ khóa tìm kiếm”; dài hơn 200 → “Từ khóa tối đa 200 ký tự.”; không khớp → “Không tìm thấy phim phù hợp”, không có bảng cũ; id chi tiết sai/không có → redirect `/searchMovie`; thiếu poster → ảnh thay thế. Lỗi kết nối/SQL được xử lý như lỗi hệ thống, không coi là kết quả tìm kiếm hợp lệ.

### 4.2 StatisticCustomerByRevenue7

Tiền điều kiện: đăng nhập thành công, session có `currentUser` và `role=MANAGER`. AuthFilter7 bảo vệ cả URL servlet và JSP trong `/view/manager/`.

1. Manager mở trang quản lý → Xem báo cáo thống kê → Khách hàng theo doanh thu.
2. `GET /statOpen` gọi `openPage()`, xóa listStat/criteria/sortOrder cũ. Khoảng mặc định: đầu tháng đến hôm nay theo `Asia/Ho_Chi_Minh`.
3. `CustomerRevenueStatUI7.jsp` hiển thị hai ô chữ `dd/mm/yyyy`, có lịch chọn native đi kèm. Người dùng gõ/chọn ngày rồi POST `/statView` với startDate/endDate dạng `dd/MM/yyyy` và `csrfToken`.
4. JavaScript kiểm tra ngày có thật và `endDate >= startDate`, đưa chuỗi lỗi vào `div#outMessage`, cùng style với tìm kiếm. Server vẫn kiểm tra lại bằng `parseDate()` theo `dd/MM/uuuu` với ResolverStyle.STRICT; còn nhận ISO `yyyy-MM-dd` để tương thích request cũ. `viewStat()` gọi `getCustomerRevenueStat(criteria)` khi hợp lệ.
5. DAO tổng hợp theo khách hàng với khoảng nửa mở `[startDate 00:00, endDate+1 ngày 00:00)`, tính tổng vé, tổng doanh thu hóa đơn, hạng và tỷ trọng.
6. Kết quả giảm dần theo doanh thu; dòng vãng lai gộp các hóa đơn không gắn customer. Khi có dữ liệu nhưng không có giao dịch vãng lai, thêm dòng vãng lai bằng 0. Nếu hoàn toàn không có giao dịch, danh sách rỗng và Tổng cộng bằng 0. Không thêm khối tổng hợp số vé/doanh thu ngoài bảng.
7. Servlet lưu `listStat`, `criteria`, `sortOrder=desc` vào session; `showList()` tính tổng và forward cùng JSP. Tỷ trọng = doanh thu dòng / tổng doanh thu × 100; tổng bằng 0 thì tỷ trọng bằng 0.
8. Nhấn tiêu đề Tổng doanh thu gửi GET `/statSort`, đảo asc/desc, gọi `sortByRevenue(list,order)`; dòng vãng lai vẫn cuối danh sách, Tổng cộng do JSP hiển thị ở tfoot.
9. Tên khách hàng là link xanh; nhấn tên hoặc dòng khách có tài khoản gửi `/customerTransaction` kèm idCustomer, startDate, endDate, back=/statShow. Link vẫn dùng ngày ISO yyyy-MM-dd. Dòng vãng lai không mở chi tiết.
10. `readCustomerStat()` đóng gói tiêu chí; `getCustomerInfo()` lấy tên/mã và hạng qua LEFT JOIN MemberCard/MembershipTier; `getTransactionsByCustomer()` lấy hóa đơn kèm vé/suất/phim/phòng. Servlet tính tổng và forward `CustomerTransactionUI7.jsp`.
11. Thông tin đầu trang có mã KH, họ tên, **hạng thành viên** (hoặc “chưa là thành viên”), khoảng ngày. Bảng outTransactionList có TT, **Mã hóa đơn**, Ngày giờ, Phim, Suất chiếu, Số vé, Số tiền, Giảm giá. “Quay lại” → `/statShow` hiển thị lại kết quả session.

Ngoại lệ: chưa đăng nhập → `/login`; sai vai trò → 403; token POST sai → 403; ngày không hợp lệ → outMessage là chuỗi, giữ giá trị startInput/endInput đã nhập, không truy vấn; end < start → thông báo, giữ tiêu chí vừa nhập; cùng ngày hợp lệ. Trong URL chi tiết giao dịch, id khách sai/không tồn tại hoặc ngày thiếu/sai/đảo thứ tự → về trang chủ; không mở rộng ngầm sang toàn bộ lịch sử. Lỗi SQL/kết nối là lỗi hệ thống.

### 4.3 RegisterAccount7 — đăng ký tài khoản

Actor: khách chưa đăng nhập. Nhập username, họ tên, email, số điện thoại tùy chọn, ngày sinh, mật khẩu và xác nhận.

1. `GET /register` → AuthServlet7 → RegisterUI7.jsp với CSRF token.
2. POST `/register`; filter kiểm tra token; servlet kiểm tra dữ liệu. Username 3–50 ký tự ASCII chữ/số/_; họ tên 2–100; email hợp lệ tối đa 255; phone rỗng hoặc 9–14 số và có thể có +; ngày sinh hợp lệ và không tương lai; password ít nhất 8 ký tự, tối đa 72 byte UTF-8; xác nhận phải khớp.
3. `registerCustomer(Customer7)` băm BCrypt cost 12, bắt đầu transaction, insert User, lấy id, tạo mã `WEB` + id, insert Customer, commit; không tạo thẻ thành viên.
4. Thành công → redirect `/login?registered=1`, người dùng đăng nhập riêng. Không tự đăng nhập sau đăng ký.

Ngoại lệ: sai dữ liệu → giữ các trường không nhạy cảm, xóa mật khẩu và báo lỗi; trùng username/email → rollback, báo đã sử dụng; lỗi DB → thông báo chung, HTTP 503. Không được gửi role từ form để tạo quản lý.

### 4.4 Login7 — đăng nhập

1. GET `/login` hiển thị LoginUI7.jsp. Người dùng gửi username/password/token bằng POST.
2. AuthFilter7 kiểm tra CSRF. AuthServlet7 gọi `UserDAO7.authenticate`.
3. UserDAOImpl7 đọc User và bảng lớp con, kiểm tra BCrypt; trả Manager7, SalesStaff7 hoặc Customer7, không điền password/hash vào đối tượng trả về.
4. Servlet hủy session cũ, tạo session mới, lưu currentUser, role, csrfToken mới.
5. Manager tới afterLogin nội bộ do filter đặt hoặc ManagerMainUI7.jsp; Customer/SalesStaff về trang chủ.

Ngoại lệ: thông tin sai hoặc không có bảng vai trò tương ứng → thông báo tên/mật khẩu chưa đúng, ở lại LoginUI7.jsp; lỗi DB → HTTP 503; người đã đăng nhập mở `/login` hoặc `/register` qua servlet được chuyển về trang tương ứng.

### 4.5 Logout7 — đăng xuất

Header có form POST `/logout` chứa csrfToken. Token đúng → hủy toàn bộ session, gồm người dùng, role, token và dữ liệu thống kê; redirect `/login?loggedOut=1`. Truy cập báo cáo sau đó yêu cầu đăng nhập lại. GET `/logout` trả 405 và không đăng xuất; POST thiếu/sai token trả 403.

## 5. Phân công lớp và phương thức phải dùng đúng

| Lớp / interface | Trách nhiệm / chữ ký quan trọng |
|---|---|
| SearchMovieServlet7 | doGet(request,response), doPost(request,response); doPost chuyển cho doGet |
| MovieDetailServlet7 | doGet(request,response); đọc idMovie/keyword, kiểm tra trailer URL |
| MovieDAO7 | `List<Movie7> getMoviesByKeyword(String keyword)`; `Movie7 getMovieDetail(Movie7 movie)` |
| MovieDAOImpl7 | cài đặt MovieDAO7; `fillMovie(ResultSet,Movie7)`; `loadGenresAndFormats(Connection,Movie7)` private |
| CustomerRevenueStatServlet7 | doGet/doPost; openPage, viewStat, parseDate(String):LocalDate, sortStat, showList private |
| CustomerTransactionServlet7 | doGet; `readCustomerStat(HttpServletRequest)` private |
| CustomerStatisticDAO7 | `getCustomerRevenueStat(CustomerStatistic7)`; `getCustomerInfo(CustomerStatistic7)`; `sortByRevenue(List<CustomerStatistic7>,String)` |
| InvoiceDAO7 | `List<Invoice7> getTransactionsByCustomer(CustomerStatistic7 customerStat)` |
| AuthServlet7 | doGet/doPost/init; register, login, read, home private |
| UserDAO7 | `User7 authenticate(String,String) throws SQLException`; `void registerCustomer(Customer7) throws SQLException` |
| UserDAOImpl7 | implements UserDAO7, extends DAO7; transaction User+Customer và ánh xạ vai trò |
| AuthFilter7 | `doFilter(ServletRequest,ServletResponse,FilterChain)`; UTF-8, CSRF, bảo vệ manager, no-store |
| PasswordUtil7 | static isValid(String), hash(String), verify(String,String); không phải lớp thực thể |
| BaseServlet7 | abstract, extends HttpServlet; protected forward(request,response,page) |
| DAO7 | abstract; protected getConnection(), printSQLException(SQLException); private static read(key,defaultValue) |
| Movie7, CustomerStatistic7, Invoice7 | Chứa dữ liệu, constructor/getter/setter/addTicket; **không** thực hiện truy vấn hoặc sắp xếp |

Trong sơ đồ thiết kế, dependency từ Servlet đến interface DAO; DAOImpl implements interface và extends DAO7. `init()` vẫn gọi `new DAOImpl7()`. Không vẽ DAOImpl extends interface hoặc JSP truy vấn trực tiếp MySQL.

Trong phân tích nghiệp vụ có thể dùng tên hành vi trừu tượng, nhưng khi yêu cầu so khớp code 1:1 cần ánh xạ chúng sang lớp xử lý thật ở bảng trên. Những hàm `Movie7.getMoviesByKeyword`, `CustomerStatistic7.getCustomerRevenueStat`, `Invoice7.getTransactionsByCustomer` trong hình cũ không có trong Java hiện tại.

## 6. URL, request và session

| URL / method | Nhận vào | Kết quả |
|---|---|---|
| GET /searchMovie | keyword tùy chọn | forward SearchMovieUI7.jsp; request keyword,searched,listMovie,message theo trạng thái |
| POST /searchMovie | keyword,csrfToken | tương thích; cùng xử lý doGet; form mới dùng GET |
| GET /movieDetail | idMovie,keyword | request movie,keyword,trailerUrl; forward MovieDetailUI7.jsp |
| GET /login, /register | không bắt buộc | forward LoginUI7/RegisterUI7 |
| POST /login | username,password,csrfToken | xác thực, tạo session mới, redirect |
| POST /register | username,password,confirmPassword,fullName,email,phone,dob,csrfToken | tạo tài khoản, redirect login; lỗi forward lại register với form,message |
| POST /logout | csrfToken | invalidate session, redirect login |
| GET /statOpen | — | xóa kết quả cũ, criteria mặc định |
| POST /statView | startDate,endDate dạng dd/MM/yyyy (còn nhận ISO),csrfToken | truy vấn, lưu session, forward kết quả; startInput/endInput hiển thị dd/MM/yyyy |
| GET /statSort | — | đảo hướng sắp xếp danh sách session |
| GET /statShow | — | hiện lại danh sách session; nếu không có thì openPage |
| GET /customerTransaction | idCustomer,startDate,endDate,back | request customerStat,listInvoice,sumTickets,sumAmount,backUrl |

Session dùng `currentUser`, `role` (`MANAGER`/`CUSTOMER`/`SALES`), `csrfToken`, `afterLogin`; module thống kê thêm `listStat`, `criteria`, `sortOrder`. Session timeout 30 phút, cookie HttpOnly, tracking bằng cookie. Đăng nhập mới hủy session cũ; đăng xuất hủy toàn bộ. Trong sơ đồ tuần tự, request forward và response redirect phải phân biệt.

`/view/manager/*` được bảo vệ trực tiếp, không chỉ ẩn link trên header. `AuthFilter7` chạy cho REQUEST `/*`; mọi POST phải có token. Không thêm bước DAO vào filter; filter chỉ dùng session.

## 7. Dữ liệu minh họa và khác biệt đã có từ trước

Các ví dụ `avatar`, “Avatar 3”, ngày 08/2026, 120 vé và 25.900.000 trong báo cáo cũ không khớp script chuẩn hiện tại. Để chụp ảnh/kiểm chứng theo đúng seed:

- Tìm `avengers` → một phim **Avengers: Doomsday**, 155 phút, khởi chiếu 01/05/2025, Hành động + Khoa học viễn tưởng, định dạng 2D/3D.
- Chọn thống kê **01/06/2025–30/06/2025** → **11 vé, 1.407.500 VND**.
- Thứ tự giảm dần: KH0045 Trần Thị Bích — 3 vé / 423.000; KH0099 Phạm Thị Linh — 1 / 300.000; KH0012 Lê Văn Chiến — 3 / 289.000; KH0078 Nguyễn Văn An — 2 / 161.500; vãng lai — 2 / 234.000 (luôn ở cuối, không sắp theo doanh thu).
- Hạng trong seed: Chiến Kim cương, Bích Vàng, An Bạc, Linh Đồng. Tài khoản mới đăng ký không có MemberCard7.
- Bảng giao dịch hiện có cột Mã hóa đơn. Java `Invoice7` cũng có invoiceCode, không dùng id thay cho mã này.
- Tiền được lưu DECIMAL trong MySQL, nhưng Java hiện đọc vào `float`; nếu mô tả kiểu Java phải ghi đúng. Việc chuyển toàn bộ sang BigDecimal là một thay đổi riêng, chưa thực hiện.
- `Movie7.formats` tổng hợp các định dạng **đã có trong tblShowtime7**, không lọc “đang mở bán”. Không mô tả nó là danh sách lịch chiếu hiện hành.
- Hai ô ngày thống kê luôn hiển thị/gửi dd/MM/yyyy bằng input text; nút lịch gọi picker HTML native và chuyển ISO sang dd/MM/yyyy. Định dạng không phụ thuộc locale trình duyệt. Link chi tiết giao dịch vẫn dùng ISO. Không dùng Flatpickr/CDN.
- `outMessage : String` là nội dung thông báo, lấy từ request.message hoặc JavaScript gán textContent vào div#outMessage; không phải lớp thông báo mới. Cả tìm kiếm và thống kê dùng cùng alertStyle. `Table` trong sơ đồ tương ứng HTML table có id cùng tên: outMovieDetail, outsubMovieList, outsubCustomerRevenueList, outTransactionList.
- CSS đều đi vào thuộc tính `style` của HTML; các chuỗi style dùng chung được đặt bằng c:set trong head.jsp. Header thật được include trong body; footer ở cuối trang. Không còn Bootstrap/classes để phụ thuộc giao diện.

## 8. Kịch bản kiểm chứng để bổ sung vào phần kiểm thử

| Ca | Kết quả cần ghi nhận |
|---|---|
| Mở tìm phim lần đầu | Có form và trạng thái chưa tìm, chưa truy vấn DB |
| Tìm `avengers`, tìm lại, quay lại từ chi tiết | Form + kết quả cùng JSP; giữ keyword; không có nút Làm mới |
| Rỗng / khoảng trắng / >200 ký tự / không khớp | Thông báo đúng, không giữ bảng của từ khóa trước |
| Tìm `%`, `_`, chuỗi SQL | Tìm literal, không trả toàn bộ phim hoặc thực thi SQL |
| Từ khóa HTML/script | Hiển thị escape, không thực thi script |
| Chi tiết và quay lại | Hiển thị phim; quay lại bằng keyword cũ; id sai về tìm kiếm |
| Đăng ký hợp lệ | Tạo đúng User + Customer, mật khẩu BCrypt, không có thẻ, chuyển login |
| Trùng email/username | Không tạo bản ghi User mồ côi; báo lỗi |
| Ngày sinh tương lai / xác nhận sai / password quá 72 byte | Không đăng ký; không đưa mật khẩu trở lại HTML |
| Đăng nhập sai/đúng ba vai trò | Sai ở lại login; đúng chuyển trang theo vai trò; Sales không được báo cáo |
| Guest mở /statOpen hoặc JSP manager trực tiếp | Chuyển login |
| Customer mở /statOpen hoặc JSP manager trực tiếp | HTTP 403 |
| POST thiếu token / GET logout | 403 / 405; session không bị đăng xuất trái yêu cầu |
| Logout hợp lệ, vào lại báo cáo | Hủy session; yêu cầu đăng nhập |
| Ngày 2025-02-30 / end < start / cùng ngày | Chặn ngày sai / chặn đảo ngày / chấp nhận cùng ngày |
| Thống kê tháng 06/2025, sort hai chiều, mở KH, quay lại | Tổng đúng seed, vãng lai cuối, giữ tiêu chí/thứ tự từ session |
| Khoảng không có hóa đơn | Bảng rỗng, tổng 0, tỷ trọng 0% |
| Màn hình rộng và điện thoại 390px | Header/footer và các nút thao tác nằm trong viewport; bảng nhiều dòng/nội dung dài cuộn trong khung; không cuộn trang |

Ảnh thực tế dùng để thay hình nằm trong `docs/screenshots`. Kết quả kiểm thử kỹ thuật được ghi tại `KIEM_THU.md`.

## 9. Thứ tự sửa Word để tránh sót

1. Chốt phạm vi đã cài đặt; tách đăng ký tài khoản khỏi cấp thẻ thành viên.
2. Sửa yêu cầu tự nhiên, glossary, UC và bảng kịch bản trước.
3. Thay lớp biên SearchResult bằng SearchMovie, bổ sung các lớp tài khoản/hạ tầng.
4. Thay class/entity/DB diagrams, sau đó state/communication/activity/sequence theo bảng hình.
5. Thay ảnh màn hình và dữ liệu ví dụ bằng seed chuẩn, thêm tài khoản và kiểm thử.
6. Sửa toàn bộ đoạn V2/V3 để dùng đúng phương thức, GET/POST, forward/redirect, session/token; không chỉ đổi tên trên hình.
7. Tìm lại toàn văn các cụm `SearchResultUI7`, `Mua vé`, `suất chiếu đang mở bán`, `MovieStatistic7`, `RevenueStatistic7`, `ManagerLogin7`, `Flatpickr`, `Bootstrap`, `avatar`, `08/2026`, `25.900.000`; xử lý theo phạm vi và bảng trên.
8. Cập nhật mục lục, danh mục hình/bảng, tham chiếu chéo và số thứ tự sau cùng. Mở từng hình ở kích thước in để kiểm tra chữ.
