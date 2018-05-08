# Build Gkdchain in a stock Go builder container
FROM golang:1.10-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers

ADD . /go-kdchain
RUN cd /go-kdchain && make kdchain

# Pull Gkdchain into a second stage deploy alpine container
FROM alpine:latest

RUN apk add --no-cache ca-certificates
COPY --from=builder /go-kdchain/build/bin/kdchain /usr/local/bin/

EXPOSE 8545 8546 31409 31409/udp
ENTRYPOINT ["kdchain"]
