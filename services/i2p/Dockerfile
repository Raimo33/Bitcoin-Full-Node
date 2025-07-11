FROM alpine:3.22 AS builder

RUN apk add --no-cache

ARG VERSION=2.9.0
ARG BASE_URL=https://files.i2p-projekt.de/$VERSION
ARG TARBALL=i2psource_$VERSION.tar.bz2

ADD $BASE_URL/$TARBALL      /tmp/
ADD $BASE_URL/$TARBALL.sig  /tmp/
COPY gpg/                   /tmp/gpg/

WORKDIR /tmp

RUN gpg --import gpg/* && \
    gpg --verify SHA256SUMS.asc SHA256SUMS && \
    sha256sum -c SHA256SUMS --ignore-missing

RUN tar -xzf $TARBALL --strip-components=1

RUN ./gradlew assemble

RUN for f in /usr/bin/i2p/*; do \
  if file "$f" | grep -q ELF; then \
    strip --strip-unneeded "$f"; \
  fi; \
done

FROM alpine:3.22

RUN apk add --no-cache \
    

COPY --from=builder /usr/bin/i2p/ /usr/bin/

WORKDIR /var/lib/i2p
EXPOSE 

VOLUME ["/var/lib/i2p"]
ENTRYPOINT [""]