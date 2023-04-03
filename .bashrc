#!/bin/bash

# -------------------------------
# If not running interactively,
# don't do anything and
# return early. Stops SFTP error
# 'Received message too long'
# -------------------------------
[[ $- == *i* ]] || return

# -------------------------------
# Set up variables
# -------------------------------

SITE_NAME=$(wp option get blogname)
SITE_HOST=$(wp --skip-plugins --skip-themes option get home | grep -oP '(?<=//)[^/]+' | sed 's/\r//')

if [[ $(hostname) == "localhost" ]]; then
	SRV_HOSTNAME="$SITE_HOST"
else
	SRV_HOSTNAME=$(hostname)
fi

# -------------------------------
# Set up prompt
# -------------------------------

export PS1="\[\e[36m\]\u\[\e[37m\]@\[\e[32m\]$SRV_HOSTNAME:\[\e[33m\]\w\[\e[37m\]\$ "
export PS2="| => "

# -------------------------------
# iTerm integration
# -------------------------------

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash" || true
source ~/.iterm2_shell_integration.bash

# Adds hostname title and badge to iTerm2
printf "\e]1337;SetBadgeFormat=%s\a" $(echo -n "Pressable: $SITE_NAME" | base64)
echo -ne "\033]0;VIP: $SITE_NAME\007"

# -------------------------------
# Aliases
# -------------------------------

# ack isn't installed, fall back to grep.
function ack() {
	if which ack >/dev/null 2>&1; then
		# run the original ack command
		command ack "$@"
	else
		# run grep instead
		grep --color -rHn "$@"
	fi
}

# Tail PHP logs
alias logs='tail -F /tmp/php-errors'

# LS settings
alias ls="ls --color=auto"
