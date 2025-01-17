# The Red Guild's devcontainer exploration

Note: We are currently updating a this container. Feel free to suggest improvements or requirements
as well.
Check out similar projects like @Deivitto's auditor-docker and @trailofbit's eth-security-toolbox.

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

## Features Overview

## Extensions
- JuanBlanco.solidity
- tintinweb.solidity-visual-auditor
- tintinweb.solidity-metrics
- tintinweb.vscode-solidity-flattener
- tintinweb.vscode-vyper
- tintinweb.vscode-LLL
- streetsidesoftware.code-spell-checker
- gimenete.github-linker
- ryu1kn.partial-diff
- tintinweb.vscode-inline-bookmarks
- eamodio.gitlens
- tintinweb.vscode-ethover
- trailofbits.weaudit
- tintinweb.vscode-inline-bookmarks
- tintinweb.vscode-solidity-language
- tintinweb.graphviz-interactive-preview
- NomicFoundation.hardhat-solidity
- Olympixai.olympix
- trailofbits.contract-explorer
- tintinweb.vscode-decompiler

## Frameworks
- **Foundry**: Really fast modular toolkit (forge, anvil, cast).
- **Hardhat**: Dev environment to develop, deploy, test and debug. Manual installation on project folder, read below.

### Security Tools
- **Fuzzing**:
  - **Medusa**: Parallelized, coverage-guided, mutational Solidity smart contract fuzzing, powered by go-ethereum.
  - **Echidna**: Fuzz testing for Ethereum contracts (prebuilt binary).
  - **ityfuzz**: Ethereum fuzzing tool for contract vulnerabilities.

- **Static Analysis**:
  - **Slither**: Static analysis for Solidity and Vyper.
    - **Slitherin**: Slither detectors.
  - **Semgrep**: Lightweight static analysis with custom rule definitions.

- **Symbolic execution**:
  - **Mythril**: A symbolic-execution-based securty analysis tool for EVM bytecode. 
  - **Halmos**: A symbolic testing tool for EVM smart contracts.

- **Decompilers**:
  - **Panoramix**: Smart contract decompiler.
 
- **Other**:
  - **Slither-LSP**: Language server for enhanced contract analysis.
  - **napalm**: A project management utility for custom solidity vulnerability detectors.
  - **Heimdall**: An advanced EVM smart contract toolkit specializing in bytecode analysis and extracting information from unverified contracts.
  - **Aderyn**: Rust-based Solidity AST analyzer.

### Utilities
- **solc-select**: Solc version manager for multiple Solidity versions.
- **vyper**: Pythonic language for Ethereum smart contracts.
- **Package Managers**:
  - **asdf**: Multiple runtime version manager.
  - **npm**, **pnpm**, **yarn**: JavaScript package managers.
  - **pipx**: Isolated Python package manager.
  - **cargo**: Rust package manager.
  - **uv**: Utility manager.
  - **nvm**: Node.js version manager.


### Languages
- **JavaScript**, **Python**, **Go**, **Rust**, **Vyper**, **Solidity**.

### Shell
**ZSH**. Configured with Oh-My-ZSH and autocompletions for: **medusa**, **anvil**, **cast**, **forge**.

### Additional Repositories
- **building-secure-contracts**: Repository with security-focused Solidity examples.

### Notes
- Multi-stage build ensures reproducibility.
- Minimal base image (Debian).

## Manual interventions
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

### Natspec Smells

- Verifies natspec for: constructors, variables, functions, structs, errors, events, modifiers
- Finds misspelled or missing @param or @return's.
- Lets you enforce the need for @inheritdoc in public/external functions.
- Can integrate on your daily workflow, or just as a final check.

```
npx @defi-wonderland/natspec-smells --include "src/**/*.sol"
```

#### Recommended setup

1. Install the package:

   ```bash
   yarn add --dev @defi-wonderland/natspec-smells
   ```

2. Create a config file named `natspec-smells.config.js`, you can use the following as an example:

   ```javascript
   /**
    * List of supported options: https://github.com/defi-wonderland/natspec-smells?tab=readme-ov-file#options
    */

   /** @type {import('@defi-wonderland/natspec-smells').Config} */
   module.exports = {
     include: 'src/**/*.sol',
     exclude: '(test|scripts)/**/*.sol',
   };
   ```

3. Run
   ```bash
   yarn natspec-smells
   ```

### Semgrep
Currently semgrep supports [Solidity](https://semgrep.dev/docs/language-support/) in `experimental` mode. Some of the rules may not work until Solidity is in `beta` at least.

> **Important:** Some of the rules utilize the [taint mode](https://semgrep.dev/docs/writing-rules/data-flow/taint-mode), which is restricted to the same function in the open-source version of semgrep. To take advantage of intra-procedural taint analysis, you must include the `--pro` flag with each command. Please note that this requires semgrep Pro.

1) By cloning the repository:

  ```shell
  $ semgrep --config solidity/security path/to/your/project
  ```

2) By using [semgrep registry](https://semgrep.dev/r):

  ```shell
  $ semgrep --config p/smart-contracts path/to/your/project
  ```

### Links
- Article (references this repo's branch article): [Where do you run your code?](https://blog.theredguild.org/where-do-you-run-your-code/)
- Workshop: [Come and build your own devContainer!](https://eth-security-explorations.notion.site/Come-and-build-your-own-devContainer-13b3c0d74d7f448f836419281d916369) @ the-mu
