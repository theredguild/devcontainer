# syntax=docker/dockerfile:1.8
# check=error=true

## Multi-stage build!
# Pull prebuilt Echidna binary
FROM --platform=linux/amd64 ghcr.io/crytic/echidna/echidna:latest AS echidna

# Base debian build (latest).
FROM mcr.microsoft.com/vscode/devcontainers/base:debian

# Switch to root (the default might be root anyway)
USER root

# Super basic stuff to get everything started
RUN apt-get update -y && apt-get install -y \
    zsh python3-pip pipx curl git sudo

# The base container usually has a “vscode” user. If not, create one here.
RUN echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to vscode (drop privs)
USER vscode
WORKDIR /home/vscode

# Set PATH with .local/bin included.
ENV HOME=/home/vscode
ENV PATH=${PATH}:${HOME}/.local/bin
RUN pipx ensurepath

# Set the default shell to zsh
ENV SHELL=/usr/bin/zsh

# Running everything under zsh
SHELL ["/usr/bin/zsh", "-ic"]


# Install golang's latest version through asdf
RUN git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.15.0 \
    && echo '. $HOME/.asdf/asdf.sh' >> $HOME/.zshrc \
    && echo 'fpath=(${ASDF_DIR}/completions $fpath)' >> $HOME/.zshrc \
    && echo 'autoload -Uz compinit && compinit' >> $HOME/.zshrc \
    && . $HOME/.asdf/asdf.sh \
    && asdf plugin add golang \
    && asdf install golang latest \
    && asdf global golang latest

# Install rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && source $HOME/.cargo/env

# # Install nvm, yarn, npm, pnpm
RUN curl -o- https://raw.githubusercontent.com/devcontainers/features/main/src/node/install.sh | sudo bash

# # Install solc-select
## Install one solc release from each branch and select the latest version as the default
RUN pipx install solc-select && solc-select install 0.4.26 0.5.17 0.6.12 0.7.6 0.8.10 latest && solc-select use latest

# Python installations
## Install slither analyzer, crytic-compile, vyper, mythx, panoramix, slider-lsp (needed for contract explorer), napalm-toolbox
RUN pipx install slither-analyzer \
    && pipx install crytic-compile \
    && pipx install vyper \ 
    && pipx install mythx-cli \
    && pipx install panoramix-decompiler \
    ## needed for the contract explorer
    && pipx install slither-lsp \
    && pipx install napalm-toolbox


# RUN pip install napalm-core

# Fetch and install setups
## install ityfuzz
RUN curl -L https://ity.fuzz.land/ | bash
RUN ityfuzzup

## Foundry framework
RUN curl -L https://foundry.paradigm.xyz | zsh
RUN foundryup

## install aderyn
RUN curl -L https://raw.githubusercontent.com/Cyfrin/aderyn/dev/cyfrinup/install | bash
RUN cyfrinup

# Git clone, compile kind of installations
## Install Medusa
RUN git clone https://github.com/crytic/medusa.git ${HOME}/medusa && \
    cd ${HOME}/medusa && \
    export LATEST_TAG="$(git describe --tags | sed 's/-[0-9]\+-g\w\+$//')" && \
    git checkout "$LATEST_TAG" && \
    go build -trimpath -o=${HOME}/.local/bin/medusa -ldflags="-s -w" && \
    chmod 755 ${HOME}/.local/bin/medusa

# Copy prebuilt Echidna binary
COPY --chown=vscode:vscode --from=echidna /usr/local/bin/echidna ${HOME}/.local/bin/echidna
RUN chmod 755 ${HOME}/.local/bin/echidna

# Clone useful repositories
RUN git clone --depth 1 https://github.com/crytic/building-secure-contracts.git


# # # Clean up
USER root
RUN apt-get autoremove -y && apt-get clean -y

# Configure MOTD
COPY --link --chown=root:root motd /etc/motd
RUN echo '\ncat /etc/motd\n' >> ~/.zshrc

USER vscode

