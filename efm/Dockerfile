FROM debian:11

COPY install.sh /install.sh

RUN chmod +x /install.sh
RUN  /install.sh

# Open EFM port
EXPOSE 7800 7801

#ENTRYPOINT ["/usr/bin/tini", "--"]

