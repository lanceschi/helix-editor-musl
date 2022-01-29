FROM alpine:3.15.0 AS builder

ENV VERSION=${VERSION:-v0.6.0}

RUN apk add  --update --no-cache bash git gcc build-base musl-dev rustup && \
  rm -rf /var/cache/apk/* && \
  rustup-init -y

ENV PATH=/root/.cargo/bin:"$PATH"  

RUN \
  git clone --recurse-submodules --shallow-submodules -j8 https://github.com/helix-editor/helix && \
  cd helix && \
  git checkout $VERSION && \
  rustup update && \
  cargo build --release --target=x86_64-unknown-linux-musl

FROM alpine:3.15.0

ENV VERSION=${VERSION:-v0.6.0}
WORKDIR "/helix-${VERSION}"

COPY --from=builder /helix/runtime ./runtime
COPY --from=builder /helix/target/x86_64-unknown-linux-musl/release/hx ./hx
COPY --from=builder /helix/LICENSE ./LICENSE
COPY --from=builder /helix/README.md ./README.md

# CMD ["/hx"]