ARG GO_VERSION=1.11

FROM golang:${GO_VERSION}-alpine AS builder

ENV PACKAGE=github.com/xaohuihui/httpcache

RUN apk add --update --no-cache ca-certificates make git curl mercurial

RUN mkdir -p /go/src/${PACKAGE}
WORKDIR /go/src/${PACKAGE}
COPY . /go/src/${PACKAGE}

RUN CGO_ENABLED=0 go build ${PACKAGE}

FROM alpine:3.7

ENV PACKAGE=github.com/xaohuihui/httpcache

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /go/src/${PACKAGE}/httpcache /httpcache

USER nobody:nobody

EXPOSE 8000
ENTRYPOINT ["./httpcache"]