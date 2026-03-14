# ============================================================
# --- Aliases: eza (modern ls replacement) ---
# ============================================================

# eza color scheme (uses ANSI 256-color codes)
export EZA_COLORS="di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

# Basic listings
alias ls='eza --group-directories-first'
alias l='eza -1'
alias ll='eza -lg'
alias la='eza -la'

# Detailed listings
alias lld='eza -lg --group-directories-first'
alias llm='eza -lg --sort=modified'
alias lls='eza -lg --sort=size'
alias lla='eza -lag'

# Tree views
alias lt='eza --tree'
alias lta='eza --tree --all'
alias ltd='eza --tree --only-dirs'
alias lt2='eza --tree --level=2'
alias lt3='eza --tree --level=3'

# Extended / special views
alias lx='eza -lbhHigUmuSa@ --time-style=long-iso'
alias lz='eza -lbGF --git'
alias lzd='eza -lbGF --git --sort=date'

# Git-aware listings
alias lg='eza --git-ignore'
alias lgi='eza --git'

# Nerd Font icon variants
alias lsi='eza --icons'
alias lli='eza -lg --icons'
alias lai='eza -la --icons'

# Quick searches
alias find-recent='eza -lg --sort modified --reverse | head'
alias find-large='eza -lg --sort size --reverse | head'
