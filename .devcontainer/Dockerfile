# DOCKERFILE SAMPLE FILE
# This would be the equivalent of the 'image' field of the devcontainer.json
# It should be referenced from the 'build' field.
# This is currently not being used, since there's no reference to it.
FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu

# Create a user, group id and uid
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN apt-get update && apt-get install

# Drop privileges, and switch to recently created user
USER vscode

# Clean up
RUN apt-get autoremove -y && apt-get clean -y

# Set the default shell to Fish
ENV SHELL=/usr/bin/fish

# Running everything under fish
SHELL ["/usr/bin/fish", "-c"]