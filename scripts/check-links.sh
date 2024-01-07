#!/usr/bin/env bash

# Check links in markdown files.
#
# Stolen from a colleague without his permission, and shoddily modified ;)

set -euo pipefail

script_dir="$(dirname "$(realpath "$0")")"

# Print a message
#
# Params:
#   $1: colour (red | green | yellow)
#   $*: status to print
#
# Example usage:
#   print_msg green "Successfully built $something"
#
#   print_msg red "An error occurred:" $msg
print_msg() {
    color="1"
    case $1 in
    red) color="31;1" ;;
    green) color="32;1" ;;
    yellow) color="33;1" ;;
    esac
    shift
    # shellcheck disable=SC1117
    printf " \033[${color}m*\033[0;1m %s\033[0m\n" "$*"
}

# Require an application to be in $PATH.
#
# Params:
#   $1: app name
#
# Example usage:
#   require_app ruby
require_app() {
    if ! command -v "$1" >/dev/null; then
        print_msg red "$1 not found, please run $script_dir/install-script-deps.sh"
        return 1
    fi
}

###############################################################################

require_app lychee || exit 1

export MDBOOK_ROOT_PATH=${MDBOOK_ROOT_PATH:-"$script_dir/.."}
echo "${MDBOOK_ROOT_PATH}"

declare -a MARKDOWN_FILES

readarray -t MARKDOWN_FILES < <(
    find "${MDBOOK_ROOT_PATH}" -type f -iname '*.md'
)

if ! [ ${#MARKDOWN_FILES[@]} -eq 0 ]; then
    print_msg yellow "Running lychee link check on markdown (.md) files ..."
    # We need to cd to directory with file to follow relative links
    for FILE in "${MARKDOWN_FILES[@]}"; do
        pushd "$(dirname "${FILE}")"
        echo "checking: $PWD/$(basename "${FILE}") ..."

        if ! lychee -qq --insecure --no-progress \
            --exclude linkedin.com \
            --exclude-mail "$(basename "${FILE}")" \
            --exclude-loopback; then
            print_msg red "lychee found broken links" \
                "fix the errors and come back later"
            exit 1
        fi
        echo ""
        popd
    done
fi
