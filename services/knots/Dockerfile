FROM alpine:3.23 AS builder

RUN apk add --no-cache \
    build-base \
    gnupg \
    cmake \
    boost-dev \
    libevent-dev \
    sqlite-dev \
    zeromq-dev \
    coreutils \
    binutils

ARG MAJOR_VERSION=29
ARG VERSION=29.3.knots20260508
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

WORKDIR /opt/bitcoin/build

RUN cmake .. \
    -DCMAKE_INSTALL_PREFIX="/usr/local/" \
    -DRDTS_CONSENT=IMPLICIT \
    -DBUILD_DAEMON="ON" \
    -DBUILD_CLI="ON" \
    -DENABLE_WALLET="OFF" \
    -DWITH_ZMQ="OFF" \
    -DBUILD_TESTS="OFF" \
    -DBUILD_GUI="OFF" \
    -DBUILD_TX="OFF" \
    -DBUILD_UTIL="OFF" \
    -DBUILD_WALLET_TOOL="OFF" \
    -DBUILD_BENCH="OFF" \
    -DBUILD_FUZZ_BINARY="OFF" \
    -DBUILD_UTIL_CHAINSTATE="OFF" \
    -DWITH_BDB="OFF" \
    -DWITH_USDT="OFF" \
    -DINSTALL_MAN="OFF" \
    -DWITH_CCACHE="OFF"

RUN cmake --build . --parallel $(nproc)
RUN cmake --install .

RUN strip --strip-unneeded /usr/local/bin/*

FROM alpine:3.23

RUN apk add --no-cache \
    libevent \
    sqlite-libs \
    boost-system \
    boost-filesystem \
    boost-program_options

COPY --from=builder /usr/local/bin/   /usr/local/bin/
COPY bitcoin.conf                     /etc/bitcoin/bitcoin.conf

WORKDIR /var/lib/bitcoin
EXPOSE 8332

VOLUME ["/var/lib/bitcoin"]

ENTRYPOINT ["bitcoind", "-conf=/etc/bitcoin/bitcoin.conf", "-datadir=/var/lib/bitcoin"]
