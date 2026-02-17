export EDITOR='nano'
export PATH=$HOME/.local/bin:/opt/homebrew/bin:/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH
export LC_ALL=en_US.UTF-8
export CLICOLOR=1

# rbenv (lazy-loaded)
[ -d "$HOME/.rbenv/bin" ] && export PATH="$HOME/.rbenv/bin:$PATH"
__init_rbenv() {
  unset -f ruby gem irb bundle rake rbenv
  eval "$(rbenv init -)"
}
for _cmd in ruby gem irb bundle rake rbenv; do
  eval "${_cmd}() { __init_rbenv && ${_cmd} \"\$@\"; }"
done
unset _cmd

# nvm (lazy-loaded)
export NVM_DIR="$HOME/.nvm"
__init_nvm() {
  unset -f node npm npx nvm yarn pnpm
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
}
for _cmd in node npm npx nvm yarn pnpm; do
  eval "${_cmd}() { __init_nvm && ${_cmd} \"\$@\"; }"
done
unset _cmd

# History settings
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth:erasedups
shopt -s histappend
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

# eggshausted prompt
__egg_prompt() {
  local last_exit=$?

  # Colors (256-color support)
  local reset='\[\e[0m\]'
  local c_user c_dir c_git c_time c_err
  if [[ "$TERM" == *256color* ]]; then
    c_user='\[\e[38;5;109m\]'
    c_dir='\[\e[38;5;143m\]'
    c_git='\[\e[38;5;109m\]'
    c_time='\[\e[38;5;109m\]'
    c_err='\[\e[38;5;124m\]'
  else
    c_user='\[\e[36m\]'
    c_dir='\[\e[32m\]'
    c_git='\[\e[36m\]'
    c_time='\[\e[36m\]'
    c_err='\[\e[31m\]'
  fi

  # User@host
  local p_user="${c_user}\u@\h${reset}"

  # Directory (red on error)
  local dir_color="${c_dir}"
  [ $last_exit -ne 0 ] && dir_color="${c_err}"
  local p_dir="${dir_color}\w${reset}"

  # Git branch + dirty
  local p_git=""
  local branch
  branch=$(command git symbolic-ref --short HEAD 2>/dev/null || command git describe --tags --exact-match HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    local dirty=""
    [ -n "$(command git status --porcelain -unormal --ignore-submodules=dirty 2>/dev/null)" ] && dirty="*"
    p_git="${c_git}${branch}${dirty}${reset} "
  fi

  # Symbol: 🐣 on success, 🍳 on error
  local symbol
  [ $last_exit -eq 0 ] && symbol=$'\xF0\x9F\x90\xA3  ' || symbol=$'\xF0\x9F\x8D\xB3  '

  # Time
  local p_time="${c_time}\t${reset}"

  # Terminal title
  printf '\e]0;%s@%s:%s\a' "$USER" "$HOSTNAME" "${PWD/#$HOME/~}"

  PS1="${p_user} ${p_dir} ${p_git}${symbol}${p_time} "
}
PROMPT_COMMAND="__egg_prompt;${PROMPT_COMMAND}"

# Aliases
alias x='exit'
alias mv='mv -i'
alias cp='cp -i'
alias rm='rm -i'
alias dirs='dirs -v'
alias n='nano -x'
alias nv='nano -xv'
alias tawk='awk -F "\t"'
alias dockr='docker run --rm -it -v $(pwd):/work -w /work'

# conda (lazy-loaded)
__init_conda() {
  unset -f conda mamba
  local __conda_setup
  __conda_setup="$('/Users/inutano/repos/miniforge3/bin/conda' 'shell.bash' 'hook' 2>/dev/null)"
  if [ $? -eq 0 ]; then
    eval "$__conda_setup"
  elif [ -f "/Users/inutano/repos/miniforge3/etc/profile.d/conda.sh" ]; then
    . "/Users/inutano/repos/miniforge3/etc/profile.d/conda.sh"
  else
    export PATH="/Users/inutano/repos/miniforge3/bin:$PATH"
  fi
}
conda() { __init_conda && conda "$@"; }
mamba() { __init_conda && mamba "$@"; }

source /Users/inutano/.docker/init-bash.sh || true # Added by Docker Desktop

# Tmux: attach or create default session
alias ts='tmux new-session -A -s default'
