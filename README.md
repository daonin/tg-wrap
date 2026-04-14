# tg-wrap

Bash-утилиты для отправки Telegram-уведомлений из командной строки. Удобно для мониторинга долгих задач: обучения моделей, транскрибации, бекапов и т.п.

## Возможности

- **tg-wrap** — оборачивает любую команду: присылает уведомление по завершении (успех/ошибка) и периодические heartbeat-сообщения каждые 10 минут
- **tg-notify** — просто отправляет произвольный текст в Telegram

## Быстрый старт

```bash
git clone https://github.com/your-username/tg-wrap.git
cd tg-wrap
bash install.sh
```

После установки откройте конфиг и заполните токен и chat_id:

```bash
$EDITOR ~/.config/notify/telegram.conf
```

Проверьте:

```bash
tg-notify "Установка работает"
```

## Получение BOT_TOKEN и CHAT_ID

**BOT_TOKEN:**
1. Напишите [@BotFather](https://t.me/BotFather) в Telegram
2. Отправьте `/newbot`, следуйте инструкциям
3. Скопируйте токен вида `1234567890:AAE...`

**CHAT_ID:**
1. Напишите вашему боту любое сообщение
2. Откройте в браузере: `https://api.telegram.org/bot<BOT_TOKEN>/getUpdates`
3. Найдите `"chat":{"id": 123456789}` — это и есть ваш CHAT_ID

## Использование

### tg-wrap

```bash
tg-wrap <команда> [аргументы]
```

Примеры:

```bash
tg-wrap python train.py --epochs 100
tg-wrap rsync -av /data /backup
nohup tg-wrap python long_script.py &
```

По завершении придёт сообщение:
- `✅ Готово: python train.py — Время: 42 мин`
- `❌ Ошибка (код 1): python train.py — Время: 3 мин`

### tg-notify

```bash
tg-notify "Текст сообщения"
```

### Файл прогресса

tg-wrap проверяет `/tmp/tg-progress` каждые 10 минут. Если файл существует — его содержимое добавляется в heartbeat-сообщение. Используйте это для промежуточных отчётов:

```bash
# В вашем скрипте
echo "Эпоха 5/100, loss: 0.42" > /tmp/tg-progress
```

### Интервал heartbeat

По умолчанию — 600 секунд (10 минут). Чтобы изменить, отредактируйте `INTERVAL` в `~/.local/bin/tg-wrap`:

```bash
INTERVAL=300  # 5 минут
```

## Структура

```
tg-wrap/
├── bin/
│   ├── tg-wrap       # обёртка с heartbeat и финальным уведомлением
│   └── tg-notify     # простая отправка сообщения
├── telegram.conf.example  # шаблон конфига (без токенов)
├── install.sh        # установщик
└── .gitignore        # исключает *.conf из git
```

Конфиг хранится отдельно от репо: `~/.config/notify/telegram.conf`
