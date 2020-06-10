
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/veetaha/.oh-my-zsh"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="dd.mm.yyyy"


# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    aws
    command-time
    fzf
    git
    golang
    npm
    nvm
    rust
    terraform
    zsh-autosuggestions

    # XXX: important! must be the last in the list
    zsh-syntax-highlighting
)

# VEETAHA CUSTOM ======================================================


### zsh-syntax-highlighting ===

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)

typeset -A ZSH_HIGHLIGHT_STYLES

ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#08dc92'

ZSH_HIGHLIGHT_STYLES[assign]='fg=#9cdcfe,bold'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#9cdcfe,bold'

ZSH_HIGHLIGHT_STYLES[alias]='fg=#dfff6d,bold'
ZSH_HIGHLIGHT_STYLES[command]='fg=#dfff6d,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#dfff6d,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=#dfff6d,bold'

ZSH_HIGHLIGHT_STYLES[path]="fg=#ce9178"
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#ce9178'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#ce9178'

ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#dfad40,bold'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#dfad40,bold'

ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#e81e31,bold'

ZSH_HIGHLIGHT_STYLES[default]='fg=#ffffff'

### ===========================


# If command execution time above min. time, plugins will not output time.
ZSH_COMMAND_TIME_MIN_SECONDS=3

export RUST_BACKTRACE=full

zle_bracketed_paste=()

ZSH_AUTOSUGGEST_STRATEGY=(history completion)

SHOW_AWS_PROMPT=false
ZSH_THEME="veetaha-custom"

compctl -K _aws_profiles a

function a() {
    asp $1
    sed -i -E "s/^(__SED_AWS_PROFILE__=).*/\1$1/" ${HOME}/.zshrc
}

__SED_AWS_PROFILE__=vkryvenko-isolated
export AWS_PROFILE=$__SED_AWS_PROFILE__

export AWS_SDK_LOAD_CONFIG=1

# FZF ==========

# Setting fd as the default source for fzf
FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
FZF_DEFAULT_OPTS='--height 40% --layout=reverse'

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude ".git" . "$1"
}

# (EXPERIMENTAL) Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
    local command=$1
    shift

    case "$command" in
        cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
        export|unset) fzf "$@" --preview "eval 'echo \$'{}" ;;
        ssh)          fzf "$@" --preview 'dig {}' ;;
        *)            fzf "$@" ;;
    esac
}

# END FZF ==========

# Captures the output of the stdout/stderr of the command invocation and
# writes it to a file in automatically created `log/` directory with the
# current date time as the file name.
function cap() {
    timestamp=$(TZ="Europe/Kyiv" date +"%Y-%m-%d.%H:%M:%S")

    log_dir=./log

    mkdir -p $log_dir

    bin_name=$(basename $1)

    prefix="$log_dir/${bin_name}.${timestamp}"

    all="${prefix}.log"

    code $all

    "$@" |& tee $all

    ret_val="${pipestatus[1]}"

    echo "\033[0;35m$all\033[0m" 1>&2

    return $ret_val
}

function aws_assume_role() {
    role=$1
    account=$(aws sts get-caller-identity --query 'Account' --output text)
    output=$(aws sts assume-role --role-arn arn:aws:iam::${account}:role/${role} --role-session-name vkryvenko)

    export AWS_ACCESS_KEY_ID=$(echo $output | jq -r '.Credentials.AccessKeyId')
    export AWS_SECRET_ACCESS_KEY=$(echo $output | jq -r '.Credentials.SecretAccessKey')
    export AWS_SESSION_TOKEN=$(echo $output | jq -r '.Credentials.SessionToken')

    unset AWS_PROFILE
}

# I usually don't need default paging in AWS CLI
export AWS_PAGER=""

# Alias for aws command that connects to localstack instead of real AWS server
alias awslocal="aws --endpoint-url http://127.0.0.1:4566"
alias z="clear && "
alias c="cargo"
alias lint="cargo xtask lint --color=always --skip-custom --all-targets --all-features"

# END VEETAHA CUSTOM ==================================================

source $ZSH/oh-my-zsh.sh

# User configuration
# https://github.com/popstas/zsh-command-time#configuration
zsh_command_time() {
    if [ -n "$ZSH_COMMAND_TIME" ]; then
        hours=$(($ZSH_COMMAND_TIME/3600))
        min=$(($ZSH_COMMAND_TIME/60))
        sec=$(($ZSH_COMMAND_TIME%60))
        if [ "$ZSH_COMMAND_TIME" -le 60 ]; then
            timer_show="$fg[green]${ZSH_COMMAND_TIME}s"
        elif [ "$ZSH_COMMAND_TIME" -gt 60 ] && [ "$ZSH_COMMAND_TIME" -le 180 ]; then
            timer_show="$fg[yellow]$min min. $sec s."
        else
            if [ "$hours" -gt 0 ]; then
                min=$(($min%60))
                timer_show="$fg[red]${hours}h ${min}m ${sec}s"
            else
                timer_show="$fg[red]${min}m ${sec}s"
            fi
        fi
        echo "$fg_bold[white]Took $timer_show$reset_color"
    fi
}
