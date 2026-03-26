Jorge Rodríguez Pedrianes' dotfiles
===================================

Personal dotfiles to configure Ubuntu on a Slimbook laptop.

This project is based on the great project of [@felipecrs](https://github.com/felipecrs), kudos for that great job 👏.

https://github.com/felipecrs/dotfiles/tree/master

Pending parts to script
-------------------------

### JetBrains Toolbox Installation

Installing JetBrains Toolbox manually from https://www.jetbrains.com/toolbox-app/

Current steps:
1. Download the Toolbox App from the official website
2. Extract the downloaded archive
3. Execute the binary
4. **Issue**: The app should automatically copy itself to `$HOME/.local/share/JetBrains/Toolbox/bin` but this is not happening
5. **Workaround**: Manually copying the binary to the expected directory

Reference: https://www.jetbrains.com/help/toolbox-app/installation.html#toolbox_linux

### JetBrains Toolbox Configuration for Xorg

Although the system supports Wayland, I'm using Xorg. To prevent JetBrains Toolbox from being slow (fractional scaling seems
to cause performance issues), add the following configuration to `${HOME}/.local/share/JetBrains/Toolbox/.settings.json`:

```json
{
  "internal": {
    "graphics_api": "Software"
  }
}
```

### Wayland Configuration for JetBrains IDEs

Since I'm using Wayland, I need to configure the IDE settings to avoid blurry rendering:

Add the following VM option to the IDE settings:

```
-Dawt.toolkit.name=WLToolkit
```
