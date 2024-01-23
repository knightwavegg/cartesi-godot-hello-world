# cartesi-godot-hello-world

This repo provides a full featured example for building a client-server application on Cartesi using Godot Engine.

### Features:

- Rollup server polling with `Cartesi.query_state()`.
- Inspect & Advance state request handling with associated signals in GDScript.
- Publish Notices, Reports, and Vouchers.
- Graphql API wrapper, including response object models.

### TODO:

- Submit inputs and execute vouchers (requires integrating ethers).
- Deployment automation.

## Run the game server

### Run in docker:

```
# In hello-world/
docker compose -f ../docker-compose.yml -f ./docker-compose.override.yml up
```

### Host mode

Run Cartesi rollup:

```
# In hello-world/
docker compose -f ../docker-compose.yml -f ./docker-compose.override.yml -f ../docker-compose-host.yml up
```

Run game server:

```
# In hello-world/game/
SERVER_MODE=true ROLLUP_HTTP_SERVER_URL="http://127.0.0.1:5004" godot --headless
```

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
