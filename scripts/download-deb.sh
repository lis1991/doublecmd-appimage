#!/bin/bash
set -e

echo "🔍 Поиск последней версии Double Commander через RSS..."

# Скачиваем RSS-ленту
RSS_FILE=$(mktemp)
curl -s "https://sourceforge.net/projects/doublecmd/rss?path=/" -o "$RSS_FILE"

# Проверим, что это XML
if ! grep -q "<rss" "$RSS_FILE"; then
  echo "❌ Ответ не является RSS"
  head -10 "$RSS_FILE"
  rm -f "$RSS_FILE"
  exit 1
fi

# Ищем последний файл .qt6.x86_64.tar.xz
LATEST_LINK=$(grep -o '<link>https://sourceforge.net/projects/doublecmd/files/[^"]*doublecmd-[0-9.]*\.qt6\.x86_64\.tar\.xz/download' "$RSS_FILE" | head -1 | sed 's/<link>//')

rm -f "$RSS_FILE"

if [ -z "$LATEST_LINK" ]; then
  echo "❌ Не найден файл .qt6.x86_64.tar.xz в RSS"
  exit 1
fi

echo "📥 Скачиваем: $LATEST_LINK"

# Скачиваем и распаковываем
wget "$LATEST_LINK" -O doublecmd.tar.xz
tar -xf doublecmd.tar.xz --strip-components=1
rm -f doublecmd.tar.xz

echo "✅ Файлы распакованы"
