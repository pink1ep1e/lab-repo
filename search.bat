@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

if "%~2"=="" (
    echo Использование: %~nx0 ^<фрагмент^> ^<искомый_текст^>
    exit /b 1
)

set LOG_FILE=%~1
set SEARCH_TEXT=%~2
set PROJECT_DIR=lab_project

if not exist "%PROJECT_DIR%\" (
    echo Ошибка: папка %PROJECT_DIR% не найдена!
    exit /b 1
)

set /a total_files=0
set /a matched_files=0
set /a total_matches=0

for /r "%PROJECT_DIR%" %%f in (*.txt) do set /a total_files+=1

(
echo Дата и время:     %DATE% %TIME:~0,8%
echo Пользователь:     %USERNAME%
echo Компьютер:        %COMPUTERNAME%
echo Рабочий каталог:  %CD%
echo Лог-файл:         %LOG_FILE%
echo Искомый фрагмент: "%SEARCH_TEXT%"
echo.
echo Найдено .txt-файлов: %total_files%
echo.
) > "%LOG_FILE%"

for /r "%PROJECT_DIR%" %%f in (*.txt) do (
    findstr /n /i /l /c:"%SEARCH_TEXT%" "%%f" > temp.txt
    for /f %%c in ('find /c /v "" ^< temp.txt') do set count=%%c

    >>"%LOG_FILE%" echo Файл: %%f
    >>"%LOG_FILE%" echo   Совпадений: !count!

    if !count! gtr 0 (
        set /a matched_files+=1
        set /a total_matches+=count
        >>"%LOG_FILE%" echo   Строки:
        for /f "delims=" %%l in (temp.txt) do >>"%LOG_FILE%" echo     %%l
    )
    >>"%LOG_FILE%" echo.
)

(
echo Всего .txt-файлов проверено:         !total_files!
echo Файлов с совпадениями:               !matched_files!
echo Всего строк с фрагментом "%SEARCH_TEXT%": !total_matches!
echo.
echo Результат: найдено !total_matches! совпадений.
) >> "%LOG_FILE%"

del temp.txt

type "%LOG_FILE%"
endlocal
