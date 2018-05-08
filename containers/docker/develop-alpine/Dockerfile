FROM alpine:3.7

RUN \
  apk add --update go git make gcc musl-dev linux-headers ca-certificates && \
  git clone --depth 1 https://github.com/kdchain/go-kdchain && \
  (cd go-kdchain && make gkdchain) && \
  cp go-kdchain/build/bin/gkdchain /gkdchain && \
  apk del go git make gcc musl-dev linux-headers && \
  rm -rf /go-kdchain && rm -rf /var/cache/apk/*

EXPOSE 8545
EXPOSE 30303

ENTRYPOINT ["/gkdchain"]
