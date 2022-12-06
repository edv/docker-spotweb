.PHONY: build
build:
	docker build .

.PHONY: start
start:
	docker compose up