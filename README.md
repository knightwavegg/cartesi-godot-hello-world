# cartesi-godot-hello-world

This repo provides a full featured example for building a client-server application on Cartesi using Godot Engine. It uses the Sunodo framework for building the server dApp docker image.

Resources:

- Cartesi Docs:
- Sunodo Docs:

## Run game client:

For interfacing with the GraphQL API, you can run the client as a desktop release:

```
# In game/
godot
```

Input and Voucher handling requires ethers.js, and thus must be exported for the Web.

```
# In game/ run:
godot --headless -v --export-release "Web"
```

Then serve index.html from a web server, one good option is the npm `serve` package:

```
# In the same directory as your index.html
serve -s . --cors
```

## Run game server on Cartesi:

### Host Mode

First, run sunodo without the backend dapp:

```
sunodo run --no-backend
```

Then, run the game in server mode:

```
ROLLUP_HTTP_SERVER_URL="http://127.0.0.1:8080/host-runner" SERVER_MODE=true godot --headless
```

### Running as a docker image

Simply use sunodo:

```
sunodo build
sunodo run
```

## Deploying the MessageBoard contract

The Godot server is a simple echo server: Any message it receives as an Input it emits as a Notice, Report, and a Voucher. The Voucher will publish the received message to the MessageBoard contract.

To deploy the MessageBoard contract to the local chain, we use forge.

```
# 1. Start sunodo with --no-backend
# 2. Deploy the MessageBoard contract
#      in the contracts/ directory:
forge create --rpc-url http://localhost:8545 --private-key <private_key> src/MessageBoard.sol:MessageBoard
# 3. Run the game in server mode
```
