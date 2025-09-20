function cs() {
    local target=${1:-}
    if [ -z "$target" ]; then
        cd "$PROJECTS" && ls .
    else
        cd "$PROJECTS/$target" && ls .
    fi
}
