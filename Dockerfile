FROM golang:1.14-alpine as builder
RUN apk add --update curl ca-certificates make git gcc g++ python
# Enable go modules
ENV GO111MODULE=on
# enable go proxy for faster builds
ENV GOPROXY=https://proxy.golang.org
COPY . /go/src/github.com/blah/test-project
ENV CGO_ENABLED=0
RUN apk add --no-cache git &&     cd /go/src/github.com/blah/test-project &&     go build -v -o /test-projectd ./cmd/test-projectd &&     apk del git &&     rm -rf /go/*
WORKDIR $GOPATH/src/github.com/segmentio/docker-patching-test-public
COPY . $GOPATH/src/github.com/segmentio/docker-patching-test-public
# this is an auto-generated build command
# based upon the first argument of the entrypoint in the existing dockerfile.  
# This will work in most cases, but it is important to note
# that in some situations you may need to define a different build output with the -o flag
# This comment may be safely removed
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -ldflags '-w -s -extldflags "-static"' -o /test-projectd
FROM scratch
COPY --from=builder /test-projectd /test-projectd
ENTRYPOINT ["/test-projectd"]
