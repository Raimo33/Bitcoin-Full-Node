FROM alpine:3.22 AS builder

RUN apk add --no-cache \
    build-base \
    boost-dev \
    openssl-dev \ 
    gnupg \
    cmake \
    coreutils \
    binutils

ARG VERSION=2.57.0
ARG BASE_URL=https://github.com/PurpleI2P/i2pd
ARG TARBALL=i2pd-$VERSION.tar.gz

WORKDIR /tmp

ADD ${BASE_URL}/archive/refs/tags/${VERSION}.tar.gz          ${TARBALL}
ADD ${BASE_URL}/releases/download/${VERSION}/SHA512SUMS      SHA512SUMS
ADD ${BASE_URL}/releases/download/${VERSION}/SHA512SUMS.asc  SHA512SUMS.asc
COPY gpg/                                                    gpg/

RUN gpg --import gpg/* && \
    gpg --verify SHA512SUMS.asc SHA512SUMS && \
    sha512sum -c SHA512SUMS --ignore-missing

RUN tar xzf ${TARBALL} --strip-components=1

WORKDIR /tmp/build

RUN cmake . \
    -DCMAKE_CXX_FLAGS="-O2 -march=native -pipe -flto" \
    -DCMAKE_EXE_LINKER_FLAGS="-flto" \
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

RUN apk add --no-cache \
    openssl \
    boost-system \
    boost-filesystem \
    boost-program_options

COPY --from=builder /usr/bin/i2pd/              /usr/bin/
COPY --from=builder /tmp/contrib/certificates/  /etc/i2pd/certificates
COPY i2pd.conf                                  /etc/i2pd/i2pd.conf

WORKDIR /var/lib/i2pd
EXPOSE 17604/tcp 17604/udp

VOLUME ["/var/lib/i2pd"]
ENTRYPOINT ["i2pd", "--conf=/etc/i2pd/i2pd.conf", "--datadir=/var/lib/i2pd"]