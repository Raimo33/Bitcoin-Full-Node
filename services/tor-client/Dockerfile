FROM alpine:3.22 AS builder

RUN apk add --no-cache \
    build-base autoconf automake pkgconfig libtool \
    binutils

#TODO verify gpg key (ADD does that)
ADD https://gitlab.torproject.org/tpo/core/tor/-/archive/main/tor-main.tar.gz /tmp/tor.tar.gz
RUN cd /tmp && tar -xzf tor.tar.gz && mv tor-main /tor-main

WORKDIR /tor-main

RUN ./autogen.sh
RUN CXXFLAGS="-O2 -march=native -pipe -flto" LDFLAGS="-flto" ./configure \
    --quiet \
    --bindir=/usr/bin/tor \
    --disable-dependency-tracking \
    --disable-unittests \
    --disable-system-torrc \
    --disable-manpage \
    --disable-html-manual \
    --disable-asciidoc \
    --disable-module-relay \
    --disable-module-dirauth \
    --enable-lzma \
    --enable-zstd

RUN make -j$(nproc)
RUN make install
RUN strip --strip-unneeded /usr/bin/tor/*

FROM alpine:3.22

ARG TOR_UID TOR_GID

RUN addgroup -g ${TOR_GID} tor && \
    adduser -u ${TOR_UID} tor  && \
    chown -R tor:tor /etc/tor

RUN mkdir -p /var/lib/tor

COPY --from=builder /usr/bin/tor /usr/bin
COPY torrc /etc/tor/torrc

WORKDIR /var/lib/tor
USER tor
EXPOSE 8333

VOLUME ["/var/lib/tor"]
CMD ["tor", "-f", "/etc/tor/torrc"]