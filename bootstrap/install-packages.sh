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
        if ! dpkg -s "$pkg" &>/dev/null; then
            to_install+=("$pkg")
        fi
    done <<< "$packages"

    if [ ${#to_install[@]} -gt 0 ]; then
        sudo apt-get update -qq
        sudo apt-get install -y "${to_install[@]}"
        for pkg in "${to_install[@]}"; do
            success "$pkg installed"
        done
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

        if ! snap list "$name" &>/dev/null; then
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

        if ! flatpak list --app | grep -q "$name"; then
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

install_npm_packages() {
    info "Installing npm packages...\n"

    export NVM_DIR="$HOME/.nvm"

    if [ ! -d "$NVM_DIR" ]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
        success "nvm installed"
    fi

    \. "$NVM_DIR/nvm.sh"

    if ! nvm ls 24 &>/dev/null; then
        nvm install 24
        success "Node.js 24 installed"
    fi

    nvm use 24

    local count
    count=$(jq '.npm // [] | length' "$PACKAGES_FILE")

    for ((i = 0; i < count; i++)); do
        local pkg
        pkg=$(jq -r ".npm[$i]" "$PACKAGES_FILE")

        if ! npm list -g "$pkg" &>/dev/null; then
            npm install -g "$pkg"
            success "$pkg installed (npm)"
        fi
    done
}

###############################################################################
# Main                                                                        #
###############################################################################

e_header "Installing packages"

install_apt_packages
install_snap_packages
install_flatpak_packages
install_github_packages
install_npm_packages

kill "$SUDO_KEEPALIVE_PID" 2>/dev/null
