"""Build the local diagram index after generate-diagrams.py and PlantUML rendering."""
import html
import re
from pathlib import Path

root = Path(__file__).resolve().parents[1] / 'docs/diagrams'
lines = ['# Bộ sơ đồ CineMan7', '',
    'Nguồn chuẩn: Java trong `src/main/java` và CSDL `sql/codeMySQL_CSDL.sql`. Không có SearchResultUI7 riêng. Các sơ đồ lớp 01–04 ẩn constructor và getter/setter/addTicket của model; xem Java cho toàn bộ accessor. Các trường trong hộp JSP là thành phần giao diện hoặc thuộc tính request, không phải field Java.', '',
    'Mở SVG để phóng to hoặc chèn vào Word; PNG dành cho phần mềm cần ảnh bitmap. Mỗi sơ đồ đều có nguồn PlantUML để sửa tiếp.', '',
    '| Sơ đồ | SVG | PNG | Nguồn |', '|---|---|---|---|']
cards=[]
for f in sorted(root.glob('*.puml')):
    title=re.search(r'^title (.*)$', f.read_text(encoding='utf8'), re.M).group(1)
    name=f.stem
    lines.append(f'| {title} | [SVG]({name}.svg) | [PNG]({name}.png) | [PlantUML]({name}.puml) |')
    cards.append(f'<section style="margin:32px 0;padding:20px;border:1px solid #cbd5e1;border-radius:16px;"><h2>{html.escape(title)}</h2><p><a href="{name}.svg">Mở SVG kích thước đầy đủ</a> | <a href="{name}.puml">Nguồn PlantUML</a></p><a href="{name}.svg"><img loading="lazy" src="{name}.svg" alt="{html.escape(title)}" style="display:block;max-width:100%;max-height:85vh;object-fit:contain;object-position:left;"></a></section>')
lines += ['', '## Tạo lại từ source', '', '```powershell', 'python tools/generate-diagrams.py',
    "mvn dependency:get '-Dartifact=net.sourceforge.plantuml:plantuml:1.2025.10'",
    'java -jar "$env:USERPROFILE/.m2/repository/net/sourceforge/plantuml/plantuml/1.2025.10/plantuml-1.2025.10.jar" -charset UTF-8 -tsvg "docs/diagrams/*.puml"',
    'java -jar "$env:USERPROFILE/.m2/repository/net/sourceforge/plantuml/plantuml/1.2025.10/plantuml-1.2025.10.jar" -charset UTF-8 -tpng "docs/diagrams/*.puml"',
    'python tools/build-diagram-index.py', '```', '',
    'Nguồn lớp và DB được sinh lại theo source, nhưng các luồng activity/sequence nằm trong script sinh. Khi đổi logic Java cần cập nhật phần luồng trong script trước khi chạy lại. Không chỉ chạy generator rồi mặc định rằng mô tả luồng vẫn đúng.', '',
    'Xem bảng thay từng hình của Word tại [DOI_CHIEU_BAO_CAO.md](../DOI_CHIEU_BAO_CAO.md). Có [trang xem ảnh](index.html) để mở bằng trình duyệt.']
(root/'README.md').write_text('\n'.join(lines)+'\n',encoding='utf8')
(root/'index.html').write_text('<!doctype html><html lang="vi"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Sơ đồ CineMan7</title><body style="font-family:Segoe UI,Arial,sans-serif;margin:24px;color:#0f172a"><h1>Bộ sơ đồ CineMan7</h1><p>Nhấn vào hình để mở SVG đầy đủ. Xem README.md để lấy nguồn và đối chiếu báo cáo.</p>'+''.join(cards)+'</body></html>',encoding='utf8')
