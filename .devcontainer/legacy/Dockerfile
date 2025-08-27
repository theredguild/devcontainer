# syntax=docker/dockerfile:1.8
# check=error=true

## Multi-stage build!
# Pull latest prebuilt Echidna binary.
# TODO: "Ensure the base image uses a non latest version tag"
FROM --platform=linux/amd64 ghcr.io/crytic/echidna/echidna:latest AS echidna

# Base debian build (latest).
FROM mcr.microsoft.com/vscode/devcontainers/base:debian

# Switch to root (the default might be root anyway)
USER root

# Super basic stuff to get everything started
RUN apt-get update -y && apt-get install -y \
    zsh python3-pip python3-venv python3-dev libpython3-dev build-essential vim curl git sudo pkg-config \
    --no-install-recommends

# The base container usually has a “vscode” user. If not, create one here.
RUN echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to vscode (drop privs)
USER vscode
WORKDIR /home/vscode

# Set HOME and create quests folder
ENV HOME=/home/vscode
RUN mkdir -p ${HOME}/quests && chown vscode:vscode ${HOME}/quests

# Set neded paths (for python, pix, pnpm)
ENV USR_LOCAL_BIN=/usr/local/bin
ENV LOCAL_BIN=${HOME}/.local/bin
ENV PNPM_HOME=${HOME}/.local/share/pnpm
ENV PATH=${PATH}:${USR_LOCAL_BIN}:${LOCAL_BIN}:${PNPM_HOME}

# Configure pip to allow system packages in container environment
ENV PIP_BREAK_SYSTEM_PACKAGES=1

# Install uv
RUN python3 -m pip install --no-cache-dir --upgrade uv

# # Install pipx
# RUN python3 -m pip install --no-cache-dir --upgrade pipx

# # Make sure pipx's paths are set
# RUN pipx ensurepath

# Set asdf manager version
ENV ASDF_VERSION=v0.15.0

# Set the default shell to zsh
ENV SHELL=/usr/bin/zsh

# Running everything under zsh
SHELL ["/usr/bin/zsh", "-ic"]


# Install golang's latest version through asdf
RUN git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch ${ASDF_VERSION}  && \
    echo '. $HOME/.asdf/asdf.sh' >> $HOME/.zshrc && \
    echo 'fpath=(${ASDF_DIR}/completions $fpath)' >> $HOME/.zshrc && \
    echo 'autoload -Uz compinit && compinit' >> $HOME/.zshrc && \
    . $HOME/.asdf/asdf.sh && \
    asdf plugin add golang && \
    asdf install golang latest && \
    asdf global golang latest

## Install rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && source $HOME/.cargo/env

USER root
## Install nvm, yarn, npm, pnpm
RUN curl -o- https://raw.githubusercontent.com/devcontainers/features/main/src/node/install.sh | bash
RUN chown -R vscode:vscode ${HOME}/.npm
USER vscode

RUN pnpm install hardhat -g

# Python installations
# Install slither, crytic-compile, solc, vyper, mythx, panoramix, slider-lsp (needed for contract explorer), napalm-toolbox. napalm-core has to be installed manually.
RUN uv tool install slither-analyzer && \ 
    uv tool install crytic-compile && \ 
    uv tool install vyper && \ 
    uv tool install panoramix-decompiler && \ 
    uv tool install slither-lsp && \ 
    uv tool install mythril && \ 
    uv tool install napalm-toolbox && \ 
    uv tool install semgrep && \ 
    uv tool install slitherin && \ 
    uv tool install solc-select && \
    solc-select install 0.4.26 0.5.17 0.6.12 0.7.6 0.8.10 latest && solc-select use latest

# Fetch and install setups
## ityfuzz
RUN curl -fsSL https://ity.fuzz.land/ | zsh
RUN ityfuzzup

## Foundry framework
RUN curl -fsSL https://foundry.paradigm.xyz | zsh
RUN foundryup

## Aderyn
RUN curl -fsSL https://raw.githubusercontent.com/Cyfrin/up/main/install | zsh
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
### Set working directory for Medusa operations
WORKDIR ${HOME}/medusa
RUN git clone https://github.com/crytic/medusa ${HOME}/medusa && \
    export LATEST_TAG="$(git describe --tags | sed 's/-[0-9]\+-g\w\+$//')" && \
    git checkout "$LATEST_TAG" && \
    go build -trimpath -o=${HOME}/.local/bin/medusa -ldflags="-s -w" && \
    chmod 755 ${HOME}/.local/bin/medusa
    #### Return to the home directory and clean up
WORKDIR ${HOME}
RUN rm -rf medusa/

# Copy prebuilt Echidna binary
COPY --chown=vscode:vscode --from=echidna /usr/local/bin/echidna ${HOME}/.local/bin/echidna
RUN chmod 755 ${HOME}/.local/bin/echidna

# Clone useful repositories inside quests
WORKDIR ${HOME}/quests
RUN git clone --depth 1 https://github.com/crytic/building-secure-contracts.git

# Back to home in case we want to do something later.
WORKDIR ${HOME}

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

# Example HEALTHCHECK, we don't need once since we're not using services. If you add services in the future, you would need to add "something" like this:
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 CMD \
  zsh -c 'command -v echidna && command -v medusa && command -v slither && command -v solc && echo "OK" || exit 1'