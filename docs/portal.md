# Web Portal

The portal puts the gamemode's data on the web: statistics and live server information, a map of everything the gamemode places in San Andreas, and this documentation. It is four small services. Three of them read the same SQLite database the gamemode writes, and all three open it read-only, so they never touch a running game.

| Service | Source | Serves | Port |
|---|---|---|---|
| gateway | `utils/gateway` | sign-in, the landing page, and the only way in to the other three | 8080 |
| statsui | `utils/statsui` | `/stats/`: leaderboards, the economy, live server info over the SA-MP query protocol, the RCON console | 8081 |
| mapui | `utils/mapui` | `/map/`: every place the gamemode puts on the map with its details, map-side stats, and the live layer | 8082 |
| docs | `mkdocs.yml`, `docs/` | `/docs/`: this site, built with MkDocs | 8083 |

statsui and mapui have no authentication of their own. The gateway checks every request, then passes it on with who is asking (`X-CRL2-User`, `X-CRL2-Admin-Level`) and drops any such headers the client sent. The backends must therefore never be reachable any other way: bind them to loopback, or keep them on the stack's internal network.

## Who can see what

Players sign in with their game nickname and password. The gateway checks these against `users` with the gamemode's own scheme (uppercase hex of `sha256(password + salt)`, as `SHA256_Hash` in `src/modules/auth.pwn`), so there is no separate portal account. A session lasts 8 hours (`GATEWAY_SESSION`).

| Path | Who |
|---|---|
| `/docs/`, `/login` | everyone, signed in or not |
| `/`, `/stats/`, `/map/` | any signed-in player, admin level 0 included |
| the RCON console and the server's raw log (`/stats/api/rcon`, `/stats/api/rcon/log`) | admin level 4 and up (`GATEWAY_MIN_ADMIN_RCON`) |
| the Tiki and Pumpkin spawns on the map (`/map/api/prizes`) | admin level 4 and up (`GATEWAY_MIN_ADMIN_PRIZES`) |

Below the bar, the RCON console is hidden and the map simply draws no prizes. The admin level is read from `users.adminlvl` at sign-in and kept in the session, so a player whose level changes (see [Commands Reference](commands.md#rcon-level-5)) gets the new level after signing in again.

## The live layer

Given a live map to read, mapui draws every player and NPC as they move, and statsui shows what each of them is doing. statsui can also read the server's log for restarts, joins and leaves, and errors. The live map is a feature of r2's SA-MP server (`map_port` and `map_key` in its `SAMP.CFG`). open.mp has nothing like it, so against the open.mp server the live layer stays off. It is off whenever `CRL2_LIVE_MAP` is empty, and the log view is off whenever `CRL2_LOG_PATH` is empty.

## Running it locally

For now the portal's sources (`utils/gateway`, `utils/statsui`, most of `utils/mapui`, `docker/`) are kept out of the repository, and so are its Make targets (`portal`, `stats`, `images`, `images-push`, `stack-secrets`, `stack-deploy`, `stack-rm`). The targets live in a gitignored `Makefile.local`, which `Makefile` includes when it exists. Without that file, none of the targets below exist.

```shell
make portal
```

This builds the docs (`make docs`), starts statsui, mapui and the gateway on loopback with `go run` against the repository's `crl2_data.db`, and serves the portal at <http://127.0.0.1:8070>. Ctrl-C stops all three. It needs Go and MkDocs. The target runs `utils/gateway/run-stack.sh`, whose environment variables (`CRL2_DB`, `CRL2_SERVER`, `CRL2_RCON_PASSWORD`, the listen addresses) override its defaults.

Each backend also runs on its own, without sign-in, so keep it on loopback:

```shell
make stats                     # statsui on http://127.0.0.1:8081
cd utils/mapui && go run .     # mapui on http://127.0.0.1:8082
```

`Makefile.local` reads `.env` from the repository root (gitignored too) and exports what it sets. Settings such as `CRL2_SERVER` or `CRL2_RCON_PASSWORD` placed there therefore reach `make portal`, `make stats` and the stack targets below. `docker compose` reads the same file.

## Containers and the swarm stack

`compose.yml` defines the four services next to the game server and its database. It gives them two networks of their own: `portal-edge`, where the gateway publishes its port (`PORTAL_PORT`), and the internal `portal-net`, where the gateway reaches the other three. statsui and mapui also join `samp-net`, which they need to reach the game server and the live map.

```shell
make images            # build the four images
make images-push       # build them and push them to CRL2_REGISTRY, tagged CRL2_TAG
make stack-secrets     # once per swarm: crl2_rcon_password (from .env) and a fresh crl2_rcon_token
docker node update --label-add crl2_data=true <node>
make stack-deploy      # deploy compose.yml as the stack STACK (default crl2)
make stack-rm          # remove the stack
```

- **Label the node.** The gateway, statsui and mapui bind-mount the gamemode's data directory (`CRL2_DATA_DIR`) read-only at `/data` and open `/data/crl2_data.db`. Their tasks are therefore pinned to the node labelled `crl2_data=true`, and without that label they stay pending.
- **`make stack-deploy` strips the top-level `name:`.** `docker compose` uses that key but the stack schema rejects it, so stripping it lets one file serve both.
- **`docker stack deploy` does not read `.env`.** `make stack-deploy` gets the values through `Makefile.local`; to deploy by hand, export them in the shell first.
- **Put TLS in front** and set `GATEWAY_SECURE=1`. Without it, session cookies travel in the clear.
- **Sessions survive a redeploy** because the gateway keeps its signing key in the `gateway-keys` volume. Running more than one gateway replica needs a shared key instead (`GATEWAY_SESSION_KEY_FILE`).

!!! danger "Never run `docker compose down -v` with this file on the game host"
    `mariadb-data` is declared in the same file, and `-v` deletes it. Stop the portal by name instead: `docker compose stop gateway statsui mapui docs`.

| Variable | Default | Meaning |
|---|---|---|
| `CRL2_DATA_DIR` | `/opt/open.mp/data` | Host directory holding `crl2_data.db` (and the server log), mounted read-only |
| `PORTAL_PORT` | `8080` | The gateway's published port |
| `CRL2_REGISTRY`, `CRL2_TAG` | `registry.vxn.dev/crl2`, `latest` | Image names |
| `STACK` | `crl2` | Stack name, for the Make targets |
| `CRL2_SERVER` | `server:39876` | The game server statsui queries |
| `CRL2_RCON_PASSWORD` | *(unset)* | The server's `rcon_password`; `make stack-secrets` stores it as `crl2_rcon_password` |
| `CRL2_TOP_N` | `10` | Leaderboard length |
| `CRL2_LIVE_MAP`, `CRL2_LIVE_MAP_KEY` | *(empty)* | The live map's address and its `map_key`; empty means no live layer |
| `CRL2_LOG_PATH` | *(empty)* | The server's log as the container sees it, e.g. `/data/SAMP.LOG`; empty means no log view |
| `GATEWAY_SESSION` | `8h` | Session lifetime |
| `GATEWAY_SECURE` | *(empty)* | `1` behind TLS |
| `GATEWAY_MIN_ADMIN_RCON`, `GATEWAY_MIN_ADMIN_PRIZES` | `4`, `4` | Admin levels for RCON and for the map's prizes |

## When the schema changes

The tools query the gamemode's tables directly. The gateway reads `users` (`nickname`, `pwdhash`, `salt`, `adminlvl`) to sign players in, and statsui and mapui read most of the rest. A migration that renames or drops a column one of them reads will break that tool. mapui's tests build their database from `sql/migrations`, so run them after a schema change:

```shell
cd utils/mapui && go test ./...
```

Each tool's own `README.md` (`utils/gateway`, `utils/statsui`, `utils/mapui`) and `docker/README.md` go further: every setting, the APIs, and troubleshooting the live map.
