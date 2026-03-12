export PATH="$HOME/.local/bin:$PATH"

# Keep mosh-server alive for 7 days without client contact
export MOSH_SERVER_NETWORK_TMOUT=604800

# Attach to default tmux session (or create it), detach other clients
alias ts='tmux new-session -A -D -s main'
