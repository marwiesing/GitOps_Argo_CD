FROM ubuntu:20.04

# Set non-interactive mode to avoid prompts during the build
ENV DEBIAN_FRONTEND=noninteractive

# Install required tools: curl for downloading, gettext for envsubst
RUN apt-get update && \
    apt-get install -y curl gettext && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory for kustomize installation
WORKDIR /usr/local/bin

# Install kustomize using the official script
RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash

# Set the working directory for the plugin configuration
WORKDIR /home/argocd/cmp-server/config/

# Copy the plugin configuration file to the correct directory
COPY plugin.yaml ./

# Set a default entrypoint for the container
CMD ["sh"]
