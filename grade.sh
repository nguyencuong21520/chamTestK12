#!/usr/bin/env bash
# grade.sh — Khởi động phiên chấm bài Web K12.
#
# Chạy trong thư mục chứa bài làm (mỗi folder con = 1 học sinh) và (các) file đề PDF/DOCX.
#
# Cách dùng:
#   ./grade.sh                 # tự dùng CLI có sẵn (claude > codex), nếu không có thì in prompt
#   ./grade.sh --print         # chỉ in prompt ra màn hình để copy/dán vào IDE (Kiro/Cursor/Antigravity)
#   ./grade.sh --claude        # ép dùng Claude Code CLI
#   ./grade.sh --codex         # ép dùng Codex CLI
#
# Yêu cầu để trích đề: python3 + (pypdf cho PDF, python-docx cho DOCX) — script tự cài nếu thiếu.

set -euo pipefail
ROOT="$(pwd)"

PROMPT='Đóng vai giáo viên tin học. Hãy chấm toàn bộ bài làm của học sinh theo đúng quy trình trong file GRADING_SKILL.md.

Nhắc lại yêu cầu cốt lõi:
- Bài làm học sinh nằm trong thư mục bai-lam/ (mỗi folder con của bai-lam/ = 1 học sinh độc lập, KHÔNG trộn lẫn bài). File đề PDF/DOCX nằm ở gốc dự án.
- Đọc (các) file đề PDF/DOCX ở gốc để lấy tiêu chí. Có thể có nhiều đề — tự nhận diện mỗi học sinh làm đề nào và chấm theo đúng đề đó.
- Đọc cả file JS/CSS liên quan, tập trung chấm LOGIC/chức năng. Thang điểm 10.
- Với MỖI học sinh, in đúng định dạng:
  **<Tên học sinh> — <điểm>/10** (Đề <n>)
  - Điểm mạnh: <đúng 1 câu>.
  - Điểm yếu: <đúng 1 câu>.
- Cuối cùng, ghi 1 dòng lưu ý nếu có học sinh nộp nhầm đề / thiếu đề.'

MODE="auto"
case "${1:-}" in
  --print)  MODE="print" ;;
  --claude) MODE="claude" ;;
  --codex)  MODE="codex" ;;
  "" )      MODE="auto" ;;
  *) echo "Tham số không hợp lệ: $1" >&2; exit 1 ;;
esac

# Xác định nơi chứa bài làm: ưu tiên bai-lam/, nếu không có thì dùng gốc
if [[ -d "bai-lam" ]]; then
  STUDENTS_DIR="bai-lam"
else
  STUDENTS_DIR="."
fi

# Liệt kê nhanh học sinh + đề để giáo viên thấy trước
echo "=== Thư mục chấm bài: $ROOT ==="
echo "-- Đề tìm thấy --"
find . -maxdepth 1 -type f \( -iname "*.pdf" -o -iname "*.docx" \) ! -name '~$*' -print | sed 's|^\./||' || true
echo "-- Học sinh (mỗi folder = 1 em) trong: $STUDENTS_DIR --"
find "$STUDENTS_DIR" -maxdepth 1 -mindepth 1 -type d ! -name '.*' ! -name '_grading-template' -print | sed "s|^$STUDENTS_DIR/||;s|^\./||" | sort || true
echo "================================"

run_with() {
  local tool="$1"
  echo "Đang chấm bằng: $tool ..."
  case "$tool" in
    claude) claude -p "$PROMPT" ;;
    codex)  codex exec "$PROMPT" ;;
  esac
}

case "$MODE" in
  print)
    echo
    echo ">>> Copy đoạn prompt dưới đây dán vào Kiro / Cursor / Antigravity:"
    echo "-------------------------------------------------------------"
    printf '%s\n' "$PROMPT"
    echo "-------------------------------------------------------------"
    ;;
  claude) run_with claude ;;
  codex)  run_with codex ;;
  auto)
    if command -v claude >/dev/null 2>&1; then
      run_with claude
    elif command -v codex >/dev/null 2>&1; then
      run_with codex
    else
      echo "Không tìm thấy CLI (claude/codex). In prompt để bạn dán vào IDE:"
      echo "-------------------------------------------------------------"
      printf '%s\n' "$PROMPT"
      echo "-------------------------------------------------------------"
    fi
    ;;
esac
