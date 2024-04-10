
ALPINE_VERSION:= 3.15
ALPINE_VERSION_RISCV64 = 20230901
ALPINE_VERSIONS_RISCV64 = 20230901 20230329 20221110 20220715 20210804
ALPINE_VERSIONS_NORM_RISCV64 = 3.19 3.18 3.17 3.16 3.15
DOCKER_PLATFORM_RISCV64 = riscv64
ALPINE_VERSIONS:= 3.15 3.16 3.17 3.18 3.19
ARCHITECTURES = amd64 arm64 arm ppc64le s390x i386
# riscv64
all: $(ARCHITECTURES)
build_all_versions: 
	$(foreach version,$(ALPINE_VERSIONS),make build_all ALPINE_VERSION=$(version);)
build_all: 
	$(foreach arch,$(ARCHITECTURES),make all ARCHITECTURES=$(arch);)

push_all_versions: 
	$(foreach version,$(ALPINE_VERSIONS),make push_all ALPINE_VERSION=$(version);)
push_all: 
	$(foreach arch,$(ARCHITECTURES),make push ARCHITECTURES=$(arch);)
push:
	docker push you54f/cargo:alpine-$(ALPINE_VERSION)-$(ARCHITECTURES)
$(ARCHITECTURES):
	docker build --progress=plain --platform linux/$@ --build-arg BASE_IMAGE=alpine:$(ALPINE_VERSION) -t you54f/cargo:alpine-$(ALPINE_VERSION)-$@ -f Dockerfile .

build_risc_versions: 
	$(foreach version,$(ALPINE_VERSIONS_RISCV64),make build_risc ALPINE_VERSION_RISCV64=$(version);)
manifest_risc_versions: 
	$(foreach version,$(ALPINE_VERSIONS_RISCV64),make manifest ARCHITECTURES=riscv64 ALPINE_VERSION=$(version);)
build_risc:
	docker build --platform linux/$(DOCKER_PLATFORM_RISCV64) --build-arg BASE_IMAGE=alpine:$(ALPINE_VERSION_RISCV64) -t you54f/cargo:alpine-$(ALPINE_VERSION_RISCV64)-$(DOCKER_PLATFORM_RISCV64) -f Dockerfile .

run:
	docker run --rm -it you54f/cargo:alpine-$(ALPINE_VERSION)

run_risc:
	docker run --platform=linux/$(DOCKER_PLATFORM_RISCV64) --rm -it you54f/cargo:alpine-$(ALPINE_VERSION_RISCV64)-$(DOCKER_PLATFORM_RISCV64)

run_platform:
	docker run --platform=linux/$(PLATFORM) --rm -it you54f/cargo:alpine-$(ALPINE_VERSION)-$(PLATFORM)


run_all:
	$(foreach arch,$(ARCHITECTURES),make run_platform PLATFORM=$(arch);)


build_in_docker:
	docker run --platform=linux/arm64 -v $$PWD/foo:/app --rm --init -it -e RUSTFLAGS="-C target-feature=+crt-static -C strip=symbols -C codegen-units=1 -C lto=true -C embed-bitcode=yes -C panic=abort" you54f/cargo:alpine-3.19-arm64 build --release
manifest_all_versions: 
	$(foreach version,$(ALPINE_VERSIONS),make manifest_all ALPINE_VERSION=$(version);)
manifest_all: 
	$(foreach arch,$(ARCHITECTURES),make manifest ARCHITECTURES=$(arch);)

# tag one image as you54f/cargo:alpine-$(ALPINE_VERSION) and push, prior to --append(ing) new images.
# not sure if docker buildx imagetools create supports creating a new tag locally and appending to it after
manifest:
	@echo docker buildx imagetools create --tag you54f/cargo:alpine-$(ALPINE_VERSION) --append you54f/cargo:alpine-$(ALPINE_VERSION)-$(ARCHITECTURES) || echo true

get_risc_versions:
	$(foreach version,$(ALPINE_VERSIONS_RISCV64),docker run --rm -it --platform linux/riscv64 alpine:$(version) cat /etc/os-release;)

risc_tag_push:
	docker tag alpine:20230901 you54f/cargo:alpine-20230901-riscv64
	docker tag alpine:20230329 you54f/cargo:alpine-20230329-riscv64
	docker tag alpine:20221110 you54f/cargo:alpine-20221110-riscv64
	docker tag alpine:20220715 you54f/cargo:alpine-20220715-riscv64
	docker tag alpine:20210804 you54f/cargo:alpine-20210804-riscv64
	docker push you54f/cargo:alpine-20230901-riscv64
	docker push you54f/cargo:alpine-20230329-riscv64
	docker push you54f/cargo:alpine-20221110-riscv64
	docker push you54f/cargo:alpine-20220715-riscv64
	docker push you54f/cargo:alpine-20210804-riscv64
	docker buildx imagetools create --tag you54f/cargo:alpine-3.19 --append you54f/cargo:alpine-20230901-riscv64
	docker buildx imagetools create --tag you54f/cargo:alpine-3.18 --append you54f/cargo:alpine-20230329-riscv64
	docker buildx imagetools create --tag you54f/cargo:alpine-3.17 --append you54f/cargo:alpine-20221110-riscv64
	docker buildx imagetools create --tag you54f/cargo:alpine-3.16 --append you54f/cargo:alpine-20220715-riscv64
	docker buildx imagetools create --tag you54f/cargo:alpine-3.15 --append you54f/cargo:alpine-20210804-riscv64

all_manis:
	docker push you54f/cargo:alpine-3.15
	docker push you54f/cargo:alpine-3.16
	docker push you54f/cargo:alpine-3.17
	docker push you54f/cargo:alpine-3.18
	docker push you54f/cargo:alpine-3.19
	docker buildx imagetools create --tag you54f/cargo:alpine-3.15 --append you54f/cargo:alpine-3.15-amd64
	docker buildx imagetools create --tag you54f/cargo:alpine-3.15 --append you54f/cargo:alpine-3.15-arm64
	docker buildx imagetools create --tag you54f/cargo:alpine-3.15 --append you54f/cargo:alpine-3.15-arm
	docker buildx imagetools create --tag you54f/cargo:alpine-3.15 --append you54f/cargo:alpine-3.15-ppc64le
	docker buildx imagetools create --tag you54f/cargo:alpine-3.15 --append you54f/cargo:alpine-3.15-i386
	docker buildx imagetools create --tag you54f/cargo:alpine-3.16 --append you54f/cargo:alpine-3.16-amd64
	docker buildx imagetools create --tag you54f/cargo:alpine-3.16 --append you54f/cargo:alpine-3.16-arm64
	docker buildx imagetools create --tag you54f/cargo:alpine-3.16 --append you54f/cargo:alpine-3.16-arm
	docker buildx imagetools create --tag you54f/cargo:alpine-3.16 --append you54f/cargo:alpine-3.16-ppc64le
	docker buildx imagetools create --tag you54f/cargo:alpine-3.16 --append you54f/cargo:alpine-3.16-i386
	docker buildx imagetools create --tag you54f/cargo:alpine-3.17 --append you54f/cargo:alpine-3.17-amd64
	docker buildx imagetools create --tag you54f/cargo:alpine-3.17 --append you54f/cargo:alpine-3.17-arm64
	docker buildx imagetools create --tag you54f/cargo:alpine-3.17 --append you54f/cargo:alpine-3.17-arm
	docker buildx imagetools create --tag you54f/cargo:alpine-3.17 --append you54f/cargo:alpine-3.17-ppc64le
	docker buildx imagetools create --tag you54f/cargo:alpine-3.17 --append you54f/cargo:alpine-3.17-s390x
	docker buildx imagetools create --tag you54f/cargo:alpine-3.17 --append you54f/cargo:alpine-3.17-i386
	docker buildx imagetools create --tag you54f/cargo:alpine-3.18 --append you54f/cargo:alpine-3.18-amd64
	docker buildx imagetools create --tag you54f/cargo:alpine-3.18 --append you54f/cargo:alpine-3.18-arm64
	docker buildx imagetools create --tag you54f/cargo:alpine-3.18 --append you54f/cargo:alpine-3.18-arm
	docker buildx imagetools create --tag you54f/cargo:alpine-3.18 --append you54f/cargo:alpine-3.18-ppc64le
	docker buildx imagetools create --tag you54f/cargo:alpine-3.18 --append you54f/cargo:alpine-3.18-s390x
	docker buildx imagetools create --tag you54f/cargo:alpine-3.18 --append you54f/cargo:alpine-3.18-i386
	docker buildx imagetools create --tag you54f/cargo:alpine-3.19 --append you54f/cargo:alpine-3.19-amd64
	docker buildx imagetools create --tag you54f/cargo:alpine-3.19 --append you54f/cargo:alpine-3.19-arm64
	docker buildx imagetools create --tag you54f/cargo:alpine-3.19 --append you54f/cargo:alpine-3.19-arm
	docker buildx imagetools create --tag you54f/cargo:alpine-3.19 --append you54f/cargo:alpine-3.19-ppc64le
	docker buildx imagetools create --tag you54f/cargo:alpine-3.19 --append you54f/cargo:alpine-3.19-s390x
	docker buildx imagetools create --tag you54f/cargo:alpine-3.19 --append you54f/cargo:alpine-3.19-i386