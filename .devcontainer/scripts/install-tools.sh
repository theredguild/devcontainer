#!/usr/bin/fish

# starship theme for fish
curl -sS https://starship.rs/install.sh | sh -s -- -y
echo "starship init fish | source" >> ~/.config/fish/config.fish
source ~/.config/fish/config.fish


# Some manual exports
## This makes pnpm installations to be available globally
echo "export PNPM_HOME=\"/home/vscode/.local/share/pnpm\"" >> ~/.config/fish/config.fish
## This is the default path for foundry's binaries
echo "export FOUNDRY=\"/home/vscode/.foundry/bin\"" >> ~/.config/fish/config.fish
## And here we just add both of them to PATH.
echo "export PATH=\"\$PATH:\$PNPM_HOME:\$FOUNDRY\"" >> ~/.config/fish/config.fish
## Load it to our current environment
source ~/.config/fish/config.fish

# # Install hardhat
pnpm install hardhat -g

# Install solc-select
pipx install solc-select

# Install slither
pipx install slither-analyzer

# install Medusa (crytic-compile)
pipx install crytic-compile

## Foundry framework
curl -L https://foundry.paradigm.xyz | bash
foundryup