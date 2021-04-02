IMAGE    ?= kishanjoshi/iotwifi
NAME     ?= txwifi
VERSION  ?= 1.0.4

all: build push

dev: dev_build dev_run

build:
	docker build -t $(IMAGE):latest .
	docker build -t $(IMAGE):arm32v6-$(VERSION) .

push:
	docker build -t $(IMAGE):latest .
	docker push $(IMAGE):latest


dev_build:
	docker build -t $(IMAGE) ./dev/
	
dev_push:
	docker build -t $(IMAGE):dev ./dev/
	docker push $(IMAGE):dev

dev_run:
	sudo docker run --rm -it --privileged --network=host \
                   -v $(CURDIR):/go/src/github.com/kishanjoshi/iotwifi \
                   -w /go/src/github.com/kishanjoshi/iotwifi \
                   --name=$(NAME) $(IMAGE):latest


