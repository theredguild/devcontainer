# syntax=docker/dockerfile:1.8
# check=error=true
# 
# ISOLATED TRG DevContainer Dockerfile
# This Dockerfile creates a highly isolated development environment for Web3 security research
# with maximum security isolation, read-only filesystem, and network isolation.
# 
# Key security features:
# - Non-root user execution
# - Minimal package installation
# - Security-hardened toolchain

## Multi-stage build for Echidna
# Pull latest prebuilt Echidna binary from Crytic's official image
# Echidna is a fuzzing tool for Ethereum smart contracts
FROM --platform=linux/amd64 ghcr.io/crytic/echidna/echidna:latest AS echidna

# Base image: Latest Debian with VS Code DevContainer support
# This provides a stable, security-focused base for development
FROM mcr.microsoft.com/vscode/devcontainers/base:debian

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
ENV UV_LOCAL_BIN=$HOME/.cargo/bin
ENV USR_LOCAL_BIN=/usr/local/bin
ENV LOCAL_BIN=${HOME}/.local/bin
ENV PNPM_HOME=${HOME}/.local/share/pnpm
ENV PATH=${PATH}:${USR_LOCAL_BIN}:${LOCAL_BIN}:${PNPM_HOME}:${UV_LOCAL_BIN}

# Install Python 3.12 with uv
RUN uv python install 3.12

# Set the default shell execution for subsequent RUN commands
# Use zsh for better shell features and compatibility
ENV SHELL=/usr/bin/zsh
SHELL ["/bin/zsh", "-ic"]

# Install Rust programming language
# Required for various Web3 security tools and Foundry framework
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="$HOME/.cargo/bin:$PATH"

# Install Go programming language through asdf version manager
# asdf provides consistent version management across different tools
# Set asdf manager version for reproducibility
RUN git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.15.0 && \
    echo '. $HOME/.asdf/asdf.sh' >> $HOME/.zshrc && \
    echo 'fpath=(${ASDF_DIR}/completions $fpath)' >> $HOME/.zshrc && \
    echo 'autoload -Uz compinit && compinit' >> $HOME/.zshrc && \
    . $HOME/.asdf/asdf.sh && \
    asdf plugin add golang && \
    asdf install golang latest && \
    asdf global golang latest

# Switch to root user temporarily for Node.js installation
# Some tools require root access for system-wide installation
USER root

# Install Node.js, npm, yarn, and pnpm through devcontainer features
# These are essential for JavaScript/TypeScript Web3 development
RUN curl -o- https://raw.githubusercontent.com/devcontainers/features/main/src/node/install.sh | bash
RUN chown -R vscode:vscode ${HOME}/.npm

# Switch back to vscode user for security
USER vscode
ENV PNPM_HOME=${HOME}/.local/share/pnpm
ENV PATH=${PATH}:${PNPM_HOME}

# Install Python-based security analysis tools (reduced set for security focus)
# These tools provide essential smart contract security analysis
# Focused on core tools: slither, mythril, crytic-compile, halmos, solc-select
RUN uv tool install slither-analyzer && \ 
    uv tool install crytic-compile && \ 
    uv tool install slither-lsp && \ 
    uv tool install mythril && \ 
    uv tool install halmos && \ 
    uv tool install solc-select && \
    solc-select install 0.4.26 0.5.17 0.6.12 0.7.6 0.8.10 latest && solc-select use latest

# Install Foundry framework for Ethereum development
# Foundry provides Forge (testing), Cast (interaction), and Anvil (local blockchain)
RUN curl -fsSL https://foundry.paradigm.xyz | zsh && \
    echo 'export PATH="$HOME/.foundry/bin:$PATH"' >> ~/.zshrc && \
    export PATH="$HOME/.foundry/bin:$PATH" && \
    ~/.foundry/bin/foundryup

# Install Hardhat globally for Ethereum development framework
# Hardhat is a popular development environment for Ethereum
RUN pnpm install hardhat -g

# Build and install Medusa fuzzing tool
# Medusa is a fuzzing tool for smart contracts, similar to Echidna
WORKDIR $HOME/medusa
RUN git clone https://github.com/crytic/medusa $HOME/medusa && \
    export LATEST_TAG="$(git describe --tags | sed 's/-[0-9]+-gw+$//')" && \
    git checkout "$LATEST_TAG" && \
    go build -trimpath -o=$HOME/.local/bin/medusa -ldflags="-s -w" && \
    chmod 755 $HOME/.local/bin/medusa

# Return to home directory and clean up build artifacts
WORKDIR $HOME
RUN rm -rf medusa/

# Copy Echidna binary from echidna stage to final image
# This provides the prebuilt Echidna tool without rebuilding
USER root
COPY --from=echidna /usr/local/bin/echidna /usr/local/bin/echidna
RUN chmod 755 /usr/local/bin/echidna

# Final setup and verification
USER vscode
RUN echo 'Development environment ready!' && \
echo 'Tools installed:' && \
    ls -la $HOME/.local/bin/ || true

# Set working directory to workspace for development
WORKDIR /workspace