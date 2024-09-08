# cartesi-godot-hello-world

This repo provides a full featured example for building a client-server application on Cartesi using Godot Engine. It uses the cartesi framework for building the server dApp docker image.

Resources:

- Cartesi Docs:

## Run game client:

Input and Voucher handling requires ethers.js, so the game client can only run in the browser.

### Running in the Godot Editor

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

First, run cartesi without the backend dapp:

```
cartesi run --no-backend
```

Then, run the game in server mode:

```
ROLLUP_HTTP_SERVER_URL="http://127.0.0.1:8080/host-runner" SERVER_MODE=true godot --headless
```

### Running as a docker image

Simply use cartesi:

```
cartesi build
cartesi run
```

## Using the MessageBoard contract

The Godot server is a simple echo server: Any message it receives as an Input it emits as a Notice, Report, and a Voucher. The Voucher will publish the received message to the MessageBoard contract.

To deploy the MessageBoard contract to the local chain, we use forge.

```
# 1. Start cartesi with --no-backend
# 2. Deploy the MessageBoard contract
#      in the contracts/ directory:
forge create --rpc-url http://localhost:8545 --private-key <private_key> src/MessageBoard.sol:MessageBoard
# 3. Run the game in server mode
# 4. Make sure the local network is added to your browser wallet
# 5. Grab one of the private keys for the wallets cartesi generates and import it to your browser wallet
# 6. Run the game client
```
