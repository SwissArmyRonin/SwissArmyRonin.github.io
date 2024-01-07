#!/usr/bin/env bash

set -euo pipefail
script_folder="$(realpath "$(dirname "$0")")"
cd "${script_folder}/.."
"${script_folder}/install-script-deps.sh"
"${script_folder}/check-links.sh"
mdbook build
