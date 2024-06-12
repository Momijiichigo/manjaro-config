
# Configurations

See inside the `~/.config` directory.

For the details of how to configure for each of the softwares, google 'em.


## Shell/Coding

### Alacritty

Terminal

### Fish

`~/config/fish/config.fish`
Fish shell configurations.
For most of the times, only need to look `~/config/fish/config.fish`.

- Env variables
- Completion scripts

### Neovim

entry point: `~/.config/nvim/init.vim`
It imports `~/.config/nvim/lua/init.lua`

#### Lazy plugin manager (for Neovim)

Lazy is a plugin manager for Neovim. 
It works efficiently by only loading the plugins when they are needed.

**Update** the plugins regularly by `:Lazy` 
- (Just type `:L` and press Tab, Enter.)
- You'll see the overview of the plugins.
- See the menus on the above area of the window.
- You see `Sync (S)`
- the letter in the parenthesis is the key to press to do the action.
- Press `S` to sync the plugins. (update, install, remove)

You'll see lists of plugins in `init.lua` file.
Edit and add required plugins accordingly.

#### Coc

Coc is a LSP client for Neovim. 
It manages LSPs of each languages
and gives you the completion, 
hover effects (Shift + K), etc.

Update the LSPs by `:CocUpdate`

## Desktop / Graphics

### Hyprland
`~/.config/hypr/hyprland.conf`

The Desktop Environment configurations.
Window blur, animation speed, window style, etc.

### Eww

General graphical widget software.
e.g. the dock/bar, wallpaper widgets, power menu, etc.
Highly configurable.

The entry point is the shell script: `~/.config/eww/launch_bar`.


### SWHKD

`~/.config/swhkd/swhkdrc`

Most of the keybinding configurations are placed here.
Very easy to read.

### Wofi

The launcher software that pops up when you press `Alt + Space`.
The configuration is about the styling.
