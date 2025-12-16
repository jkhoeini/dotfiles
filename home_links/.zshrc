# Change to true to do a profiling on shell load
RUN_ZPROF=false

# This should remain at the top of file to do a proper profiling
if $RUN_ZPROF; then
    zmodload zsh/zprof
fi

# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"
export HOMEBREW_EVAL_ALL=1

source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"

# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle :compinstall filename "$HOME/.zshrc"

# End of lines added by compinstall

fpath+=~/.zfunc

if [[ -e "$(brew --prefix)/share/zsh/site-functions" ]]; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
zstyle ':completion:*' rehash no

# Per-Zsh-version dump avoids stale cache hits after upgrades
: "${COMPDUMP:=${ZDOTDIR:-$HOME}/.zcompdump-${ZSH_VERSION}}"

autoload -Uz compinit && compinit -C -d "$COMPDUMP"
autoload -U +X bashcompinit && bashcompinit

# Byte-compile the dump for faster load next shells
# (only when changed; ignore errors silently)
if [[ -s "$COMPDUMP" && ( ! -s "${COMPDUMP}.zwc" || "$COMPDUMP" -nt "${COMPDUMP}.zwc" ) ]]; then
  zcompile -R -- "${COMPDUMP}.zwc" "$COMPDUMP" 2>/dev/null
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory autocd beep extendedglob
bindkey -v
# End of lines configured by zsh-newuser-install

# Good options
setopt AUTO_LIST AUTO_MENU GLOB GLOB_DOTS GLOB_STAR_SHORT EXTENDED_HISTORY HIST_BEEP HIST_IGNORE_ALL_DUPS HIST_SAVE_NO_DUPS SHARE_HISTORY

# Do menu-driven completion.
zstyle ':completion:*' menu select

# Color completion for some things.
# http://linuxshellaccount.blogspot.com/2008/12/color-completion-using-zsh-modules-on.html
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# formatting and messages
# http://www.masterzen.fr/2009/04/19/in-love-with-zsh-part-one/
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format "$fg[yellow]%B--- %d%b"
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format "$fg[red]No matches for:$reset_color %d"
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

source "$(brew --prefix)/share/antidote/antidote.zsh"
antidote load ~/.config/antidote/plugins.txt

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g L='| less -R'
alias -g G='| grep -i'

autoload -U promptinit; promptinit
prompt pure

if [[ -e  "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc" ]]; then
    source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
fi

bindkey '^T' fzf-file-widget
bindkey '^R' fzf-history-widget
bindkey '^K' per-directory-history-toggle-history

eval "$(mise activate zsh)"

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true

# NOTE disabled for performance. Instead the envs are set in nix
# eval $(luarocks path)

# help cursor-ide detect command is finished
[[ -s "$HOME/.iterm2_shell_integration.zsh" ]] && source "$HOME/.iterm2_shell_integration.zsh"

[ -n "$EAT_SHELL_INTEGRATION_DIR" ] && \
  source "$EAT_SHELL_INTEGRATION_DIR/zsh"

[[ -s "$HOME/spotify.zsh" ]] && source "$HOME/spotify.zsh"

source <(jj util completion zsh)

nixhome () {
    nix eval "nixpkgs#legacyPackages.aarch64-darwin.${1:?usage: nixhome <package>}.meta.homepage";
}
_nixhome_complete() {
  local -a pkgs
  pkgs=(${(f)"$(
    nix eval --raw 'nixpkgs#legacyPackages.aarch64-darwin' \
      --apply 'pkgs: builtins.concatStringsSep "\n" (builtins.attrNames pkgs)' \
      2>/dev/null
  )"})
  compadd -Q -- $pkgs
}
compdef _nixhome_complete nixhome

# This should remain as the last command in file to properly profile everything
if $RUN_ZPROF; then
    zprof
fi
