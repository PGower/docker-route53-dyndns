## Containerize cli53
## Discover the expected DNS names following the same conventions than jwilder/nginx-proxy
## Generate the DNS A record file and call cli53 to process it

FROM dockerfile/python
MAINTAINER hugues@sutoiku.com

RUN pip install cli53

RUN mkdir /app
WORKDIR /app

RUN \
	wget https://github.com/jwilder/docker-gen/releases/download/0.3.3/docker-gen-linux-amd64-0.3.3.tar.gz && \
	tar xvzf docker-gen-linux-amd64-0.3.3.tar.gz -C /usr/local/bin && \
	rm docker-gen-linux-amd64-0.3.3.tar.gz

ADD cli53routes.tmpl /app/cli53routes.tmpl

ENV DOCKER_HOST unix:///tmp/docker.sock

CMD /usr/local/bin/docker-gen -only-published -watch -notify "/bin/sh /tmp/cli53routes" /app/cli53routes.tmpl /tmp/cli53routes
