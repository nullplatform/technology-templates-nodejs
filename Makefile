#
# Makefile for processing assets
#
# This Makefile is designed to receive two parameters that control its behavior.
# It helps manage assets by processing them in a specified working directory
# and outputting the results to a designated asset output directory.

# Parameter: ASSET_WORKING_DIRECTORY
# This is the directory where the assets will be processed from.
# This variable is set to the path of the directory containing your source assets.

# Parameter: ASSET_OUTPUT_DIRECTORY
# This is the directory where the processed assets will be stored.
# This variable is set to the path of the directory where the processed assets will be saved.

# Parameter: ASSET_TARGET_URL
# The remote repository URL where the processed assets will be pushed or deployed.
# This variable is set to the URL of the destination repository.

ASSET_FILE=$(ASSET_NAME).zip

.PHONY: all-lambda all-docker-image build-lambda build-docker-file push-lambda push-docker-file build push

all-lambda: clean-lambda build-lambda push-lambda
all-docker-image: build-docker-file push-docker-file

build: build-lambda build-docker-file
push: push-docker-file push-lambda

#
# Lambda zip file
#

build-lambda: setup-lambda test-lambda compile-lambda package-lambda
clean-lambda:
	rm -r $(ASSET_OUTPUT_DIRECTORY)
setup-lambda:
	mkdir -p $(ASSET_OUTPUT_DIRECTORY)
	cp $(ASSET_WORKING_DIRECTORY)/package.json $(ASSET_OUTPUT_DIRECTORY)
	npm --prefix $(ASSET_OUTPUT_DIRECTORY) install --omit=dev
test-lambda:
	npm --prefix $(ASSET_WORKING_DIRECTORY) install --only=dev
	npm --prefix $(ASSET_WORKING_DIRECTORY) run test
compile-lambda:
	cp $(ASSET_WORKING_DIRECTORY)/*.js $(ASSET_OUTPUT_DIRECTORY)
package-lambda:
	cd $(ASSET_OUTPUT_DIRECTORY) && zip -r $(ASSET_FILE) .
push-lambda:
	aws s3 cp $(ASSET_OUTPUT_DIRECTORY)/$(ASSET_FILE) $(ASSET_TARGET_URL)

#
# Docker image
#
build-docker-file:
	docker build $(BUILD_ARGS) -t $(ASSET_NAME) -f $(ASSET_WORKING_DIRECTORY)/Dockerfile $(BUILD_WORKING_DIRECTORY)
push-docker-file:
	docker tag $(ASSET_NAME):latest $(ASSET_TARGET_URL)
	docker push $(ASSET_TARGET_URL)
