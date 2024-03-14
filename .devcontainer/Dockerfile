FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID


# Install Fish shell
RUN echo "deb http://ppa.launchpad.net/fish-shell/release-3/ubuntu jammy main"\
| tee /etc/apt/sources.list.d/fish-shell.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 27557F056DC33CA5
RUN apt-get update && apt-get install -y fish

# Install Python, Go, and other dependencies
RUN apt-get install -y python3-pip golang

# # Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_21.x | sudo -E bash - &&\
sudo apt-get install -y nodejs

# # Install Hardhat
RUN npm install -g hardhat

# Install solc-select
RUN pip3 install solc-select

# Install slither
RUN pip3 install slither-analyzer

# install Medusa (crytic-compile)
RUN pip3 install crytic-compile

# Clean up
RUN apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Set the default shell to Fish
ENV SHELL=/usr/bin/fish

# As a non-privileged user
USER vscode

# Running everything under fish
SHELL ["/usr/bin/fish", "-c"]

# Install Starship prompt for fish
RUN curl -sS https://starship.rs/install.sh | sh -s -- -y

# Installing foundry and updating it
RUN curl -L https://foundry.paradigm.xyz | bash
RUN foundryup

# Back to root
USER root
SHELL ["/bin/sh", "-c"]