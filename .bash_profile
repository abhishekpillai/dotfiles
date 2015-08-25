if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# git aliases
alias gst="git status"
alias gd="git diff"

# other aliases
alias be="bundle exec"

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

source $(brew --prefix)/etc/bash_completion.d/git-prompt.sh

function prompt {
  local Green="\[\033[0;32m\]"        # Green
  local GreenBold="\[\033[1;32m\]"       # Green
  local White="\[\033[0;37m\]"        # White
  # more colors here: http://mediadoneright.com/content/ultimate-git-ps1-bash-prompt
  export PS1="\W$Green \$(__git_ps1 \"(%s)\")$White\$ "
}
prompt

export EDITOR=vim
