FROM alpine:3.19

ARG GROUP_ID

RUN apk add --no-cache

#TODO install knots.
#TODO copy bitcoin.conf in /var/lib/knots (after mount...)

RUN addgroup -g $GROUP_ID tor
RUN adduser -g tor -SDH knots

WORKDIR /var/lib/knots
USER knots

VOLUME ["/var/lib/knots", "/var/lib/tor"]
CMD ["bitcoind", "-datadir=/var/lib/knots"]

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 CMD ["nc", "-z", "localhost", "9050"]