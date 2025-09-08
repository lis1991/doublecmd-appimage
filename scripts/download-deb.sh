#!/bin/bash
set -e

echo "🔍 Поиск последней версии Double Commander на SourceForge..."
JSON_URL="https://sourceforge.net/projects/doublecmd/files/doublecmd-qt6/?&sort=date&dir=desc"
TEMP_HTML=$(curl -s "$JSON_URL")
LATEST_LINK=$(echo "$TEMP_HTML" | grep -o 'href="[^"]*doublecmd-qt6_[0-9.]*-1_amd64\.deb"' | head -1 | sed 's/href="//;s/"$//')

if [ -z "$LATEST_LINK" ]; then
  echo "❌ Не удалось найти ссылку на .deb файл"
  echo "📄 Ответ от SourceForge:"
  echo "$TEMP_HTML" | head -10
  exit 1
fi

DEB_URL="https://downloads.sourceforge.net$LATEST_LINK"
echo "📥 Скачиваем: $DEB_URL"

wget "$DEB_URL" -O doublecmd.deb
ar x doublecmd.deb
tar -xf data.tar.xz
rm -f doublecmd.deb control.tar.* data.tar.* debian-binary
