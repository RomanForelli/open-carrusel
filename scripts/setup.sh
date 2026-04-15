#!/usr/bin/env bash
set -e

echo "🎠 Setting up Open Carrusel..."
echo ""

# 1. Install dependencies
echo "📦 Installing dependencies (this may take a moment — Puppeteer downloads Chromium ~300MB)..."
npm install
echo ""

# 2. Create data directories
echo "📁 Creating data directories..."
mkdir -p data
mkdir -p public/uploads

# Initialize data files if they don't exist
for file in brand.json carousels.json templates.json staged-actions.json style-presets.json; do
  filepath="data/$file"
  if [ ! -f "$filepath" ]; then
    case "$file" in
      brand.json)
        echo '{"name":"","colors":{"primary":"#1a1a2e","secondary":"#16213e","accent":"#e94560","background":"#ffffff","surface":"#f5f5f5"},"fonts":{"heading":"Inter","body":"Inter"},"customFonts":[],"logoPath":null,"styleKeywords":[],"createdAt":"","updatedAt":""}' > "$filepath"
        ;;
      carousels.json)
        echo '{"carousels":[]}' > "$filepath"
        ;;
      templates.json)
        echo '{"templates":[]}' > "$filepath"
        ;;
      staged-actions.json)
        echo '{"actions":[]}' > "$filepath"
        ;;
      style-presets.json)
        echo '{"presets":[]}' > "$filepath"
        ;;
    esac
    echo "  Created $filepath"
  fi
done
mkdir -p data/exports
mkdir -p data/.font-cache
echo ""

# 3. Detect Claude CLI
echo "🔍 Looking for Claude CLI..."
CLAUDE_FOUND=""

if [ -n "$CLAUDE_CLI_PATH" ] && [ -f "$CLAUDE_CLI_PATH" ]; then
  CLAUDE_FOUND="$CLAUDE_CLI_PATH"
elif command -v claude &> /dev/null; then
  CLAUDE_FOUND="$(command -v claude)"
elif [ -f "$HOME/.local/bin/claude" ]; then
  CLAUDE_FOUND="$HOME/.local/bin/claude"
elif [ -f "/usr/local/bin/claude" ]; then
  CLAUDE_FOUND="/usr/local/bin/claude"
elif [ -f "/opt/homebrew/bin/claude" ]; then
  CLAUDE_FOUND="/opt/homebrew/bin/claude"
fi

if [ -n "$CLAUDE_FOUND" ]; then
  echo "  ✅ Found Claude CLI at: $CLAUDE_FOUND"
  # Write to .env.local
  if [ -f .env.local ]; then
    # Remove existing CLAUDE_CLI_PATH line if present
    grep -v "^CLAUDE_CLI_PATH=" .env.local > .env.local.tmp 2>/dev/null || true
    mv .env.local.tmp .env.local
  fi
  echo "CLAUDE_CLI_PATH=$CLAUDE_FOUND" >> .env.local
else
  echo "  ⚠️  Claude CLI not found."
  echo "  The app will run without AI features."
  echo "  To enable AI: install Claude CLI from https://docs.anthropic.com/en/docs/claude-code"
  echo "  Then set CLAUDE_CLI_PATH in .env.local"
fi
echo ""

# 4. Start dev server (skipped when called from /start, which manages the server itself)
if [ -z "$OC_SETUP_NO_DEV" ]; then
  echo "🚀 Starting Open Carrusel..."
  echo "  Open http://localhost:3000 in your browser"
  echo ""
  npm run dev
else
  echo "✅ Setup complete. (Dev server start skipped — caller will handle it.)"
fi
