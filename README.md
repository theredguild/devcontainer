# The Red Guild's devcontainer exploration

_Note: We are working on a new and updated version of this container. Feel free to suggest improvements or requirements as well._

## Requirements
1. Visual Studio Code.
1. DevContainer extension by MS: `ms-vscode-remote.remote-containers`.
1. Must have installed on your local OS: `docker` and `docker-buildx`.

## Kick-off
1. Start the docker service, and make sure your user is in the `docker` group.
   Otherwise, log in back again.
1. Clone this repo and open the folder with vscode how you like. Running
 `code .` works well.
1. Select _"Reopen in Container"_ and wait. This will build the container volume.
1. If this is your first time, you'll be prompted to press enter on a console
   log that triggers the terminal.
1. If not you can go to the extensions section on your side, click the Remote
    Explorer tab and select the active devcontainer.

## Usage
If you open the Command Palette (Ctrl+Shift+p or whatever your shortcut is) you
 can access several features:
- You can attach VS Code to a running container, where you can open any folder
 or Clone a repository.
- You can open new folders or workspaces of your liking inside the current 
volume.
- You can even clone a new repository in a new volume based on the same
 devcontainer.

## What's in it?
- frameworks: foundry, hardhat (manual install)
- utilities: solc-select
- fuzzing: slither, medusa
- others: node, npm, pnpm, yarn, python, go
- terminal: zsh with Oh-My-ZSH
- extensions:
   - `NomicFoundation.hardhat-solidity`,
   - `tintinweb.solidity-visual-auditor`,
   - `trailofbits.weaudit`,
   - `tintinweb.solidity-metrics`

## Useful resources
### Install different node versions with nvm
```bash
# Install the latest version
nvm install --lts
# Install version 14
nvm install 14
# Use a specific version
nvm use 12.22.7
# List current installations
nvm ls
```

### Install Hardhat
Hardhat does not come by default, since the official documentation states
that you should install it locally on the working repository with `npx`.

If you wish to install hardhat globally, you can run:
`pnpm install hardhat` wherever you want.

The other reason it does not come by default, it's because the nvm
installation is not trivial at all, and working with its peculiarities
inside a Dockerfile to install packages is not worth the mess.

### Links
- Article (references this repo's branch article): [Where do you run your code?](https://blog.theredguild.org/where-do-you-run-your-code/)
- Workshop: [Come and build your own devContainer!](https://eth-security-explorations.notion.site/Come-and-build-your-own-devContainer-13b3c0d74d7f448f836419281d916369) @ the-mu
