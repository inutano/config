# .zshrc

# History "{{{1
HISTFILE=${HOME}/.zsh_history
SAVEHIST=10000
HISTSIZE=10000
setopt append_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_nodups
setopt share_history

# Directory "{{{1
DIRSTACKSIZE=8
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_minus
setopt pushd_silent
setopt pushd_to_home

# Completion "{{{1
LISTMAX=0
setopt complete_aliases
setopt complete_in_word
setopt extendedglob
unsetopt list_ambiguous
setopt list_packed
setopt list_types
setopt mark_dirs
setopt numeric_glob_sort
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:warnings' format 'No matches'

autoload -U compinit
compinit -u

# Prompt "{{{1
autoload -U colors; colors
setopt prompt_subst
unsetopt transient_rprompt

DEFAULT=$'%n@%m:%(5~,%-2~/.../%2~,%~) \U1F423 '
SUCCESS=$'%n@%m:%(5~,%-2~/.../%2~,%~) \U1F425 '
ERROR=$'%n@%m:%(5~,%-2~/.../%2~,%~) \U1F373 '
PROMPT=$'%(?.%F{yellow}${DEFAULT}.%F{red}${ERROR})%{$reset_color%} '
#PROMPT=$'%($bg[yellow].${DEFAULT})%(?.%($bg[blue].${SUCCESS}).%($bg[red].${ERROR})) '

#if [ $SSH_CONNECTION ] || [ $REMOTEHOST ]; then
#  PROMPT='%{%(!.$bg[default].%(?.$bg[blue].$bg[blue]))%}%n@%m:%(5~,%-2~/.../%2~,%~)%#%{$reset_color%} '
#  RPROMPT='%{%(!.$bg[default].%(?.$bg[blue].$bg[blue]))%}[`date +%Y/%m/%d` %T]%{$reset_color%}'
#else
#  PROMPT='%{%(!.$bg[default].%(?.$bg[yellow].$bg[yellow]))%}%n@%m:%(5~,%-2~/.../%2~,%~)%#%{$reset_color%} '
#  RPROMPT='%{%(!.$bg[default].%(?.$bg[yellow].$bg[yellow]))%}[`date +%Y/%m/%d` %T]%{$reset_color%}'
#fi

# Misc "{{{1
umask 022
limit coredumpsize 0
stty erase '^h'
stty kill '^g'
stty stop 'undef'

bindkey -e

setopt bad_pattern
unsetopt beep
setopt c_bases
setopt check_jobs
unsetopt clobber
unsetopt flow_control
setopt ignore_eof
setopt long_list_jobs
setopt print_eightbit

autoload -U tetris; zle -N tetris

# History search "{{{1
autoload -U  up-line-or-beginning-search
zle      -N  up-line-or-beginning-search
bindkey '^P' up-line-or-beginning-search

autoload -U  down-line-or-beginning-search
zle      -N  down-line-or-beginning-search
bindkey '^N' down-line-or-beginning-search

# Abbreviation "{{{1
typeset -A myAbbrev
myAbbrev=(
"L" "| less"
"G" "| grep"
"H" "| head"
"T" "| tail"
"W" "| wc"
"A" "| awk"
"S" "| sed"
"Y" "yes |"
"...." "../.."
)
function my-expand-abbrev() {
  emulate -L zsh
  setopt extendedglob
  typeset MATCH
  LBUFFER="${LBUFFER%%(#m)[^[:blank:]]#}${myAbbrev[${MATCH}]:-${MATCH}}${KEYS}"
}
zle -N my-expand-abbrev
bindkey " " my-expand-abbrev

# For GNU screen "{{{1
if [ "$TERM" = "screen" ]; then
  chpwd () { echo -n "_`dirs`\\" }
  preexec() {
    emulate -L zsh
    local -a cmd; cmd=(${(z)2})
    case $cmd[1] in
      fg)
      if (( $#cmd == 1 )); then
        cmd=(builtin jobs -l %+)
      else
        cmd=(builtin jobs -l $cmd[2])
      fi
      ;;
      %*)
      cmd=(builtin jobs -l $cmd[1])
      ;;
      cd)
      if (( $#cmd == 2)); then
        cmd[1]=$cmd[2]
      fi
      ;&
      *)
      echo -n "k$cmd[1]:t\\"
      return
      ;;
    esac

    local -A jt; jt=(${(kv)jobtexts})

    $cmd >>(read num rest
    cmd=(${(z)${(e):-¥$jt$num}})
    echo -n "k$cmd[1]:t\\") 2>/dev/null
  }
  chpwd
fi

if [ "$TERM" = "screen" ]; then
  precmd(){
    screen -X title $(basename $(print -P "%~"))
  }
fi

# Aliases "{{{1
setopt aliases
alias ls='gls -F --color=auto'
alias ll='gls -lhF --color=auto'
alias la='gls -aF --color=auto'
alias lla='gls -laF --color=auto'
alias x='exit'
alias mv='mv -i'
alias cp='cp -i'
alias rm='rm -i'
alias dirs='dirs -v'
alias pd='popd'
alias ud='cd ../'
alias s='screen -R'
alias v='vim'
alias r='R'
alias emacs='open -a /Applications/Emacs.app'
alias n='nano -x'
alias nv='nano -xv'
alias tawk='awk -F "\t"'

# configuration for boxen
[ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh
[ -f /opt/boxen/nvm/nvm.sh ] && source /opt/boxen/nvm/nvm.sh

# zsh-notify
autoload -U add-zsh-hook
source ~/.zsh.d/zsh-notify/notify.plugin.zsh
export SYS_NOTIFIER="/opt/boxen/homebrew/bin/terminal-notifier"
export NOTIFY_COMMAND_COMPLETE_TIMEOUT=17
