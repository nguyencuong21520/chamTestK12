#!/usr/bin/env bash
# Cài bộ cấu hình "Chấm bài Web K12" vào một thư mục lớp/khóa mới.
#
# Cách dùng:
#   ./install.sh /duong/dan/toi/thu-muc-bai-lam
#   ./install.sh .            # cài vào thư mục hiện tại
#
# Sau khi cài, thư mục đích sẽ có đủ file cho Kiro / Cursor / Codex / Claude / Antigravity.

set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${1:-}"

if [[ -z "$DEST" ]]; then
  echo "Thiếu thư mục đích." >&2
  echo "Cách dùng: ./install.sh /duong/dan/toi/thu-muc-bai-lam" >&2
  exit 1
fi

if [[ ! -d "$DEST" ]]; then
  echo "Thư mục đích không tồn tại: $DEST" >&2
  exit 1
fi

echo "Cài cấu hình chấm bài vào: $DEST"

# Tạo các thư mục cấu hình
mkdir -p "$DEST/.cursor/rules" \
         "$DEST/.agent/rules" \
         "$DEST/.claude/skills/cham-bai-web-k12" \
         "$DEST/.kiro/skills/cham-bai-web-k12"

# Copy file gốc + các điểm vào cho từng công cụ
cp "$SRC_DIR/GRADING_SKILL.md" "$DEST/"
cp "$SRC_DIR/AGENTS.md"        "$DEST/"
cp "$SRC_DIR/CLAUDE.md"        "$DEST/"
cp "$SRC_DIR/grade.sh"         "$DEST/" 2>/dev/null || true
cp "$SRC_DIR/.cursor/rules/cham-bai-web-k12.mdc"              "$DEST/.cursor/rules/"
cp "$SRC_DIR/.agent/rules/cham-bai-web-k12.md"               "$DEST/.agent/rules/"
cp "$SRC_DIR/.claude/skills/cham-bai-web-k12/SKILL.md"       "$DEST/.claude/skills/cham-bai-web-k12/"
cp "$SRC_DIR/.kiro/skills/cham-bai-web-k12/SKILL.md"         "$DEST/.kiro/skills/cham-bai-web-k12/"

chmod +x "$DEST/grade.sh" 2>/dev/null || true

echo "Xong. Thư mục '$DEST' đã sẵn sàng để chấm bài."
echo "Mở thư mục bằng công cụ AI của bạn và nói: \"chấm bài giúp tôi\"."
