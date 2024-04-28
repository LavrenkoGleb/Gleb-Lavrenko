# Техническое задание №1(ТЗ№1)
## Условие:
>Необходимо написать скрипт на bash, который на вход принимает два параметра - две директории (входная директория и выходная директория). Задача скрипта - "обойти" входную директорию и скопировать все файлы из нее (и из всех сложенных директорий) в выходную директорию - но уже без иерархии, а просто все файлы - внутри выходной директории.
## Скрипт на BASH для решения поставленной задачи:
```
#!/bin/bash

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <input_directory> <output_directory>"
    exit 1
elif [[ ! -d "$1" ]]; then
    echo "Sorry, input_directory does not exist."
    exit 2
fi

find "$1" -type f -exec sh -c '
    input_directory="$1"    
    output_directory="$2"
    for file in "$input_directory"; do
        filename=$(basename "$file")
        basename=$(echo $filename | cut -d. -f1)
        extension=$(echo $filename | cut -c $((${#basename} + 1))-${#filename})
        ind=""
        count=0
        while [ -e "$output_directory/$basename$ind$extension" ]; do
            count=$((count + 1))
            ind="$count"
            done
        if [[ "$extension" == "" ]]; then
            cp "$file" "$output_directory/$basename$ind"
        elif [[ "$extension" != "" ]]; then
            cp "$file" "$output_directory/$basename$ind$extension"
        fi
     done
    ' sh {} "$2" \;
echo "Copying completed."
```
## Ход работы скрипта:
- Проверяет количество переданных аргументов(если их кол-во ≠ 2, то скрипт заканчивает работу)
- Считывает два параметра: входную и выходную директории
- Проверяет наличие файлов во входной директории
- Обходит входную директорию и считывает файлы оттуда
- Для каждого файла проверяе: если есть файл с таким же названием и типом в выходной директории, то изменяет его название, чтобы файлы с одинаковым названием и типом не терялись.
- Копирует файлы из входной директории в выходную директорию