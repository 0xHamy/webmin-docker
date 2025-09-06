FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies required by Webmin + common server software
RUN apt-get update && apt-get install -y \
    # Webmin dependencies
    perl \
    libnet-ssleay-perl \
    openssl \
    libauthen-pam-perl \
    supervisor \
    libpam-runtime \
    libio-pty-perl \
    python3 \
    wget \
    unzip \
    shared-mime-info \
    apt-show-versions \
    # Networking tools
    net-tools \
    iproute2 \
    # Web & DB servers for Webmin modules
    apache2 \
    nginx \
    mariadb-server \
    postfix \
    dovecot-core dovecot-imapd dovecot-pop3d \
    bind9 \
    vsftpd \
    spamassassin \
    clamav \
    # Useful extras
    vim \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy your downloaded Webmin .deb into the container
COPY webmin_2.500_all.deb /tmp/webmin.deb

# Install Webmin from local .deb
RUN dpkg --install /tmp/webmin.deb || apt-get -f install -y \
    && rm /tmp/webmin.deb \
    && update-rc.d -f webmin remove

# Copy Webmin user creation script
COPY create-webmin-users.sh /usr/local/bin/create-webmin-users.sh
RUN chmod +x /usr/local/bin/create-webmin-users.sh

# Run the script to set up initial accounts
RUN /usr/local/bin/create-webmin-users.sh

# Expose Webmin and webserver ports
EXPOSE 10000 80 443 21

# Start Webmin using its init script in foreground
CMD ["/etc/webmin/start", "--nofork"]
