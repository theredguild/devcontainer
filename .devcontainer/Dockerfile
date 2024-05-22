# Base debian build (latest).
FROM mcr.microsoft.com/vscode/devcontainers/base:debian

# Update packages.
RUN apt-get update

# Install Python, Go, and other dependencies
RUN apt-get install -y pipx golang

# Set the default shell to Fish
ENV SHELL=/usr/bin/zsh

# Running everything under zsh
SHELL ["/usr/bin/zsh", "-c"]

USER vscode
# Install rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# # Install nvm, yarn, npm, pnpm
RUN curl -o- https://raw.githubusercontent.com/devcontainers/features/main/src/node/install.sh | sudo bash

# # Install solc-select
RUN pipx install solc-select

# # Install slither
RUN pipx install slither-analyzer

# # install Medusa (crytic-compile)
RUN pipx install crytic-compile

# ## Foundry framework
RUN curl -L https://foundry.paradigm.xyz | zsh
RUN foundryup

# # # Clean up
RUN sudo apt-get autoremove -y && sudo apt-get clean -y