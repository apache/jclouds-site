IMAGE := jclouds/site-builder
MOUNTPOINT := /jclouds-site

image:  ## Build the Docker image with all requirements to build and publish the sire
	docker build -t $(IMAGE) .

build:  ## Build and run the site locally
	docker run --rm -v "${PWD}:$(MOUNTPOINT)" -p 4000:4000 $(IMAGE) jekyll serve --safe --port 4000

publish:  ## Publish the site to https://jclouds.apache.org
	rm -rf site-content
	docker run --rm -ti -v "${PWD}:$(MOUNTPOINT)" $(IMAGE) bash deploy-site.sh

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "Usage:\n    make \033[36m<target>\033[0m\n\nAvailable targets:\n"} \
		  /^[a-zA-Z_-]+:.*?##/ { printf "    \033[36m%-15s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

.PHONY:
	image build publish help
