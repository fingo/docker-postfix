FROM alpine:edge
MAINTAINER Bojan Cekrlic

# You can set this variables when running the image to override the host name or
# foward the messages to another server
# ENV	HOSTNAME
# Hostname that will be used in the outgoing mail
# ENV	RELAYHOST
# The relay host for this server
# ENV	ALLOWED_SENDER_DOMAINS
# Limit the list of sending domains to this list only

RUN	true && \
	apk add --no-cache --update postfix ca-certificates supervisor rsyslog bash && \
	(rm "/tmp/"* 2>/dev/null || true) && (rm -rf /var/cache/apk/* 2>/dev/null || true)

COPY	supervisord.conf /etc/supervisord.conf
COPY	rsyslog.conf /etc/rsyslog.conf
COPY	postfix.sh /postfix.sh
RUN	chmod +x /postfix.sh

VOLUME	[ "/var/spool/postfix", "/etc/postfix" ]

USER	root
WORKDIR	/tmp

EXPOSE 587
ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
