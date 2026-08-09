#!/usr/bin/env bash

##--------------------------------------------------------------------
## My interactive shell script to help aid / ease the installation of
## drivers and tools necessary to get WiFi running in Linux, using the
## internal WiFi-NIC (Broadcom) which is notoriously difficult.
##--------------------------------------------------------------------

# Check if user0 (root) or user has root privileges (sudo)
if [ "$EUID" != 0 ]
then
	echo "Must be run as root."
	echo "Run this script with: sudo $0"
	echo "Quiting..."
	exit 1
fi

# Define menu choices
options=("Install and try with b43 drivers" "Remove b43 drivers" "Update wl and dkms" "Quit")
selected=0

check_root_install() {
  clear
  if [ ! -d "b43" ]; then
	  echo "Driver directory not found; Did you clone/copy the entire repository?"
	  echo "Exiting..."
	  exit 2
  fi
  mkdir /lib/firmware/b43
  cp b43/*  /lib/firmware/b43
  modprobe -rv b43 
  if [ ! modprobe -v b43 ]; then
  	echo "Failed installing driver. Make sure all files are present, then try again."
    	echo "If it still fails, proceed to the next step in the guide/repository."
  	echo "Exiting..."
  	exit 3
  fi
  exit
}

remove_drivers() {
	clear
	modprobe -rv b43
	rm -Rf /lib/firmware/b43
	echo "Removed b43 drivers; Now run the next install/update"
	exit
}

lin_image() {
	clear
	apt install linux-image-$(uname -r|sed 's,[^-]*-[^-]*-,,') linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,') broadcom-sta-dkms
	apt install broadcom-sta-dkms
}

# Draw menu
draw_menu() {
    tput cup 0 0
    echo "=== Linux/MacBook b43 Menu ==="
    echo "Use UP/DOWN arrow keys, ENTER to select."
    echo ""

    for i in "${!options[@]}"; do
        if [ "$i" -eq "$selected" ]; then
            # Highlight selected item
            printf " > \e[7m %s \e[0m\n" "${options[$i]}"
        else
            printf "   %s \n" "${options[$i]}"
        fi
    done
}

clear
tput civis

trap "tput cnorm; clear; exit" EXIT

while true; do
    draw_menu

    read -rsn1 key
    if [[ $key == $'\x1b' ]]; then
        read -rsn2 key
        case $key in
            '[A') # UP Arrow
                if [ $selected -gt 0 ]; then
                    ((selected--))
                fi
                ;;
            '[B') # DOWN Arrow
                if [ $selected -lt $((${#options[@]} - 1)) ]; then
                    ((selected++))
                fi
                ;;
        esac
    elif [[ $key == "" ]]; then # ENTER Key
        tput cnorm

        case $selected in
            0)
                check_root_install
                ;;
	    1)
		remove_drivers
		;;
	    2)
		lin_image
		;;
            3)
                exit 0
                ;;
        esac

        echo ""
        read -p "Press [Enter] to return to menu..."
        clear
        tput civis
    fi
done
