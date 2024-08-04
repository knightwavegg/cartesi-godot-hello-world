FROM --platform=linux/riscv64 riscv64/ubuntu:22.04 as cast-builder

RUN apt update && apt install -y \
  build-essential \
  curl \
  git

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > rustup.sh && chmod +x rustup.sh && ./rustup.sh -y

SHELL ["/bin/bash", "--login" , "-c"]
RUN git clone https://github.com/knightwavegg/tinycast.git && \
    cd tinycast && \
    cargo install --path ./crates/cast --profile local --force --locked

FROM --platform=linux/riscv64 knightwavegg/cartesi-godot:4.2.1-stable

ARG MACHINE_EMULATOR_TOOLS_VERSION=0.14.1
ADD https://github.com/cartesi/machine-emulator-tools/releases/download/v${MACHINE_EMULATOR_TOOLS_VERSION}/machine-emulator-tools-v${MACHINE_EMULATOR_TOOLS_VERSION}.deb /
RUN dpkg -i /machine-emulator-tools-v${MACHINE_EMULATOR_TOOLS_VERSION}.deb \
    && rm /machine-emulator-tools-v${MACHINE_EMULATOR_TOOLS_VERSION}.deb

LABEL io.cartesi.rollups.sdk_version=0.6.2
LABEL io.cartesi.rollups.ram_size=128Mi

ARG DEBIAN_FRONTEND=noninteractive
RUN <<EOF
set -e
apt-get update
apt-get install -y --no-install-recommends \
    busybox-static=1:1.30.1-7ubuntu3
rm -rf /var/lib/apt/lists/* /var/log/* /var/cache/*
useradd --create-home --user-group dapp
EOF

ENV PATH="/opt/cartesi/bin:/opt/cartesi/dapp:${PATH}"

WORKDIR /opt/cartesi/dapp

COPY game game/

RUN cd game && godot --headless --export-debug "Linux/X11" ../server.x86_64

COPY --from=cast-builder /root/.cargo/bin /root/.cargo/bin

ENV PATH="/root/.cargo/bin:$PATH"
ENV SERVER_MODE="true"
ENV ROLLUP_HTTP_SERVER_URL="http://127.0.0.1:5004"

ENTRYPOINT ["rollup-init"]
CMD ["server.x86_64", "--headless"]
