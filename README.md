# Cargo Alpine Docker Images

A range of docker images for building cross-platform statically linked executables against musl.

Why?

- Official [Cargo alpine docker tag](https://hub.docker.com/_/rust/tags?page=&page_size=&ordering=&name=alpine) only comes in `arm64` and `amd64` flavour
- Cross-rs doesn't yet support musl variants of `s390x` / `ppc64le` / `riscv64` builds.

## Usage

```sh
docker run --platform=linux/${TARGET_ARCH} -v $PWD/foo:/app --rm --init -it you54f/cargo:alpine-3.19 build --release
```

You can pass in rust flags, as an environment variable. 

```sh
-e RUSTFLAGS="-C target-feature=+crt-static -C strip=symbols -C codegen-units=1 -C lto=true -C embed-bitcode=yes -C panic=abort" 
```

### Static Builds

**note** This is the most important bit for static executables.

- `C target-feature=+crt-static`
  - Static build. Without this, users will need to install `libgcc` on alpine, for created binaries to work

### Small Builds

- `-C strip=symbols`
  - Strip the binary.
- `-C codegen-units=1`
  - Trade off between longer compilation time, smaller binary size. This prefers smaller
- `-C lto=true`
- `-C embed-bitcode=yes`
  - Needs to be set to yes, with `-C lto=true`
- `-C panic=abort`
  - Abort rather than unwind on panic

## Multi-manifest images

### Architectures

- `amd64`
- `arm64`
- `arm`
- `ppc64le`
- `s390x`
- `i386`
- `riscv64`
  
### Tags


- `you54f/cargo:alpine-3.15`
- `you54f/cargo:alpine-3.16`
- `you54f/cargo:alpine-3.17`
  - `s390x` introduced
- `you54f/cargo:alpine-3.18`
- `you54f/cargo:alpine-3.19`


## Individual tags

- `you54f/cargo:alpine-3.15-amd64`
- `you54f/cargo:alpine-3.15-arm64`
- `you54f/cargo:alpine-3.15-arm`
- `you54f/cargo:alpine-3.15-ppc64le`
- `you54f/cargo:alpine-3.15-i386`
- `you54f/cargo:alpine-3.16-amd64`
- `you54f/cargo:alpine-3.16-arm64`
- `you54f/cargo:alpine-3.16-arm`
- `you54f/cargo:alpine-3.16-ppc64le`
- `you54f/cargo:alpine-3.16-i386`
- `you54f/cargo:alpine-3.17-amd64`
- `you54f/cargo:alpine-3.17-arm64`
- `you54f/cargo:alpine-3.17-arm`
- `you54f/cargo:alpine-3.17-ppc64le`
- `you54f/cargo:alpine-3.17-s390x`
- `you54f/cargo:alpine-3.17-i386`
- `you54f/cargo:alpine-3.18-amd64`
- `you54f/cargo:alpine-3.18-arm64`
- `you54f/cargo:alpine-3.18-arm`
- `you54f/cargo:alpine-3.18-ppc64le`
- `you54f/cargo:alpine-3.18-s390x`
- `you54f/cargo:alpine-3.18-i386`
- `you54f/cargo:alpine-3.19-amd64`
- `you54f/cargo:alpine-3.19-arm64`
- `you54f/cargo:alpine-3.19-arm`
- `you54f/cargo:alpine-3.19-ppc64le`
- `you54f/cargo:alpine-3.19-s390x`
- `you54f/cargo:alpine-3.19-i386`