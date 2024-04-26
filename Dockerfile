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

LABEL io.sunodo.sdk_version=0.2.0
LABEL io.cartesi.rollups.ram_size=128Mi

ARG MACHINE_EMULATOR_TOOLS_VERSION=0.12.0
RUN <<EOF
set -e
apt-get update
apt-get install -y --no-install-recommends busybox-static=1:1.30.1-7ubuntu3 ca-certificates=20230311ubuntu0.22.04.1 curl=7.81.0-1ubuntu1.15
curl -fsSL https://github.com/cartesi/machine-emulator-tools/releases/download/v${MACHINE_EMULATOR_TOOLS_VERSION}/machine-emulator-tools-v${MACHINE_EMULATOR_TOOLS_VERSION}.tar.gz \
  | tar -C / --overwrite -xvzf -
rm -rf /var/lib/apt/lists/*
EOF

ENV PATH="/opt/cartesi/bin:${PATH}"

WORKDIR /opt/cartesi/dapp

COPY game game/
COPY entrypoint.sh .

RUN cd game && godot --headless --export-debug "Linux/X11" ../server.x86_64

COPY --from=cast-builder /root/.cargo/bin /root/.cargo/bin

ENV PATH="/root/.cargo/bin:$PATH"
ENV ROLLUP_HTTP_SERVER_URL="http://127.0.0.1:5004"

ENTRYPOINT ["./entrypoint.sh"]