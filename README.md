# cartesi-godot-hello-world

This repo provides a full featured example for building a client-server application on Cartesi using Godot Engine. It uses the Sunodo framework for building the server dApp docker image.

Resources:

- Cartesi Docs:
- Sunodo Docs:
-

### Run game client:

For interfacing with the GraphQL API, you can run the client as a desktop release:

```
# In hello-world/game/
godot
```

Input and Voucher handling requires ethers.js, and thus must be exported for the Web.

```
# In hello-world/game/ run:
godot --headless -v --export-release "Web"
```

Then serve index.html from a web server, one good option is the npm `serve` package:

```
# In the same directory as your index.html
serve -s . --cors
```

TX_DEFAULT_CONFIRMATIONS=1
