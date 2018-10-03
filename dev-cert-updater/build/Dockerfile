FROM alpine:latest

RUN apk add --update --no-cache \
	bash \
	jq \
	openssh-client

RUN mkdir -p /main
RUN mkdir -p /main/keys
RUN mkdir -p /main/certs
WORKDIR /main
COPY update_keys.sh update_keys.sh

CMD ["/bin/sh", "./update_keys.sh"]