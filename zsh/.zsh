# Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

## OH_MY_ZSH
###############################################################################
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

plugins=(
  git
  zsh-autosuggestions
)

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#2ca876,bg=white,bold,underline"

source $ZSH/oh-my-zsh.sh

## LOCAL CONFIGURATION
###############################################################################
export PATH="/usr/local/opt/libpq/bin:$PATH"

## NPM functions
###############################################################################
function remove_npmrc_files() {
  cd ~/work/gamma-docker
  # remove old .npmrc file references
  find . -name .npmrc -type f -print0 | xargs -0 rm
}

# SSH functions
# *****************************************************************************
# To establish a remote ssh connection to these endpoints do the following:
# 1. Forward the local ssh port
# ssh -L localPort:remoteEndpoint:remotePort remoteHost

# Example: ssh -L 65432:prod-east-postgres-20190505.crwbf3hd3akt.us-east-1.rds.amazonaws.com:5432 admin.prod-east

# The above will map local port 65432 to prod-east-postgres-20190505.crwbf3hd3akt.us-east-1.rds.amazonaws.com:5432 on admin.prod-east

# https://unix.stackexchange.com/questions/115897/whats-ssh-port-forwarding-and-whats-the-difference-between-ssh-local-and-remot?newreg=eddf26e7eeaa45ae81c768a39f407d96
# This guide was extremely useful in understanding ssh port forwarding.

# For ease of use, add the following function to your bash configuration file.
# It can be called from the terminal in the following manner: forward_pg_prod_east &. This will run the command in the background, allowing us to close the existing terminal without closing the connection.
# # SSH functions
# # *****************************************************************************
# function forward_pg_prod_east() {
#     ssh -v -L 65432:prod-east-postgres-20190505.crwbf3hd3akt.us-east-1.rds.amazonaws.com:5432 admin.prod-east
# }

# For Sql connection :

# ssh -v -L 65430:prod-east-mysql-20190505.crwbf3hd3akt.us-east-1.rds.amazonaws.com:3306 admin.prod-east
# 2. Connect to the database using a local tool

# Using DataGrip for example, use the provided 1Pass credentials to connect to port 65432 on localhost

# Enjoy.
function forward_pg_prod_east() {
  ssh -v -L 65432:prod-east-postgres-20190505.crwbf3hd3akt.us-east-1.rds.amazonaws.com:5432 admin.prod-east
}

# Docker functions
# *****************************************************************************
function stop_containers() {
  docker stop $(docker ps -a -q)
}

function remove_containers() {
  docker rm $(docker ps -a -q)
}

function remove_volumes() {
  docker volume rm $(docker volume ls -qf dangling=true)
}

function nuke_docker() {
  docker system prune -a --volumes
}

function clean_containers() {
  echo "Cleaning existing containers"
  stop_containers
  remove_containers
  remove_volumes
}

##############################################################################
# Simplifies the execution and start of multiple gamma services
# Flags:
#   -t: Optional
#       Removes existing containers and volume data
# Arguments:
#   List of gamma service names
##############################################################################
function start_services() {
  BUILD_SERVICES=false
  SERVICE_NAMES=("${@}")
  CONCATENATED_SERVICES=""

  cd ~/work/gamma-docker
  # get latest changes
  git pull

  while getopts 'bt' flag; do
    case "${flag}" in
    b)
      SERVICE_NAMES=("${@:2}")
      BUILD_SERVICES=true
      ;;
    t)
      SERVICE_NAMES=("${@:2}")
      clean_containers
      ;;
    *)
      SERVICE_NAMES=("${@:2}")
      ;;
    esac
  done

  # bulld and start services
  for service in "${SERVICE_NAMES[@]}"; do
    echo "Building service: $service"
    CONCATENATED_SERVICES+=" $service"
  done

  echo "CONCATENATED_SERVICES: $CONCATENATED_SERVICES"
  if [ "$BUILD_SERVICES" = true ]; then
    echo "Building services... $CONCATENATED_SERVICES"
    ./bin/build.sh $CONCATENATED_SERVICES
  fi
  echo "Starting services..."
  ./bin/start.sh $CONCATENATED_SERVICES

  # watch last called service
  echo "Watching $service"
  docker logs -f "$service"
}

# Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"
