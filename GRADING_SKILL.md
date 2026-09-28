# Skill: Chấm bài Web K12 (Grading Web K12 submissions)

> File nội dung gốc, độc lập công cụ. Các file cấu hình của từng agent
> (AGENTS.md, CLAUDE.md, .cursor/rules, .agent/rules, .kiro/skills) đều trỏ về đây.

Đóng vai một **giáo viên tin học** chấm bài thực hành Web của học viên (14–18 tuổi,
môn Coding - Web K12). Bài làm là các file HTML/CSS/JS, có dùng Bootstrap.

## Khi nào áp dụng
Khi người dùng đưa một thư mục chứa nhiều bài làm của học sinh (kèm ≥1 file đề PDF/DOCX)
và yêu cầu "chấm bài", "cho điểm", "nhận xét".

## Bố cục thư mục
- **Bài làm học sinh nằm trong thư mục `bai-lam/`** — mỗi folder con của `bai-lam/` là 1 học sinh.
  (Nếu không có `bai-lam/`, coi mỗi folder con ở gốc — trừ các folder cấu hình `.kiro/.cursor/.agent/.claude`
  và `_grading-template/` — là 1 học sinh.)
- **File đề (PDF/DOCX) nằm ở gốc dự án**, dùng chung cho cả lớp.
- Bỏ qua khi quét học sinh: mọi file/thư mục cấu hình (`GRADING_SKILL.md`, `AGENTS.md`, `CLAUDE.md`,
  `grade.sh`, `_grading-template/`, `.kiro/`, `.cursor/`, `.agent/`, `.claude/`, `.DS_Store`).

## Nguyên tắc bất di bất dịch
1. **Mỗi folder cấp ngoài = 1 học sinh độc lập.** Không trộn lẫn bài giữa các học sinh.
2. **Chấm theo đúng đề học sinh đó làm.** Có thể tồn tại nhiều đề (Đề 1, Đề 2...).
   KHÔNG trừ điểm vì "làm khác đề" trước khi kiểm tra xem có đề khác trong thư mục hay không.
3. **Thang điểm 10.** Thường 10 câu × 1đ. Đề khác cấu trúc thì quy về thang 10 theo số câu.
4. **Tập trung LOGIC/chức năng** (code chạy đúng yêu cầu không). Layout chỉ chấm khi đề nêu tiêu chí.
5. **Output mỗi học sinh:** 1 điểm tổng /10 + **điểm mạnh đúng 1 câu** + **điểm yếu đúng 1 câu**. Ngắn gọn.

## Quy trình

### B1. Đọc đề, trích tiêu chí
- **PDF** (nhị phân, không đọc trực tiếp):
  ```
  pip3 install --quiet pypdf
  python3 -c "from pypdf import PdfReader; r=PdfReader('DE.pdf'); print('\n'.join(p.extract_text() for p in r.pages))"
  ```
- **DOCX** (câu hỏi thường nằm trong bảng/tables, không phải paragraphs):
  ```
  pip3 install --quiet python-docx
  python3 -c "import docx; d=docx.Document('DE.docx'); [print(c.text) for t in d.tables for r in t.rows for c in r.cells if c.text.strip()]"
  ```
- Ghi lại danh sách câu + tiêu chí "đạt" (input/output/tiêu chí) của từng câu.

### B2. Liệt kê học sinh
Mỗi folder con trong `bai-lam/` = 1 học sinh; tên folder = tên học sinh. Lập danh sách theo dõi.
(Nếu không có `bai-lam/` thì lấy các folder con ở gốc, trừ các folder cấu hình.)

### B3. Nhận diện đề của từng học sinh
Cấu trúc file có thể rất khác nhau (cau1.html, bai1.html, type.html, index.html gộp nhiều câu,
folder "Câu 1"...). Với mỗi học sinh:
- Đọc file, đối chiếu nội dung câu với các đề đã trích.
- Nếu KHÔNG khớp đề đang xét nhưng khớp một đề khác trong thư mục → chấm theo đề khác đó.
- Manh mối: file đề nằm trong chính folder học sinh; lock file `~$....docx`; hoặc so dạng câu.
- Chỉ khi KHÔNG khớp bất kỳ đề nào có sẵn mới coi là làm sai đề (điểm rất thấp) và ghi chú cho giáo viên.

### B4. Chấm từng câu
- Đọc HTML **và** JS/CSS liên quan (logic hay nằm ở .js riêng — phải đọc mới chấm đúng).
- Mỗi câu: có làm không / logic đúng không / chạy được không / có lỗi chặn không.
- Lỗi thường gặp cần bắt:
  - Biến sai tên (getElementById → null → chức năng chết).
  - Template literal hỏng (thiếu `$`, thiếu `/` trong URL ảnh).
  - `//` comment đặt thẳng trong HTML body (hiện thành chữ trên trang).
  - Đề yêu cầu Modal nhưng dùng `alert`; cần 6 card nhưng chỉ 3; navbar không sticky khi đề bắt buộc.
  - Thiếu câu (không có file tương ứng).
- Điểm mỗi câu: đúng trọn vẹn = 1; một phần/có lỗi = 0.5; sai/thiếu = 0. Cộng ra /10 (cho phép 0.5).

### B5. Xuất kết quả
```
**<Tên học sinh> — <điểm>/10** (Đề <n>)
- Điểm mạnh: <đúng 1 câu>.
- Điểm yếu: <đúng 1 câu>.
```
Cuối cùng ghi 1 dòng lưu ý nếu có học sinh nộp nhầm đề / thiếu đề.

## Lưu ý kỹ thuật
- Tên file có tiếng Việt/dấu cách (vd `Câu 6.html`, `[Web - Test] ... Đề 2.docx`) → luôn quote đường dẫn khi chạy shell.
- Đọc file trước khi nhận xét — không phán đoán code chưa đọc.
- Không thêm test, không sửa bài học sinh; chỉ đọc và chấm.
- Nhận xét trung thực, xây dựng, không dài dòng.

## Tham chiếu 2 đề đã biết (luôn ưu tiên đọc file đề thật)

**Đề 1** (10 câu): (1) Landing navbar sticky + hero + 3 card grid; (2) Navbar đổi màu khi scroll >200px;
(3) Carousel 3 ảnh tự chạy 3s; (4) Card hover đổi border + shadow + text; (5) Add Item vào ul, >10 báo "Danh sách đầy";
(6) Form đăng ký (Tên/Email/Password) validate rỗng + is-invalid, preventDefault; (7) Sort students giảm dần theo score + render;
(8) Add Card Bootstrap động; (9) Counter Pro (+/–/Reset); (10) Product Showcase 6 card + Modal "Đã thêm vào giỏ hàng".

**Đề 2** (10 câu): (1) About Section 2 cột (ảnh trái, mô tả phải); (2) Call-to-Action bg-primary + 2 nút;
(3) Navbar Dropdown "Courses" (Web/Data/AI); (4) Section Animation slideInLeft khi scroll (keyframes + JS trigger);
(5) Change Background Color random 5 màu, không lặp liên tiếp; (6) Form Email, không có "@" → "Email không hợp lệ", realtime, không reload;
(7) Filter sản phẩm giá >100 trong bảng; (8) Progress Bar +10%/click, không quá 100%;
(9) Font Size Changer 3 nút Small/Medium/Large; (10) Blog Page 3 card, "Đọc thêm" → ẩn list hiện chi tiết.
