FROM postgres:16-bullseye

# Install tools
RUN apt-get update && apt-get install -y \
    procps \
    net-tools \
    iproute2 \
    && rm -rf /var/lib/apt/lists/*

# Copy initialization script
COPY init_user.sh /docker-entrypoint-initdb.d/init-user.sh
RUN chmod +x /docker-entrypoint-initdb.d/init-user.sh

CMD ["postgres"]
