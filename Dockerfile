ARG BASE_IMAGE=alpine:3.19
FROM ${BASE_IMAGE} as builder
RUN apk add --no-cache \
    build-base \
    musl-dev \
    rust \
    cargo \
    openssl-dev \
    libffi-dev \
    linux-headers \
    zlib-dev \
    clang libgcc
WORKDIR /app
ENTRYPOINT [ "cargo" ]

# FROM builder as build
# COPY foo/Cargo.toml foo/Cargo.lock /app/foo/
# COPY foo/src /app/foo/src
# RUN set -e; if [ $(uname -m) == 'riscv64' ];then \
#         cargo build --release --manifest-path /app/foo/Cargo.toml; \
#     elif [ $(uname -m) == 'i686' ];then \
#         rustc /app/foo/src/main.rs; \
#         mkdir -p /app/foo/target/release; \
#         mv ./foo /app/foo/target/release/foo; \
#     else \
#         RUSTFLAGS="-C target-feature=+crt-static" cargo build --release --manifest-path /app/foo/Cargo.toml; \
#     fi

# ARG BASE_IMAGE=alpine:3.19
# FROM ${BASE_IMAGE}
# COPY --from=build /app/foo/target/release/foo /usr/local/bin/foo
# # RUN apk add libgcc
# RUN if [ $(uname -m) == 'riscv64' ];then \
#         apk add libgcc; \
#     fi
# ENTRYPOINT [ "foo" ]