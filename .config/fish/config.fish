set -x DENO_INSTALL $HOME/.deno
set -x WINEPREFIX $HOME/.proton/Proton Experimental/pfx
set -U SXHKD_SHELL sh


fish_add_path $DENO_INSTALL/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.elan/bin
# fish_add_path $JAVA_HOME/bin

function fish_prompt
    $HOME/.cargo/bin/powerline $status
end


#if test -n "$DESKTOP_SESSION"
#    for env_var in (gnome-keyring-daemon --start)
#        set -x (echo $env_var | string split "=")
#    end
#end

if status is-interactive
    # Commands to run in interactive sessions can go here
end

function spt
  /usr/bin/spotifyd
  /usr/bin/spt
end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# eval /home/daichi/anaconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<


# pnpm
set -gx PNPM_HOME "/home/daichi/.local/share/pnpm"
fish_add_path $PNPM_HOME
# pnpm end
