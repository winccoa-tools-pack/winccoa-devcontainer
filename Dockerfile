# ========================================
# STAGE 1: Extract WinCC OA
# ========================================
FROM debian:12 AS unpack

# Install only unzip for extraction
RUN apt-get update && apt-get install -y unzip && rm -rf /var/lib/apt/lists/*

# Copy and extract ZIP file
COPY installer/WinCCOA-3.21.0-debian.x86_64.zip /tmp/
RUN unzip /tmp/WinCCOA-3.21.0-debian.x86_64.zip -d /tmp/winccoa


# ========================================
# STAGE 2: Final Image
# ========================================
FROM debian:12

# Disable prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install base dependencies + Locales (FIX for PostgreSQL)
RUN apt-get update && apt-get install -y \
    unzip \
    openssh-server \
    sudo \
    locales \
    gosu \
    && rm -rf /var/lib/apt/lists/* \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen en_US.UTF-8

# Copy WinCC OA from stage 1
COPY --from=unpack /tmp/winccoa /opt/WinCC_OA

# Install WinCC OA packages
WORKDIR /opt/WinCC_OA
RUN apt-get update && \
    apt-get install -y ./*.deb && \
    rm -rf /var/lib/apt/lists/*

# Set environment variables (incl. locale for PostgreSQL)
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV PVSS_II=/opt/WinCC_OA
ENV PATH="${PVSS_II}/bin:${PATH}"

# Configure SSH
RUN mkdir /var/run/sshd && \
    echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Make SSH keys persistent - copy them at startup
COPY --chmod=755 ssh-startup.sh /usr/local/bin/ssh-startup.sh

# Create user and set passwords
RUN echo 'root:winccoasecret' | chpasswd && \
    useradd -m -s /bin/bash winccoa && \
    echo 'winccoa:winccoasecret' | chpasswd && \
    usermod -aG sudo winccoa && \
    echo 'winccoa ALL=(ALL) NOPASSWD: /usr/sbin/sshd, /usr/local/bin/ssh-startup.sh' >> /etc/sudoers

# Create project folders
RUN mkdir -p /opt/projects && \
    chown -R winccoa:winccoa /opt/projects && \
    mkdir -p /home/winccoa/WinCCOA_Proj && \
    chown -R winccoa:winccoa /home/winccoa/WinCCOA_Proj

# Copy projects from ./projects into image (if present)
COPY --chown=winccoa:winccoa ./projects/ /home/winccoa/WinCCOA_Proj/

# Set working directory
WORKDIR /home/winccoa/WinCCOA_Proj

# Expose ports
EXPOSE 22 4999 5678 4777

# Startup script
COPY --chmod=755 docker-entrypoint.sh /docker-entrypoint.sh

# Container starts as root (for SSH), then calls gosu
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["tail", "-f", "/dev/null"]
