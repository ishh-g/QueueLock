# QueueLock — hackathon submission

## Problem and users

Small clinics, salons and shops in India run long physical queues.
Customers cannot tell how long they will wait, or whether the queue was
run fairly. QueueLock is a data-minimised virtual queue: customers scan a
QR code, join with just a nickname (no account, no app install), and see
a live position plus a wait estimate learned from real service times.
Staff at several counters call customers without ever calling the same
person twice. A public, tamper-evident log lets anyone audit the run.

## Features (only what works)

- **Join with a nickname** from a QR link (`/q/:slug`). One-time ticket
  token in the URL; only its hash is stored. Join receipt (ledger seq +
  hash) shown on the ticket page.
- **Live ticket page** (`/t/:token`): big number, position, ETA, called
  banner with countdown and counter name, fairness receipt, leave button,
  visible reconnecting state.
- **Staff dashboard** (`/staff/:queueId`): counter pick/add, big Call
  next, Start / Done / Done+next / Skip, waiting/called/serving lists
  updating live, Open/Pause/Close, QR join link, average service time.
- **Missed-call grace**: first miss returns the ticket behind the next
  three people; second miss skips it. Idempotent timeout handling via
  per-call future calls plus a 60 s sweeper safety net.
- **Learned wait estimates**: every completion records a real service
  sample; EWMA average drives per-ticket ETAs ("about N min, based on M
  recent services"; honest fallback with zero samples — never seeded).
- **Public audit** (`/audit/:slug`): chain status (verified count or
  first bad entry), paginated entries, check-your-receipt box.
- **Abuse protection**: 10 joins/min per queue + caller address (hashed),
  500-ticket waiting cap, nicknames purged after 24 h (the ledger never
  holds them, so the chain survives).
- **Proven by tests**: 50 concurrent joins gap-free; 2×20 concurrent
  calls exactly once; chain verifies and tampering is located at the
  exact entry; receipts check out; non-owners rejected; timeouts,
  grace ordering and estimator covered. 42/42 green, analyzers clean.

## How Serverpod is used

- **Transactional row locking**: every state change runs in one
  transaction that loads the queue row `FOR UPDATE`
  (`QueueService.withQueueLock`), serialising each queue and its ledger
  chain; the ledger append commits atomically with the change.
- **Streaming endpoints**: `watch` / `watchQueue` serve live views over
  WebSockets; post-commit fan-out on per-queue message channels;
  streams recompute from the DB, messages carry no state.
- **FutureCalls**: per-ticket `CallTimeout` armed after commit;
  recurring `Sweeper` (timeouts, nickname purge, rate-limit prune).
- **ORM + migrations**: all models in `.spy.yaml`, versioned migrations.
- **Auth**: email/password sign-in for staff (owner-only queues);
  ticket-token customers need no account.
- **Server-side ledger + estimator**: hash chain and EWMA computed and
  enforced on the server; clients only render.
- **Tests**: `withServerpod` groups with own embedded-Postgres databases
  and real transactions.

## How it was built (AI disclosure)

Built solo with OpenCode + Muse Spark (see `docs/AI_USAGE.md` for the
per-milestone breakdown), Serverpod's own agent skills (accepted at
scaffold), and `serverpod generate` for all protocol code. All business
logic was written and reviewed as source; generated code was never
hand-edited. Serverpod friction found along the way is logged in
`docs/serverpod-feedback.md`.

## Pilot

- Venue: TBD (real-world trial per `docs/PILOT.md` runbook).
- Outcome: TBD.

## Demo

- Video (under 2 minutes, screen + real phone): TBD.
- No third-party trademarks or copyrighted music in the app or video.

## Run and test

See `README.md` (run, demo seed, tests, checks, deploy). Quick version:

```sh
serverpod start            # server + embedded Postgres + web app
cd queuelock_server && dart test   # 42/42
```

## Hosted link and credentials

- Link: TBD (deploy via `serverpod cloud launch` / `serverpod cloud deploy`).
- The app is public; judges can sign up with any email (verification
  emails are sent by Serverpod Cloud in staging/production). Demo flow:
  sign in → create queue → add counter → join from `/q/<slug>`.
- Stays free and unrestricted for judges until 20 Oct 2026.

## Known limits, stated plainly

- No push notifications when a phone is locked (in-app banner, beep and
  vibration where the browser allows, instead); no payments; no
  WhatsApp/SMS; owner-only staff model.
- The ledger is tamper-evident (not tamper-proof) and depends on
  customers keeping their receipts.
- Web-push stretch skipped: no maintained Dart-native server package
  for Web Push (VAPID + RFC 8291 encryption).
