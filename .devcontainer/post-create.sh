#!/bin/bash
set -euo pipefail
git config --global user.email "mhvelplund@users.noreply.github.com"
git config --global user.name "Mads Hvelplund"
git config --global --add safe.directory /workspaces/www.swissarmyronin.dk
curl -sL https://github.com/badboy/mdbook-toc/releases/download/0.14.2/mdbook-toc-0.14.2-x86_64-unknown-linux-gnu.tar.gz | sudo tar xvz -C /usr/local/bin