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
__planetprompt_opt_git="${__planetprompt_opt_git:-off}"
__planetprompt_opt_chroot="${__planetprompt_opt_chroot:-on}"
__planetprompt_opt_shade="${__planetprompt_opt_shade:-dark}"

# grab the hostname once during startup (seriously, who changes their hostname that often?)
__planetprompt_hostname="$(hostname -s)"

# use extended color pallete if available
case "$TERM" in
	*-256color)
		# fancy shmancy 256-colour palette
		turquoise="%F{81}"
		orange="%F{166}"
		purple="%F{135}"
		hotpink="%F{161}"
		limegreen="%F{118}"

		[ "$__planetprompt_opt_shade" = "light" ] && {
			# override some colours in the light variant
			turquoise="%F{69}"
			limegreen="%F{106}"
		}
		;;
	*)
		# standard 16-colour palette
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
__planetprompt_chroot_stub=""
[ ! -z "${SCHROOT_CHROOT_NAME}" ] && {
	__planetprompt_chroot="[${SCHROOT_CHROOT_NAME}] "
	__planetprompt_chroot_stub="%{$turquoise%}[%{$limegreen%}${SCHROOT_CHROOT_NAME}%{$turquoise%}]%{$reset_color%} "
}

# set this up so we don't hit an undefined env variable
__planetprompt_git_prompt=""

# setup a hook to change the xterm/screen/tmux title on pwd change
function __planetprompt_update {
	# these are the symbols we use in the prompt to indicate git "things"
	local __git_char_branch=$'\ue0a0'
	local __git_char_tag=$'\u2302'
	local __git_char_ref=$'\u25cc'

	# xterm/screen titles
	case "$TERM" in
		xterm*|vte*|rxvt*)
			printf "\033]0;%s%s@%s:%s\007" "${__planetprompt_chroot}" "${USER}" "${__planetprompt_hostname%%.*}" "${PWD/#$HOME/~}"
			;;
		screen*)
			printf "\033k%s%s@%s:%s\033\\" "${__planetprompt_chroot}" "${USER}" "${__planetprompt_hostname%%.*}" "${PWD/#$HOME/~}"
			;;
	esac

	# if chroot-in-prompt is enabled, set or unset the snippet
	if [ "$__planetprompt_opt_chroot" = "on" ]; then
		__planetprompt_chroot_prompt="$__planetprompt_chroot_stub"
	else
		__planetprompt_chroot_prompt=""
	fi

	# if git is enabled, incorporate into the prompt
	if [ "$__planetprompt_opt_git" = "on" ]; then
		local __git_dir="$(git rev-parse --git-dir 2>/dev/null)"
		if [ -n "$__git_dir" ]; then
			# we have teh git
			local __git_meta="$(git symbolic-ref --short HEAD 2>/dev/null)"
			local __git_char="$__git_char_branch"

			if [ -z "$__git_meta" ]; then
				# the "branch" is empty, this might be a tag. let's find out.
				__git_meta="$(git describe --tags --exact-match 2>/dev/null)"
				__git_char="$__git_char_tag"
			fi

			if [ -z "$__git_meta" ]; then
				# ok, best guess time. it's not a branch, not a tag, this is likely a detached ref.
				__git_meta="$(git rev-parse --short HEAD 2>/dev/null)"
				__git_char="$__git_char_ref"
			fi

			__planetprompt_git_prompt="%{$turquoise%}(%{$limegreen%}$__git_char%{$purple%}$__git_meta%{$turquoise%})%{$reset_color%} "
		else
			# not in a git repo, clear the prompt
			__planetprompt_git_prompt=""
		fi
	else
		__planetprompt_git_prompt=""
	fi
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
					if command -v git >/dev/null; then
						__planetprompt_opt_git="on"
					else
						echo "Can't find 'git' executable. Won't enable git prompt stub." >&2
					fi
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
PROMPT=$'${__planetprompt_chroot_prompt}${__planetprompt_git_prompt}%{$purple%}%n%{$reset_color%}@%{$orange%}%m%{$reset_color%}:%{$limegreen%}%~%{$reset_color%}%{$reset_color%}%# '
