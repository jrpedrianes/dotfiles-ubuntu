Jorge Rodríguez Pedrianes' dotfiles
===================================

Personal dotfiles to configure Ubuntu on a Slimbook laptop.

This project is based on the great project of [@felipecrs](https://github.com/felipecrs), kudos for that great job 👏.

https://github.com/felipecrs/dotfiles/tree/master

Pending parts to script
-------------------------

https://www.virtualbox.org/wiki/Linux_Downloads

https://gist.github.com/the-spyke/2de98b22ff4f978ebf0650c90e82027e?permalink_comment_id=3976215

### JetBrains Toolbox Installation

Installing JetBrains Toolbox manually from https://www.jetbrains.com/toolbox-app/

Current steps:
1. Download the Toolbox App from the official website
2. Extract the downloaded archive
3. Execute the binary
4. **Issue**: The app should automatically copy itself to `$HOME/.local/share/JetBrains/Toolbox/bin` but this is not happening
5. **Workaround**: Manually copying the binary to the expected directory

Reference: https://www.jetbrains.com/help/toolbox-app/toolbox-app-silent-installation.html#toolbox_linux

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
