FROM alpine:3.22 AS builder

RUN apk add --no-cache \
  build-base autoconf automake pkgconfig libtool \
  boost-dev zeromq-dev libevent-dev unzip binutils

ADD https://codeload.github.com/bitcoinknots/bitcoin/zip/refs/heads/28.x-knots /tmp/bitcoin.zip
RUN cd /tmp && unzip bitcoin.zip && mv bitcoin-28.x-knots /bitcoin

WORKDIR /bitcoin

RUN ./autogen.sh
RUN CXXFLAGS="-O2 -march=native -pipe -flto" LDFLAGS="-flto" ./configure \
  --quiet \
  --disable-tests \
  --disable-gui-tests \
  --disable-bench \
  --disable-fuzz-binary \
  --disable-dependency-tracking \
  --disable-man \
  --disable-shared \
  --disable-static \
  --disable-util-wallet \
  --without-bdb \
  --with-gui=no \
  --bindir=/usr/bin/knots

RUN make -j$(nproc)
RUN make install
RUN strip --strip-unneeded /usr/bin/knots/*

FROM alpine:3.22

RUN apk add --no-cache boost zeromq libevent

ARG KNOTS_UID KNOTS_GID TOR_GID

RUN addgroup -g ${KNOTS_GID} knots && \
    addgroup -g ${TOR_GID} tor && \
    adduser -SDH -u ${KNOTS_UID} -g knots -G tor knots

RUN mkdir -p /etc/knots

COPY --from=builder /usr/bin/knots/ /usr/bin/
COPY bitcoin.conf /etc/knots/bitcoin.conf

RUN chown -R knots:knots /etc/knots

WORKDIR /var/lib/knots
USER knots
VOLUME ["/var/lib/knots", "/var/lib/tor"]

CMD ["bitcoind", "-datadir=/var/lib/knots", "-conf=/etc/knots/bitcoin.conf"]