# The Red Guild's devcontainer exploration
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
- frameworks: hardhat, foundry
- utilities: solc-select
- fuzzing: slither, medusa
- others: node, pnpm, python, go
- terminal: fish with starship theme
- extensions:
   - `NomicFoundation.hardhat-solidity`,
   - `tintinweb.solidity-visual-auditor`,
   - `trailofbits.weaudit`,
   - `tintinweb.solidity-metrics`


## Useful resources
- Workshop: [Come and build your own devContainer!](https://eth-security-explorations.notion.site/Come-and-build-your-own-devContainer-13b3c0d74d7f448f836419281d916369) @ the-mu
