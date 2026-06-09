#!/bin/bash
set -e

# Install Flutter SDK on Vercel
if [ ! -d "/tmp/flutter" ]; then
  echo "Installing Flutter..."
  git clone https://github.com/flutter/flutter.git --depth 1 -b stable /tmp/flutter 2>/dev/null
fi
export PATH="/tmp/flutter/bin:$PATH"
export PUB_CACHE="/tmp/.pub-cache"

flutter config --enable-web --no-analytics 2>/dev/null
flutter pub get
flutter build web --release
