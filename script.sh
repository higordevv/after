#!/bin/bash


if [[ $EUID -ne 0 ]]; then
   echo "Este script deve ser executado como super usuário (root)." 
   exit 1
fi

programas=(
    "vscode"
    "spotify"
    "insomnia"
    "brave"
    "mongodb-compass"
    "mysql-shell"
    "mongosh"
    "docker"
    "feh"
    "wget"
)


declare -A distros=( 
    ["ubuntu"]="apt-get update && apt-get upgrade -y"
    ["debian"]="apt-get update && apt-get upgrade -y"
    ["linuxmint"]="apt-get update && apt-get upgrade -y"
    ["arch"]="pacman -Syu"
    ["fedora"]="dnf update"
    ["opensuse"]="zypper update"
    ["manjarolinux"]="pacman -Syu"
    ["centos"]="yum update"
    ["redhatenterpriseserver"]="yum update"
)

distro=$(lsb_release -i | awk '{print tolower($3)}')
interface=$(echo $SHELL | awk -F/ '{print $NF}')

for d in "${!distros[@]}"; do
    if [ $distro == "$d" ]; then
        echo "Sistema $d"
        eval "${distros[$d]} >> /dev/null"
        if [ $interface == "zsh" ]; then
            echo "zsh já está instalado e configurado"
        else 
            echo "bash detectado"
            if [ $distro == "ubuntu" || $distro == "debian" || $distro == "linuxmint"]; then
                apt-get install -y zsh
            elif [ $distro == "arch" || $distro == "manjarolinux"]; then
                 pacman -S zsh
            elif [ $distro == "fedora"]; then
                 dnf install zsh
            elif [ $distro == "opensuse"]; then
                zypper install zsh
            elif [ $distro == "centos" || $distro == "redhatenterpriseserver"]; then
                yum install zsh
            else
                echo "distribuição não suportada"
            fi
                echo "configurando zsh como shell padrão"
                chsh -s $(which zsh)
            fi
            for i in "${programas[@]}"; do
                if [ $distro == "ubuntu" || $distro == "debian" || $distro == "linuxmint"]; then
                    apt-get install -y $i
                elif [ $distro == "arch" || $distro == "manjarolinux"]; then
                    pacman -S $i
                elif [ $distro == "fedora"]; then
                    dnf install $i
                elif [ $distro == "opensuse"]; then
                    zypper install $i
                elif [ $distro == "centos" || $distro == "redhatenterpriseserver"]; then
                    yum install $i
                else
                    echo "distribuição não suportada para instalação do $i"
                fi
                done
                echo "Programas instalados com sucesso!"
        fi
        break
    fi
done
