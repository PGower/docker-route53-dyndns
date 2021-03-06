## DynDNS for Docker with Route53
##
## Dynamic DNS counterpart of James Wilder's nginx-proxy for docker:
## [jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy).
##
## Containerize cli53
## Discover the expected DNS names following the same conventions than jwilder/nginx-proxy
## Generate the DNS A record file and call cli53 to process it

FROM python:2-slim
MAINTAINER hugues@sutoiku.com

## RUN pip install cli53

RUN mkdir /app
WORKDIR /app

RUN apt-get update && apt-get install -y wget curl --no-install-recommends && rm -rf /var/lib/apt/lists/* && \
	wget https://github.com/jwilder/docker-gen/releases/download/0.4.0/docker-gen-linux-amd64-0.4.0.tar.gz && \
	tar xvzf docker-gen-linux-amd64-0.4.0.tar.gz -C /usr/local/bin && \
	rm docker-gen-linux-amd64-0.4.0.tar.gz

RUN wget https://github.com/barnybug/cli53/releases/download/0.8.12/cli53-linux-amd64 && mv /app/cli53-linux-amd64 /usr/local/bin/cli53 && \
    chmod a+x /usr/local/bin/cli53

ADD cli53routes.tmpl /app/cli53routes.tmpl

ENV DOCKER_HOST unix:///tmp/docker.sock

CMD /usr/local/bin/docker-gen -watch -notify "/bin/bash /tmp/cli53routes" /app/cli53routes.tmpl /tmp/cli53routes
