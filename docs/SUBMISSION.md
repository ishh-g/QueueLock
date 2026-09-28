# Submission (draft, M0)

Maintained per `AGENTS.md` section 19. Only what works is listed.

## Problem and users

Small clinics, salons and shops in India run long physical queues. Customers
cannot tell how long they will wait or whether the queue was run fairly.
QueueLock is a data-minimised virtual queue: customers join from a QR code
with just a nickname, see a live position and a learned wait estimate; staff
call customers from several counters without double-calling; a public
tamper-evident ledger lets anyone audit the run.

## Features (M0: skeleton only)

- `greeting.hello` example endpoint reachable from the Flutter Web app.
- Nothing of the QueueLock domain is built yet (starts in M1).

## How Serverpod is used (M0)

- `serverpod create` scaffold: `queuelock_server`, generated
  `queuelock_client`, `queuelock_flutter`.
- `serverpod start`: one command runs server + embedded Postgres + Flutter
  Web with hot reload.
- Embedded PostgreSQL for dev and test (no Docker needed).
- Serverpod auth module (`serverpod_auth_idp_*`) scaffolded, unused so far.

## How it was built

See `docs/AI_USAGE.md` for the AI-tool disclosure.

## Run and test

See `README.md`. Hosted link: TBD (M0 deploys the skeleton to Serverpod
Cloud; link goes here once live).

## Known limits, stated plainly

- M0 skeleton: no queues, tickets, ledger, or auth flows yet.
- The ledger will be tamper-evident (not tamper-proof) and will depend on
  customers keeping their receipts.
- No push notifications when a phone is locked, no payments, no
  WhatsApp/SMS, owner-only staff model (all per spec, to be built in M1–M5).
