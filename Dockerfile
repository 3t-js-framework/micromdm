FROM golang:latest as builder

WORKDIR /go/src/github.com/micromdm/micromdm/

ENV CGO_ENABLED=0 \
	GOARCH=amd64 \
	GOOS=linux

COPY . .

RUN make deps
RUN make


FROM ubuntu:18.04

RUN apt-get update && apt-get install -y ca-certificates nano	

COPY --from=builder /go/src/github.com/micromdm/micromdm/build/linux/micromdm /usr/bin/
COPY --from=builder /go/src/github.com/micromdm/micromdm/build/linux/mdmctl /usr/bin/

EXPOSE 80 443
VOLUME ["/var/db/micromdm"]
CMD ["micromdm", "serve"]
