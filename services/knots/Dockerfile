FROM alpine:3.19

ARG GROUP_ID

RUN apk add --no-cache build-base

RUN git clone https://github.com/bitcoin-knots/bitcoin.git
WORKDIR /bitcoin
RUN ./autogen.sh
RUN CXXFLAGS="-O2 -march=native -pipe" ./configure \
    --quiet \
    --no-create \
    --disable-tests \
    --disable-gui-tests \
    --disable-bench \
    --disable-fuzz-binary \
    --disable-dependency-tracking \
    --disable-man \
    --disable-util-wallet \
    --with-gui=no
RUN make -j$(nproc)
RUN make install

COPY bitcoin.conf /etc/bitcoin.conf

RUN addgroup -g $GROUP_ID tor
RUN adduser -g tor -SDH knots
RUN chmod +x /entrypoint.sh
RUN chown -R knots:knots /var/lib/knots
RUN chown -R knots:knots /etc/bitcoin.conf

WORKDIR /var/lib/knots
USER knots

VOLUME ["/var/lib/knots", "/var/lib/tor"]
CMD ["bitcoind", "-datadir=/var/lib/knots", "-conf=/etc/bitcoin.conf"]

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 CMD []