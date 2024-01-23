FROM knightwavegg/cartesi-godot:4.2.1-stable as game-build
WORKDIR /opt/cartesi/dapp

COPY game game/

RUN cd game && godot --headless --export-debug "Linux/X11" server.x86_64

COPY entrypoint.sh .

ENV SERVER_MODE true

CMD ./server.x86_64 --headless