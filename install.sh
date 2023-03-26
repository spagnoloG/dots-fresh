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
    'zsh-autosuggestions'
    'zsh-syntax-highlighting'
    'adobe-source-code-pro-fonts'
    'alacritty'
    'zathura'
    'feh'
    'firefox'
    'brave-bin'
    'sway'
    'swaylock-effects'
    'xorg-xwayland'
    'swaybg'
    'swaynag'
    'swappy'
    'kanshi'
    'catimg'
    'wl-clipboard'
    'nerd-fonts-source-code-pro'
    'qt5ct'
    'kvantum'
    'ttf-iosevka'
    'stow'
    'rsync'
    'brightnessctl'
    'transmission-gtk'
    'flameshot'
    'tlp'
    'texlive-most'
    'tree'
    'zathura-pdf-mupdf'
    'matcha-gtk-theme'
    'kvantum-theme-nordic-git'
    'xcursor-breeze'
    'papirus-icon-theme'
    'ttf-material-design-icons-extended'
    'thunar'
    'man-pages'
    'man-db'
    'bluez'
    'blueman-manager'
    'dmenu'
    'xfce-polkit'
    'wmname'
    'p7zip'
)
#latex packgs

SEC_PACKAGES=(
    'ghidra'
    'ida-free'
    'nmap'
    'gdb'
    'gdb-common'
    'proxychains'
    'tor'
    'sslscan'
    'net-tools'
    'whois'
    'binwalk'
    'pdfgrep'
    'pngcheck'
    'binwalk'
    'foremost'
    'hash-identifier'
    'perl-image-exiftool'
    'wireshark-qt'
    'net-tools'
    'zsteg'
    'steghide'
    'ghex'
    'metasploit'
    'bbe'
    'avaloniailspy'
    'ttf-ms-fonts'
    'dirbuster-wordlists'
    'subfinder-bin'
    'sonic-visualiser'
)

DEV_PACKAGES=(
    'postman-bin'
    'jetbrains-toolbox'
    'python-pip'
    'yarn'
    'neovim'
    'visual-studio-code-bin'
    'thunderbird'
    'libreoffice-fresh'
    'dbeaver'
    'mycli'
)

CONFIGS=(
    'alacritty'
    'cava'
    'nvim'
    'gtk-3.0'
    'tmux'
    'wallpapers'
)

DOTS_INFO="info[configure_dots] -> this function only checks if\n\t\t dots can be applied safely, if there are\n\t\t no error messages, remove -n parameter.\n"

function usage() {
    local program_name
    program_name=${0##*/}
    cat <<EOF
Usage: sudo $program_name [-option]
Options:
    --help    Print this message
    -i        Install base packages (sudo perms needed)
    -s        Instal sec packages
    -d        Install dev packages
    -a        Apply dots
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

function install_ohmyzsh_plugins() {
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
}


function configure_dots(){
    for conf in ${CONFIGS[@]};
    do
        stow -vt  ~ "$conf"
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
            # Check for root perms
            if [ -z "$SUDO_USER" ]; then
                usage
                exit 1
            fi
            printf "info -> installing paru pckg manager\n"
            install_paru
            printf "info -> installing sys packages\n"
            package_installer "paru" "${SYSTEM_PACKAGES[@]}"
            install_ohmyzsh_plugins  
            ;;
        -s)
            printf "info -> installing sec packages\n"
            package_installer "paru" "${SEC_PACKAGES[@]}"
            ;;
        -d)
            printf "info -> installing dev packages\n"
            package_installer "paru" "${DEV_PACKAGES[@]}"
            ;;
        -a)
            printf "info -> Installing dots\n"
            configure_dots
            ;;
        *)
            usage
            exit 1
    esac
}

[ -z "$@"] && usage

# iterate through cli arguments
for param in "$@"
do
    main "$param"
done
