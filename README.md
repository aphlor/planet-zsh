Planet theme for zsh
====================

### What?

It's a theme for zsh. It was intended to be a slimmed down version of [steeef](https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/steeef.zsh-theme) from [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh/).

Features:
* git branch in prompt, off by default for speed reasons, turn on with ```planet git on```
* schroot name in prompt, on by default, turn off with ```planet chroot off```
* Looks like a slightly more colourful standard Debian bash prompt
* xterm/screen/tmux title handling with ```precmd``` hook

### Installation

Use [antigen](http://antigen.sharats.me) to install this theme.

```antigen theme aphlor/planet-zsh planet```

oh-my-zsh is not required. Purists can store and source the theme directly if they wish.
