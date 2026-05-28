#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEVELOPER_DIR="${DEVELOPER_DIR:-/Applications/Xcode.app/Contents/Developer}"
APP="$ROOT/build/Build/Products/Release/BrightIntosh.app"
INSTALL_PATH="${INSTALL_PATH:-/Applications/BrightIntosh.app}"

export DEVELOPER_DIR

xcodebuild \
  -project "$ROOT/BrightIntosh.xcodeproj" \
  -scheme BrightIntosh \
  -configuration Release \
  -derivedDataPath "$ROOT/build" \
  -destination 'platform=macOS,arch=arm64' \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGNING_REQUIRED=NO \
  build

codesign --force --deep --sign - "$APP"
codesign --verify --deep --strict --verbose=2 "$APP"

if [[ "${SKIP_INSTALL:-0}" != "1" ]]; then
  rm -rf "$INSTALL_PATH"
  /usr/bin/ditto "$APP" "$INSTALL_PATH"
  codesign --verify --deep --strict --verbose=2 "$INSTALL_PATH"
fi

echo "Built $APP"
if [[ "${SKIP_INSTALL:-0}" != "1" ]]; then
  echo "Installed $INSTALL_PATH"
fi
