# QueueLock

A virtual queue for clinics, salons and small shops in India. Customers scan a
QR code, join with just a nickname, and see a live position and a wait estimate
learned from real service times. Staff at several counters call customers
without ever calling the same person twice. A public, tamper-evident log lets
anyone check the queue was run fairly.

Built with **Serverpod 4.0.3** (server + generated client + Flutter Web).
Full spec: `AGENTS.md`. Submission draft: `docs/SUBMISSION.md`.

## Packages

- `queuelock_server` — Serverpod server (thin endpoints, logic in services)
- `queuelock_client` — generated client, never hand-edited
- `queuelock_flutter` — Flutter Web app
- `tool/seed_demo.dart` — demo seed (owner + empty demo queue)

## Prerequisites

- Flutter 3.44.4+ (brings Dart 3.12.2+)
- Serverpod CLI 4.0.3: `dart install serverpod_cli`

Local development and tests use an **embedded PostgreSQL** (`dataPath` in
`queuelock_server/config/development.yaml` and `test.yaml`). No Docker needed.

Keep the repo outside OneDrive/Dropbox-style sync folders: the sync locks
fight the build tools (`C:\src\QueueLock` works on Windows).

## Run

From the repo root:

```sh
serverpod start
```

This starts the server, the embedded Postgres (applies pending migrations),
and the Flutter app with hot reload. Useful keys: `R` hot restart,
`M` create and apply a migration, `P` repair migration. Run only one
server at a time (the embedded database takes a lock).

Routes: `/` landing, `/q/:slug` join, `/t/:token` live ticket,
`/staff` staff area, `/staff/:queueId` counter dashboard,
`/audit/:slug` public audit.

Staff sign-in uses email + password. In development the verification code
is printed in the server terminal (`Registration code for <email>: <code>`);
in staging/production it is emailed via Serverpod Cloud.

## Demo seed

Creates (or reuses) the demo owner and a fresh empty demo queue with a
20 s call timeout. The maintenance role binds no ports, so this works
alongside `serverpod start`:

```sh
cd queuelock_server
dart run ../tool/seed_demo.dart --role maintenance --apply-migrations
```

Demo credentials: `demo@queuelock.local` / `Demo-pass-1234` (local dev only).

## Test

```sh
cd queuelock_server
dart test            # full suite: unit + integration (boots test servers)
dart test test/unit  # fast unit tests only
```

Concurrency tests run against real booted servers with real transactions
(`rollbackDatabase: disabled`, one database per group). Note: the test
server does not execute future calls, so timeout expiry is reached with
genuinely-expired rows through the sweeper/handler — the same production
code path (see `test/integration/timeout_sweeper_test.dart`).

## Static checks (run before every commit)

```sh
cd queuelock_server
dart format .
dart analyze --fatal-infos
cd ../queuelock_flutter
flutter analyze
```

CI (`.github/workflows/`) runs format, analyze, and tests on push/PR to `main`.

## Regenerate after changing models or endpoints

```sh
cd queuelock_server
serverpod generate                       # models (.spy.yaml) or endpoints changed
serverpod create-migration               # models with a `table` changed
```

Never hand-edit generated code (`queuelock_server/lib/src/generated/`,
`queuelock_client`). One definition per `.spy.yaml` file.

## Deploy

Recommended: Serverpod Cloud (see
https://docs.serverpod.dev/deployments/deploy-to-serverpod-cloud):

```sh
serverpod cloud launch
serverpod cloud deploy
```

A `Dockerfile` for self-hosting is at `queuelock_server/Dockerfile`.

Known limits, stated plainly: no push notifications when a phone is
locked (in-app banner + beep/vibration where the browser allows instead),
no payments, no WhatsApp/SMS, owner-only staff model. The ledger is
tamper-evident (not tamper-proof) and depends on customers keeping their
receipts.
