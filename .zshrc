# startx on login on tty1
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec startx
fi

#  [[ $TERM == "tramp" ]] && unsetopt zle && PS1='$ ' && return

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# [[ $TERM == "tramp" ]] && unsetopt zle && PS1='$ ' && return
# if [[ "$TERM" == "tramp" ]]
# then
#     unsetopt zle
#     unsetopt prompt_cr
#     unsetopt prompt_subst
#     unfunction precmd
#     unfunction preexec
#     PS1='$ '
# fi
if [[ "$TERM" == "tramp" ]]
then
  unsetopt zle
  unsetopt prompt_cr
  unsetopt prompt_subst
  if whence -w precmd >/dev/null; then
      unfunction precmd
  fi
  if whence -w preexec >/dev/null; then
      unfunction preexec
  fi
  PS1='$ '
fi

function vterm_printf(){
    if [ -n "$TMUX" ]; then
	# Tell tmux to pass the escape sequences through
	# (Source: http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324)
	printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "${TERM%%-*}" = "screen" ]; then
	# GNU screen (screen, screen-256color, screen-256color-bce)
	printf "\eP\e]%s\007\e\\" "$1"
    else
	printf "\e]%s\e\\" "$1"
    fi
}
#vterm clear scrollback
if [[ "$INSIDE_EMACS" = 'vterm' ]]; then
    alias clear='vterm_printf "51;Evterm-clear-scrollback";tput clear'
fi
if [[ "$INSIDE_EMACS" = 'vterm' ]]; then
    alias clear='vterm_printf "51;Evterm-clear-scrollback";tput clear'
fi
#vterm directory tracking
function vterm_prompt_end() {
    vterm_printf "51;A$(whoami)@$(hostname):$(pwd)";
}
setopt PROMPT_SUBST
PROMPT=$PROMPT'%{$(vterm_prompt_end)%}'
PROMPT_COMMAND+=vterm_prompt_end
# TERM=xterm-256color
chpwd_functions=(${chpwd_functions[@]} "vterm_prompt_end")

export LANG=en_US.UTF-8
export FPATH=$HOME/.zinit/completions/:$FPATH
export PATH=/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:/home/chitij/.cargo/bin:/home/chitij/.local/bin/

alias sourcezsh='source ~/.zshrc'
alias sourcebash='source ~/.bashrc'
alias qr='qrencode -t ansiutf8'
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
export OMDB_API_KEY='33949ec8'

# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'
alias test='rustc --test -o test'
# export QT_AUTO_SCREEN_SCALE_FACTOR=2
# export GDK_SCALE=2

# mkdir and cd into that dir
mkcdir () {
    mkdir "$1" &&
	cd "$1"
}

# history 
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=3'
### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
	print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
	print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk

setopt promptsubst

autoload colors
colors
autoload compinit
compinit
# [[ $COLORTERM = *(24bit|truecolor)* ]] || zinit load zsh/nearcolor
zinit load romkatv/powerlevel10k

#B 
# zinit wait lucid for \
#         OMZL::git.zsh \
#   atload"unalias grv" \
#         OMZP::git
# PS1="READY >" # provide a simple prompt till the theme loads

# # C.
# zinit wait'!' lucid for \
#     OMZL::prompt_info_functions.zsh \
#     OMZT::gnzh

# zinit load marlonrichert/zsh-autocomplete
# zstyle ':autocomplete:tab:*' insert-unambiguous yes
# zstyle ':autocomplete:tab:*' widget-style menu-select
# zstyle ':autocomplete:tab:*' fzf-completion yes

zinit wait lucid for \
    zsh-users/zsh-history-substring-search \
atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma/fast-syntax-highlighting \
 blockf \
    zsh-users/zsh-completions \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

zplugin ice wait'0' lucid atload'zsh-vim-mode'
zinit load softmoth/zsh-vim-mode 
VIM_MODE_VICMD_KEY='^D'
VIM_MODE_TRACK_KEYMAP=no
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

zinit wait"!1" lucid for \
      load zimfw/utility \
      zimfw/archive \
      supercrabtree/k \
      hlissner/zsh-autopair \
      chrissicool/zsh-256color

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
