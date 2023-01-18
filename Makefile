all: lint docker-pxe

docker-pxe:
	docker compose build

lint:
	docker compose up hadolint

test: lint
	foreman start

.PHONE: clean

clean:
	docker compose down
	docker rmi -f docker-pxe-dnsmasq hadolint/hadolint
	vagrant destroy -f
	rm -r .vagrant
