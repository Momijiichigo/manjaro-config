set -x DENO_INSTALL $HOME/.deno

set -x EDITOR /usr/bin/nvim

set -x VIRTUAL_ENV_DISABLE_PROMPT 1

fish_add_path $DENO_INSTALL/bin
fish_add_path $HOME/.cargo/bin
# fish_add_path $HOME/.elan/bin
# fish_add_path $JAVA_HOME/bin

# function fish_prompt
#     $HOME/.cargo/bin/powerline $status
# end



if status is-interactive
    # Commands to run in interactive sessions can go here
end

function spt
  /usr/bin/spotifyd
  /usr/bin/spt
end

function y
  set tmp (mktemp -t "yazi-cwd.XXXXXX")
  yazi $argv --cwd-file="$tmp"
  if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
    builtin cd -- "$cwd"
  end
  rm -f -- "$tmp"
end


