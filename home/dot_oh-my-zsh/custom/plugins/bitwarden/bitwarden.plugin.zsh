# According to the standard:
# https://github.com/zdharma/Zsh-100-Commits-Club/blob/master/Zsh-Plugin-Standard.adoc
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"

if (( ! $+commands[bw] )); then
  return
fi

export BITWARDENCLI_APPDATA_DIR="$HOME/.config/Bitwarden_CLI"

if [[ ! -f "$ZSH_CACHE_DIR/completions/_bw" ]]; then
  typeset -g -A _comps
  autoload -Uz _bw
  _comps[bw]=_bw
fi

bw completion --shell zsh >| "$ZSH_CACHE_DIR/completions/_bw" &|

source ${0:h}/bitwarden.zsh
