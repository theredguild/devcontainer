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
    zsh python3-pip pipx curl git sudo pkg-config

# The base container usually has a “vscode” user. If not, create one here.
RUN echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to vscode (drop privs)
USER vscode
WORKDIR /home/vscode

# Set PATH with .local/bin included.
ENV HOME=/home/vscode
ENV LOCAL_BIN=${HOME}/.local/bin
ENV PATH=${PATH}:${LOCAL_BIN}
RUN pipx ensurepath

# Set the default shell to zsh
ENV SHELL=/usr/bin/zsh

# Running everything under zsh
SHELL ["/usr/bin/zsh", "-ic"]


# Install golang's latest version through asdf
RUN git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.15.0 && \
    echo '. $HOME/.asdf/asdf.sh' >> $HOME/.zshrc && \
    echo 'fpath=(${ASDF_DIR}/completions $fpath)' >> $HOME/.zshrc && \
    echo 'autoload -Uz compinit && compinit' >> $HOME/.zshrc && \
    . $HOME/.asdf/asdf.sh && \
    asdf plugin add golang && \
    asdf install golang latest && \
    asdf global golang latest

## Install rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && source $HOME/.cargo/env

## Install nvm, yarn, npm, pnpm
RUN curl -o- https://raw.githubusercontent.com/devcontainers/features/main/src/node/install.sh | sudo bash

# Python installations
## Install slither-analyzer, crytic-compile (through napalm-core), solc (through napalm-core), vyper, mythx, panoramix, slider-lsp (needed for contract explorer), napalm-toolbox
RUN pipx install napalm-core --include-deps && \ 
    pipx install slither-analyzer && \ 
    pipx install vyper && \ 
    pipx install panoramix-decompiler && \ 
    pipx install slither-lsp && \ 
    pipx install mythril && \ 
    pipx install napalm-toolbox && \ 
    pipx install semgrep && \ 
    pipx install slitherin && \ 
    solc-select install 0.4.26 0.5.17 0.6.12 0.7.6 0.8.10 latest && solc-select use latest



# Fetch and install setups
## ityfuzz
RUN curl -fsSL https://ity.fuzz.land/ | zsh
RUN ityfuzzup

## Foundry framework
RUN curl -fsSL https://foundry.paradigm.xyz | zsh
RUN foundryup

## Aderyn
RUN curl -fsSL https://raw.githubusercontent.com/Cyfrin/aderyn/dev/cyfrinup/install | zsh
RUN cyfrinup

## Halmos
### First installs uv, and then the latest version of halmos and adds it to PATH
RUN curl -fsSL https://astral.sh/uv/install.sh | bash && \
    uv tool install halmos

## Heimdall
### Replace 'bifrost' call for 'bifrost -B' so it downloads de binary instead of compiling it.
### Right now this debian uses a glibc version lower than heimdall needs.
RUN curl -fsSL https://get.heimdall.rs | zsh && \
    . ${HOME}/.cargo/env && \
    ${HOME}/.bifrost/bin/bifrost

# Git clone, compile kind of installations
## Install Medusa
RUN git clone https://github.com/crytic/medusa.git ${HOME}/medusa && \
    cd ${HOME}/medusa && \
    export LATEST_TAG="$(git describe --tags | sed 's/-[0-9]\+-g\w\+$//')" && \
    git checkout "$LATEST_TAG" && \
    go build -trimpath -o=${HOME}/.local/bin/medusa -ldflags="-s -w" && \
    chmod 755 ${HOME}/.local/bin/medusa && \
    cd ${HOME} && rm -rf medusa

# Copy prebuilt Echidna binary
COPY --chown=vscode:vscode --from=echidna /usr/local/bin/echidna ${HOME}/.local/bin/echidna
RUN chmod 755 ${HOME}/.local/bin/echidna

# Clone useful repositories
RUN git clone --depth 1 https://github.com/crytic/building-secure-contracts.git


# Do some things as root
USER root

## Add completions for medusa, anvil, cast, forge.
RUN mkdir -p /usr/share/zsh/site-functions && \
    medusa completion zsh > /usr/share/zsh/site-functions/_medusa && \
    for tool in anvil cast forge; do \
        "$tool" completions zsh > /usr/share/zsh/site-functions/_$tool; \
    done

## Clean
RUN apt-get autoremove -y && apt-get clean -y

## Configure MOTD
COPY --link --chown=root:root motd /etc/motd
RUN echo '\ncat /etc/motd\n' >> ~/.zshrc

## back to user!
USER vscode

