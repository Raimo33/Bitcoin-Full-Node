FROM alpine:3.22 AS builder

RUN apk add --no-cache \
    build-base libevent-dev openssl-dev zlib-dev \
    gnupg coreutils binutils 

ARG VERSION=0.4.8.9
ARG BASE_URL=https://dist.torproject.org
ARG TARBALL=tor-$VERSION.tar.gz

WORKDIR /tmp

ADD $BASE_URL/$TARBALL                .
ADD $BASE_URL/$TARBALL.sha256sum      ./SHA256SUM
ADD $BASE_URL/$TARBALL.sha256sum.asc  ./SHA256SUM.asc
COPY gpg/                             ./gpg/

RUN gpg --import gpg/* && \
    gpg --verify SHA256SUM.asc SHA256SUM && \
    sha256sum -c SHA256SUM

RUN tar -xzf $RELEASE --strip-components=1

RUN CXXFLAGS="-O2 -march=native -pipe -flto" LDFLAGS="-flto" ./configure \
    --quiet \
    --bindir=/usr/bin/tor \
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

RUN for f in /usr/bin/tor/*; do \
  if file "$f" | grep -q ELF; then \
    strip --strip-unneeded "$f"; \
  fi; \
done

FROM alpine:3.22

RUN apk add --no-cache \
    openssl zlib libevent

COPY --from=builder /usr/bin/tor  /usr/bin
COPY torrc                        /etc/tor/torrc

WORKDIR /var/lib/tor
EXPOSE 9001 9030

VOLUME ["/var/lib/tor"]
ENTRYPOINT ["tor", "-f", "/etc/tor/torrc"]