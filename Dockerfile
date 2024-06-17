# syntax=docker/dockerfile:1

ARG CADDY_VERSION=2.8.4

FROM --platform=$BUILDPLATFORM caddy:$CADDY_VERSION-builder AS builder

ARG TARGETPLATFORM
RUN <<eot
    set -eux

    case $TARGETPLATFORM in
      linux/amd64 ) export GOOS=linux GOARCH=amd64;;
      linux/arm64 ) export GOOS=linux GOARCH=arm64;;
      *           ) echo "unsupported platform $TARGETPLATFORM"; exit 1;;
    esac

    CGO_ENABLED=0 xcaddy build --with github.com/caddy-dns/route53 --replace github.com/libdns/route53=github.com/winterqt/libdns-route53@017a75a1a73834ad388f91905b76d0d88d2aba5e
eot

FROM caddy:$CADDY_VERSION

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
