if (( ! $+commands[chezmoi] )); then
  return
fi

if [[ ! -f "$ZSH_CACHE_DIR/completions/_chezmoi" ]]; then
  typeset -g -A _comps
  autoload -Uz _chezmoi
  _comps[chezmoi]=_chezmoi
fi

chezmoi completion zsh >| "$ZSH_CACHE_DIR/completions/_chezmoi" &|
