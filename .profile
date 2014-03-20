# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/sh" ] ; then
    PATH="$HOME/sh:$PATH"
fi

mesg n
