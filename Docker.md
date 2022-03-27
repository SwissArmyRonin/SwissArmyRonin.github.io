# Docker

## GUI apps

Source: https://www.trickster.dev/post/running-gui-apps-within-docker-containers/

Create `docker-compose.yml`:

```yaml
version: '2'
services:
  firefox:
    image: jlesage/firefox
    environment:
      - DISPLAY=novnc:0
    depends_on:
      - novnc
    networks:
      - x11
  novnc:
    image: theasp/novnc:latest
    environment:
      # Adjust to your screen size
      - DISPLAY_WIDTH=1600
      - DISPLAY_HEIGHT=968
      - RUN_XTERM=no
    ports:
      - "8080:8080"
    networks:
      - x11
networks:
  x11:
```

Run:

```shell
docker-compose up
```

Open http://localhost:8080/vnc_auto.html

## Run a rust command

The parameter `--user "$(id -u)":"$(id -g)"` makes the current user the owner of the generated artifacts, avoiding `root` as owner.

```shell
LAMBDA_ARCH="linux/arm64" # set this to either linux/arm64 for ARM functions, or linux/amd64 for x86 functions.
RUST_TARGET="aarch64-unknown-linux-gnu" # corresponding with the above, set this to aarch64 or x86_64 -unknown-linux-gnu for ARM or x86 functions.
RUST_VERSION="latest" # Set this to a specific version of rust you want to compile for, or to latest if you want the latest stable version.
docker run \
  --platform ${LAMBDA_ARCH} \
  --rm --user "$(id -u)":"$(id -g)" \
  -v "${PWD}":/usr/src/myapp -w /usr/src/myapp rust:${RUST_VERSION} \
  cargo build -p lambda_runtime --example basic --release --target ${RUST_TARGET} # This line can be any cargo command
```

## Extract Dockerfile

Generate a good starting point for a Dcokerfile.
```
docker history --no-trunc --format '{{.CreatedBy}}' qemu | grep -v '#(nop)' | tac
```

[gimmick:Disqus](swissarmyronin-github-io)
