if [ "$#" -ne 2 ]; then
    echo "Использование: $0 <фрагмент> <искомый_текст>"
    exit 1
fi

LOG_FILE="$1"
SEARCH_TEXT="$2"
PROJECT_DIR="lab_project"

if [ ! -d "$PROJECT_DIR" ]; then
    echo "Ошибка: папка $PROJECT_DIR не найдена!"
    exit 1
fi

CURRENT_DATE=$(date '+%Y-%m-%d %H:%M:%S')
CURRENT_USER=$(whoami)
CURRENT_HOST=$(hostname)
CURRENT_DIR=$(pwd)

total_files=$(find "./$PROJECT_DIR" -type f -name "*.txt" | wc -l)
matched_files=0
total_matches=0

> "$LOG_FILE"

{
    echo "Дата и время:     $CURRENT_DATE"
    echo "Пользователь:     $CURRENT_USER"
    echo "Компьютер:        $CURRENT_HOST"
    echo "Рабочий каталог:  $CURRENT_DIR"
    echo "Лог-файл:         $LOG_FILE"
    echo "Искомый фрагмент: \"$SEARCH_TEXT\""
    echo ""
    echo "Найдено .txt-файлов: $total_files"
    echo ""
} >> "$LOG_FILE"

while read -r file; do
    matches=$(grep -inF "$SEARCH_TEXT" "$file")

    if [ -n "$matches" ]; then
        count=$(echo "$matches" | wc -l)
        matched_files=$((matched_files + 1))
        total_matches=$((total_matches + count))

        {
            echo "Файл: $file"
            echo "  Совпадений: $count"
            echo "  Строки:"
            echo "$matches" | sed 's/^/    /'
            echo ""
        } >> "$LOG_FILE"
    else
        {
            echo "Файл: $file"
            echo "  Совпадений: 0"
            echo ""
        } >> "$LOG_FILE"
    fi
done < <(find "./$PROJECT_DIR" -type f -name "*.txt" | sort)

# Сводка
{
    printf "Всего .txt-файлов проверено:         %d\n" "$total_files"
    printf "Файлов с совпадениями:               %d\n" "$matched_files"
    printf "Всего строк с фрагментом \"%s\": %d\n" "$SEARCH_TEXT" "$total_matches"
    echo ""
    echo "Результат: найдено $total_matches совпадений."
} >> "$LOG_FILE"

cat "$LOG_FILE"
