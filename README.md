# The Red Guild's devcontainer exploration

This container is always a work in progress. Feel free to suggest improvements or requirements as
well. Check out similar projects like **@Deivitto**'s auditor-docker and **@trailofbit's**
eth-security-toolbox.

The most important thing about this devcontainer, is that we always try to find the best way to
install the most popular tools, so they can all work seamlessly, and at the same time add security
by default. If you want to know more, and really want to take advante of this devcontainer read
below.

This is the minimized version of the devcontainer. It has some security features disabled to be able
to run `sudo`, or escalate privileges. Aditionnaly, we have removed some heavy tooling for it to be
more lightweight. Feel free to disable as many extensions as you like.

## Requirements
1. Visual Studio Code.
1. DevContainer extension by MS: `ms-vscode-remote.remote-containers`.
1. Must have installed on your local OS: `docker` and `docker-buildx`.

## Kick-off
1. Start the docker service, and make sure your user is in the `docker` group. Otherwise, add
   yourself to it but you'll have to log in back again.
2. Clone this repo, if you want a minimal version checkout `minimal`.
3. Open the folder with **vscode** how you like. Running `code .` works well.
4. Select **Reopen in Container** and wait. This will build the container volume.
5. If this is your first time, you'll be prompted to press enter on a console log that triggers the
   terminal.
6. If not you can go to the extensions section on your side, click the **Remote Explorer** tab and
    select the active devcontainer.

## Usage
If you open the **Command Palette** (Ctrl+Shift+p or whatever your shortcut is) you
 can access several features:
- You can attach VS Code to a running container, where you can open any folder
 or Clone a repository.
- You can open new folders or workspaces of your liking inside the current 
volume.
- You can even clone a new repository in a new volume based on the same
 devcontainer.

## Features Overview

### Extensions

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

### Frameworks
- **Foundry**: Really fast modular toolkit (forge, anvil, cast).
- **Hardhat**: Dev environment to develop, deploy, test and debug.

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
  - **Heimdall**: An advanced EVM smart contract toolkit specializing in bytecode analysis and
    extracting information from unverified contracts.
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
- Remember to disable telemetry. `Ctrl+Shift+P > Open Settings (UI) >` type `telemetry` and uncheck
all the boxes. Alternatively you can add them directly by going to `Open Settings (JSON)`, example:
```json
  "telemetry.telemetryLevel": "off",
  "gitlens.telemetry.enabled": false,
  "partialDiff.enableTelemetry": false,
  ```


## Manual interventions & info

### Hardening: Enabling SELinux
SELinux (Security-Enhanced Linux) is a mandatory access control (MAC) system that restricts processes and users to only the resources they are explicitly allowed to access, enhancing system security.

You can check if you have this already enabled by running `sudo sestatus`

If you don't have SELinux installed, and you really want up your game, and protect your host from
container escapes go ahead and install it. Find whichever guide convinves you the most! Afterward,
enable it inside `/etc/docker/daemon.json` (it should be enabled by default afaik).
```bash
❯ cat /etc/docker/daemon.json 
{
  "selinux-enabled": true
}
```

To manually disable SELinux you can uncomment the following line:
```json
    // Disable SELinux.
    // "--security-opt", "seccomp=unconfined"
```

### Hardening: Enabling AppArmor
AppArmor is a Linux security module that enforces file and network access restrictions for applications through profiles. It sometimes can be more straighforward than SELinux.

You can check it has been enabled by running `sudo apparmor_status`. 

This has been enabled via the argument:
```json
"--security-opt", "apparmor:docker-default"`
```


### Hardening: Dropping capabilities
Capabilities in Linux are fine-grained permissions that allow processes to perform specific
privileged operations without granting full root privileges. They break down the all-or-nothing
nature of root access into smaller, specific rights, improving security.

We have done this by running the following argument: 
```json
"--cap-drop=ALL"
```

This allows us to reduce attack surface by limiting privileged operations. And avoid the need to run
processes as full root.

A few examples:
- `CAP_NET_ADMIN`: Allows network administration (e.g., configuring interfaces).
- `CAP_CHOWN`: Allows changing file ownership.


### Hardening: No new privileges
There's a flag that allows you to avoid getting the user more privilages than it already has. So if
you want to use **sudo** or elevate privilages, you can restart your container after commenting the
following line:
```json
"--security-opt", "no-new-privileges",
```

### Hardening: Read-only filesystem
This may be one of the safest configurations out there but a hard one to use, at least for
development environments. 

It's trickier because it limits a lot what you can do. But if you want to
experiment by yourself, you can start by enabling the `"--read-only"` flag and troubleshooting under
the `mount` section which volumes are mandatory needed as writable.

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

## How to audit your Dockerfile

```bash
# Hadolint
hadolint Dockerfile

# Dockerfile linter 
dockerfile-lint -f Dockerfile

# Trivy misconfiguration
trivy config .

# Checkov
checkov -f Dockerfile

# First authenticate, open the link.
snyk auth --auth-type=token
# Run Snyk
snyk container test app:latest --file=Dockerfile

# Scan images with Dockle
dockle theredguild/devsecops-toolkit:minimal
dockle goodwithtech/dockle-test:v2

```

### Introduction to `asdf`

`asdf` is a versatile version manager for programming languages and tools. It allows you to install
and manage multiple versions of tools like Go, Python, Node.js, and more, all in one place. It's
especially useful for projects requiring specific tool versions.

#### Install Plugins
Add the plugin for the language or tool you need:
```bash
asdf plugin add <language/tool>
asdf plugin list all
```

Golang: `asdf plugin add golang`
Python: `asdf plugin add python`
Node.js: `asdf plugin add nodejs`

#### You can list and install specific versions
```bash
asdf install golang 1.20.5
asdf install python 3.11.5
asdf install nodejs 18.15.0
```

#### Make a version be used globally
```bash
asdf global golang 1.20.5
asdf global python 3.11.5
```

#### Make a version be used locally
```bash
asdf local golang 1.19.2
asdf local python 3.10.4
```

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

### Links
- Article (references this repo's branch article): [Where do you run your code?](https://blog.theredguild.org/where-do-you-run-your-code/)
- Workshop: [Come and build your own devContainer!](https://eth-security-explorations.notion.site/Come-and-build-your-own-devContainer-13b3c0d74d7f448f836419281d916369) @ the-mu
