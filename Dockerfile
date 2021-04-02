FROM arm32v6/golang:1.10.1-alpine3.7 AS builder

ENV GOPATH /go
WORKDIR /go/src

RUN mkdir -p /go/src/github.com/kishanjoshi/iotwifi
COPY . /go/src/github.com/kishanjoshi/iotwifi

RUN CGO_ENABLED=0 go build -a -installsuffix cgo -o /go/bin/wifi /go/src/github.com/kishanjoshi/iotwifi/main.go

FROM arm32v6/alpine

RUN apk update
RUN apk add bridge hostapd wireless-tools wpa_supplicant dnsmasq iw

RUN mkdir -p /etc/wpa_supplicant/
COPY ./dev/configs/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf

WORKDIR /

COPY --from=builder /go/bin/wifi /wifi
CMD ["/wifi"]

# docker run -d --privileged --network=host \
#                    -e IOTWIFI_PORT=8082 \
#                    -v /etc/hostname:/cfg/hostname \
#                    -v $PWD:/go/src/github.com/kishanjoshi/iotwifi \
#                    -w /go/src/github.com/kishanjoshi/iotwifi \
#                    --name=iotwifi kishanjoshi/iotwifi:latest

# docker run -it --privileged --network=host \
#                    -e IOTWIFI_PORT=8082 \
#                    -v /etc/hostname:/cfg/hostname \
#                    -v $PWD:/go/src/github.com/kishanjoshi/iotwifi \
#                    -w /go/src/github.com/kishanjoshi/iotwifi \
#                    --name=iotwifi kishanjoshi/iotwifi:dev /bin/ash


# docker run -d --restart=always -v $PWD/wificfg.json:/cfg/wificfg.json --privileged -e IOTWIFI_PORT=8082 --net host --name=iotwifi cjimti/iotwifi
# docker run --rm -v $PWD/wificfg.json:/cfg/wificfg.json --privileged -e IOTWIFI_PORT=8082 --net host --name=iotwifi cjimti/iotwifi


# docker run -d --restart=always -v /etc/hostname:/cfg/hostname -v $PWD/wificfg.json:/cfg/wificfg.json --privileged -e IOTWIFI_PORT=8082 --net host --name=iotwifi kishanjoshi/iotwifi
# docker run --rm -v /etc/hostname:/cfg/hostname -v $PWD/wificfg.json:/cfg/wificfg.json --privileged -e IOTWIFI_PORT=8082 --net host --name=iotwifi kishanjoshi/iotwifi