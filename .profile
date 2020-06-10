add_to_path() {
    local IFS=":"
    export PATH="$*:${PATH}"
}

. "$HOME/.cargo/env"

export GOPATH=~/go
export GOBIN=~/go/bin

local APPS="${HOME}/apps"

add_to_path \
    "${HOME}/dev/scripts" \
    "${APPS}/bin" \
    "${HOME}/.tfenv/bin" \
    "${HOME}/.local/bin" \
    "/usr/local/go/bin" \
    "$GOBIN"
