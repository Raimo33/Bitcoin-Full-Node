FROM alpine:3.22 AS builder

RUN apk add --no-cache \
    build-base \
    libevent-dev \
    openssl-dev \
    zlib-dev \
    xz-dev \
    zstd-dev \
    gnupg \
    coreutils \
    binutils 

ARG VERSION=0.4.8.9
ARG BASE_URL=https://dist.torproject.org
ARG TARBALL=tor-${VERSION}.tar.gz

WORKDIR /opt/tor

ADD ${BASE_URL}/${TARBALL}                ${TARBALL}
ADD ${BASE_URL}/${TARBALL}.sha256sum      SHA256SUM
ADD ${BASE_URL}/${TARBALL}.sha256sum.asc  SHA256SUM.asc
COPY gpg/                                 gpg/

RUN gpg --import gpg/* && \
    gpg --verify SHA256SUM.asc SHA256SUM && \
    sha256sum -c SHA256SUM

RUN tar xzf $TARBALL --strip-components=1

RUN CXXFLAGS="-march=native" ./configure \
    --quiet \
    --bindir=/opt/tor/bin \
    --disable-dependency-tracking \
    --disable-unittests \
    --disable-system-torrc \
    --disable-manpage \
    --disable-html-manual \
    --disable-asciidoc \
    --disable-module-dirauth \
    --enable-lzma \
    --enable-zstd

RUN make -j$(nproc)
RUN make install

RUN strip --strip-unneeded /opt/tor/bin/tor

FROM alpine:3.22

RUN apk add --no-cache \
    openssl \
    zlib \
    libevent \
    xz \
    zstd \
    curl

COPY --from=builder /opt/tor/bin/tor  /usr/local/bin/tor
COPY torrc                            /etc/tor/torrc

WORKDIR /var/lib/tor
EXPOSE 9001 9030

VOLUME ["/var/lib/tor"]
ENTRYPOINT ["tor", "-f", "/etc/tor/torrc"]