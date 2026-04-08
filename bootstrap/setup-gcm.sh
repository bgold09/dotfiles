#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$DOTFILES_DIR/script/helpers.bash"

# When invoked via sudo, HOME points to root's home. Reset it to the real user's.
if [ -n "$SUDO_USER" ]; then
    HOME=$(eval echo "~$SUDO_USER")
    # Resolve the real user's PATH via a login shell to find tools like git-credential-manager
    user_path=$(sudo -u "$SUDO_USER" bash -l -c 'echo $PATH' 2>/dev/null || true)
    [ -n "$user_path" ] && export PATH="$user_path"
fi

export PATH="$HOME/.local/bin:$PATH"

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
