#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$DOTFILES_DIR/script/helpers.bash"
PACKAGES_FILE="$DOTFILES_DIR/packages-linux.json"

###############################################################################
# sudo keepalive                                                              #
###############################################################################

sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done >/dev/null 2>&1 &
SUDO_KEEPALIVE_PID=$!

###############################################################################
# Package installation from packages-linux.json                               #
###############################################################################

install_apt_packages() {
    info "Installing apt packages...\n"

    local packages
    packages=$(jq -r '.apt[]' "$PACKAGES_FILE")

    local to_install=()
    while IFS= read -r pkg; do
        if dpkg -s "$pkg" &>/dev/null; then
            success "$pkg already installed"
        else
            to_install+=("$pkg")
        fi
    done <<< "$packages"

    if [ ${#to_install[@]} -gt 0 ]; then
        sudo apt-get update -qq
        sudo apt-get install -y "${to_install[@]}"
        for pkg in "${to_install[@]}"; do
            success "$pkg installed"
        done
    else
        success "All apt packages already installed"
    fi
}

install_snap_packages() {
    info "Installing snap packages...\n"

    local count
    count=$(jq '.snap | length' "$PACKAGES_FILE")

    for ((i = 0; i < count; i++)); do
        local name classic
        name=$(jq -r ".snap[$i] | if type == \"string\" then . else .name end" "$PACKAGES_FILE")
        classic=$(jq -r ".snap[$i] | if type == \"string\" then \"true\" else (.classic // true | tostring) end" "$PACKAGES_FILE")

        if snap list "$name" &>/dev/null; then
            success "$name already installed (snap)"
        else
            local flags=""
            if [ "$classic" = "true" ]; then
                flags="--classic"
            fi
            sudo snap install "$name" $flags
            success "$name installed (snap)"
        fi
    done
}

install_flatpak_packages() {
    info "Installing flatpak packages...\n"

    if ! command -v flatpak &>/dev/null; then
        sudo apt-get install -y flatpak
        success "flatpak installed"
    fi

    if ! flatpak remotes | grep -q flathub; then
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
        success "flathub remote added"
    fi

    local count
    count=$(jq '.flatpak | length' "$PACKAGES_FILE")

    for ((i = 0; i < count; i++)); do
        local name remote
        name=$(jq -r ".flatpak[$i] | if type == \"string\" then . else .name end" "$PACKAGES_FILE")
        remote=$(jq -r ".flatpak[$i] | if type == \"string\" then \"flathub\" else (.remote // \"flathub\") end" "$PACKAGES_FILE")

        if flatpak list --app | grep -q "$name"; then
            success "$name already installed (flatpak)"
        else
            flatpak install -y "$remote" "$name"
            success "$name installed (flatpak)"
        fi
    done
}

install_github_packages() {
    info "Installing GitHub release packages...\n"

    local count
    count=$(jq '.github // [] | length' "$PACKAGES_FILE")

    for ((i = 0; i < count; i++)); do
        local repo asset name
        repo=$(jq -r ".github[$i].repo" "$PACKAGES_FILE")
        asset=$(jq -r ".github[$i].asset" "$PACKAGES_FILE")
        name=$(jq -r ".github[$i].name // \"\"" "$PACKAGES_FILE")
        if [ -z "$name" ]; then
            name="${repo##*/}"
        fi

        local release_json latest_version asset_url
        release_json=$(curl -fsSL "https://api.github.com/repos/${repo}/releases" | \
            jq '[.[] | select(.prerelease == false)] | first')

        latest_version=$(echo "$release_json" | jq -r '.tag_name | ltrimstr("v")')

        if [ -z "$latest_version" ] || [ "$latest_version" = "null" ]; then
            warn "Could not determine latest version for $name"
            continue
        fi

        if dpkg -s "$name" &>/dev/null; then
            local installed_version
            installed_version=$(dpkg-query -W -f='${Version}' "$name" 2>/dev/null | sed 's/-.*//')
            if [ "$installed_version" = "$latest_version" ]; then
                continue
            fi
            info "Upgrading $name $installed_version -> $latest_version...\n"
        fi

        asset_url=$(echo "$release_json" | \
            jq -r --arg pattern "$asset" \
            '.assets[] | select(.name | test($pattern)) | .browser_download_url' | \
            head -1)

        if [ -z "$asset_url" ] || [ "$asset_url" = "null" ]; then
            warn "No matching asset found for $name"
            continue
        fi

        local tmp_dir
        tmp_dir=$(mktemp -d)
        curl -fsSL -o "$tmp_dir/package.deb" "$asset_url"
        sudo dpkg -i "$tmp_dir/package.deb"
        rm -rf "$tmp_dir"
        success "$name $latest_version installed (github)"
    done
}

###############################################################################
# Copilot CLI                                                                 #
###############################################################################

install_copilot_cli() {
    info "Installing Copilot CLI...\n"

    export NVM_DIR="$HOME/.nvm"

    if [ ! -d "$NVM_DIR" ]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
        success "nvm installed"
    else
        success "nvm already installed"
    fi

    # Load nvm for this session
    \. "$NVM_DIR/nvm.sh"

    if ! nvm ls 24 &>/dev/null; then
        nvm install 24
        success "Node.js 24 installed"
    else
        success "Node.js 24 already installed"
    fi

    nvm use 24

    if ! npm list -g @github/copilot &>/dev/null; then
        npm install -g @github/copilot
        success "@github/copilot installed"
    else
        success "@github/copilot already installed"
    fi
}

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
        $run_as dconf load /org/gnome/Ptyxis/ < "$ptyxis_dconf"
        success "Ptyxis terminal settings restored"
    else
        warn "Ptyxis settings file not found at $ptyxis_dconf"
    fi
}

###############################################################################
# GPG + pass + git-credential-manager                                         #
###############################################################################

setup_gcm() {
    info "Setting up GPG, pass, and git-credential-manager...\n"

    if gpg --list-keys "bgold09@users.noreply.github.com" &>/dev/null; then
        success "GPG key already exists"
    else
        warn "No GPG key found for bgold09@users.noreply.github.com"
        info "Run manually:\n"
        info "  gpg --quick-generate-key --batch \"Brian Golden <bgold09@users.noreply.github.com>\"\n"
        info "  pass init \"Brian Golden <bgold09@users.noreply.github.com>\"\n"
        info "  git-credential-manager configure\n"
        return
    fi

    if [ -d "$HOME/.password-store" ]; then
        success "pass store already initialized"
    else
        pass init "Brian Golden <bgold09@users.noreply.github.com>"
        success "pass store initialized"
    fi

    if git config --global credential.credentialStore &>/dev/null; then
        success "git-credential-manager already configured"
    else
        if command -v git-credential-manager &>/dev/null; then
            git-credential-manager configure
            success "git-credential-manager configured"
        else
            warn "git-credential-manager not found, skipping"
        fi
    fi
}

###############################################################################
# Fonts                                                                       #
###############################################################################

install_fonts() {
    info "Installing Inconsolata Nerd Font...\n"

    local font_dir="$HOME/.local/share/fonts"

    if ls "$font_dir"/Inconsolata*.ttf &>/dev/null; then
        success "Inconsolata Nerd Font already installed"
        return
    fi

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

install_apt_packages
install_snap_packages
install_flatpak_packages
install_github_packages
install_copilot_cli
install_zoxide
configure_gnome
setup_gcm
install_fonts

e_header "Bootstrap complete!"

kill "$SUDO_KEEPALIVE_PID" 2>/dev/null
