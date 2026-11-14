# bat.yazi

A previewer plugin for [Yazi](https://yazi-rs.github.io) to render text and code files with full syntax highlighting via [bat](https://github.com/sharkdp/bat).

It features dynamic light/dark theme switching and automatic detection for both `bat` and `batcat` executables.

## Preview

![preview](./preview.png)

## Requirements

* **Yazi** (latest version recommended)
* **bat** (or `batcat` on Debian/Ubuntu systems) installed and available in your `$PATH`.

## Installation

Recommended way to install this plugin is via [Yazi's package manager](https://yazi-rs.github.io/docs/cli#pm),

```bash
ya pkg add CColombus/bat
```

Or you can clone this repository directly into your Yazi plugins directory,

```bash
# macOS / Linux
git clone https://github.com/CColombus/bat.yazi.git ~/.config/yazi/plugins/bat.yazi

# Windows (PowerShell)
git clone https://github.com/CColombus/bat.yazi.git $env:APPDATA\yazi\config\plugins\bat.yazi
```

## Configuration

### 1. Set as Previewer (`yazi.toml`)

Edit your `~/.config/yazi/yazi.toml` file to prepend `bat` plugin as the previewer for your desired file types.

```toml
[plugin]
prepend_previewers = [
  # Broad: any text-mimed file
  { mime = "text/*",              run = "bat" },
  { mime = "application/json",    run = "bat" },
  { mime = "application/x-yaml",  run = "bat" },
  { mime = "application/toml",    run = "bat" },

  # Fallback globs for extensions that mime detection may miss
  { url = "*.rs",       run = "bat" },
  { url = "*.go",       run = "bat" },
  { url = "*.py",       run = "bat" },
  { url = "*.js",       run = "bat" },
  { url = "*.ts",       run = "bat" },
  { url = "*.tsx",      run = "bat" },
  { url = "*.jsx",      run = "bat" },
  { url = "*.lua",      run = "bat" },
  { url = "*.sh",       run = "bat" },
  { url = "*.c",        run = "bat" },
  { url = "*.cpp",      run = "bat" },
  { url = "*.h",        run = "bat" },
  { url = "*.html",     run = "bat" },
  { url = "*.htm",      run = "bat" },
  { url = "*.md",       run = "bat" },
  { url = "*.vhd",      run = "bat" },
  { url = "*.vhdl",     run = "bat" },
  { url = "*.v",        run = "bat" }
  # ...add your own
]

```

### 2. Plugin Options (`init.lua`)

You can optionally customize how `bat` renders your files by configuring the plugin in your `~/.config/yazi/init.lua` file.

```lua
require("bat"):setup({
    theme_dark  = "Dracula",        -- Theme applied when Yazi detects a dark terminal
    theme_light = "OneHalfLight",   -- Theme applied when Yazi detects a light terminal
    style       = "numbers,grid",   -- Passed to bat's --style flag (defaults to "plain")
    wrap        = "never",          -- Passed to bat's --wrap flag (defaults to "never")
})

```

>[!tip]
>
>### Theme Options
>
>You can specify any theme that is available in your `bat` installation. To see a list of available themes, run:
>
>```bash
>bat --list-themes
>```
>
>If no theme is specified, the plugin will use `bat`'s default theme and if you want to use the same theme for both light and dark modes, you can just set `theme_dark` and leave `theme_light` unset.
>
>### Style Options
>
>The `style` option is same as `bat`'s `--style` flag and can be a comma-separated list of the following components:
>
>| Component | Description |
>| ----------- | ------------- |
>| `changes` | Show Git modification markers. |
>| `header` | Alias for `header-filename`. |
>| `header-filename` | Show filenames before the content. |
>| `header-filesize` | Show file sizes before the content. |
>| `grid` | Vertical/horizontal lines to separate the side bar and header from the content. |
>| `rule` | Horizontal lines to delimit files. |
>| `numbers` | Show line numbers in the side bar. |
>| `snip` | Draw separation lines between distinct line ranges. |
>
>Or you can specify one of the pre-defined styles:
>
>| Style | Description |
>| ------- | ------------- |
>| `default` | Enables the recommended style components listed above. |
>| `full` | Enables all available components. |
>| `auto` | Same as `default`, unless the output is piped. |
>| `plain` | Disables all available components. |
>
>If no style is specified, the plugin will default to `plain` style.
>
>### Wrap Options
>
>The `wrap` option is same as `bat`'s `--wrap` flag and can be either `never` or `character`. If no wrap option is specified, the plugin will default to `never`.

## References

* [Yazi - A fast terminal file manager](https://yazi-rs.github.io)
* [bat - A cat(1) clone with wings](https://github.com/sharkdp/bat)

## Acknowledgements

* [edden27 / dog.yazi](https://github.com/edden27/dog.yazi) - Inspired this plugin's implementation.
