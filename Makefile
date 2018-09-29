THIS_FILE := $(lastword $(MAKEFILE_LIST))

default: build-ui

build-ui:
	cd "./ui" && npm run build

deploy-ui:
	./scripts/deploy-ui.sh


.PHONY: build-ui deploy-ui
