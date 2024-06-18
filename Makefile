#
# Makefile for processing assets
#

.PHONY: build push

ifeq ($(ASSET_TYPE),lambda)
build: build-lambda
push: push-lambda
endif

ifeq ($(ASSET_TYPE),docker-image)
build: build-docker-image
push: push-docker-image
endif

ASSET_NAME=$(ASSET_TYPE)-asset

#
# Lambda zip file
#

ASSET_FILE=$(ASSET_NAME).zip
ASSET_OUTPUT_DIRECTORY=build

build-lambda: setup-lambda test-lambda compile-lambda package-lambda
clean-lambda:
	rm -r $(ASSET_OUTPUT_DIRECTORY)
setup-lambda:
	mkdir -p $(ASSET_OUTPUT_DIRECTORY)
	cp package.json $(ASSET_OUTPUT_DIRECTORY)
	npm --prefix $(ASSET_OUTPUT_DIRECTORY) install --omit=dev
test-lambda:
	npm install --only=dev
	npm run test
compile-lambda:
	cp *.js $(ASSET_OUTPUT_DIRECTORY)
package-lambda:
	cd $(ASSET_OUTPUT_DIRECTORY) && zip -r $(ASSET_FILE) .
push-lambda:
	np asset push --type lambda --name $(ASSET_NAME) --source $(ASSET_OUTPUT_DIRECTORY)/$(ASSET_FILE)

#
# Docker image
#

build-docker-image:
	docker build -t $(ASSET_NAME) .
push-docker-image:
	np asset push --type docker-image --name $(ASSET_NAME) --source $(ASSET_NAME)