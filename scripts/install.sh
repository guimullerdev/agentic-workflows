#!/usr/bin/env bash
# Symlink skills e agents deste repo para ~/.claude (padrão) ou <projeto>/.claude
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
TARGET="${1:-$HOME}"
DEST="$TARGET/.claude"
[ "$TARGET" = "$HOME" ] || DEST="$(cd "$TARGET" && pwd)/.claude"

mkdir -p "$DEST/skills" "$DEST/agents"

for dir in "$REPO"/skills/*/; do
  name="$(basename "$dir")"
  if [ -e "$DEST/skills/$name" ] && [ ! -L "$DEST/skills/$name" ]; then
    echo "skip skills/$name (já existe e não é symlink)"; continue
  fi
  ln -sfn "${dir%/}" "$DEST/skills/$name" && echo "skill  $name"
done

for f in "$REPO"/agents/*.md; do
  name="$(basename "$f")"
  if [ -e "$DEST/agents/$name" ] && [ ! -L "$DEST/agents/$name" ]; then
    echo "skip agents/$name (já existe e não é symlink)"; continue
  fi
  ln -sfn "$f" "$DEST/agents/$name" && echo "agent  $name"
done

# run-phase usa a tabela de modelos como referência
mkdir -p "$REPO/skills/run-phase/reference"
ln -sfn "$REPO/docs/best-practices/model-selection.md" "$REPO/skills/run-phase/reference/model-selection.md"

echo "Instalado em $DEST"
