function cs() {
    cd $1 && ls .
}
# renames tmux pane to cwd
# this executes on every tmux commands
precmd () {
    tmux set -qg status-left "#S #P $(pwd)"
}
