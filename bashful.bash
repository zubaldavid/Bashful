
# Aliases
alias load="source ~/.bash_profile; echo 'Loaded bash profile.'"
alias branches="git branch --list"
alias ignore="git rm -r --cached .; git add ."

#### PS1 customization ####
NONE="\[\033[0m\]"    # unsets color to term fg color

# regular colors
K="\[\033[0;30m\]"    # black
R="\[\033[0;31m\]"    # red
G="\[\033[0;32m\]"    # green
Y="\[\033[0;33m\]"    # yellow
B="\[\033[0;34m\]"    # blue
M="\[\033[0;35m\]"    # magenta
C="\[\033[0;36m\]"    # cyan
W="\[\033[0;37m\]"    # white

# emphasized (bolded) colors
EMK="\[\033[1;30m\]"
EMR="\[\033[1;31m\]"
EMG="\[\033[1;32m\]"
EMY="\[\033[1;33m\]"
EMB="\[\033[1;34m\]"
EMM="\[\033[1;35m\]"
EMC="\[\033[1;36m\]"
EMW="\[\033[1;37m\]"

# background colors
BGK="\[\033[40m\]"
BGR="\[\033[41m\]"
BGG="\[\033[42m\]"
BGY="\[\033[43m\]"
BGB="\[\033[44m\]"
BGM="\[\033[45m\]"
BGC="\[\033[46m\]"
BGW="\[\033[47m\]"

# Pushes the current branch and sets the remote as upstream
pushup() {
    local branch=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1 /'`;
    git push --set-upstream origin $branch
}

create-pr() {
    # Get current branch that user is on
    current_branch="$(git symbolic-ref --short -q HEAD)"
    
    # User can specify target branch; or use default branch (specified below)
    target_branch="${1:-develop}"

    # Get the URL of origin
    origin_url="$(git config --get remote.origin.url)"

    # Modify the URL by removing the ".git"
    modified_url=${origin_url::${#origin_url}-4}

    # Final URL compares the two branches as a pull request
    url=$modified_url'/compare/'$target_branch'...'$current_branch'?expand=1'

    # Launch Github
    open $url
}

# displays only the last 40 characters of pwd
set_new_pwd() {
    # How many characters of the $PWD should be kept
    local pwdmaxlen=40
    # Indicate that there has been dir truncation
    local trunc_symbol=".."
    local dir=${PWD##*/}
    pwdmaxlen=$(( ( pwdmaxlen < ${#dir} ) ? ${#dir} : pwdmaxlen ))
    NEW_PWD=${PWD/#$HOME/\~}
    local pwdoffset=$(( ${#NEW_PWD} - pwdmaxlen ))
    if [ ${pwdoffset} -gt "0" ]
    then
        NEW_PWD=${NEW_PWD:$pwdoffset:$pwdmaxlen}
        NEW_PWD=${trunc_symbol}/${NEW_PWD#*/}
    fi
}

# the name of the git branch in the current directory
set_git_branch() {
    unset GIT_BRANCH
    local branch=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1 /'`;

    if test "$branch"
        then
            GIT_BRANCH="${EMG}git:${NONE}$branch"
    fi
}

# the name of the activated virtual env
set_virtual_env_base() {
    unset VIRTUAL_ENV_BASE
    local venv=`basename "$VIRTUAL_ENV"`

    if test $venv
        then
            VIRTUAL_ENV_BASE="($venv) "
    fi
}

# hostname
set_hostname() {
  unset HOST_FOR_PROMPT

  # Default to current host's prompt
  local current_host=`hostname`
  local color=${EMR}
  
  HOST_FOR_PROMPT="${color}$current_host${NONE}"

}


update_prompt() {
    set_new_pwd
    set_git_branch
    set_virtual_env_base
    set_hostname
    
    PS1="${HOST_FOR_PROMPT} ${VIRTUAL_ENV_BASE}${GIT_BRANCH}${EMB}${NEW_PWD}${NONE} \$ "
}

PROMPT_COMMAND=update_prompt

yolo() {
    git add --all
    git commit -m $0
    git push
}

go() {
    printf "\n"
    git status -s
    printf "\nCONTINUE? (Y/N): "
    read cont
    if [ "$cont" = "n" ]; then
        return
    fi
    printf "\n"
    git add --all
    git status -s
    printf "\nENTER A COMMIT MESSAGE:\n-----------------------\n"
    read -e message
    printf "\n"
    git commit -m "$message"
    git push
}




