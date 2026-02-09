FROM ghcr.io/actions/actions-runner:latest

USER root

# Install SSH server
RUN apt-get update -qq && \
    apt-get install -y -qq openssh-server && \
    rm -rf /var/lib/apt/lists/*

# Configure SSH
RUN mkdir -p /run/sshd && \
    chmod 755 /run/sshd && \
    chown root:root /run/sshd && \
    ssh-keygen -A && \
    echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Fix home dir permissions (sshd rejects world-writable homes)
RUN chmod 755 /home/runner

# Set up SSH directory for runner user
RUN mkdir -p /home/runner/.ssh && \
    chmod 700 /home/runner/.ssh && \
    chown runner:runner /home/runner/.ssh

# Authorized keys injected at build time via build arg
ARG SSH_PUBLIC_KEY=""
RUN echo "${SSH_PUBLIC_KEY}" > /home/runner/.ssh/authorized_keys && \
    chmod 600 /home/runner/.ssh/authorized_keys && \
    chown runner:runner /home/runner/.ssh/authorized_keys

# Entrypoint starts sshd then runs the original command
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER runner

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/home/runner/run.sh"]
