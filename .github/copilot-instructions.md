# Copilot Instructions

## Repository overview

Personal dotfiles managed by [`cnct`](https://github.com/bgold09/cnct). All file linking, copying, and shell bootstrap is declared in `cnct.json`. The install scripts (`install.ps1`, `install.sh`) are thin entry points that install prerequisites and then run `cnct`.

## How `cnct.json` works

`cnct.json` is the source of truth for what gets installed and where. Action types:

- **`link`** – symlink a file from the repo into `~` (most config files)
- **`copy`** – copy instead of symlink (e.g., `git/gitconfig → ~/.gitconfig`)
- **`shell`** – run a script (bootstrap steps)
- **`cloneGitRepository`** – clone a repo during setup
- **`linkExpand`** – symlink every file inside a directory into a target directory

When adding a new dotfile, add the appropriate `link`/`copy` entry to `cnct.json`.

## Directory structure

| Directory | Purpose |
|-----------|---------|
| `bash/` | `bashrc`, `bash_profile`, `exports.bash`, `functions.bash`, `prompt.bash`, `aliases/`, `completions/` |
| `bootstrap/` | `bootstrap.sh` (Linux), `bootstrap.ps1` (Windows), `install-packages.sh` (Linux packages) |
| `bin/` | UNIX executables added to `$PATH` |
| `bin-windows/` | Windows executables added to `$PATH`; only `.exe`/`.dll` committed |
| `editors/` | VS Code settings |
| `git/` | `gitconfig` (includes `base.gitconfig` + `~/.os.gitconfig`), `gitignore` |
| `powershell/` | `profile.ps1`, `aliases.ps1`, `functions.ps1`, `functions/` |
| `system/` | Shell-agnostic terminal config (`inputrc`, `dircolors`, `bat.config`, `wgetrc`) |
| `vim/` | `vimrc`, `base.vimrc`, `plugins.vim`, `plugins.lua`, `ideavimrc` |
| `windows/` | CMD env (`win32-rc.cmd`, `aliases.doskey`, `clink.lua`), Windows Terminal, ConEmu, winget, PowerToys |

## Key conventions

### Layered / local overrides

Many config files support local overrides that are never committed:
- `~/.localrc` – extra bash config (aliases, functions, exports)
- `~/.plugins.local.vim` – additional vim-plug `Plug` lines
- `~/.os.gitconfig` – OS-specific git settings (linked from `git/os-linux.gitconfig`, etc.)

### OS-specific config

- Git: `git/gitconfig` includes `base.gitconfig` + `~/.os.gitconfig`; the OS-specific file is linked by `cnct` based on platform
- Bash/PowerShell: OS checks happen inline (`uname`, `$IsWindows`, etc.)
- Bootstrap: `bootstrap.sh` for Linux/macOS, `bootstrap.ps1` for Windows

### Config loading order (bash)

`bashrc` loads in this order: `functions.bash` → `exports.bash` → `prompt.bash` → completions → aliases → `~/.localrc` → history settings → Python startup → dircolors → nvm → zoxide

### Config loading order (PowerShell)

`profile.ps1` loads: aliases/functions (recursive glob) → custom prompt → PSReadLine → Windows-specific path/policy → posh-git → Terminal-Icons → zoxide → winget completion → editor selection → local overrides

### Theming

Solarized Dark is used consistently: `system/dircolors`, `system/bat.config`, `windows/windowsterminal-settings.json`, VS Code settings, and ConEmu. Font is Consolas patched with Nerd Fonts.

### Vim/Neovim

- `vimrc` just loads `~/.base.vimrc` and `~/.vim/plugins.vim`
- `plugins.vim` bootstraps vim-plug and conditionally loads plugins for Vim vs Neovim vs VS Code
- `plugins.lua` configures Neovim-only plugins (Telescope, Neo-tree, lualine, gitsigns)

### Package management

- **Linux**: `packages-linux.json` – sections for `apt`, `snap`, `flatpak`, `github` (release `.deb`), and `npm`; processed by `bootstrap/install-packages.sh`
- **Windows**: `windows/winget-packages.json` – used with `winget import` in `bootstrap/bootstrap.ps1`

### Script helpers

`script/helpers.bash` provides `info`/`success`/`warn`/`fail` logging functions; source it in any new bash bootstrap script.
