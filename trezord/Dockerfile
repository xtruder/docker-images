FROM golang:1.18-alpine as builder

RUN apk add git gcc musl-dev libusb linux-headers
RUN GO111MODULE=auto go get github.com/trezor/trezord-go
RUN GO111MODULE=auto go build github.com/trezor/trezord-go

FROM alpine:3

COPY --from=builder /go/bin/trezord-go /usr/local/bin/trezord-go
ENTRYPOINT ["/usr/local/bin/trezord-go"]
