# planet-zsh. originally based on steeef from oh-my-zsh, but taken its own direction.
#
# moderately configurable. git support, recently added, can be switched on and off
# but defaults to off.
#
# steeef, the original here:
# https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/steeef.zsh-theme

setopt prompt_subst
autoload colors
colors

# some globals for options
__planetprompt_opt_git="no"
__planetprompt_opt_chroot="yes"

# grab the hostname once during startup (seriously, who changes their hostname that often?)
__planetprompt_hostname="$(hostname -s)"

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
__planetprompt_chroot=""
__planetprompt_chroot_prompt=""
[ ! -z "${SCHROOT_CHROOT_NAME}" ] && {
	__planetprompt_chroot="[chroot: ${SCHROOT_CHROOT_NAME}] "
	__planetprompt_chroot_prompt="%{$turquoise%}[%{$limegreen%}${SCHROOT_CHROOT_NAME}%{$turquoise%}]%{$reset_color%} "
}

# setup a hook to change the xterm/screen/tmux title on pwd change
function __planetprompt_update {
	case "$TERM" in
		xterm*|vte*|rxvt*)
			printf "\033]0;%s%s@%s:%s\007" "${__planetprompt_chroot}" "${USER}" "${__planetprompt_hostname%%.*}" "${PWD/#$HOME/~}"
			;;
		screen*)
			printf "\033k%s%s@%s:%s\033\\" "${__planetprompt_chroot}" "${USER}" "${__planetprompt_hostname%%.*}" "${PWD/#$HOME/~}"
			;;
	esac
}
autoload add-zsh-hook
add-zsh-hook precmd __planetprompt_update

# run it now to avoid disappointment
__planetprompt_update

# 'planet' function to edit appearance options during runtime
function planet {
	case "$1" in
		chroot)
			case "$2" in
				on)
					__planetprompt_opt_chroot="on"
					;;
				off)
					__planetprompt_opt_chroot="off"
					;;
				"")
					echo "chroot in prompt: ${__planetprompt_opt_chroot}"
					;;
				*)
					echo "Please use on/off." >&2
					;;
			esac
			;;

		git)
			case "$2" in
				on)
					__planetprompt_opt_git="on"
					;;
				off)
					__planetprompt_opt_git="off"
					;;
				"")
					echo "git data in prompt: ${__planetprompt_opt_git}"
					;;
				*)
					echo "Please use on/off." >&2
					;;
			esac
			;;

		*)
			echo "Unrecognised subcommand." >&2
			;;
	esac
}

# set the actual prompt
PROMPT=$'${__planetprompt_chroot_prompt}%{$purple%}%n%{$reset_color%}@%{$orange%}%m%{$reset_color%}:%{$limegreen%}%~%{$reset_color%}%{$reset_color%}%# '
