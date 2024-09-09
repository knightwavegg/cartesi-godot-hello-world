# cartesi-godot-hello-world

This repo provides a full featured example for building a client-server application on Cartesi using Godot Engine. It uses the cartesi framework for building the server dApp docker image.

## Resources:

- [ Cartesi Docs ]( https://docs.cartesi.io/cartesi-rollups/1.5/ )
- [ Godot Docs ]( https://docs.godotengine.org/en/stable/about/introduction.html )
- [ Foundry Docs ](https://book.getfoundry.sh/)

## Architecture

This project consists of 3 components:
1. The game client, run as an HTML5 game.
2. The game server, built as a Docker container.
3. A MessageBoard contract, that the game server publishes inputs to via Vouchers.

The client & server are both built using the [Godot project](game/) in this repo.The Messageboard is a very [simple contract](contracts/src/MessageBoard.sol) built using Foundry.

## Dependencies

The game client requires Ethers.js in order to interact with the users browser wallet and read data from smart contracts on-chain. This is packaged in the export presets for the web build and interfaced with using the Ethers.gd plugin in the addons/ directory.

 The game server has an additional dependency for formatting arguments to build vouchers called cast. This is shipped as part of the foundry CLI, but is not supported in the Docker image. To fill that gap I built a minimal fork of cast called [ tinycast ](https://github.com/knightwavegg/tinycast). It only supports a small subset of the cast functionality, but it's enough to support voucher creation.

## Running the project locally

### Client

Input and Voucher handling requires ethers.js, so the game client can only run in the browser.

```
# In game/ run:
godot --headless -v --export-release "Web"
# Then serve index.html from a web server, one good option is the npm `serve` package:
serve -s public --cors
```

### Server

#### Host Mode

First, run cartesi without the backend dapp:

```
cartesi run --no-backend
```

Then, run the game in server mode:

```
ROLLUP_HTTP_SERVER_URL="http://127.0.0.1:8080/host-runner" SERVER_MODE=true godot --headless
```

#### Running as a docker image

Simply use cartesi:

```
cartesi build
cartesi run
```

### Using the MessageBoard contract

The Godot server is a simple echo server: Any message it receives as an Input it emits as a Notice, Report, and a Voucher. The Voucher will publish the received message to the MessageBoard contract.

To deploy the MessageBoard contract to the local chain, we use forge. Grab one of the private keys seeded with ETH to use in the local chain deployment.

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