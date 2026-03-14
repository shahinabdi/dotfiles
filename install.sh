#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_BASE="${HOME}/.dotfiles-backups"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="${BACKUP_BASE}/${TIMESTAMP}"

declare -a MAPPINGS=(
  "cli/eza/aliases.bash|${HOME}/.config/eza/aliases.bash"
  "cli/eza/config.toml|${HOME}/.config/eza/config.toml"
  "cli/fzf/fzf-options|${HOME}/.config/fzf/fzf-options"
  "cli/fzf/keybindings.bash|${HOME}/.config/fzf/keybindings.bash"
  "git/gitconfig|${HOME}/.gitconfig"
  "git/gitignore_global|${HOME}/.gitignore_global"
  "git/gitmessage|${HOME}/.gitmessage"
  "shell/bashrc/bashrc|${HOME}/.bashrc"
  "terminal/alacritty/alacritty.toml|${HOME}/.config/alacritty/alacritty.toml"
  "terminal/alacritty/themes/jellybeans-default.toml|${HOME}/.config/alacritty/themes/jellybeans-default.toml"
  "terminal/alacritty/themes/noctis-default.toml|${HOME}/.config/alacritty/themes/noctis-default.toml"
  "terminal/starship/starship.toml|${HOME}/.config/starship.toml"
  "vscode/settings.json|${HOME}/.config/Code/User/settings.json"
  "window-manager/sway/config|${HOME}/.config/sway/config"
  "window-manager/wofi/config|${HOME}/.config/wofi/config"
  "window-manager/wofi/style.css|${HOME}/.config/wofi/style.css"
)

log() {
  printf "%s\n" "$*"
}

copy_one() {
  local src_rel="$1"
  local dest="$2"
  local src="${REPO_ROOT}/${src_rel}"

  if [[ ! -f "$src" ]]; then
    log "[WARN] Missing source file: ${src_rel}"
    return 0
  fi

  mkdir -p "$(dirname "$dest")"
  cp -f "$src" "$dest"
  log "[COPY] ${src_rel} -> ${dest}"
}

backup_one() {
  local dest="$1"

  if [[ -e "$dest" || -L "$dest" ]]; then
    local rel_dest="${dest#${HOME}/}"
    local backup_path="${BACKUP_DIR}/${rel_dest}"
    mkdir -p "$(dirname "$backup_path")"
    cp -a "$dest" "$backup_path"
    log "[BACKUP] ${dest} -> ${backup_path}"
  else
    log "[SKIP] No existing file to back up: ${dest}"
  fi
}

do_backup() {
  mkdir -p "$BACKUP_DIR"

  local entry src_rel dest
  for entry in "${MAPPINGS[@]}"; do
    src_rel="${entry%%|*}"
    dest="${entry#*|}"
    backup_one "$dest"
  done

  log ""
  log "Backup created in: ${BACKUP_DIR}"
}

do_copy() {
  local entry src_rel dest
  for entry in "${MAPPINGS[@]}"; do
    src_rel="${entry%%|*}"
    dest="${entry#*|}"
    copy_one "$src_rel" "$dest"
  done

  log ""
  log "Install complete."
}

show_menu() {
  cat <<'EOF'
Dotfiles Installer
==================
1) Backup existing files and install dotfiles
2) Install dotfiles only (no backup)
3) Backup existing files only
4) Exit
EOF
}

main() {
  while true; do
    show_menu
    read -r -p "Choose an option [1-4]: " choice

    case "$choice" in
      1)
        do_backup
        do_copy
        break
        ;;
      2)
        do_copy
        break
        ;;
      3)
        do_backup
        break
        ;;
      4)
        log "Exit."
        break
        ;;
      *)
        log "Invalid option. Please select 1, 2, 3, or 4."
        ;;
    esac
    log ""
  done
}

main "$@"
