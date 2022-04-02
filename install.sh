#!/bin/bash

SYSTEM_PACKAGES=(
    'acpi'
    'atool'
    'bat'
    'blueman'
    'bluez-utils'
    'curl'
    'dhcpcd'
    'git'
    'htop'
    'lsd'
    'neofetch'
    'odt2txt'
    'openssh'
    'pacman-contrib'
    'poppler'
    'ranger'
    'tmux'
    'usbguard'
    'zsh'
    'adobe-source-code-pro-fonts'
    'kitty'
    'zathura'
    'feh'
    'firefox'
    'brave-bin'
    'sway'
    'swaylock'
    'papirus-icon-theme'
    'nerd-fonts-source-code-pro'
    'qt5ct'
    'kvantum'
    'ttf-iosevka'
    'stow'
)
#latex packgs

SEC_PACKAGES=(
    'ghidra'
    'nmap'
    'gdb'
    'proxychains'
    'tor'
    'sslscan'
    'net-tools'
    'whois'
    'binwalk'
    'pdfgrep'
    'pngcheck'
)

DEV_PACKAGES=(
    'postman-bin'
    'jetbrains-toolbox'
    'python-pip'
    'yarn'
    'neovim'
    'visual-studio-code-bin'
)

CONFIGS=(
    'kitty'
    'sway'
    'waybar'
    'mako'
    'nvim'
)

DOTS_INFO="info[configure_dots] -> this function only checks if\n\t\t dots can be applied safely, if there are\n\t\t no error messages, remove -n parameter.\n"

function usage() {
    local program_name
    program_name=${0##*/}
    cat <<EOF
Usage: sudo $program_name [-option]
Options:
    --help    Print this message
    -i        Install base packages and dots
    -s        Instal sec packages
    -d        Install dev packages
EOF
}


function package_installer(){
    local PCK_MNGR="$1"
    shift
    local PCKGS=("$@")

    for pckg in "${PCKGS[@]}";
    do
        if pacman -Qq "$pckg" > /dev/null; then
            continue
        fi
        if ! sudo -u "$SUDO_USER" "$PCK_MNGR" -S "$pckg" -q --noconfirm; then
            printf "err[package_installer] -> package ${pckg} failed to install!\n"
            exit 1
        fi
    done
}


function configure_dots(){
    for conf in ${CONFIGS[@]};
    do
        stow -nvt ~ "$conf"
    done
    printf "${DOTS_INFO}"
}

function install_paru(){
    if pacman -Qs paru > /dev/null ; then
        return 0
    fi
    sudo pacman -S rust
    sudo -u "$SUDO_USER" -- sh -c "
    git clone https://aur.archlinux.org/paru.git
    cd paru || return;
    yes | makepkg -si"
}

function main() {    
    case "$1" in
        ''|-h|--help)
            usage
            exit 0
            ;;
        -i)
            printf "info -> installing paru pckg manager\n"
            install_paru
            printf "info -> installing sys packages\n"
            package_installer "paru" "${SYSTEM_PACKAGES[@]}"
            configure_dots
            ;;
        -s)
            printf "info -> installing sec packages\n"
            package_installer "paru" "${SEC_PACKAGES[@]}"
            ;;
        -d)
            printf "info -> installing dev packages\n"
            package_installer "paru" "${DEV_PACKAGES[@]}"
            ;;
        *)
            usage
            exit 1
    esac
}

if [ -z "$SUDO_USER" ]; then
    usage
    exit 1
fi

# iterate through cli arguments
for param in "$@"
do
    main "$param"
done
