# This would be the equivalent of the 'image' field of the devcontainer.json
# It is now being referenced from the 'build' field.
FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu

# Drop privileges. Using the ones that come already from
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN apt-get update && apt-get install

USER vscode

# Clean up
RUN apt-get autoremove -y && apt-get clean -y

# Set the default shell to Fish
ENV SHELL=/usr/bin/fish

# Running everything under fish
SHELL ["/usr/bin/fish", "-c"]