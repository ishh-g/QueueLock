# QueueLock

A virtual queue for clinics, salons and small shops in India. Customers scan a
QR code, join with just a nickname, and see a live position and a wait estimate
learned from real service times. Staff at several counters call customers
without ever calling the same person twice. A public, tamper-evident log lets
anyone check the queue was run fairly.

Built with **Serverpod 4.0.3** (server + generated client + Flutter Web).
Full spec: `AGENTS.md`.

## Packages

- `queuelock_server` — Serverpod server (thin endpoints, logic in services)
- `queuelock_client` — generated client, never hand-edited
- `queuelock_flutter` — Flutter Web app

## Prerequisites

- Flutter 3.44.4+ (brings Dart 3.12.2+)
- Serverpod CLI 4.0.3: `dart install serverpod_cli`

Local development and tests use an **embedded PostgreSQL** (`dataPath` in
`queuelock_server/config/development.yaml` and `test.yaml`). No Docker needed.

## Run

From the repo root:

```sh
serverpod start
```

This starts the server, the embedded Postgres (applies pending migrations),
and the Flutter app with hot reload. The demo app opens in a browser;
entering a name calls the `greeting.hello` endpoint on the server.

Useful keys while `serverpod start` runs: `R` hot restart, `M` create and
apply a migration, `P` repair migration.

## Test

```sh
cd queuelock_server
dart test
```

## Static checks (run before every commit)

```sh
cd queuelock_server
dart format .
dart analyze --fatal-infos
```

CI (`.github/workflows/`) runs format, analyze, and tests on push/PR to `main`.

## Regenerate after changing models or endpoints

```sh
serverpod generate                       # models (.spy.yaml) or endpoints changed
serverpod create-migration               # models with a `table` changed
```

Never hand-edit generated code (`queuelock_server/lib/src/generated/`,
`queuelock_client`).

## Deploy

Recommended: Serverpod Cloud (see
https://docs.serverpod.dev/deployments/deploy-to-serverpod-cloud):

```sh
serverpod cloud launch
serverpod cloud deploy
```

A `Dockerfile` for self-hosting is at `queuelock_server/Dockerfile`.
