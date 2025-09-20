export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt NO_BG_NICE # don't nice background tasks
setopt NO_HUP
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS # allow functions to have local options
setopt LOCAL_TRAPS # allow functions to have local traps
setopt HIST_VERIFY
setopt SHARE_HISTORY # share history between sessions ???
setopt EXTENDED_HISTORY # add timestamps to history
setopt PROMPT_SUBST
setopt CORRECT
setopt COMPLETE_IN_WORD
setopt IGNORE_EOF

setopt APPEND_HISTORY # adds history
setopt INC_APPEND_HISTORY SHARE_HISTORY  # adds history incrementally and share it across sessions
setopt HIST_IGNORE_ALL_DUPS  # don't record dupes in history
setopt HIST_REDUCE_BLANKS

# don't expand aliases _before_ completion has finished
#   like: git comm-[tab]
setopt complete_aliases

bindkey '^[^[[D' backward-word
bindkey '^[^[[C' forward-word
bindkey '^[[5D' beginning-of-line
bindkey '^[[5C' end-of-line
bindkey '^[[3~' delete-char
bindkey '^?' backward-delete-char

# set 256 colours
export TERM=xterm-256color


# zoxide (better `cd`)
# ------------------------------------------------------------------------------
if type zoxide &>/dev/null; then
  eval "$(zoxide init zsh --cmd cd)"
fi


# fzf key bindings and fuzzy completion
if type fzf &>/dev/null; then
  if fzf --help 2>&1 | grep -q -- "--zsh"; then
    source <(fzf --zsh)
  else
    for _fzf_example_dir in /usr/share/doc/fzf/examples /usr/share/doc/fzf; do
      if [[ -f "$_fzf_example_dir/key-bindings.zsh" ]]; then
        # Debian/Ubuntu packages ship helper scripts instead of the --zsh flag.
        source "$_fzf_example_dir/key-bindings.zsh"
        [[ -f "$_fzf_example_dir/completion.zsh" ]] && source "$_fzf_example_dir/completion.zsh"
        break
      fi
    done
    unset _fzf_example_dir
  fi

  if type fd &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
  fi

  export FZF_CTRL_R_OPTS="
    --color header:italic
    --height=80%
    --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
    --header 'CTRL-Y: Copy command into clipboard, CTRL-/: Toggle line wrapping, CTRL-R: Toggle sorting by relevance'
    "

  export FZF_CTRL_T_OPTS="
    --walker-skip .git,node_modules,target
    --preview 'bat -n --color=always {}'
    --bind 'ctrl-/:change-preview-window(down|hidden|)'
    --no-height
    "

  export FZF_ALT_C_OPTS="
    --walker-skip .git,node_modules,target
    --preview 'tree -C {}'
    --height=80%
    --bind 'ctrl-/:change-preview-window(down|hidden|)'
    --header 'CTRL-/: Toggle preview window position'
    "
fi
