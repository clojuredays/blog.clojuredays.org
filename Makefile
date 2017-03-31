push:
	git push

go-get-update:
	go get -u github.com/spf13/hugo

generate:
	hugo

preview:
	hugo server

TS := $(date)
docs:
	mkdir -p docs

deploy: docs
	git add  docs && git commit -a -m "Blog updated at $(shell date)" && git push

docker-image:
	docker pull golang:1.8
	docker build -t blog-builder .

generate-using-docker: docker-image
	docker run --rm=true -t -v $(shell pwd):/var/blog --name blog-builder blog-builder make generate

deploy-using-docker:
	make generate-using-docker
	make deploy
	make push

preview-using-docker: docker-image
	docker run --rm=true -t -v $(shell pwd):/var/blog -p 4000:4000 --name blog-builder blog-builder make preview

debug-using-docker: docker-image
	docker run --rm=true -ti -v $(shell pwd):/var/blog -p 4000:4000 --name blog-builder blog-builder bash
