r"""Generate editable PlantUML sources from the current CineMan7 implementation.
Run: python tools/generate-diagrams.py
Render: java -jar plantuml.jar -charset UTF-8 -tsvg docs/diagrams/*.puml
"""
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'docs/diagrams'
OUT.mkdir(parents=True, exist_ok=True)
HEADER = r'''@startuml
!pragma layout smetana
skinparam backgroundColor white
skinparam defaultFontName Arial
skinparam defaultFontSize 13
skinparam shadowing false
skinparam roundcorner 10
skinparam classAttributeIconSize 0
skinparam sequenceMessageAlign center
skinparam maxMessageSize 95
skinparam classBackgroundColor #F0F9FF
skinparam classBorderColor #0284C7
skinparam ArrowColor #475569
skinparam participantBackgroundColor #F0F9FF
skinparam participantBorderColor #0284C7
hide empty members
'''

def save(name, title, source):
    (OUT / (name + '.puml')).write_text(HEADER + 'title ' + title + '\n' + source + '\n@enduml\n', encoding='utf-8')

def java_class(package, name, methods=True):
    s=(ROOT / 'src/main/java' / package / (name + '.java')).read_text(encoding='utf-8')
    decl=re.search(r'public\s+(abstract\s+)?(?:final\s+)?(class|interface)\s+'+name+r'(?:\s+extends\s+(\w+))?(?:\s+implements\s+(\w+))?',s)
    abstract,kind,parent,interface=decl.groups()
    lines=[('abstract ' if abstract else '')+kind+' '+name+' {']
    for m in re.finditer(r'^    (private|protected|public)\s+(?:static\s+)?(?:final\s+)?([\w<>?, ]+)\s+(\w+)\s*(?:=[^;]*)?;',s,re.M):
        access,typ,field=m.groups();lines.append('  '+{'private':'-','protected':'#','public':'+'}[access]+field+' : '+typ.strip())
    if methods:
        for m in re.finditer(r'^    (?:(public|protected|private)\s+)?(?:static\s+)?(?:final\s+)?([\w<>]+)\s+(\w+)\s*\(([^)]*)\)\s*(?:throws[^\{;]+)?[\{;]',s,re.M):
            access,ret,method,args=m.groups()
            if method == name: continue  # Constructors have no return type; omit them from this view.
            if package=='model' and re.match(r'(get|set|add)',method):continue
            args=re.sub(r'\s+',' ',args.strip())
            lines.append('  '+{'private':'-','protected':'#','public':'+',None:'+'}[access]+method+'('+args+') : '+ret)
    lines.append('}')
    if parent:lines.append(parent+' <|-- '+name)
    if interface:lines.append(interface+' <|.. '+name)
    return '\n'.join(lines)

model_files=sorted((ROOT/'src/main/java/model').glob('*.java'))
entities='\n'.join(java_class('model',p.stem) for p in model_files)
relations=[]
names={p.stem for p in model_files}
for p in model_files:
    for typ,field in re.findall(r'^    private\s+(\w+(?:<\w+>)?)\s+(\w+)\s*(?:=[^;]*)?;',p.read_text(encoding='utf8'),re.M):
        target=typ[5:-1] if typ.startswith('List<') else typ
        if target in names:
            multiple='0..*' if typ.startswith('List<') else ('0..1' if field in ['memberCard','customer','salesStaff','promotion','seat'] else '1')
            relations.append(p.stem+' --> "'+multiple+'" '+target+' : '+field)
save('01-entity-classes','Lớp thực thể — thuộc tính đúng theo model Java',entities+'\n'+'\n'.join(relations)+r'''
note "Ẩn constructor, getter/setter và addTicket để dễ đọc.\nKhông có MovieStatistic7 hoặc RevenueStatistic7 trong mã hiện tại.\nformats là List<String> suy ra từ tblShowtime7; không phải cột tblMovie7.\nCác mũi tên thể hiện tham chiếu Java, không thay cho toàn bộ ràng buộc FK." as N
''')

save('02-search-design','Lớp thiết kế — tìm kiếm phim', '\n'.join([
java_class('controller','BaseServlet7'),java_class('controller','SearchMovieServlet7'),java_class('controller','MovieDetailServlet7'),
java_class('dao','MovieDAO7'),java_class('daoimpl','DAO7'),java_class('daoimpl','MovieDAOImpl7'),
java_class('model','Movie7'),java_class('model','MovieGenre7'),java_class('model','Genre7')])+r'''
class "CustomerMainUI7.jsp" as Home <<boundary>>
class "SearchMovieUI7.jsp" as Search <<boundary>> {
  keyword : String
  outsubMovieList : Table
  outMessage : String
}
class "MovieDetailUI7.jsp" as Detail <<boundary>> {
  outMovieDetail : Table
  outPoster : Image
  subBuyTicket : Button
  subTrailer : Link
  subBack : Link
  movie : Movie7 (request attribute)
}
Home --> SearchMovieServlet7 : GET /searchMovie
Search --> SearchMovieServlet7 : GET /searchMovie?keyword=...
Search --> MovieDetailServlet7 : GET /movieDetail?idMovie&keyword
SearchMovieServlet7 --> Search : forward (mọi trạng thái)
MovieDetailServlet7 --> Detail : forward
Detail --> SearchMovieServlet7 : GET /searchMovie?keyword=...
SearchMovieServlet7 --> MovieDAO7
MovieDetailServlet7 --> MovieDAO7
MovieDAO7 ..> Movie7
Movie7 --> "0..*" MovieGenre7 : movieGenres
MovieGenre7 --> Genre7 : genre
note "Các thành phần JSP là trường giao diện / thuộc tính request, không phải thuộc tính Java.\nTable tương ứng thẻ HTML table với id cùng tên. outMessage là chuỗi request.message\nđược render vào div#outMessage, không phải đối tượng thông báo riêng.\nKhông tồn tại SearchResultUI7.jsp; subBuyTicket chỉ hiện alert ngoài phạm vi module." as N
''')

save('03-statistics-design','Lớp thiết kế — thống kê khách hàng', '\n'.join([
java_class('controller','CustomerRevenueStatServlet7'),java_class('controller','CustomerTransactionServlet7'),
java_class('dao','CustomerStatisticDAO7'),java_class('dao','InvoiceDAO7'),
java_class('daoimpl','CustomerStatisticDAOImpl7'),java_class('daoimpl','InvoiceDAOImpl7'),
java_class('model','CustomerStatistic7'),java_class('model','Invoice7')])+r'''
class "ManagerMainUI7.jsp" as Home <<boundary>>
class "SelectStatisticUI7.jsp" as Select <<boundary>>
class "CustomerRevenueStatUI7.jsp" as Stat <<boundary>> {
  startDate : String (dd/MM/yyyy)
  endDate : String (dd/MM/yyyy)
  outMessage : String
  outsubCustomerRevenueList : Table
}
class "CustomerTransactionUI7.jsp" as Detail <<boundary>> {
  customerStat : CustomerStatistic7 (kèm memberCard.tier)
  outTransactionList : Table
}
class AuthFilter7 <<filter>>
Home --> Select
Select --> CustomerRevenueStatServlet7 : GET /statOpen
Stat --> CustomerRevenueStatServlet7 : POST /statView\nGET /statSort, /statShow
Stat --> CustomerTransactionServlet7 : GET /customerTransaction\nidCustomer,startDate,endDate,back
CustomerRevenueStatServlet7 --> Stat : forward
CustomerTransactionServlet7 --> Detail : forward
CustomerRevenueStatServlet7 --> CustomerStatisticDAO7
CustomerTransactionServlet7 --> CustomerStatisticDAO7
CustomerTransactionServlet7 --> InvoiceDAO7
CustomerStatisticDAO7 ..> CustomerStatistic7
InvoiceDAO7 ..> Invoice7
AuthFilter7 ..> Home : chỉ MANAGER
AuthFilter7 ..> CustomerRevenueStatServlet7 : chỉ MANAGER
AuthFilter7 ..> CustomerTransactionServlet7 : chỉ MANAGER
note "Các DAOImpl kế thừa DAO7; hai Servlet kế thừa BaseServlet7.\nCustomerStatistic7 kế thừa Customer7.\nTên khách là link màu xanh; nhấn dòng cũng mở chi tiết. Vãng lai không mở chi tiết.\nThông báo: request.message -> div#outMessage, cùng kiểu với màn tìm phim.\nForm hiển thị/gửi dd/MM/yyyy; link chi tiết vẫn gửi yyyy-MM-dd." as N
''')

save('04-auth-design','Lớp thiết kế — tài khoản và phân quyền', '\n'.join([
java_class('controller','AuthServlet7'),java_class('filter','AuthFilter7'),java_class('dao','UserDAO7'),
java_class('daoimpl','UserDAOImpl7'),java_class('util','PasswordUtil7')])+r'''
class "LoginUI7.jsp" as Login <<boundary>>
class "RegisterUI7.jsp" as Register <<boundary>>
class "header.jsp" as Header <<fragment>>
abstract class User7
abstract class Staff7
class Customer7
class Manager7
class SalesStaff7
User7 <|-- Customer7
User7 <|-- Staff7
Staff7 <|-- Manager7
Staff7 <|-- SalesStaff7
AuthFilter7 ..> AuthServlet7 : UTF-8, CSRF trước POST
Login --> AuthServlet7 : GET /login; POST username,password,csrfToken
Register --> AuthServlet7 : GET /register; POST thông tin,csrfToken
Header --> AuthServlet7 : POST /logout + csrfToken
AuthServlet7 --> UserDAO7
AuthServlet7 ..> PasswordUtil7 : isValid
UserDAOImpl7 ..> PasswordUtil7 : hash / verify
UserDAOImpl7 ..> Customer7 : tạo 2 bản ghi trong transaction
UserDAOImpl7 ..> User7 : authenticate trả lớp con theo bảng
note "Session: currentUser (không có hash), role, csrfToken, afterLogin.\nVai trò suy từ bảng kế thừa; không thêm cột role vào tblUser7.\nĐăng ký chỉ tạo Customer7; không tự cấp MemberCard7." as N
''')

save('05-search-state','Trạng thái giao diện — tìm kiếm đã gộp', r'''
[*] --> Home
state "CustomerMainUI7.jsp" as Home
state "SearchMovieUI7.jsp" as Search {
  state "Chưa tìm" as Initial
  state "Thông báo kiểm tra từ khóa" as Invalid
  state "Danh sách phim" as Results
  state "Không tìm thấy phim" as Empty
  [*] --> Initial
  Initial --> Invalid : tìm rỗng / quá 200 ký tự
  Initial --> Results : tìm hợp lệ, có phim
  Initial --> Empty : tìm hợp lệ, không có phim
  Invalid --> Results : tìm lại, có phim
  Invalid --> Empty : tìm lại, không có phim
  Empty --> Results : đổi từ khóa, có phim
  Results --> Results : tìm lại
  Results --> Empty : tìm lại, không có phim
  Results --> Invalid : từ khóa không hợp lệ
  Empty --> Invalid : từ khóa không hợp lệ
}
Home --> Search : GET /searchMovie
state "MovieDetailUI7.jsp" as Detail
Results --> Detail : GET /movieDetail?idMovie&keyword
Detail --> Results : Quay lại (GET keyword cũ)
Detail --> Search : mã phim không hợp lệ / không tồn tại
Search --> Home : Về trang chủ
''')

save('06-search-activity','Hoạt động — form và kết quả cùng SearchMovieUI7.jsp', r'''
|Khách hàng|
start
:Chọn Tìm thông tin phim;
|SearchMovieServlet7|
:GET /searchMovie;
:forward SearchMovieUI7.jsp (chưa tìm);
repeat
  |Khách hàng|
  :Nhập từ khóa, nhấn Tìm kiếm;
  |SearchMovieServlet7|
  :GET /searchMovie?keyword=...;\ntrim và kiểm tra 1..200 ký tự;
  if (Từ khóa hợp lệ?) then (không)
    :Đặt keyword, searched, message;\nforward cùng SearchMovieUI7.jsp;
  else (có)
    |MovieDAOImpl7|
    :getMoviesByKeyword(keyword);\nescape !, %, _ trong LIKE;\nfillMovie; loadGenresAndFormats;
    |SearchMovieServlet7|
    :Đặt keyword, searched, listMovie;\nmessage nếu không có phim;\nforward SearchMovieUI7.jsp;
  endif
  |Khách hàng|
repeat while (Tiếp tục tìm?) is (có) not (không)
if (Chọn một phim trong danh sách?) then (có)
  |MovieDetailServlet7|
  :GET /movieDetail?idMovie&keyword;
  :Đóng gói Movie7.id; gọi getMovieDetail;
  if (Có phim?) then (có)
    :Kiểm tra scheme http/https cho trailer;\nđặt movie, keyword, trailerUrl;\nforward MovieDetailUI7.jsp;
    |Khách hàng|
    :Xem chi tiết / trailer;\nQuay lại tìm kiếm với keyword cũ;
  else (không)
    :Redirect /searchMovie;
  endif
endif
stop
''')

save('07-search-sequence','Tuần tự thiết kế — tìm kiếm và xem chi tiết', r'''
actor Customer
boundary "CustomerMainUI7.jsp" as Home
boundary "SearchMovieUI7.jsp" as UI
control SearchMovieServlet7 as S
control MovieDetailServlet7 as D
participant "MovieDAOImpl7 : MovieDAO7" as DAO
entity Movie7 as M
database MySQL as DB
boundary "MovieDetailUI7.jsp" as Detail
Customer -> Home : Chọn Tìm thông tin phim
Home -> S : GET /searchMovie
S -> UI : forward (keyword chưa có)
UI --> Customer : form + trạng thái chưa tìm
Customer -> UI : nhập keyword, nhấn Tìm kiếm
UI -> S : GET /searchMovie?keyword=...
S -> S : trim; set keyword, searched
alt rỗng hoặc >200 ký tự
  S -> UI : message; forward cùng JSP
else hợp lệ
  S -> DAO : getMoviesByKeyword(keyword)
  DAO -> DB : SELECT LIKE ? ESCAPE '!'\nORDER BY releaseDate,id
  DB --> DAO : ResultSet
  loop từng phim
    DAO -> DAO : fillMovie(rs,movie)
    DAO -> M : set các thuộc tính
  end
  loop từng phim
    DAO -> DAO : loadGenresAndFormats(connection,movie)
    DAO -> DB : SELECT thể loại; SELECT DISTINCT format
    DB --> DAO : genres, formats
    DAO -> M : setMovieGenres; setFormats
  end
  DAO --> S : List<Movie7>
  S -> UI : set listMovie; message nếu rỗng; forward
end
UI --> Customer : cùng màn hình, giữ keyword
opt chọn một phim có trong danh sách
  Customer -> UI : nhấn tên phim
  UI -> D : GET /movieDetail?idMovie&keyword
  D -> M : new Movie7(); setId(idMovie)
  D -> DAO : getMovieDetail(selected)
  DAO -> DB : SELECT phim theo id
  DB --> DAO : ResultSet
  DAO -> DAO : fillMovie; loadGenresAndFormats
  DAO -> DB : SELECT genres / formats
  DB --> DAO : kết quả
  DAO --> D : Movie7 hoặc null
  alt không tìm thấy hoặc id sai định dạng
    D --> Customer : redirect /searchMovie
  else có phim
    D -> D : xác thực URL trailer http/https
    D -> Detail : movie,keyword,trailerUrl; forward
    Detail --> Customer : thông tin chi tiết
    Customer -> Detail : Quay lại
    Detail -> S : GET /searchMovie?keyword=...
    ref over S,DAO : Thực hiện lại tìm kiếm, trả về SearchMovieUI7.jsp
  end
end
''')

save('08-statistics-activity','Hoạt động — thống kê, phân quyền và giữ kết quả', r'''
start
:GET trang quản lý / endpoint thống kê;
if (Đã đăng nhập?) then (không)
  :AuthFilter7 lưu afterLogin;\nredirect /login;
  stop
elseif (role = MANAGER?) then (không)
  :HTTP 403; Error.jsp;
  stop
endif
:ManagerMainUI7.jsp -> SelectStatisticUI7.jsp;
:GET /statOpen -> openPage();\nxóa listStat, criteria, sortOrder khỏi session;\nngày đầu tháng -> hôm nay;
repeat
  :CustomerRevenueStatUI7.jsp hiển thị\nngày chọn và kết quả (nếu có);
  :Manager chọn thao tác;
  if (Xem thống kê?) then (có)
    :POST /statView + csrfToken;
    if (CSRF hợp lệ?) then (không)
      :HTTP 403;
      stop
    endif
    if (Ngày hợp lệ, end >= start?) then (không)
      :message; forward cùng JSP;\nkhông truy vấn thống kê;
    else (có)
:viewStat() -> parseDate(dd/MM/yyyy);\ngetCustomerRevenueStat(criteria);\ntruy vấn [start 00:00, end+1 00:00);\ngộp khách vãng lai, tính tỷ trọng;
      :session listStat, criteria, sortOrder=desc;\nshowList() tính tổng và forward cùng JSP;
    endif
  elseif (Sắp xếp doanh thu?) then (có)
    :GET /statSort -> sortStat();\nđảo asc/desc, sortByRevenue;\ngiữ khách vãng lai cuối danh sách;\nshowList();
  else (Xem giao dịch)
    :Nhấn dòng khách hàng có tài khoản;
    :GET /customerTransaction\n?idCustomer&startDate&endDate&back=/statShow;
    :readCustomerStat(); getCustomerInfo();\ngetTransactionsByCustomer(); tính tổng;
    :CustomerTransactionUI7.jsp;
    :Quay lại GET /statShow -> showList();
  endif
repeat while (Tiếp tục xem?) is (có) not (không)
stop
''')

save('09-statistics-sequence','Tuần tự thiết kế — thống kê và chi tiết giao dịch', r'''
actor Manager
participant AuthFilter7 as F
boundary "ManagerMainUI7.jsp" as H
boundary "SelectStatisticUI7.jsp" as Select
boundary "CustomerRevenueStatUI7.jsp" as UI
control CustomerRevenueStatServlet7 as S
participant "CustomerStatisticDAOImpl7 : CustomerStatisticDAO7" as DAO
collections HttpSession as Session
database MySQL as DB
control CustomerTransactionServlet7 as T
participant "InvoiceDAOImpl7 : InvoiceDAO7" as I
boundary "CustomerTransactionUI7.jsp" as Detail
note over F : Trước mỗi REQUEST đến trang / endpoint quản lý:\ncurrentUser tồn tại, role=MANAGER; mọi POST có csrfToken hợp lệ.
Manager -> H : mở trang quản lý (đã đăng nhập)
H -> Select : chọn Xem báo cáo thống kê
Manager -> Select : chọn Khách hàng theo doanh thu
Select -> F : GET /statOpen
F -> S : chain.doFilter
S -> S : openPage()
S -> Session : remove listStat, criteria, sortOrder
S -> UI : forward với criteria mặc định (Asia/Ho_Chi_Minh)
UI --> Manager : form ngày trên cùng trang
Manager -> UI : chọn ngày, nhấn Xem thống kê
UI -> F : POST /statView startDate,endDate (dd/MM/yyyy),csrfToken
F -> S : chain.doFilter
S -> S : doPost -> doGet -> viewStat(); parseDate()
alt ngày sai định dạng
  S -> S : message; openPage()
  S -> UI : forward, giữ startInput/endInput;\nmessage là String, không có danh sách
else end < start
  S -> UI : message + criteria; forward, không truy vấn
else khoảng hợp lệ (bao gồm cùng ngày)
  S -> DAO : getCustomerRevenueStat(criteria)
  DAO -> DB : tổng vé / doanh thu theo customer\n[start, end + 1 ngày)
  DB --> DAO : rows (cid null = vãng lai)
  DAO -> DAO : đóng gói CustomerStatistic7; tính tỷ trọng;\ngộp vãng lai cuối danh sách nếu có dữ liệu
  DAO --> S : List<CustomerStatistic7>
  S -> Session : listStat, criteria, sortOrder=desc
  S -> S : showList(); tính sumTickets, sumRevenue
  S -> UI : forward listStat, criteria, sortOrder, tổng
  UI --> Manager : kết quả và Tổng cộng
end
opt sắp xếp
  Manager -> UI : nhấn Tổng doanh thu
  UI -> F : GET /statSort
  F -> S : chain.doFilter
  S -> S : sortStat(); đảo hướng
  S -> Session : lấy listStat, sortOrder
  S -> DAO : sortByRevenue(list,order)
  DAO --> S : danh sách mới, vãng lai ở cuối
  S -> Session : cập nhật listStat, sortOrder
  S -> S : showList()
  S -> UI : forward cùng JSP
end
opt nhấn dòng khách hàng
  Manager -> UI : xem giao dịch khách có tài khoản
  UI -> F : GET /customerTransaction\nidCustomer,startDate,endDate,back=/statShow
  F -> T : chain.doFilter
  T -> T : readCustomerStat(request)
  T -> DAO : getCustomerInfo(customerStat)
  DAO -> DB : SELECT họ tên, mã KH, hạng thành viên theo id\nLEFT JOIN MemberCard + MembershipTier
  DB --> DAO : customer
  DAO --> T : CustomerStatistic7 hoặc null
  alt không có khách / id sai / ngày thiếu hoặc sai
    T --> Manager : redirect /
  else hợp lệ
    T -> I : getTransactionsByCustomer(customerStat)
    I -> DB : SELECT Invoice + Ticket + Showtime + Room + Movie
    DB --> I : ResultSet theo ngày, invoice, ticket
    I --> T : List<Invoice7> kèm tickets
    T -> T : tính sumTickets, sumAmount;\nchỉ chấp nhận back=/statShow, còn lại /statOpen
    T -> Detail : forward customerStat,listInvoice,tổng,backUrl
    Detail --> Manager : tên + hạng thành viên, giao dịch + Tổng cộng
    Manager -> Detail : Quay lại
    Detail -> F : GET /statShow
    F -> S : chain.doFilter
    S -> S : showList() từ session
    S -> UI : forward kết quả cũ
  end
end
''')

save('10-register-sequence','Tuần tự — đăng ký tài khoản khách hàng', r'''
actor Guest
participant AuthFilter7 as F
boundary "RegisterUI7.jsp" as UI
control AuthServlet7 as S
entity Customer7 as C
participant "UserDAOImpl7 : UserDAO7" as DAO
participant PasswordUtil7 as P
database MySQL as DB
Guest -> F : GET /register
F -> F : tạo session và csrfToken nếu chưa có
F -> S : doGet
S -> UI : forward
UI --> Guest : form + csrfToken
Guest -> UI : điền thông tin, nhấn Tạo tài khoản
UI -> F : POST /register + csrfToken
alt CSRF sai
  F --> Guest : HTTP 403
else CSRF đúng
  F -> S : doPost -> register
  S -> C : đóng gói thông tin từ form
  S -> P : isValid(password)
  P --> S : boolean
  S -> S : kiểm tra username, họ tên, email, phone,\nngày sinh không tương lai, xác nhận mật khẩu
  alt dữ liệu sai
    S -> C : setPassword(null)
    S -> UI : form (không mật khẩu), message; forward
  else hợp lệ
    S -> DAO : registerCustomer(customer)
    DAO -> P : hash(password) với BCrypt cost 12
    P --> DAO : hash
    DAO -> DB : BEGIN; INSERT tblUser7; lấy generated id
    DAO -> C : setId; setCustomerCode("WEB"+id)
    DAO -> DB : INSERT tblCustomer7
    alt trùng username / email hoặc lỗi SQL
      DAO -> DB : ROLLBACK
      DAO --> S : SQLException
      S -> UI : message; giữ thông tin không chứa mật khẩu
    else thành công
      DAO -> DB : COMMIT
      DAO -> C : setPassword(null)
      DAO --> S : void
      S --> Guest : redirect /login?registered=1
    end
  end
end
note over DAO,DB : Không INSERT MemberCard7 / MembershipTier7.\nĐăng ký tài khoản khác với đăng ký thẻ thành viên.
''')

save('11-login-sequence','Tuần tự — đăng nhập và xác định vai trò', r'''
actor User
participant AuthFilter7 as F
boundary "LoginUI7.jsp" as UI
control AuthServlet7 as S
participant "UserDAOImpl7 : UserDAO7" as DAO
participant PasswordUtil7 as P
database MySQL as DB
collections HttpSession as Session
User -> F : GET /login
F -> F : tạo csrfToken nếu chưa có
F -> S : doGet
S -> UI : forward nếu chưa đăng nhập
UI --> User : form
User -> UI : nhập username,password
UI -> F : POST /login + csrfToken
alt CSRF sai
  F --> User : HTTP 403
else hợp lệ
  F -> S : doPost -> login
  S -> DAO : authenticate(username,password)
  DAO -> DB : SELECT User LEFT JOIN Customer, Staff, Manager, SalesStaff
  DB --> DAO : dòng user hoặc rỗng
  DAO -> P : verify(password,storedHash) nếu có user
  P --> DAO : boolean
  alt sai tài khoản / sai mật khẩu / thiếu vai trò
    DAO --> S : null
    S -> UI : message; forward
  else thành công
    DAO -> DAO : tạo Manager7 / SalesStaff7 / Customer7;\nđóng gói không có password/hash
    DAO --> S : User7 (lớp con)
    S -> Session : đọc afterLogin; invalidate session cũ
    S -> Session : tạo session mới; currentUser,role,csrfToken mới
    alt Manager7
      S --> User : redirect afterLogin nội bộ hoặc ManagerMainUI7.jsp
    else Customer7 / SalesStaff7
      S --> User : redirect /
    end
  end
end
note over S,Session : Đăng nhập lại khi đã có currentUser: redirect về trang tương ứng.\nLỗi SQL/kết nối: HTTP 503 và thông báo chung, không lộ chi tiết CSDL.
''')

save('12-logout-sequence','Tuần tự — đăng xuất và bảo vệ báo cáo', r'''
actor User
boundary "header.jsp" as Header
participant AuthFilter7 as F
control AuthServlet7 as S
collections HttpSession as Session
User -> Header : nhấn Đăng xuất
Header -> F : POST /logout + csrfToken
alt CSRF sai
  F --> User : HTTP 403, session giữ nguyên
else CSRF đúng
  F -> S : doPost
  S -> Session : invalidate() toàn bộ session\n(user, role, tiêu chí, danh sách, token)
  S --> User : redirect /login?loggedOut=1
end
User -> F : GET /statOpen hoặc /view/manager/*.jsp
F -> Session : kiểm tra currentUser
alt chưa đăng nhập
  F -> Session : lưu afterLogin = ManagerMainUI7.jsp
  F --> User : redirect /login
else đã đăng nhập nhưng role khác MANAGER
  F --> User : HTTP 403
else MANAGER
  F --> User : cho phép xử lý tiếp
end
note over F,S : GET /logout trả HTTP 405; không đăng xuất bằng GET.\nTrang quản lý / tài khoản dùng Cache-Control: no-store.
''')

save('13-auth-activity','Hoạt động — đăng ký, đăng nhập, đăng xuất', r'''
start
:Người dùng mở CineMan7;
if (Chọn Đăng ký?) then (có)
  :GET /register; hiển thị RegisterUI7.jsp;
  :Nhập thông tin; POST /register + csrfToken;
  if (CSRF và dữ liệu hợp lệ?) then (không)
    :403 nếu CSRF sai;\nhoặc giữ form và báo lỗi nhập liệu;
    stop
  endif
  :BCrypt hash; BEGIN;\nINSERT User + Customer;
  if (Trùng username/email hoặc lỗi SQL?) then (có)
    :ROLLBACK; báo lỗi;
    stop
  else (không)
    :COMMIT; redirect /login?registered=1;
  endif
endif
:GET /login; nhập username/password;\nPOST /login + csrfToken;
if (CSRF hợp lệ?) then (không)
  :HTTP 403;
  stop
endif
:SELECT user và các bảng vai trò; BCrypt verify;
if (Thông tin đúng, có vai trò?) then (không)
  :Thông báo đăng nhập chưa đúng; giữ LoginUI7.jsp;
  stop
endif
:Hủy session cũ; tạo session mới;\nlưu currentUser không có password, role, csrfToken;
if (MANAGER?) then (có)
  :Trang quản lý; được mở thống kê;
else (không)
  :Trang chủ; truy cập thống kê bị 403;
endif
:Nhấn Đăng xuất; POST /logout + csrfToken;
if (CSRF hợp lệ?) then (có)
  :invalidate session; redirect /login?loggedOut=1;
else (không)
  :HTTP 403; giữ session;
endif
stop
''')

save('14-packages','Thiết kế gói — đúng cấu trúc thư mục', r'''
package view {
  package customer
  package manager
  package auth
  artifact "head.jsp / header.jsp / footer.jsp" as Shared
}
package controller
package filter
package dao
package daoimpl
package model
package util
database "MySQL cineman7" as DB
view --> controller : URL form / link
controller --> view : forward
filter ..> controller : chain + kiểm tra session/CSRF
controller --> dao : khai báo biến bằng interface
controller ..> daoimpl : khởi tạo DAOImpl trong init()
controller --> model
controller ..> util : PasswordUtil7.isValid
dao ..> model : tham số / kiểu trả về
daoimpl ..|> dao : implements
daoimpl --> model
daoimpl --> util : hash / verify
daoimpl --> DB : JDBC / PreparedStatement
customer ..> Shared
manager ..> Shared
auth ..> Shared
''')

save('15-implemented-usecases','Use case — phạm vi đã cài đặt', r'''
left to right direction
actor "Khách truy cập" as Guest
actor "Người dùng có tài khoản" as User
actor "Khách hàng" as Customer
actor "Nhân viên bán hàng" as Sales
actor "Nhân viên quản lý" as Manager
User <|-- Customer
User <|-- Sales
User <|-- Manager
rectangle CineMan7 {
  usecase RegisterAccount7
  usecase Login7
  usecase Logout7
  usecase SearchMovie7
  usecase EnterKeyword7
  usecase ViewSearchResult7
  usecase ViewMovieDetail7
  usecase ViewStatistics7
  usecase StatisticCustomerByRevenue7
  usecase ViewCustomerTransactionDetail7
}
Guest --> RegisterAccount7
Guest --> SearchMovie7
User --> Login7
User --> Logout7
User --> SearchMovie7
SearchMovie7 .> EnterKeyword7 : <<include>>
SearchMovie7 .> ViewSearchResult7 : <<include>>
ViewMovieDetail7 .> ViewSearchResult7 : <<extend>>
Manager --> ViewStatistics7
StatisticCustomerByRevenue7 .> ViewStatistics7 : <<extend>>
ViewCustomerTransactionDetail7 .> StatisticCustomerByRevenue7 : <<extend>>
note bottom of ViewSearchResult7 : EnterKeyword7 và ViewSearchResult7\ncùng SearchMovieUI7.jsp.
note bottom of RegisterAccount7 : Chỉ tạo tài khoản; không phải RegisterMember7.
note bottom of StatisticCustomerByRevenue7 : Tiền điều kiện: session currentUser và role MANAGER.\nLogin7 dùng chung, không có servlet ManagerLogin7 riêng.
''')

schema=(ROOT/'sql/codeMySQL_CSDL.sql').read_text(encoding='utf8')
er=[];fk=[]
for table,body in re.findall(r'CREATE TABLE (\w+)\s*\((.*?)\n\);',schema,re.S):
    er.append('entity '+table+' {')
    for line in body.splitlines():
        line=line.strip()
        m=re.match(r'(`?\w+`?)\s+(INT|VARCHAR\(\d+\)|DATE(?:TIME)?|TEXT|DECIMAL\(\d+,\d+\)|ENUM\([^)]*\))\s*(.*)',line,re.I)
        if m:
            name,typ,rest=m.groups();er.append('  '+('* ' if 'NOT NULL' in rest or 'PRIMARY KEY' in rest else '')+name+' : '+typ+(' <<PK>>' if 'PRIMARY KEY' in rest else '')+(' <<UNIQUE>>' if 'UNIQUE' in rest else ''))
    er.append('}')
    for col,parent,key in re.findall(r'FOREIGN KEY \((\w+)\) REFERENCES (\w+)\((\w+)\)',body):
        nullable=bool(re.search(r'\b'+col+r'\s+INT\s+(?:NULL|,)',body))
        unique=(col=='tblUser7id' or bool(re.search(r'\b'+col+r'\s+INT[^\n]*UNIQUE',body)))
        fk.append(parent+' "'+('0..1' if nullable else '1')+'" -- "'+('0..1' if unique else '0..*')+'" '+table+' : '+col)
save('16-database','CSDL — bảng và khóa ngoại từ script SQL','\n'.join(er+fk)+r'''
note "tblInvoiceCounter7 là bảng kỹ thuật của trigger cấp invoiceCode.\nKhông có User7.role trong CSDL.\nKhông có bảng thống kê: CustomerStatistic7 được tổng hợp khi truy vấn.\nXem codeMySQL_CSDL.sql cho đầy đủ CHECK, UNIQUE ghép, DEFAULT và trigger." as N
''')

save('17-search-communication','Giao tiếp — tìm kiếm theo cấu trúc MVC hiện tại', r'''
allowmixing
left to right direction
actor Customer
object "CustomerMainUI7.jsp" as H
object "SearchMovieUI7.jsp" as UI
object "SearchMovieServlet7" as S
object "MovieDAOImpl7 : MovieDAO7" as DAO
object "Movie7" as M
object "MovieDetailServlet7" as D
object "MovieDetailUI7.jsp" as Detail
Customer --> H : 1. Chọn tìm phim
H --> S : 2. GET /searchMovie
S --> UI : 3. forward ban đầu\n8. forward kết quả / message
Customer --> UI : 4. Nhập keyword\n9. Chọn phim
UI --> S : 5. GET keyword
S --> DAO : 6. getMoviesByKeyword
DAO --> M : 7. fillMovie; genres/formats
UI --> D : 10. GET idMovie,keyword
D --> DAO : 11. getMovieDetail
DAO --> M : 12. fillMovie; genres/formats
D --> Detail : 13. forward movie,keyword,trailerUrl
Detail --> Customer : 14. Xem chi tiết
Detail --> S : 15. Trở lại: GET keyword cũ
note "Trình bày các thông điệp chính; alt/loop và lỗi xem biểu đồ tuần tự 07.\nKhông có lời gọi từ JSP vào DAO hoặc nghiệp vụ từ model." as N
''')

save('18-statistics-communication','Giao tiếp — thống kê theo cấu trúc MVC hiện tại', r'''
allowmixing
left to right direction
actor Manager
object "ManagerMainUI7.jsp" as H
object "SelectStatisticUI7.jsp" as Select
object "CustomerRevenueStatUI7.jsp" as UI
object "CustomerRevenueStatServlet7" as S
object "CustomerStatisticDAOImpl7" as DAO
object "CustomerTransactionServlet7" as T
object "InvoiceDAOImpl7" as I
object "CustomerTransactionUI7.jsp" as Detail
Manager --> H : 1. Chọn báo cáo
H --> Select : 2. Mở chọn loại
Select --> S : 3. GET /statOpen
S --> UI : 4. forward ngày mặc định\n8. forward kết quả\n11. forward đã sắp xếp
Manager --> UI : 5. Chọn ngày\n9. Sắp xếp\n12. Chọn khách
UI --> S : 6. POST /statView + CSRF\n10. GET /statSort\n17. GET /statShow khi quay lại
S --> DAO : 7. getCustomerRevenueStat\n10.1. sortByRevenue
UI --> T : 13. GET idCustomer,startDate,endDate,back
T --> DAO : 14. getCustomerInfo
T --> I : 15. getTransactionsByCustomer
T --> Detail : 16. forward chi tiết + tổng
Detail --> S : 17. Trở lại /statShow
note "AuthFilter7 kiểm tra MANAGER trước từng request quản lý;\nPOST phải có csrfToken. Chi tiết đầy đủ xem sơ đồ 09." as N
''')

print('Generated', len(list(OUT.glob('*.puml'))), 'diagram sources in', OUT)
