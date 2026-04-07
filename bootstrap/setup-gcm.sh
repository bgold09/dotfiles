#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$DOTFILES_DIR/script/helpers.bash"

###############################################################################
# GPG + pass + git-credential-manager                                         #
###############################################################################

info "Setting up GPG, pass, and git-credential-manager...\n"

if ! gpg --list-keys "bgold09@users.noreply.github.com" &>/dev/null; then
    gpg --quick-generate-key "Brian Golden <bgold09@users.noreply.github.com>"
    success "GPG key created"
fi

if [ ! -d "$HOME/.password-store" ]; then
    pass init "Brian Golden <bgold09@users.noreply.github.com>"
    success "pass store initialized"
fi

if ! git config --global credential.credentialStore &>/dev/null; then
    git-credential-manager configure
    success "git-credential-manager configured"
fi
