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

# if we are working in a chroot, set up some snippets to show the chroot
_chroot_snippet=""
_chroot_prompt_snippet=""
[ ! -z "${SCHROOT_CHROOT_NAME}" ] && {
	_chroot_snippet="[chroot: ${SCHROOT_CHROOT_NAME}] "
	_chroot_prompt_snippet="%{$turquoise%}[%{$limegreen%}${SCHROOT_CHROOT_NAME}%{$turquoise%}]%{$reset_color%} "
}

# setup a hook to change the xterm/screen/tmux title on pwd change
function update_term_title {
	case "$TERM" in
		xterm*|vte*|rxvt*)
			printf "\033]0;%s%s@%s:%s\007" "${_chroot_snippet}" "${USER}" "${_prompt_hostname%%.*}" "${PWD/#$HOME/~}"
			;;
		screen*)
			printf "\033k%s%s@%s:%s\033\\" "${_chroot_snippet}" "${USER}" "${_prompt_hostname%%.*}" "${PWD/#$HOME/~}"
			;;
	esac
}
autoload add-zsh-hook
add-zsh-hook precmd update_term_title

# run it now to avoid disappointment
update_term_title

# set the actual prompt
PROMPT=$'${_chroot_prompt_snippet}%{$purple%}%n%{$reset_color%}@%{$orange%}%m%{$reset_color%}:%{$limegreen%}%~%{$reset_color%}%{$reset_color%}%# '
