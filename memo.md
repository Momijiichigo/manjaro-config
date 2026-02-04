- install `yay`: `pacman -S yay`
- install Rustup from the officially recommended way: https://rust-lang.org/tools/install/
- copy the `workspace/rust` to your workspace directly (I use `~/workspace/aur/rust`)
  - move to that directory: `cd ~/workspace/aur/rust`
  - then run `makepkg . --install`

- install packages in `./yay_package_list`:
  - `yay -S --needed - < ./yay_package_list`
- copy the configs
  - recommended:
    - alacritty
    - fish
    - nvim
    - hypr
    - eww
    - rofi
    - swaync
  - copy the `.cargo/config.toml` to `~/.cargo/config.toml` for faster builds (using `mold`)

- change the default shell to fish:
  - `chsh -s /usr/bin/fish`

- If you want my powerline, `git clone` [this repo](https://github.com/Momijiichigo/powerline-rust) to your workspace, then build and install it:
  - `cargo install --path . --no-default-features --features=bare-shell,libgit`
  - And un-comment out the `function fish_prompt` in `~/.config/fish/config.fish`


# Configurations

See inside the `~/.config` directory.

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

#### KMSCON

`~/.config/kmscon/kmscon.conf`:

```
font-name=FiraCode Nerd Font, DejaVu Sans Mono, Source Han Sans JP
font-size=18
```
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

### Rofi

The launcher software that pops up when you press `Alt + Space`.
The configuration is about the styling.
