FROM alpine:3.22 AS builder

RUN apk add --no-cache \
  build-base autoconf automake pkgconfig libtool \
  boost-dev zeromq-dev libevent-dev unzip binutils \
  sqlite-dev gnupg

ARG _BASE_URL=https://github.com/bitcoinknots/bitcoin/releases/download/v28.1.knots20250305

ADD ${_BASE_URL}/bitcoin-28.1.knots20250305.tar.gz  /tmp/
ADD ${_BASE_URL}/SHA256SUMS                         /tmp/
ADD ${_BASE_URL}/SHA256SUMS.asc                     /tmp/
COPY luke-jr.asc                                    /tmp/

WORKDIR /tmp

RUN gpg --import luke-jr.asc && \
    gpg --verify SHA256SUMS.asc SHA256SUMS && \
    sha256sum -c SHA256SUMS --ignore-missing

RUN tar -xzf bitcoin-28.1.knots20250305.tar.gz && \
    mv bitcoin-28.1.knots20250305 bitcoin

WORKDIR /bitcoin

RUN ./autogen.sh
RUN CXXFLAGS="-O2 -march=native -pipe -flto" LDFLAGS="-flto" ./configure \
  --quiet \
  --bindir=/usr/bin/knots \
  --disable-dependency-tracking \
  --disable-tests \
  --disable-gui-tests \
  --disable-bench \
  --disable-fuzz-binary \
  --disable-man \
  --disable-shared \
  --disable-static \
  --enable-wallet \
  --without-bdb \
  --with-sqlite \
  --with-gui=no

RUN make -j$(nproc)
RUN make install

RUN for f in /usr/bin/knots/*; do \
  if file "$f" | grep -q ELF; then \
    strip --strip-unneeded "$f"; \
  fi; \
done

FROM alpine:3.22

RUN apk add --no-cache boost zeromq libevent sqlite

ARG KNOTS_UID KNOTS_GID TOR_GID

RUN mkdir -p /etc/knots

RUN addgroup -g ${KNOTS_GID} knots && \
    addgroup -g ${TOR_GID} tor && \
    adduser -SDH -u ${KNOTS_UID} -G knots knots && \
    addgroup knots tor

COPY --from=builder /usr/bin/knots/ /usr/bin/
COPY bitcoin.conf /etc/knots/bitcoin.conf

RUN chown -R knots:knots /etc/knots

WORKDIR /var/lib/knots
USER knots
EXPOSE 8332

VOLUME ["/var/lib/knots", "/var/lib/tor"]
CMD ["bitcoind", "-conf=/etc/knots/bitcoin.conf"]
#TODO fix unreachable node. ephemeral hidden service issue