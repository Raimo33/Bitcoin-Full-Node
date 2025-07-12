FROM alpine:3.22 AS builder

RUN apk add --no-cache \
    build-base \
    boost-dev \
    zeromq-dev \
    libevent-dev \
    sqlite-dev \
    gnupg \
    coreutils \
    binutils

ARG MAJOR_VERSION=28
ARG VERSION=28.1.knots20250305
ARG BASE_URL=https://bitcoinknots.org/files/${MAJOR_VERSION}.x/${VERSION}
ARG TARBALL=bitcoin-${VERSION}.tar.gz

WORKDIR /tmp

ADD ${BASE_URL}/${TARBALL}      ${TARBALL}
ADD ${BASE_URL}/SHA256SUMS      SHA256SUMS
ADD ${BASE_URL}/SHA256SUMS.asc  SHA256SUMS.asc
COPY gpg/                       gpg/

RUN gpg --import gpg/* && \
    gpg --verify SHA256SUMS.asc SHA256SUMS && \
    sha256sum -c SHA256SUMS --ignore-missing

RUN tar xzf ${TARBALL} --strip-components=1

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
    zeromq \
    libevent \
    sqlite \
    boost-system \
    boost-filesystem \
    boost-program_options

COPY --from=builder /usr/bin/knots/  /usr/bin/
COPY bitcoin.conf                    /etc/knots/bitcoin.conf

WORKDIR /var/lib/knots
EXPOSE 8332

VOLUME ["/var/lib/knots"]
ENTRYPOINT ["bitcoind", "-conf=/etc/knots/bitcoin.conf"]