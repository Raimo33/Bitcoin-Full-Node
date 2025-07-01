FROM alpine:3.19

ARG GROUP_ID

RUN apk add --no-cache tor netcat-openbsd

COPY torrc /etc/tor/torrc
RUN mkdir -p /var/lib/tor

RUN addgroup -g $GROUP_ID tor
RUN adduser -g tor -SDH tor
RUN chown -R tor:tor /etc/tor /var/lib/tor
RUN chmod 750 /etc/tor/

WORKDIR /var/lib/tor
USER tor
EXPOSE 9050 9051 9001

VOLUME ["/var/lib/tor"]
CMD ["tor", "-f", "/etc/tor/torrc"]

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 CMD ["nc", "-z", "localhost", "9050"]