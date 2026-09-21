#!/bin/bash
set -e

# ============================================================
# Vercel Build Script for Flutter Web
# ============================================================
# This script runs on Vercel's Linux build machines.
# It downloads Flutter SDK, resolves dependencies, and builds
# the Flutter Web release bundle into build/web/.
# ============================================================

FLUTTER_VERSION="3.38.5"
FLUTTER_CHANNEL="stable"
FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/${FLUTTER_CHANNEL}/linux/flutter_linux_${FLUTTER_VERSION}-${FLUTTER_CHANNEL}.tar.xz"

echo "============================================================"
echo ">>> Flutter Web Build for Vercel"
echo ">>> Flutter Version: ${FLUTTER_VERSION}"
echo ">>> Channel: ${FLUTTER_CHANNEL}"
echo "============================================================"

# Download and extract Flutter SDK
echo ">>> Downloading Flutter SDK..."
curl -sL "${FLUTTER_URL}" | tar xJ -C /tmp

# Add Flutter to PATH
export PATH="/tmp/flutter/bin:/tmp/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Verify Flutter installation
echo ">>> Flutter version:"
flutter --version

# Disable analytics in CI
flutter config --no-analytics 2>/dev/null || true

# Resolve dependencies
echo ">>> Running flutter pub get..."
flutter pub get

# Build Flutter Web release
echo ">>> Building Flutter Web (release)..."
flutter build web --release

# Verify build output
echo ">>> Build complete. Verifying output..."
if [ -f "build/web/index.html" ] && [ -f "build/web/main.dart.js" ]; then
    echo ">>> ✅ Build output verified:"
    ls -la build/web/
else
    echo ">>> ❌ Build output missing critical files!"
    exit 1
fi

echo "============================================================"
echo ">>> Build finished successfully"
echo "============================================================"
