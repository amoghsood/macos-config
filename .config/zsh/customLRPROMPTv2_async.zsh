#!/usr/bin/env zsh
source $HOME/.config/zsh/async.zsh

set_colors() {
  apple_interface_style=$(defaults read -g AppleInterfaceStyle 2>/dev/null)
  if [[ $apple_interface_style == "Dark"  ]]; then
    # Dark mode is enabled
    # Set your preferred dark mode color scheme here
    CWD_COLOR="109"
    CONDA_ENV_COLOR="106"
    GIT_INFO_COLOR="166"
    SUCCESS_COLOR="106"
    FAILURE_COLOR="124"
    PROMPT_CHAR_COLOR="167"
  fi
  if [[ -z $apple_interface_style ]]; then
    # Light mode is enabled
    # Set your preferred light mode color scheme here
    CWD_COLOR="24"
    CONDA_ENV_COLOR="106"
    GIT_INFO_COLOR="166"
    SUCCESS_COLOR="106"
    FAILURE_COLOR="124"
    PROMPT_CHAR_COLOR="88"
  fi
}

# Dummy variables for color codes

#set_colors #has to be set in pre-cmd hook to auto-update

#USER_COLOR="75"
#HOST_COLOR="33"
#CWD_COLOR="24"
#CONDA_ENV_COLOR="106"
#GIT_INFO_COLOR="166"
#SUCCESS_COLOR="106"
#FAILURE_COLOR="124"
#PROMPT_CHAR_COLOR="88"
async_init
#Function for async vcs_info update
update_vcs_info() {
   #delayed_vcs_info
   #git status --porcelain &>/dev/null # Refresh the git status
   vcs_info
   zle reset-prompt
}
# NEW: Create async worker
async_start_worker vcs_worker -n
# NEW: Register async function
async_register_callback vcs_worker update_vcs_info

# Function to get conda environment information
get_conda_env() {
  if [[ -n "${CONDA_DEFAULT_ENV}" ]]; then
    echo "(${CONDA_DEFAULT_ENV}) "
  fi
}

#precmd loaded at each command
#updates prompt
precmd() {
  # Update vcs_info, async future?
  #vcs_info
  # UPDATED: Replace synchronous vcs_info with async
  async_job vcs_worker vcs_info 
  set_colors
  #check exit status of last command, and set a colored unicode char based on that
  if [ $? -eq 0 ]; then
    PS1="%F{$SUCCESS_COLOR}"$'\u25CF'"%f "
   #PS1="%F{$SUCCESS_COLOR}$(echo -e '\u25CF')%f "
  else
     PS1="%F{$FAILURE_COLOR}"$'\u25CF'"%f "
   # PS1="%F{$FAILURE_COLOR}$(echo -e '\u25CF')%f "
  fi
  #combine the exit status icon with cwd path and proompt char
  #PS1+="%F{$CWD_COLOR}%B%2~%b %F{$PROMPT_CHAR_COLOR}$(echo -e '\u2771') %f"
  PS1+="%F{$CWD_COLOR}%B%2~%b %F{$PROMPT_CHAR_COLOR}"$'\u2771'" %f"
  PROMPT="$PS1"

  #Update git formats staged,unstaged and untracked files + branch
  # zstyle ':vcs_info:git:*' formats "%F{$GIT_INFO_COLOR}[%u%c%m %b]%f"
  zstyle ':vcs_info:git:*' formats "%F{$GIT_INFO_COLOR}[%u%c%m"$'\uE725'" %b]%f"
  #combine conda env with git info 
  RPROMPT='%F{$CONDA_ENV_COLOR}$(get_conda_env)%f$vcs_info_msg_0_'
}

autoload -Uz vcs_info
#autoload -U colors && colors

#for testing

#delayed_vcs_info() {
#  sleep 3 # Add a 3-second delay
#  vcs_info "$@"
#}


# Enable only git
zstyle ':vcs_info:*' enable git

# Setup a hook that runs before every prompt
precmd_functions+=( precmd )
setopt prompt_subst

#function check_untracked_files() {
#  if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
#      git status --porcelain | grep '??' &> /dev/null ; then
#    return 0
#  else
#    return 1
#  fi
#}

zstyle ':vcs_info:*' check-for-changes true
#check for untracked files and store that information in %m option
+vi-git-untracked() {
  if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
     git status --porcelain | rg -m 1 '^\?\?' &>/dev/null
     #git status --porcelain | rg '^?? ' | rg -v '^( M|A|D|R|C|U)' &>/dev/null
  then
    hook_com[misc]='?'
  else
    hook_com[misc]=''
  fi
  }

#+vi-git-untracked() {
#  local staged_files
#  local unstaged_files
#  local untracked_files
#
#  if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]]; then
#    staged_files=$(git status --porcelain | grep '^A ')
#    unstaged_files=$(git status --porcelain | grep '^ M')
#    #untracked_files=$(git status --porcelain | rg '^?? ' | rg -v '^( M|A|D|R|C|U)')
#    untracked_files=$(git status --porcelain | grep '^\?\? ')
#    #echo "staged_files: $staged_files"
#    #echo "unstaged_files: $unstaged_files"
#    #echo "untracked_files: $untracked_files"
#    
#    if [[ -n $staged_files ]]; then
#      hook_com[staged]='+'
#    fi
#
#    if [[ -n $unstaged_files ]]; then
#      hook_com[unstaged]='*'
#    fi
#
#    if [[ -n $untracked_files ]]; then
#      hook_com[misc]='?'
#    else
#      hook_com[misc]=''
#    fi
#  fi
#}

zstyle ':vcs_info:*' hooks git-untracked 
#zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
#change icons from defaults U S
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' stagedstr '+'

