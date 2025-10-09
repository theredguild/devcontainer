# syntax=docker/dockerfile:1.8
# check=error=true
# 
# MINIMAL TRG DevContainer Dockerfile
# This Dockerfile creates a minimal development environment for Web3 development
# with essential tools, basic security features, and a streamlined toolchain.
# 
# Key features:
# - Multi-stage build for Echidna binary
# - Essential development tools only
# - Basic security hardening
# - Minimal attack surface
# - Focused on core Web3 development needs

## Multi-stage build for Echidna
# Pull latest prebuilt Echidna binary from Crytic's official image
# TODO: "Ensure the base image uses a non latest version tag"
# Echidna is a fuzzing tool for Ethereum smart contracts
FROM --platform=linux/amd64 ghcr.io/crytic/echidna/echidna:latest AS echidna

# Base debian build (latest).
# Use Debian base image for stability and compatibility
FROM mcr.microsoft.com/vscode/devcontainers/base:debian

# Switch to root (the default might be root anyway)
# Root access is needed for system package installation
USER root

# Install essential system packages for development
# These are the minimal packages needed for Web3 development tools
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    bash-completion       # Shell completion support \
    build-essential       # Compilation tools (gcc, make, etc.) \
    curl                  # HTTP client for downloading tools \
    git                   # Version control system \
    jq                    # JSON processor for tool outputs \
    pkg-config            # Package configuration helper \
    sudo                  # Privilege escalation (needed for some tools) \
    unzip                 # Archive extraction \
    vim                   # Text editor \
    wget                  # Alternative HTTP client \
    zsh                   # Advanced shell \
    && rm -rf /var/lib/apt/lists/*


    
# Install Python development dependencies
# Required for Python-based security tools and package management
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    python3-pip          # Python package installer \
    libpython3-dev       # Python development headers \
    python3-dev          # Python development tools \
    python3-venv         # Python virtual environment support \
    && rm -rf /var/lib/apt/lists/*

# Switch to vscode user for security (drop privileges)
# This ensures all subsequent operations run as non-root user
USER vscode
WORKDIR /home/vscode
ENV HOME=/home/vscode

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Update PATH environment for tool access
# Configure paths for Python, Node.js, and other tools
ENV UV_LOCAL_BIN=$HOME/.local/bin
ENV USR_LOCAL_BIN=/usr/local/bin
ENV LOCAL_BIN=${HOME}/.local/bin
ENV PNPM_HOME=${HOME}/.local/share/pnpm
ENV PATH=${PATH}:${USR_LOCAL_BIN}:${LOCAL_BIN}:${PNPM_HOME}:${UV_LOCAL_BIN}

# Install Python 3.12 with uv
RUN uv python install 3.12

# Set the default shell to zsh
# zsh provides better shell features and development experience
ENV SHELL=/usr/bin/zsh

# Running everything under zsh for consistency and features
SHELL ["/usr/bin/zsh", "-ic"]

# Install Go programming language through asdf version manager
# asdf provides consistent version management across different tools
# Go is required for various Web3 tools and Foundry framework
RUN git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.15.0 && \
    echo '. $HOME/.asdf/asdf.sh' >> $HOME/.zshrc && \
    echo 'fpath=(${ASDF_DIR}/completions $fpath)' >> $HOME/.zshrc && \
    echo 'autoload -Uz compinit && compinit' >> $HOME/.zshrc && \
    . $HOME/.asdf/asdf.sh && \
    asdf plugin add golang && \
    asdf install golang latest && \
    asdf global golang latest

# Install Rust programming language
# Required for various Web3 security tools and Foundry framework
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && source $HOME/.cargo/env

# Switch to root user temporarily for Node.js installation
# Some tools require root access for system-wide installation
USER root

# Install Node.js, npm, yarn, and pnpm through devcontainer features
# These are essential for JavaScript/TypeScript Web3 development
RUN curl -o- https://raw.githubusercontent.com/devcontainers/features/main/src/node/install.sh | bash

# Switch back to vscode user for security
USER vscode

# Install Hardhat globally for Ethereum development framework
# Hardhat is a popular development environment for Ethereum
RUN pnpm install hardhat -g

# Python installations - minimal set for essential development
# Install only the core tools needed for basic Web3 development
# Install vyper and solc-select for smart contract development
RUN uv tool install vyper && \ 
    uv tool install solc-select && \
    solc-select install 0.8.10 latest && \
    solc-select use latest

# Install Foundry framework for Ethereum development
# Foundry provides Forge (testing), Cast (interaction), and Anvil (local blockchain)
## Foundry framework
RUN curl -fsSL https://foundry.paradigm.xyz | zsh
RUN foundryup

# Switch to root user for system-level operations
# Do some things as root for system configuration
USER root

# Add shell completions for Foundry tools
# This provides better user experience with tab completion
## Add completions for medusa, anvil, cast, forge.
RUN mkdir -p /usr/share/zsh/site-functions && \
    for tool in anvil cast forge; do \
        "$tool" completions zsh > /usr/share/zsh/site-functions/_$tool; \
    done

# Clean up package cache and temporary files
# This reduces image size and improves security
## Clean
RUN apt-get autoremove -y && apt-get clean -y

# Switch back to vscode user for development
## back to user!
USER vscode

# Health check for container monitoring
# Example HEALTHCHECK, we don't need once since we're not using services. 
# If you add services in the future, you would need to add "something" like this:
HEALTHCHECK --interval=60s --timeout=10s --start-period=10s --retries=3 CMD \
  zsh -c 'command -v forge && command -v solc && echo "OK" || exit 1'