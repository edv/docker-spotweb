.PHONY: build
build:
	docker compose -f docker-compose-local.yml build --pull --no-cache

.PHONY: up
up:
	docker compose -f docker-compose-local.yml up

.PHONY: stop
stop:
	docker compose -f docker-compose-local.yml stop

.PHONY: clean
clean:
	docker compose -f docker-compose-local.yml down -v

.PHONY: restart
restart: stop up

.PHONY: log
log:
	docker compose -f docker-compose-local.yml logs -f

.PHONY: ssh
ssh:
	docker compose -f docker-compose-local.yml exec spotweb sh