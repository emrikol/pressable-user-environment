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

SITE_NAME=$(wp --skip-plugins --skip-themes option get blogname 2>/dev/null)
EDITOR=nano

# -------------------------------
# Set up prompt
# -------------------------------

export PS1="\[\e[36m\]\u\[\e[37m\]@\[\e[32m\]$DOMAIN_NAME:\[\e[33m\]\w\[\e[37m\]\$ "
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

# Tail PHP logs
alias logs='tail -F /tmp/php-errors'

# LS settings
alias ls="ls --color=auto"

# -------------------------------
# Custom Functions
# -------------------------------

# Update bashrc from GitHub!
function update_bashrc() {
	if curl -s -f -o ~/.bashrc https://raw.githubusercontent.com/emrikol/pressable-user-environment/main/.bashrc; then
		source ~/.bashrc
		echo "Updated .bashrc successfully"
	else
		echo "Failed to download .bashrc from GitHub"
	fi
}

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
