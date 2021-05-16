FROM debian:10-slim AS build

RUN apt-get update \
  && apt-get install -y --no-install-recommends build-essential \
  && apt-get -y clean \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
ADD . /workspace

ARG BUILD_CONFIG_NAME="-arduino-esp32"
ARG CPPFLAGS="-DSPIFFS_OBJ_META_LEN=4"

RUN make dist

# FROM gcr.io/distroless/base-debian10
FROM debian:10-slim

WORKDIR /
COPY --from=build /workspace/mkspiffs /

ENTRYPOINT ["/mkspiffs"]
