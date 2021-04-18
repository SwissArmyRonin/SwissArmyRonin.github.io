# Node.js

## Installing node.js

Source: [Set up your Node.js development environment with WSL 2](https://docs.microsoft.com/en-us/windows/nodejs/setup-on-wsl2)

```bash
# Get Node version manager. Check for newer release at https://github.com/nvm-sh/nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
nvm install node  # Install the newest node
nvm install --lts # Install the current LTS version

# Set some defaults form npm init. See current settings with "npm config list | grep init"
npm set init.author.name "Mads Hvelplund"
npm set init.author.email "mads@swissarmyronin.dx"
npm set init.author.url "https://your-url.com"
npm set init.license "MIT"
npm set init.version "1.0.0"
```

## Setup new project

Initialize a project with:

```bash
npx license MIT
npx gitignore node
npm init -y
```

## Turn callback functions to promises

[How to make a Promise out of a Callback function in JavaScript](https://www.freecodecamp.org/news/how-to-make-a-promise-out-of-a-callback-function-in-javascript-d8ec35d1f981/)


## Use node for shell scripting

[How to run shell script file or command using Nodejs?](https://medium.com/stackfame/how-to-run-shell-script-file-or-command-using-nodejs-b9f2455cb6b7)


[gimmick:Disqus](swissarmyronin-github-io)