#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config/notify"
BIN_DIR="$HOME/.local/bin"
CONF_FILE="$CONFIG_DIR/telegram.conf"

echo "=== tg-wrap installer ==="

# Создаём директории
mkdir -p "$CONFIG_DIR" "$BIN_DIR"

# Конфиг
if [ -f "$CONF_FILE" ]; then
    echo "Конфиг уже существует: $CONF_FILE — пропускаем."
else
    cp "$SCRIPT_DIR/telegram.conf.example" "$CONF_FILE"
    chmod 600 "$CONF_FILE"
    echo ""
    echo "Создан конфиг: $CONF_FILE"
    echo "Откройте его и заполните BOT_TOKEN и CHAT_ID:"
    echo "  \$EDITOR $CONF_FILE"
    echo ""
fi

# Скрипты
cp "$SCRIPT_DIR/bin/tg-wrap" "$BIN_DIR/tg-wrap"
cp "$SCRIPT_DIR/bin/tg-notify" "$BIN_DIR/tg-notify"
chmod +x "$BIN_DIR/tg-wrap" "$BIN_DIR/tg-notify"
echo "Скрипты установлены в $BIN_DIR"

# Проверка PATH
if ! echo "$PATH" | grep -q "$BIN_DIR"; then
    echo ""
    echo "Добавьте в ~/.bashrc или ~/.zshrc:"
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo "Затем перезапустите оболочку или выполните: source ~/.bashrc"
fi

echo ""
echo "Готово. Проверьте установку:"
echo "  tg-notify \"Привет от tg-wrap\""
