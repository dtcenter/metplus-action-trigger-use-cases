FROM alpine:3.20.3

RUN apk add --update --no-cache github-cli git

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
