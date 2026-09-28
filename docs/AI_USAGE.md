# AI usage

Disclosed per the hackathon rules (AI-tool use must be in the submission text).

## M0 (Sep 28, 2026)

- Tool: OpenCode with Muse Spark (`opencode/muse-spark-1.3-contributor-free`).
- Used for: installing the toolchain (Flutter SDK, Serverpod CLI 4.0.3),
  scaffolding the Serverpod project (`serverpod create -n queuelock --ide
  opencode`), writing `README.md` and this `docs/` set, setting up CI review.
- Serverpod agent skills (`.opencode/skills/`) were accepted at scaffold time
  as `AGENTS.md` instructs.
- All generated code was produced by `serverpod create` / `serverpod
  generate`, not hand-written by the AI. No application logic exists yet.

## M1 (Sep 28, 2026)

- Same tool. Used for: `.spy.yaml` models, `QueueService` (critical
  section), `LedgerService` (hash chain), `TicketTokens`, thin endpoints,
  integration + unit tests.
- Concurrency tests use `withServerpod` with `rollbackDatabase.disabled`
  (each group gets its own embedded-Postgres database) instead of a
  hand-started server + raw generated client: same real-transaction
  semantics, hermetic on CI. Documented in the test file header.
- New dependency: `crypto` (spec section 7 mandates it for the ledger
  hash).
- M1 follow-up: new tests for `complete(callNext: true)`, `skip` from
  `serving`, `leave` from `called` caught a stale-head bug (chained ledger
  appends reused the pre-append queue row, duplicating `seq`); fixed by
  having `LedgerService.append` return the fresh head row.

## M2 (Sep 28, 2026)

- Same tool. Used for: view models, `ticketView`/`queueSnapshot`
  builders, post-commit message fan-out, `watch`/`watchQueue` stream
  endpoints, stream tests, the go_router Flutter app (5 screens).
- New dependencies: `go_router`, `flutter_web_plugins` (both spec
  section 4/13: path-URL routing for `/q/:slug` and `/t/:token`).

## M3 (Sep 28, 2026)

- Same tool. Used for: `Estimator`, grace rule, `applyCallTimeout`,
  `CallTimeout`/`Sweeper` future calls, sweeper + retention, `complete`
  sample recording, live ETA, tests 4–6.
- Test deviation (spec section 0): test 4 asks for `callTimeoutSec = 1`
  but section 6 sets a 10 s minimum, so tests use 10 s with genuinely
  expired rows (backdated `calledAt`) through the sweeper and handler —
  the same code the scheduled call runs. Scheduling itself is asserted
  via the `serverpod_future_call` row. Finding: the `withServerpod`
  test server does not execute future calls, so a real wall-clock
  expiry cannot be tested there (logged in `serverpod-feedback.md`).

## M4 (Sep 28, 2026)

- Same tool. Used for: audit page, dashboard QR, best-effort call
  alert, polish pass.
- New dependencies: `qr_flutter` (spec section 13 names it), `web` +
  `flutter_web_plugins` interop for vibrate/beep "when the browser
  allows".

## M5 (Sep 28, 2026)

- Same tool. Used for: join rate limit, cap proof test, demo seed,
  README refresh.
- Rate-limit design note: endpoint sessions expose the caller address
  via `Session.request.remoteInfo` (Forwarded/XFF/connection fallback);
  it is hashed (SHA-256, never stored raw) and enforced inside the
  queue-lock transaction. Unknown address (tests, internal calls) skips
  the check — every production HTTP call carries one.
- Web-push stretch: checked, skipped — no maintained Dart-native
  server package for Web Push (VAPID + RFC 8291 encryption); hand-
  rolling the crypto is out of scope. In-app banner + beep/vibrate stay
  the call signal (already built in M4).
- Repo moved `OneDrive\Desktop\QueueLock` → `C:\src\QueueLock`: sync
  locks kept killing builds. Fresh-clone run passed (see below).
