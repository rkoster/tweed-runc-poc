IMAGE := rkoster/tweed-runc-poc

default:
	docker build -t $(IMAGE) .
	docker run --privileged $(IMAGE)

debug:
	docker run -it --privileged --entrypoint /bin/bash $(IMAGE)
