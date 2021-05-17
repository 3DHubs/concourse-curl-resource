FROM alpine:latest
RUN apk add --no-cache coreutils curl jq
COPY assets/ /opt/resource/
COPY test /opt/test
