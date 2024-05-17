# syntax=docker/dockerfile:1

FROM --platform=$BUILDPLATFORM caddy:2.7.6-builder AS builder

ARG TARGETPLATFORM
RUN <<eot
    set -eux

    case $TARGETPLATFORM in
      linux/amd64 ) export GOOS=linux GOARCH=amd64;;
      linux/arm64 ) export GOOS=linux GOARCH=arm64;;
      *           ) echo "unsupported platform $TARGETPLATFORM"; exit 1;;
    esac

    CGO_ENABLED=0 xcaddy build --with github.com/caddy-dns/route53
eot

FROM caddy:2.7.6

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
