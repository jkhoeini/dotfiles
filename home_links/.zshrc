# Change to true to do a profiling on shell load
RUN_ZPROF=false

# This should remain at the top of file to do a proper profiling
if $RUN_ZPROF; then
    zmodload zsh/zprof
fi

# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"
export HOMEBREW_EVAL_ALL=1

export PATH="$HOME/.local/bin/:$HOME/.poetry/bin:$HOME/.cargo/bin:$HOME/.deno/bin:/usr/local/bin:$PATH"


# Added by Toolbox App
export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"

source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"

export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_EXECUTABLE_PATH=`which chromium`

# NOTE disabled for performance
# PONYSAY="$(shuf -n 1 -e ponysay ponythink) -f $(shuf -n 1 -e $(ponysay --all | grep -v 'ponies located in'))"
# COWSAY="$(shuf -n 1 -e cowsay cowthink) -$(shuf -n 1 -e b d g p s t w y) -f $(shuf -n 1 -e $(cowsay -l | tail -n +2)) -n | lolcat"
# fortune | eval $(shuf -n 1 -e "$PONYSAY" "$COWSAY" $(jot -b cat 20))

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# NOTE disabled for performance
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle :compinstall filename "$HOME/.zshrc"

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

# End of lines added by compinstall
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


# ENV Configs

export EDITOR='nvim'


# Antidote

source "$(brew --prefix)/share/antidote/antidote.zsh"
antidote load ~/.config/antidote/plugins.txt


# Aliases

source ~/.zsh_aliases


# Configs

autoload -U promptinit; promptinit
prompt pure

if [[ -e  "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc" ]]; then
    source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
fi

bindkey '^T' fzf-file-widget
bindkey '^R' fzf-history-widget
# bindkey '^I' fzf-completion
bindkey '^K' per-directory-history-toggle-history

# bun completions
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

eval "$(mise activate zsh)"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

export PATH=$HOME/dotemacs/doom/bin:$PATH

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# NOTE disabled for performance
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true

# Mojo setup
export MODULAR_HOME="$HOME/.modular"
export PATH="$HOME/.modular/pkg/packages.modular.com_mojo/bin:$PATH"

# NOTE disabled for performance
# eval $(luarocks path)
# Replaced with these lines instead from the output of the above
export LUA_PATH='/opt/homebrew/Cellar/luarocks/3.12.2/share/lua/5.4/?.lua;/opt/homebrew/share/lua/5.4/?.lua;/opt/homebrew/share/lua/5.4/?/init.lua;/opt/homebrew/lib/lua/5.4/?.lua;/opt/homebrew/lib/lua/5.4/?/init.lua;./?.lua;./?/init.lua;$HOME/.luarocks/share/lua/5.4/?.lua;$HOME/.luarocks/share/lua/5.4/?/init.lua'
export LUA_CPATH='/opt/homebrew/lib/lua/5.4/?.so;/opt/homebrew/lib/lua/5.4/loadall.so;./?.so;$HOME/.luarocks/lib/lua/5.4/?.so'
export PATH="$HOME/.luarocks/bin:$PATH"

# help cursor-ide detect command is finished
PROMPT_EOL_MARK=“”
[[ -s "$HOME/.iterm2_shell_integration.zsh" ]] && source "$HOME/.iterm2_shell_integration.zsh"

export GEMINI_API_KEY=$(security find-generic-password -a $USER -s GEMINI_API_KEY -w)

[ -n "$EAT_SHELL_INTEGRATION_DIR" ] && \
  source "$EAT_SHELL_INTEGRATION_DIR/zsh"

[[ -s "$HOME/spotify.zsh" ]] && source "$HOME/spotify.zsh"

source <(jj util completion zsh)

export PATH="$PATH:/Users/mohammadk/Library/Application Support/Coursier/bin"

# Added by Antigravity
export PATH="/Users/mohammadk/.antigravity/antigravity/bin:$PATH"

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
