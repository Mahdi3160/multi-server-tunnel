#!/bin/bash

CONFIG_DIR="/etc/private-tunnel"
CONFIG_FILE="$CONFIG_DIR/config.conf"

# ساخت پوشه تنظیمات اگر وجود نداشت
mkdir -p "$CONFIG_DIR"

# بارگذاری تنظیمات
load_config() {
    if [[ -f "$CONFIG_FILE" ]]; then
        source "$CONFIG_FILE"
    else
        # مقادیر پیش‌فرض
        IRAN_IP="198.245.214.82"
        declare -A SERVERS
        for i in $(seq 1 10); do
            SERVERS[$i,"IP"]="198.245.214.$((80 + i))"
            SERVERS[$i,"TYPE"]="tcp"
        done
        save_config
    fi
}

save_config() {
    echo "IRAN_IP=$IRAN_IP" > "$CONFIG_FILE"
    for i in $(seq 1 10); do
        echo "SERVER${i}_IP=${SERVERS[$i,IP]}" >> "$CONFIG_FILE"
        echo "SERVER${i}_TYPE=${SERVERS[$i,TYPE]}" >> "$CONFIG_FILE"
    done
}

show_status() {
    STATUS=""
    STATUS+="Iran Server IP: $IRAN_IP\n\n"
    for i in $(seq 1 10); do
        STATUS+="Server $i IP: ${SERVERS[$i,IP]} | Type: ${SERVERS[$i,TYPE]}\n"
    done
    whiptail --title "Private Tunnel Status" --msgbox "$STATUS" 20 60
}

set_iran_ip() {
    NEW_IP=$(whiptail --inputbox "Enter Iran Server IP:" 8 40 "$IRAN_IP" --title "Set Iran IP" 3>&1 1>&2 2>&3)
    if [[ $? -eq 0 && $NEW_IP != "" ]]; then
        IRAN_IP="$NEW_IP"
        save_config
    fi
}

set_server_ip_type() {
    SERVER_NUM=$(whiptail --title "Select Server" --menu "Choose server to configure" 15 50 10 \
        1 "Server 1" 2 "Server 2" 3 "Server 3" 4 "Server 4" 5 "Server 5" \
        6 "Server 6" 7 "Server 7" 8 "Server 8" 9 "Server 9" 10 "Server 10" 3>&1 1>&2 2>&3)
    if [[ $? -ne 0 ]]; then return; fi

    NEW_IP=$(whiptail --inputbox "Enter IP for Server $SERVER_NUM:" 8 40 "${SERVERS[$SERVER_NUM,IP]}" --title "Set Server IP" 3>&1 1>&2 2>&3)
    if [[ $? -ne 0 || $NEW_IP == "" ]]; then return; fi

    CHOICE=$(whiptail --title "Select Connection Type" --menu "Choose connection type for Server $SERVER_NUM" 10 40 2 \
        tcp "TCP" udp "UDP" 3>&1 1>&2 2>&3)
    if [[ $? -ne 0 ]]; then return; fi

    SERVERS[$SERVER_NUM,IP]="$NEW_IP"
    SERVERS[$SERVER_NUM,TYPE]="$CHOICE"
    save_config
}

main_menu() {
    while true; do
        CHOICE=$(whiptail --title "Private Tunnel Menu" --menu "Choose an option:" 15 50 6 \
            1 "View Status" \
            2 "Set Iran Server IP" \
            3 "Configure Servers" \
            4 "Exit" 3>&1 1>&2 2>&3)

        if [[ $? -ne 0 ]]; then
            break
        fi

        case $CHOICE in
            1) show_status ;;
            2) set_iran_ip ;;
            3) set_server_ip_type ;;
            4) break ;;
        esac
    done
}

load_config
main_menu
