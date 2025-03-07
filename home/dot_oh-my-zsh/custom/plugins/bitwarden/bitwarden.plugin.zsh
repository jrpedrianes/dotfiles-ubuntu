# According to the standard:
# https://github.com/zdharma-continuum/Zsh-100-Commits-Club/blob/master/Zsh-Plugin-Standard.adoc
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# Do nothing if op is not installed
if (( ! $+commands[bw] )); then
  return
fi

export BITWARDENCLI_APPDATA_DIR="$HOME/.config/Bitwarden_CLI"

source ${0:h}/bitwarden.zsh

## If the completion file doesn't exist yet, we need to autoload it and
## bind it to `bw`. Otherwise, compinit will have already done that.
# if [[ ! -f "$ZSH_CACHE_DIR/completions/_bw" ]]; then
#   typeset -g -A _comps
#   autoload -Uz _bw
#   _comps[bw]=_bw
# fi
#
# bw completion --shell zsh >| "$ZSH_CACHE_DIR/completions/_bw" &|

# eval "$(bw completion --shell zsh); compdef _bw bw;"
