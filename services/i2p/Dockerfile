FROM alpine:3.22 AS builder

RUN apk add --no-cache \
    gnupg

ARG VERSION=2.57.0
ARG BASE_URL=https://github.com/PurpleI2P/i2pd
ARG TARBALL=i2psource_$VERSION.tar.gz

WORKDIR /tmp

ADD $BASE_URL/archive/refs/tags/$VERSION.tar.gz          .
ADD $BASE_URL/releases/download/$VERSION/SHA512SUMS      .
ADD $BASE_URL/releases/download/$VERSION/SHA512SUMS.asc  .
COPY gpg/                                                ./gpg/

RUN gpg --import gpg/* && \
    gpg --verify SHA256SUMS.asc SHA256SUMS && \
    sha256sum -c SHA256SUMS --ignore-missing

RUN tar -xzf $TARBALL --strip-components=1

WORKDIR /tmp/build

RUN cmake . \
    -DCMAKE_INSTALL_BINDIR=/usr/bin/i2pd \
    -DCMAKE_BUILD_TYPE=Release \
    -DWITH_LIBRARY=OFF \
    -DWITH_HARDENING=ON

RUN make -j$(nproc)
RUN make install

RUN for f in /usr/bin/i2pd/*; do \
  if file "$f" | grep -q ELF; then \
    strip --strip-unneeded "$f"; \
  fi; \
done

FROM alpine:3.22

# RUN apk add --no-cache

COPY --from=builder /usr/bin/i2pd/  /usr/bin/
COPY i2pd.conf                      /etc/i2pd/i2pd.conf
COPY tunnels.conf                   /etc/i2pd/tunnels.conf

WORKDIR /var/lib/i2p
EXPOSE 17604/tcp 17604/udp

VOLUME ["/var/lib/i2p"]
ENTRYPOINT ["i2pd", "--conf=/etc/i2pd/i2pd.conf", "--tunconf=/etc/i2pd/tunnels.conf"]