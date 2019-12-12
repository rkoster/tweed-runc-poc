IMAGE := rkoster/tweed-runc-poc
default:
	docker build -t $(IMAGE) .
	docker run $(IMAGE)
