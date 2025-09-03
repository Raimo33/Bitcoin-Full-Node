FROM alpine:3.22 AS builder

RUN apk add --no-cache \
    build-base \
    boost-dev \
    libevent-dev \
    sqlite-dev \
    gnupg \
    coreutils \
    binutils

ARG MAJOR_VERSION=28
ARG VERSION=28.1.knots20250305
ARG BASE_URL=https://bitcoinknots.org/files/${MAJOR_VERSION}.x/${VERSION}
ARG TARBALL=bitcoin-${VERSION}.tar.gz

WORKDIR /opt/bitcoin

ADD ${BASE_URL}/${TARBALL}      ${TARBALL}
ADD ${BASE_URL}/SHA256SUMS      SHA256SUMS
ADD ${BASE_URL}/SHA256SUMS.asc  SHA256SUMS.asc
COPY gpg/                       gpg/

RUN gpg --import gpg/* && \
    gpg --verify SHA256SUMS.asc SHA256SUMS && \
    sha256sum -c SHA256SUMS --ignore-missing

RUN tar xzf ${TARBALL} --strip-components=1

RUN CXXFLAGS="-march=native" ./configure \
    --quiet \
    --bindir=/opt/bitcoin/bin \
    --with-daemon \
    --disable-wallet \
    --disable-zmq \
    --disable-fuzz-binary \
    --disable-debug \
    --disable-tests \
    --disable-bench \
    --disable-man \
    --disable-ccache \
    --disable-dependency-tracking \
    --without-libs \
    --without-utils \
    --without-gui \
    --without-bdb

RUN make -j$(nproc)
RUN make install

RUN strip --strip-unneeded /opt/bitcoin/bin/*

FROM alpine:3.22

RUN apk add --no-cache \
    libevent \
    sqlite-libs \
    boost-system \
    boost-filesystem \
    boost-program_options

COPY --from=builder /opt/bitcoin/bin/   /usr/local/bin/
COPY bitcoin.conf                       /etc/bitcoin/bitcoin.conf

WORKDIR /var/lib/bitcoin
EXPOSE 8332

VOLUME ["/var/lib/bitcoin"]

ENTRYPOINT ["bitcoind", "-conf=/etc/bitcoin/bitcoin.conf", "-datadir=/var/lib/bitcoin"]