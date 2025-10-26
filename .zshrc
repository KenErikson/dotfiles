
# Load Git completion
#zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.zsh
fpath=(~/.zsh $fpath)
autoload -Uz compinit && compinit

##GIT show
# Load version control information
autoload -Uz vcs_info
precmd() { vcs_info }

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats '(%b)'

# Set up the prompt (with git branch name)
setopt PROMPT_SUBST
PROMPT='%B%n %~%b ${vcs_info_msg_0_} %B%# %b'

## Also set in .zprofile and .zshrc
#export HOMEBREW_NO_AUTO_UPDATE=1
export OPTION_NO_DEPENDENCIES=1
export HOMEBREW_NO_INSTALL_FROM_API=1
##

alias gw=/Users/Ken/git/gradlew
alias ken-edit-zhrc='hx ~/.zshrc'
alias ken-edit-profile='hx ~/.zprofile'
# alias ken-log-centre='less +F /opt/hibox/centre/logs/centre.log'
alias ken-log-centre='tail -n 200 -F /opt/hibox/centre/logs/centre.log |grcat /Users/ken/.grc/log.grc'
# alias ken-log-catalina='less +F /opt/hibox/centre/tomcat/logs/catalina.out'
alias ken-log-catalina='tail -n 200 -F /opt/hibox/centre/tomcat/logs/catalina.out| grcat /Users/ken/.grc/log.grc'
alias ken-mysql='sudo mysql hiboxcentre -e "show tables";sudo mysql hiboxcentre'

alias gitpush='git push --set-upstream origin $(git symbolic-ref --short HEAD)'
alias gitca='git commit -a --amend --no-edit'
alias gitpm='git fetch upstream master:upstream-master'
alias gitrebaseupstream='git rebase -X ours upstream-master'

alias ken-update-locks="~/git/dev/scripts/update-dependency-locks.sh"
#alias ken-hbx-docs="~/git/gradlew hbxReferenceDocs"
alias ken-xrtv-docs="rm -rf /Users/ken/git/webapps/hbx/build/asciidoc;~/git/gradlew hbxReferenceDocs --rerun-tasks"
alias ken-hiboxadmin-docs="rm -rf ~/Users/ken/git/webapps/hiboxadmin/build/apidoc;~/git/gradlew :webapps-hiboxadmin:asciidoctor --rerun-tasks"

alias ken-hiboxadmin-apitest-fast='gw :webapps-hiboxadmin:apiIntegrationTest --tests "fi.hibox.admin.api.auth.AdminAuthClientRestControllerTests"'
alias ken-robot-start='gw startHiboxcentreContainer'
alias ken-robot-stop='gw stopHiboxcentreContainer'
alias ken-robot-template='robot -d output -x robot.xml -v URL:http://docks:49165/hiboxadmin TestSuite'
alias ken-robot-run-hiboxadmin='~/Gandalf/hr'
alias ken-robot-run-dlx='~/Gandalf/hr-dlx'

alias tomcatrestart='~/Gandalf/tomcatRestart.sh'
alias quicktomcatrestart='~/Gandalf/quicktomcatrestart.sh'
alias superquicktomcatrestart='~/Gandalf/superQuickTomcatRestart.sh'
alias devupdate='~/git/dev-update.sh --no-dependencies'
alias armdockers='docker image inspect --format "{{.ID}} {{.RepoTags}} {{.Architecture}}" $(docker image ls -q)'
alias junit='gw :webapps-hbx:junitApiIntegrationTest -DintegrationTests.avoidFixtureBasedDbContainer=true'
alias ken-prune-branches-git='git branch -l | grep -v "*" | egrep -v "(^\*|upstream-master|master|TMP|CONFIG)" | xargs git branch -d 2>&1 | grep -v "If you are sure" ; git fetch --all --prune'
alias ken-dev-vue='gw :webapps-hiboxadmin:devVueAdmin'
alias ken-ansible-example='echo "REMEMBER --check to not edit stuff, --diff to display, -l to limit host. cd to
ansible-installation and pull newest master. Run example: ansible-playbook -l dna_lab_centre
playbooks_isp_conf/hbx_node_conf.yml --diff --check"'
alias ken-keycloak-docker='docker run -p 8082:8080 -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=admin quay.io/keycloak/keycloak:23.0.0 start-dev'
alias ken-incus-help='echo "REMEMBER limactl start   setup: in ~/randomGits/ansible-installation/ run:  LC_ALL=C bash scripts/set_up_local_centre.sh -l       then control via local incus: incus list      ssh: incus config device add ubuntu-2204-centre-test-a589cf44 port-8001-tcp proxy listen=tcp:0.0.0.0:8001 connect=tcp:127.0.0.1:22   from build.hibox.fi/releases LC_ALL=C scripts/set_up_local_centre.sh -m ~/Downloads/messagequeue-release-24.01-0-g25977dcf"'
alias ken-db-sanity='nano ~/tomcat9/bin/setenv.sh'
#alias gitmess='(){ echo Your arg was $1. ;}'
alias ken-centraln-psql='psql -h localhost -p 15432 -U centraln centraln'
alias ken-centraln-serve='cd /Users/ken/randomGits/centraln/;make serve'
alias dotgit='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

source /Users/ken/.docker/init-zsh.sh || true # Added by Docker Desktop
source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
source /opt/homebrew/opt/chruby/share/chruby/auto.sh
chruby ruby-3.1.3 # run chruby to see actual version
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

eval "$(direnv hook zsh)"

 gitmess(){
  #git status | head -n 1
  if [ $# -eq 1 ]
  then
    CURRENT_BRANCH=$(eval git branch --show-current)
    if [[ "$CURRENT_BRANCH" == "master" || "$CURRENT_BRANCH" == "upstream-master" || "$CURRENT_BRANCH" == "main" ]]; then
      echo "On branch '$CURRENT_BRANCH', no action taken."
      exit 0
    fi
    CURRENT_NUMBER=$(eval echo "$CURRENT_BRANCH" | awk -F'[-]+' '{ print $1 }' | grep -o '[0-9]\+')
    re='^[0-9]+.+'
    if ! [[ $CURRENT_BRANCH =~ $re ]] ; then
      echo "$CURRENT_BRANCH is not valid gitmess branch"
      exit 0
    fi
    if [ $CURRENT_NUMBER ]
    then
      INPUT_MESSAGE=""
      vared -p "Message $CURRENT_BRANCH: " -c INPUT_MESSAGE
      #read "INPUT_MESSAGE?Message $CURRENT_BRANCH: "
      NEW_MESSAGE="($1) #$CURRENT_NUMBER $INPUT_MESSAGE"

      if [ $KEN_IN_ANSIBLE_FOLDER ]
      then
        NEW_MESSAGE="($1) $INPUT_MESSAGE - hiboxcentre#$CURRENT_NUMBER"
      fi
      echo
      git commit -a -m "$NEW_MESSAGE" > /dev/null
      #echo "New message: $NEW_MESSAGE"
      git log -1
    else
      echo "No number found, you're on your own kid"
      exit 0
    fi
  else
    echo "Must be 1 args: <tag>"
  fi
}

HISTSIZE=20000
HISTFILESIZE=20000
SAVEHIST=20000
setopt INC_APPEND_HISTORY_TIME
# setopt appendhistory

# autoload -Uz add-zsh-hook

# setopt extendedhistory incappendhistorytime

# load-shared-history() {
  # Pop the current history off the history stack, so we don't grow
  # the history stack endlessly
  # fc -P

  # Load a new history from $HISTFILE and push it onto the history
  # stack.
  # fc -p $HISTFILE
# }

# Import the latest history at the start of each new command line.
# add-zsh-hook precmd load-shared-history


#export HIBOX_JUNIT_JUPITER_EXECUTION_ORDER_RANDOM_SEED='7304794546755652'

# alias code="zed"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

setopt HIST_IGNORE_SPACE HIST_IGNORE_DUPS
