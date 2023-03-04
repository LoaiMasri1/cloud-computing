#!/bin/bash

# Install cowsay if it's not already installed
if ! command -v cowsay &> /dev/null
then
    sudo apt-get update
    sudo apt-get install cowsay
fi

# Get and print current date
date=$(date +"%A, %B %d %Y")

# Get and print current user
user=$(whoami)

# Get Linux version
version=$(cat /etc/os-release | grep "PRETTY_NAME" | cut -d "=" -f 2 | tr -d '"')

# Use cowsay to print welcome message

welcome(){
    cowsay "Welcome to LunixStatus! Today is $date, and you are logged in as $user on Linux version $version."
}


getRunningProcess(){
    echo "Running processes:"
    ps aux | awk '{print $1, $2, $3, $4, $11}' | column -t
}

getMemoryStatus(){
    echo "Memory status:"
    free -m
}

getHardStatus(){
    echo "Hard disk status:"
    df -h
}

getApacheVersion(){
    if ! command -v apache2 &> /dev/null
    then
        echo "Apache is not installed"
    else
        version=$(apache2 -v | grep "version")
        echo "Apache version: $version"
    fi
    read -n 1 -p "Press 1 to return to the main menu or 2 exit the script:" option
        if [ $option -eq 1 ] ; then
            mainMenu
        elif [ $option -eq 2 ] ; then
            exit
        fi
}

redirect(){
    echo "Choose an option:"
    echo "1. Back to main menu"
    echo "2. Update the view"
    echo "3. Exit"

    read -p "Option: " option

    case $option in
        1) mainMenu;;
        2) "$1";;
        3) exit;;
        *) echo "Invalid option"; sleep 1; "$1";;
    esac
}

handleOption(){
    while true
    do
    $1
    redirect $1
    done
}

mainMenu(){
    while true
    do
        clear
        welcome
        echo "Please select an option:"
        echo "1. List running processes"
        echo "2. Check memory status"
        echo "3. Check hard disk status"
        echo "4. Check Apache version"
        echo "5. Exit"
        read -p "Option: " option

        case $option in
            1) handleOption getRunningProcess;;
            2) handleOption getMemoryStatus;;
            3) handleOption getHardStatus;;
            4) getApacheVersion;;
            5) exit;;
            *) echo "Invalid option"; sleep 1; mainMenu;;
        esac
    done
}

if [ $# -eq 0 ] ; then
    mainMenu
fi


while getopts ":prha" opt; do
    case $opt in
        p) getRunningProcess;;
        r) getMemoryStatus;;
        h) getHardStatus;;
        a) getApacheVersion;;
        *) echo "Invalid option"; sleep 1; mainMenu;;
    esac
done

# The script should be added to Linux PATH, to be recognized as any other command



