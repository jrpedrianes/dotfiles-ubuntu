if (( ! $+commands[switcher] )); then
  return
fi

# Load kubectl switcher. https://github.com/danielfoehrKn/kubeswitch
source <(switcher init zsh)
source <(switch completion zsh)
