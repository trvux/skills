#!/usr/bin/env bash
# Headless-Chrome screenshot helper — no browser extension required.
#
# Use this during the visual iteration loop (step 5) to actually see a
# rendered page instead of reasoning about it blind from class names.
# Read the resulting PNG with your Read/image tool right after running this.
#
# Usage:
#   screenshot.sh <url> [output.png] [width] [height]
#
# Examples:
#   screenshot.sh http://localhost:3000
#   screenshot.sh http://localhost:3000/pricing /tmp/pricing.png 1440 2000

set -euo pipefail

URL="${1:?Usage: screenshot.sh <url> [output.png] [width] [height]}"
OUT="${2:-./screenshot.png}"
WIDTH="${3:-1440}"
HEIGHT="${4:-1600}"

find_chrome() {
  local candidates=(
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
    "/Applications/Chromium.app/Contents/MacOS/Chromium"
    "/usr/bin/google-chrome"
    "/usr/bin/google-chrome-stable"
    "/usr/bin/chromium"
    "/usr/bin/chromium-browser"
  )
  for c in "${candidates[@]}"; do
    if [ -x "$c" ]; then
      echo "$c"
      return 0
    fi
  done
  # fall back to PATH lookup
  for name in google-chrome google-chrome-stable chromium chromium-browser; do
    if command -v "$name" >/dev/null 2>&1; then
      command -v "$name"
      return 0
    fi
  done
  return 1
}

CHROME_BIN="$(find_chrome || true)"
if [ -z "$CHROME_BIN" ]; then
  echo "Could not find a Chrome/Chromium binary. Install Google Chrome, or" >&2
  echo "pass its path via CHROME_BIN=/path/to/chrome $0 ..." >&2
  exit 1
fi
CHROME_BIN="${CHROME_BIN_OVERRIDE:-$CHROME_BIN}"

"$CHROME_BIN" \
  --headless=new \
  --disable-gpu \
  --hide-scrollbars \
  --screenshot="$OUT" \
  --window-size="${WIDTH},${HEIGHT}" \
  "$URL" 2>/dev/null

if [ -f "$OUT" ]; then
  echo "Saved screenshot to $OUT"
else
  echo "Screenshot failed — no output file at $OUT" >&2
  exit 1
fi
