FROM ubuntu
MAINTAINER Jacques Supcik <jacques@supcik.net>

RUN apt-get update && apt-get install -y --no-install-recommends \
		g++ \
		gcc \
		libc6-dev \
		make \
		pkg-config \
		ca-certificates \
		curl \
		unzip \
		python \
		git \
	&& rm -rf /var/lib/apt/lists/*

ENV GOLANG_VERSION 1.6.3
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256 cdde5e08530c0579255d6153b08fdb3b8e47caabbe717bc7bcd7561275a87aeb

ENV GAE_SDK_VERSION 1.9.46
ENV GAE_SDK_DOWNLOAD_URL https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_linux_amd64-$GAE_SDK_VERSION.zip
ENV GAE_SDK_DOWNLOAD_SHA1 644aa81aa1f3032312f376d57ee3d99f88e86da1

RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
	&& echo "$GOLANG_DOWNLOAD_SHA256  golang.tar.gz" | sha256sum -c - \
	&& tar -C /usr/local -xzf golang.tar.gz \
	&& rm golang.tar.gz

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

RUN curl -fsSL "$GAE_SDK_DOWNLOAD_URL" -o go_appengine_sdk.zip \
	&& echo "$GAE_SDK_DOWNLOAD_SHA1 go_appengine_sdk.zip" | sha1sum -c - \
	&& unzip -d /usr/local/ go_appengine_sdk.zip \
	&& rm go_appengine_sdk.zip

ENV PATH $PATH:/usr/local/go_appengine/

COPY go-wrapper /usr/local/bin/
WORKDIR $GOPATH
