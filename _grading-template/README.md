# Bộ template "Chấm bài Web K12"

Gói cấu hình để bất kỳ công cụ AI nào (Kiro, Cursor, Codex, Claude Code, Antigravity)
cũng đóng vai giáo viên và chấm bài theo cùng một quy trình.

## Nội dung
```
GRADING_SKILL.md   ← file gốc: toàn bộ quy trình chấm (các file khác đều trỏ về đây)
AGENTS.md          ← Codex + Cursor đọc ở gốc dự án
CLAUDE.md          ← Claude Code đọc lúc khởi động
.cursor/rules/     ← Cursor rule (.mdc)
.agent/rules/      ← Google Antigravity
.claude/skills/    ← Claude Code skill (on-demand)
.kiro/skills/      ← Kiro skill (on-demand)
install.sh         ← copy toàn bộ cấu hình sang thư mục lớp mới
grade.sh           ← khởi động phiên chấm bài
```

## Dùng cho một lớp/khóa mới

1. Cài cấu hình vào thư mục bài làm của lớp đó:
   ```
   ./install.sh /duong/dan/toi/thu-muc-bai-lam-lop-moi
   ```
2. Bỏ (các) file đề (PDF/DOCX) và các folder bài làm (mỗi folder = 1 học sinh) vào thư mục đó.
3. Chấm:
   - **Trong IDE (Kiro/Cursor/Antigravity):** mở thư mục, gõ trong chat: `chấm bài giúp tôi`.
   - **Bằng dòng lệnh:** xem phần dưới.

## Câu lệnh chấm bài

Chạy trong thư mục chứa bài làm:

```
./grade.sh            # tự dùng CLI có sẵn (claude → codex); không có thì in prompt để dán vào IDE
./grade.sh --print    # chỉ in prompt để copy dán vào Kiro/Cursor/Antigravity
./grade.sh --claude   # ép dùng Claude Code CLI
./grade.sh --codex    # ép dùng Codex CLI
```

`grade.sh` sẽ liệt kê đề + danh sách học sinh tìm thấy, rồi gọi AI chấm theo `GRADING_SKILL.md`.

## Yêu cầu để đọc đề
- `python3`
- PDF: gói `pypdf` — `pip3 install pypdf`
- DOCX: gói `python-docx` — `pip3 install python-docx`

(Các agent sẽ tự cài khi cần; cài sẵn giúp nhanh hơn.)
