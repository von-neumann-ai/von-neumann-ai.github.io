#!/usr/bin/env bash
cd $HOME
set -e

# Miniconda3
if [ ! -d ~/miniconda3 ]; then
	echo "==> Installing Python/Miniconda"
	wget https://repo.anaconda.com/miniconda/Miniconda3-py311_24.7.1-0-Linux-x86_64.sh
	bash Miniconda3-py311_24.7.1-0-Linux-x86_64.sh -b
	. ~/miniconda3/etc/profile.d/conda.sh
	conda init
	rm Miniconda3-py311_24.7.1-0-Linux-x86_64.sh
else
	echo "==> Miniconda3 already installed. Skipping"
fi


# NVM
if [ ! -d ~/.config/nvm ]; then
	echo "==> Installing Node/NVM"
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
	. ~/.config/nvm/nvm.sh
	nvm install --lts
else
	echo "==> NVM already installed. Skipping"
fi

# TMUX conf
if [ ! -f ~/.tmux.conf ]; then
	echo "==> Applying default tmux configuration"
	tee ~/.tmux.conf << END
set -g mouse on

unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix
END

else
	echo "==> Tmux configuation found. Skipping"
fi

# FZF
if [ ! -d ~/.fzf ]; then
	echo "==> Install FZF"
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install --all

	# eternal history
	cp ~/.bash_history ~/.bash_eternal_history
	tee -a ~/.bashrc << END
# Eternal bash history.
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history
# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
END
else
	echo "==> FZF Found. Skipping"
fi

# distrobox
if ! distrobox ls | grep -q "my-dev"; then
	echo "==> Initializig distrobox environment"
	distrobox create --name my-dev --image ubuntu:22.04 --yes
	distrobox enter my-dev -- uname -a
else
	echo "==> my-dev distrobox found. Skipping"
fi

echo "Your environment is setup! Please logout and login"
