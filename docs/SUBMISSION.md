# Submission (draft, M0)

Maintained per `AGENTS.md` section 19. Only what works is listed.

## Problem and users

Small clinics, salons and shops in India run long physical queues. Customers
cannot tell how long they will wait or whether the queue was run fairly.
QueueLock is a data-minimised virtual queue: customers join from a QR code
with just a nickname, see a live position and a learned wait estimate; staff
call customers from several counters without double-calling; a public
tamper-evident ledger lets anyone audit the run.

## Features (M1: core domain done)

- Queue/Counter/Ticket/LedgerEntry/ServiceSample models + migration.
- `join` (receipt with one-time token + ledger seq/hash), `callNext`
  (race-free across counters), `startServing`, `complete` (optional chained
  `callNext`), `skip`, `leave`, queue `info`, ledger page, `verify`,
  `checkReceipt`. Owner-only staff endpoints; ticket hashes never leave
  the server.
- Proven: 50 concurrent joins gap-free; 2×20 concurrent calls exactly
  once; chain verifies, tamper located at exact seq; non-owner rejected.

## Features (M2: realtime + screens done)

- `queue.watch(token)` → live `TicketView` (number, status, position,
  called counter + seconds to arrive, fairness receipt); `counter
  .watchQueue(queueId)` → live `QueueSnapshot` (waiting/called/serving,
  counters, avg service time). Post-commit fan-out on per-queue channels;
  streams recompute views from the DB, messages carry no state.
- Flutter Web with path URLs: `/` landing, `/q/:slug` join, `/t/:token`
  live ticket (called banner with countdown, receipt panel, leave),
  `/staff` sign-in + queue list + create, `/staff/:queueId` counter
  dashboard (pick counter, call next, start/complete/skip, status
  switch, live lists). ETA shows a placeholder until the M3 estimator.
- Proven: stream tests (subscribe → mutate → fresh view, no polling);
  `flutter build web` succeeds.

## Features (M3: timeouts + estimator done)

- Missed-call grace: first miss returns the ticket to waiting behind the
  next three (orderKey midpoint rule), second miss skips it. Timeout
  handler is idempotent (status + callId match required).
- `CallTimeout` future call armed after every commit; recurring `Sweeper`
  (60 s, single identifier-guarded chain) recovers missed timeouts and
  purges nicknames older than 24 h.
- Estimator: per-service samples, EWMA average (prior 300 s), live
  `etaSeconds` in ticket views ("about N min, based on M recent
  services", honest fallback with zero samples).
- Proven: tests 4 (schedule row + sweeper re-entry at index 3 + skip +
  idempotent re-runs), 5 (grace ordering unit), 6 (estimator unit).

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
