FROM docker:dind

# Accept build-time architecture argument
ARG TARGETARCH

#install curl, bash, kubectl, and coreutils (for timeout command)
RUN apk add --no-cache curl bash coreutils
# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/
# use our own to start kind cluster
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# persist existing entrypoint and modify it to disable TLS
RUN cp /usr/local/bin/dockerd-entrypoint.sh /usr/local/bin/startup.sh
# Modify startup script to disable TLS
RUN sed -i 's/DOCKER_TLS_CERTDIR=\/certs/DOCKER_TLS_CERTDIR=""/' /usr/local/bin/startup.sh
RUN sed -i 's/dockerd-entrypoint.sh dockerd/dockerd-entrypoint.sh dockerd --host=unix:\/\/\/var\/run\/docker.sock --host=tcp:\/\/0.0.0.0:2375 --tls=false/' /usr/local/bin/startup.sh

#copy scripts
COPY scripts/ /usr/local/bin/

#make scripts executable
RUN chmod +x /usr/local/bin/env-setup
RUN chmod +x /usr/local/bin/env-cleanup
RUN chmod +x /usr/local/bin/k3d-install.sh

# Pre-install k3d to avoid startup delay
# RUN /usr/local/bin/k3d-install.sh

# Pre-pull k3d images to avoid download delays during cluster creation
# Add retry logic for image pulls to handle DNS timeouts
# RUN k3d version || true

# Function to retry docker pull with exponential backoff
RUN echo '#!/bin/sh' > /usr/local/bin/retry-pull.sh && \
    echo 'retry_pull() {' >> /usr/local/bin/retry-pull.sh && \
    echo '  local image="$1"' >> /usr/local/bin/retry-pull.sh && \
    echo '  local max_attempts=5' >> /usr/local/bin/retry-pull.sh && \
    echo '  local attempt=1' >> /usr/local/bin/retry-pull.sh && \
    echo '  while [ $attempt -le $max_attempts ]; do' >> /usr/local/bin/retry-pull.sh && \
    echo '    echo "Attempt $attempt/$max_attempts: Pulling $image"' >> /usr/local/bin/retry-pull.sh && \
    echo '    if docker pull "$image"; then' >> /usr/local/bin/retry-pull.sh && \
    echo '      echo "Successfully pulled $image"' >> /usr/local/bin/retry-pull.sh && \
    echo '      return 0' >> /usr/local/bin/retry-pull.sh && \
    echo '    fi' >> /usr/local/bin/retry-pull.sh && \
    echo '    echo "Failed to pull $image, attempt $attempt"' >> /usr/local/bin/retry-pull.sh && \
    echo '    sleep $((attempt * 2))' >> /usr/local/bin/retry-pull.sh && \
    echo '    attempt=$((attempt + 1))' >> /usr/local/bin/retry-pull.sh && \
    echo '  done' >> /usr/local/bin/retry-pull.sh && \
    echo '  echo "Failed to pull $image after $max_attempts attempts"' >> /usr/local/bin/retry-pull.sh && \
    echo '  return 1' >> /usr/local/bin/retry-pull.sh && \
    echo '}' >> /usr/local/bin/retry-pull.sh && \
    chmod +x /usr/local/bin/retry-pull.sh

# Use retry logic for image pulls - MOVED TO RUNTIME
# RUN /usr/local/bin/retry-pull.sh ghcr.io/k3d-io/k3d-tools:5.8.3 || true
# RUN /usr/local/bin/retry-pull.sh docker.io/rancher/k3s:v1.31.5-k3s1 || true
# RUN /usr/local/bin/retry-pull.sh kindest/node:v1.32.3 || true

ENV KIND_DEFAULT_VERSION=v1.32.3

RUN apk add --no-cache openssh-server
RUN apk add bash 
RUN apk add openssh-server-pam

RUN ssh-keygen -A

# allow root ssh login without password 
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication no/' /etc/ssh/sshd_config
RUN sed -i 's/^#UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

# create a non-login user for ssh access
RUN adduser -D -s /bin/bash candidate
RUN passwd -d candidate

# #set not password for candidate user
RUN echo "candidate::0:0:candidate:/home/candidate:/bin/bash" > /etc/passwd
RUN echo "candidate:x:1000:1000:candidate:/home/candidate:/bin/bash" >> /etc/passwd

# create a home directory for the candidate user
RUN mkdir -p /home/candidate/.kube
RUN chown -R candidate:candidate /home/candidate
RUN chmod 755 /home/candidate/.kube

EXPOSE 6443
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]