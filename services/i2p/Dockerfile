FROM alpine:3.22 AS builder

RUN apk add --no-cache \
    openjdk24 gnupg gettext

ARG VERSION=2.9.0
ARG SHA256SUM=03989319e186d9b06ed96ea0efa6ac95af1bc57af956d7f5f06f52f8da64fcd7
ARG BASE_URL=https://files.i2p-projekt.de/$VERSION
ARG TARBALL=i2psource_$VERSION.tar.bz2

WORKDIR /tmp

ADD $BASE_URL/$TARBALL      .
ADD $BASE_URL/$TARBALL.sig  .
COPY gpg/                   ./gpg/

RUN gpg --import gpg/* && \
    gpg --verify $TARBALL.sig $TARBALL && \
    echo "$SHA256SUM $TARBALL" | sha256sum -c -

RUN tar -xzf $TARBALL --strip-components=1

RUN ./gradlew assemble

FROM alpine:3.22

RUN apk add --no-cache \
    openjdk24-jre

COPY --from=builder 

WORKDIR /var/lib/i2p
EXPOSE 

VOLUME ["/var/lib/i2p"]
ENTRYPOINT [""]