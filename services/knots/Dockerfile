FROM alpine:3.22 AS builder

RUN apk add --no-cache \
    build-base boost-dev zeromq-dev libevent-dev sqlite-dev \
    gnupg coreutils binutils

ARG _BASE_URL=https://bitcoinknots.org/files/28.x/28.1.knots20250305
ARG _RELEASE=bitcoin-28.1.knots20250305

ADD ${_BASE_URL}/${_RELEASE}.tar.gz    /tmp/
ADD ${_BASE_URL}/SHA256SUMS            /tmp/
ADD ${_BASE_URL}/SHA256SUMS.asc        /tmp/
COPY gpg/                              /tmp/gpg/

WORKDIR /tmp

RUN gpg --import gpg/* && \
    gpg --verify SHA256SUMS.asc SHA256SUMS && \
    sha256sum -c SHA256SUMS --ignore-missing

RUN tar -xzf ${_RELEASE}.tar.gz --strip-components=1

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

RUN apk add --no-cache \
    boost zeromq libevent sqlite

COPY --from=builder /usr/bin/knots/ /usr/bin/
COPY bitcoin.conf   /etc/knots/bitcoin.conf

WORKDIR /var/lib/knots
EXPOSE 8332

VOLUME ["/var/lib/knots"]
ENTRYPOINT ["bitcoind", "-conf=/etc/knots/bitcoin.conf"]