# Node.js

## Test server for OpenAPI specs

A Node package that returns the examples from the API as responses: <https://www.npmjs.com/package/@openapi-generator-plus/typescript-express-example-server-generator>.


## Installing node.js

Source: [Set up your Node.js development environment with WSL 2](https://docs.microsoft.com/en-us/windows/nodejs/setup-on-wsl2)

```bash
# Get Node version manager. Check for newer release at https://github.com/nvm-sh/nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
nvm install node  # Install the newest node
nvm install --lts # Install the current LTS version

# Set some defaults form npm init. See current settings with "npm config list | grep init"
npm set init.author.name "Mads Hvelplund"
npm set init.author.email "mads@swissarmyronin.dx"
npm set init.author.url "https://your-url.com"
npm set init.license "MIT"
npm set init.version "1.0.0"
```

_Make sure that neither path for node and npm hit the ones installed locally by NVM!_

## Setup new project

Initialize a project with:

```bash
npx --yes license MIT
npx --yes gitignore node
npm init -y

# for typescript add ...
npm i typescript --save-dev
npx --yes tsc --init
echo "console.log('Hello World');" > index.ts
tsc && node index.js
```

## Misc.

- [Make a Promise out of a Callback function in JavaScript](https://www.freecodecamp.org/news/how-to-make-a-promise-out-of-a-callback-function-in-javascript-d8ec35d1f981/)
- Use node for shell scripting: [google/zx](https://github.com/google/zx)
- [Set up a new TypeScript project](https://www.digitalocean.com/community/tutorials/typescript-new-project)
- [How to Build an AWS Lambda Function in Typescript](files/How_to_Build_an_AWS_Lambda_Function_in_Typescript.pdf) (src: [scotch.io](https://web.archive.org/web/20201031135018/https://scotch.io/@nwayve/how-to-build-a-lambda-function-in-typescript))

[gimmick:Disqus](swissarmyronin-github-io)
