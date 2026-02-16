#!/bin/bash

# Цвета
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
nc='\033[0m' # No Color

# Проверка наличия nmap
check_nmap() {
    if ! command -v nmap &> /dev/null; then
        echo -e "${red}Ошибка: nmap не установлен."
        echo -e "${yellow}Установите nmap, например: sudo apt install nmap (для Debian/Ubuntu)${nc}"
        exit 1
    fi
}

# Функция определения IP-адреса роутера (gateway)
defining_ip_route() {
    echo -e "${yellow}Определение IP-адреса роутера..."
    gateway=$(ip route show | grep -i 'default via' | awk '{print $3}')
    if [ -n "$gateway" ]; then
        echo -e "${green}IP роутера: $gateway"
    else
        echo -e "${red}Не удалось определить IP роутера."
    fi
}

# Функция сканирования одного хоста
Scanning_single_host() {
    local target=$1
    if [ -z "$target" ]; then
        echo -e "${red}Целевой IP не указан.${nc}"
        return 1
    fi
    echo -e "${yellow}Сканирование хоста $target...${nc}"
    sudo nmap "$target"
}

# Функция определения ОС
Definition_operating_system() {
    local target=$1
    if [ -z "$target" ]; then
        echo -e "${red}Целевой IP не указан.${nc}"
        return 1
    fi
    echo -e "${yellow}Определение ОС для $target...${nc}"
    sudo nmap -O "$target"
}

# Главное меню
main() {
    check_nmap

    echo -e "${green}========================================================"
    echo -e "${green}---------------------SCAN PORT NMAP---------------------"
    echo -e "${green}========================================================"
    echo -e "${green}Версия:v0.0.8b"
    echo
    echo -e "${nc}1) Определение IP-адреса роутера"
    echo -e "${nc}2) Сканирование одного хоста"
    echo -e "${nc}3) Определение ОС"
    echo -e "${nc}4) Выход"
    echo

    read -p "Введите номер пункта меню: " selection_options

    case "$selection_options" in
        1)
            defining_ip_route
            ;;
        2)
            read -p "Введите IP-адрес целевого хоста: " target_ip
            Scanning_single_host "$target_ip"
            ;;
        3)
            read -p "Введите IP-адрес целевого хоста: " target_ip
            Definition_operating_system "$target_ip"
            ;;
        4)
            echo -e "${green}Выход.${nc}"
            exit 0
            ;;
        *)
            echo -e "${red}Ошибка: неверный пункт меню.${nc}"
            ;;
    esac
}

# Запуск
main
