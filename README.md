Planet theme for zsh
====================

### What?

It's a theme for zsh. It was intended to be a slimmed down version of [steeef](https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/steeef.zsh-theme) from [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh/).

Features:
* git branch in prompt, off by default for speed reasons, turn on with `planet git on`
* schroot name in prompt, on by default, turn off with `planet chroot off`
* Looks like a slightly more colourful standard Debian bash prompt
* `xterm`/`screen`/`tmux` title handling with `precmd` hook

### Installation

Use [antigen](http://antigen.sharats.me) to install this theme.

> ```antigen theme aphlor/planet-zsh planet```

oh-my-zsh is not required. Purists can store and source the theme directly if they wish.

### How do I do a use with this?

Three variables define how the prompt appears by default. You can set them up in your `.zshrc` or `.zprofile` prior to the planet theme being activated.

| Option                      | Values         | Description                                                        |
|-----------------------------|----------------|--------------------------------------------------------------------|
| `__planetprompt_opt_git`    | `on`/`off`     | Enable or disable the `git` prompt support. Defaults to `off`.     |
| `__planetprompt_opt_chroot` | `on`/`off`     | Display the current `schroot` in the prompt. Defaults to `off`.    |
| `__planetprompt_opt_shade`  | `dark`/`light` | Adjust the colours for background suitability. Defaults to `dark`. |

`git` and `chroot` can also be adjusted during normal shell operation. For example, to turn on git prompt:

> `planet git on`

And to turn off chroot display:

> `planet chroot off`

Values do not persist between shell sessions.
