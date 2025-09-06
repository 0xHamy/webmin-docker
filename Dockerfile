FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies required by Webmin
RUN apt-get update && apt-get install -y \
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
    && rm -rf /var/lib/apt/lists/*

# Copy your downloaded Webmin .deb into the container
COPY webmin_2.500_all.deb /tmp/webmin.deb

# Install Webmin from local .deb
RUN dpkg --install /tmp/webmin.deb || apt-get -f install -y \
    && rm /tmp/webmin.deb \
    && update-rc.d -f webmin remove

# Expose Webmin port
EXPOSE 10000

# Start Webmin using its init script in foreground
CMD ["/etc/webmin/start", "--nofork"]
