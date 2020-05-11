FROM golang:alpine

COPY . /go/src/github.com/blah/test-project

ENV CGO_ENABLED=0
RUN apk add --no-cache git && \
    cd /go/src/github.com/blah/test-project && \
    go build -v -o /test-projectd ./cmd/test-projectd && \
    apk del git && \
    rm -rf /go/*

ENTRYPOINT ["/test-projectd"]
