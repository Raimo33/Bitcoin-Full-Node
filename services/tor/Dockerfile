FROM alpine:3.22

ARG TOR_UID TOR_GID 

RUN apk add --no-cache tor shadow netcat-openbsd

COPY torrc /etc/tor/torrc
RUN mkdir -p /var/lib/tor

RUN groupmod -g ${TOR_GID} tor && \
    usermod -u ${TOR_UID} tor  && \
    chown -R tor:tor /etc/tor

WORKDIR /var/lib/tor
USER tor
EXPOSE 8333

VOLUME ["/var/lib/tor"]
CMD ["tor", "-f", "/etc/tor/torrc"]

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 CMD ["nc", "-z", "localhost", "9050"]