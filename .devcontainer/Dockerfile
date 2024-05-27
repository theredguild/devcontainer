# Base debian build (latest).
FROM mcr.microsoft.com/vscode/devcontainers/base:debian

# Update packages.
RUN apt-get update

# Install pipx
RUN apt-get install -y pipx

# Set the default shell to zsh
ENV SHELL=/usr/bin/zsh

# Running everything under zsh
SHELL ["/usr/bin/zsh", "-c"]

# Dropping privileges
USER vscode

# Install golang's latest version through asdf
RUN git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.14.0 \
    && echo '. $HOME/.asdf/asdf.sh' >> $HOME/.zshrc \
    && echo 'fpath=(${ASDF_DIR}/completions $fpath)' >> $HOME/.zshrc \
    && echo 'autoload -Uz compinit && compinit' >> $HOME/.zshrc \
    && . $HOME/.asdf/asdf.sh \
    && asdf plugin add golang \
    && asdf install golang latest

# Install rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && source $HOME/.cargo/env

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

