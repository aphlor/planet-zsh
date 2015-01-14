# steeef theme from oh-my-zsh with all of the vcs, virtualisation stuff ripped out.
# multiline put onto a single line. at/in replaced by @ and :. looks like a debian
# bash prompt, doesn't it?
#
# original here:
# https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/steeef.zsh-theme

setopt prompt_subst
autoload colors
colors

_prompt_hostname="$(hostname -s)"

# use extended color pallete if available
case "$TERM" in
	*-256color)
		turquoise="%F{81}"
		orange="%F{166}"
		purple="%F{135}"
		hotpink="%F{161}"
		limegreen="%F{118}"
		;;
	*)
		turquoise="$fg[cyan]"
		orange="$fg[yellow]"
		purple="$fg[magenta]"
		hotpink="$fg[red]"
		limegreen="$fg[green]"
		;;
esac

# setup a hook to change the xterm/screen/tmux title on pwd change
function update_term_title {
	case "$TERM" in
		xterm*|vte*|rxvt*)
			printf "\033]0;%s@%s:%s\007" "${USER}" "${_prompt_hostname%%.*}" "${PWD/#$HOME/~}"
			;;
		screen*)
			printf "\033k%s@%s:%s\033\\" "${USER}" "${_prompt_hostname%%.*}" "${PWD/#$HOME/~}"
			;;
	esac
}
autoload add-zsh-hook
add-zsh-hook chpwd update_term_title

# run it now to avoid disappointment
update_term_title

# set the actual prompt
PROMPT=$'%{$purple%}%n%{$reset_color%}@%{$orange%}%m%{$reset_color%}:%{$limegreen%}%~%{$reset_color%}%{$reset_color%}%# '
