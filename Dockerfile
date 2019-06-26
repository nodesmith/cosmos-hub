FROM golang:1.12-alpine AS builder

# Add some libraries so we can build
RUN apk add --no-cache --update bash git make alpine-sdk libc-dev linux-headers

ENV GAIA_REPO_NAME=cosmos-sdk
COPY $GAIA_REPO_NAME/ $GOPATH/src/github.com/cosmos/$GAIA_REPO_NAME/

RUN cd $GOPATH/src/github.com/cosmos/$GAIA_REPO_NAME && \
    make tools install


FROM alpine:3.10

# Add some utilities which can be useful for debugging
RUN apk add --no-cache --update curl nano bash jq ca-certificates

COPY --from=builder /go/bin/gaiacli /usr/local/bin/
COPY --from=builder /go/bin/gaiad /usr/local/bin/

EXPOSE 1317
EXPOSE 26658

ENTRYPOINT [ "gaiacli" ] 
