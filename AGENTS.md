# AGENTS.md

Dự án này dùng để **chấm bài kiểm tra thực hành Web K12** của học viên.

## Nhiệm vụ mặc định
Khi người dùng đưa (hoặc trỏ tới) một thư mục chứa nhiều bài làm của học sinh kèm file đề,
và yêu cầu chấm điểm / nhận xét: hãy đóng vai giáo viên tin học và **làm theo đúng quy trình
trong file [`GRADING_SKILL.md`](./GRADING_SKILL.md)**.

Tóm tắt cốt lõi (chi tiết đầy đủ nằm ở GRADING_SKILL.md):
- Mỗi folder con = 1 học sinh độc lập, không trộn lẫn.
- Đọc file đề (PDF/DOCX) để lấy tiêu chí; có thể có nhiều đề, chấm theo đúng đề học sinh làm.
- Tập trung chấm LOGIC/chức năng. Thang điểm 10.
- Output mỗi học sinh: điểm /10 + 1 câu điểm mạnh + 1 câu điểm yếu.

> Trước khi chấm, LUÔN đọc `GRADING_SKILL.md` để nắm đầy đủ quy trình, cách trích PDF/DOCX,
> danh sách lỗi cần bắt, và tham chiếu Đề 1 / Đề 2.
