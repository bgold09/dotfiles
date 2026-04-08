#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$DOTFILES_DIR/script/helpers.bash"

###############################################################################
# sudo keepalive                                                              #
###############################################################################

sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done >/dev/null 2>&1 &
SUDO_KEEPALIVE_PID=$!

###############################################################################
# GNOME settings                                                              #
###############################################################################

configure_gnome() {
    if ! command -v gsettings &>/dev/null; then
        warn "gsettings not available, skipping GNOME configuration"
        return
    fi

    info "Configuring GNOME settings...\n"

    # When running under sudo, gsettings/dconf need the original
    # user's D-Bus session. Run these commands as the real user
    # with the correct bus address.
    local run_as=""
    if [ -n "$SUDO_USER" ]; then
        local uid
        uid=$(id -u "$SUDO_USER")
        local bus="unix:path=/run/user/${uid}/bus"
        run_as="sudo -u $SUDO_USER DBUS_SESSION_BUS_ADDRESS=$bus"
    fi

    # Dark mode
    $run_as gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    success "Dark mode enabled"

    # Caps Lock → Ctrl
    $run_as gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:nocaps']"
    success "Caps Lock remapped to Ctrl"

    # Clock format (12h)
    $run_as gsettings set org.gnome.desktop.interface clock-format '12h'
    success "Clock format set to 12h"

    # Ptyxis terminal settings
    local ptyxis_dconf="$DOTFILES_DIR/system/ptyxis.dconf"
    if [ -f "$ptyxis_dconf" ]; then
        $run_as bash -c "dconf load /org/gnome/Ptyxis/ < '$ptyxis_dconf'"
        success "Ptyxis terminal settings restored"
    else
        warn "Ptyxis settings file not found at $ptyxis_dconf"
    fi
}

###############################################################################
# Fonts                                                                       #
###############################################################################

install_fonts() {
    local font_dir="$HOME/.local/share/fonts"

    if ls "$font_dir"/Inconsolata*.ttf &>/dev/null; then
        return
    fi

    info "Installing Inconsolata Nerd Font...\n"
    mkdir -p "$font_dir"
    local tmp_dir
    tmp_dir=$(mktemp -d)

    curl -fsSL -o "$tmp_dir/Inconsolata.zip" \
        "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Inconsolata.zip"
    unzip -qo "$tmp_dir/Inconsolata.zip" -d "$tmp_dir/Inconsolata"
    cp "$tmp_dir"/Inconsolata/*.ttf "$font_dir/"
    rm -rf "$tmp_dir"

    fc-cache -fv &>/dev/null
    success "Inconsolata Nerd Font installed"
}

###############################################################################
# zoxide                                                                      #
###############################################################################

install_zoxide() {
    if command -v zoxide &>/dev/null; then
        return
    fi

    info "Installing zoxide...\n"
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
    success "zoxide installed"
}

###############################################################################
# Main                                                                        #
###############################################################################

e_header "Linux bootstrap"

"$DOTFILES_DIR/bootstrap/install-packages.sh"
install_zoxide
configure_gnome
install_fonts

kill "$SUDO_KEEPALIVE_PID" 2>/dev/null
