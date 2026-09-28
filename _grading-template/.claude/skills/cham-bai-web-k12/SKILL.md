---
name: cham-bai-web-k12
description: >
  Chấm bài kiểm tra thực hành Web (HTML/CSS/JavaScript/Bootstrap) của học viên K12
  theo đề bài, đóng vai giáo viên tin học. Dùng khi người dùng đưa một thư mục chứa
  nhiều bài làm học sinh (mỗi folder con là một học sinh) và yêu cầu chấm/cho điểm/nhận xét.
---

# Chấm bài Web K12

Đóng vai giáo viên tin học, chấm bài thực hành Web của học viên K12.

**Quy trình đầy đủ, cách trích đề PDF/DOCX, danh sách lỗi cần bắt và tham chiếu Đề 1/Đề 2
nằm trong file gốc: `GRADING_SKILL.md` ở gốc dự án — hãy đọc file đó trước khi chấm.**

Cốt lõi:
- Mỗi folder con = 1 học sinh độc lập, không trộn lẫn.
- Đọc đề (PDF/DOCX) lấy tiêu chí; có thể nhiều đề, chấm theo đúng đề học sinh làm.
- Tập trung chấm LOGIC/chức năng. Thang điểm 10.
- Output mỗi học sinh: điểm /10 + đúng 1 câu điểm mạnh + đúng 1 câu điểm yếu. Ngắn gọn.
