# Use the official Ubuntu 24.04 base image
FROM ubuntu:24.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary packages
RUN apt-get update && apt-get install -y \
    sudo \
    wget \
    curl \
    gnupg2 \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a new user with sudo privileges
ARG HOST_UID
ARG HOST_GID
ARG USERNAME=dockeruser

# Create user and group with matching UID and GID
RUN if ! getent group $HOST_GID; then groupadd -g $HOST_GID $USERNAME; fi && \
    if ! getent passwd $HOST_UID; then \
      useradd -u ${HOST_UID} -g ${HOST_GID} -m ${USERNAME}; \
    else \
        existing_user=$(getent passwd $HOST_UID | cut -d: -f1) && \
        usermod -l $USERNAME $existing_user && \
        groupmod -n $USERNAME $(getent group $HOST_GID | cut -d: -f1); \
    fi && \
    echo "${USERNAME}:ubuntu" | chpasswd && \
    adduser ${USERNAME} sudo && \
    echo "${USERNAME} ALL=(ALL) ALL" >> /etc/sudoers;

# Switch to the new user
USER $USERNAME

# Install Visual Studio Code
RUN curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /usr/share/keyrings/packages.microsoft.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list \
    && sudo apt-get update \
    && sudo apt-get install -y code \
    && sudo apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /home/$USERNAME

# Command to run when starting the container
CMD [ "bash" ]
