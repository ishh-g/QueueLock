# QueueLock — Build Spec and Agent Rules

## 0. How to use this file

- Read this whole file before doing anything. Work **one milestone at a time** (section 16). Do not start a milestone until the previous one's acceptance checks pass.
- Serverpod API details (method names, config, package names) must be checked against the **current Serverpod 4.x docs** (https://docs.serverpod.dev) before use. If the docs disagree with this file on an API detail, the docs win: use the documented API and tell me what differed. Never invent an API. If `serverpod create` offers optional AI-agent skills for the editor, accept them.
- If a requirement here is ambiguous or seems wrong, say so and propose an alternative. Do not silently deviate.

## 1. Context

- Hackathon: **"Build Something Real: The Serverpod Hackathon"**. Solo entrant. Submission closes **14 Oct 2026, 23:59 CEST**. No extensions.
- Rules that shape the build: a working full-stack app with **Serverpod as the backend**; **newly created** during the submission period; the app must run consistently and behave as shown in the demo; a public demo video under 2 minutes; a hosted, testable link that stays free and unrestricted for judges until 20 Oct 2026 (credentials if private); AI-tool use must be disclosed in the submission text; the demo must not show third-party trademarks or copyrighted music.
- Scoring, which decides every trade-off:
  1. **Does it work — 30%.** It runs, the core flow completes, **nothing critical is faked**. Ties are broken by this score first.
  2. **Use of the Serverpod stack — 25%.** Serverpod does real backend work, not a static page with a backend attached.
  3. **Craft and technical creativity — 25%.** Rough UI is fine, careless engineering is not.
  4. **Usefulness — 20%.** A clear user with a clear problem, and it helps.
- Prefer **correctness and provability over feature count**. A small thing that provably works beats a large thing that mostly works.

## 2. Product

**One-liner:** a virtual queue for clinics, salons and small shops in India. Customers scan a QR code, join with just a nickname, and see a live position and a wait estimate learned from real service times. Staff at several counters call customers at the same time without ever calling the same person twice. A public, tamper-evident log lets anyone check the queue was run fairly.

**Users**
- **Customer:** no account, no app install. Opens a link (Flutter Web) from the QR code.
- **Staff / owner:** authenticated. Creates a queue, opens counters, calls customers.

**Problem:** long physical queues, and no way for customers to know how long they will wait or whether the queue was run fairly.

## 3. Non-negotiables

1. **Nothing critical is faked.** No mocked notifications, no fake payments, no hard-coded waits, no simulated data presented as real. Seeding a demo owner account is fine. Fake tickets or fake service history are not. If any demo data is synthetic, it must be created through the real endpoints and labelled in the UI.
2. **The server is the only authority.** Ticket numbers, positions, ordering, ETA, timeouts and the ledger are computed and enforced on the server. The client only renders.
3. **Every state change is one transaction** that also appends a ledger entry (section 7).
4. **No secrets in git.** Use Serverpod's `config/passwords.yaml` (gitignored) or environment variables.
5. **Data minimisation.** Customers give a nickname only (max 24 chars, trimmed, control characters removed). No phone number, no reason for the visit. Do not claim legal compliance anywhere. Say "data-minimised".
6. **English UI only** for the MVP.

## 4. Stack and layout

- **Serverpod 4.x** (server, generated client, Flutter app). Pin **exact** versions and keep all three packages on the same version. Use the newest stable 4.x the CLI installs; run `serverpod version`.
- **Flutter Web** is the target platform. Use `go_router` with path URLs so `/q/<slug>` and `/t/<token>` deep links work (configure SPA fallback on the host).
- **Postgres.** `serverpod start` can run an embedded Postgres for local development.
- Packages: `queuelock_server`, `queuelock_client` (generated, never hand-edited), `queuelock_flutter`.
- Server code layout (thin endpoints, logic in services):
  - `lib/src/endpoints/` thin: validate input, check auth, call a service.
  - `lib/src/services/` `queue_service.dart`, `ledger_service.dart`, `estimator.dart`, `ticket_tokens.dart`.
  - `lib/src/future_calls/` `call_timeout_future_call.dart`, `sweeper_future_call.dart`.
  - `lib/src/models/` `.spy.yaml` model files.
- After changing a model or endpoint: `serverpod generate`. After changing a model with a `table`: `serverpod create-migration`. Never hand-edit generated code.

## 5. Ticket lifecycle

```
waiting ──callNext──► called ──startServing──► serving ──complete──► done
   ▲                    │
   │                    └─ timeout ─► first miss: back to waiting (reentries = 1, re-inserted after the next 3 people)
   │                                  second miss: skipped (terminal)
waiting/called ──leave──► cancelled (terminal)
```

- **Grace rule:** on the first missed call the ticket returns to `waiting` and is re-inserted so that **three waiting tickets are ahead of it**. On the second miss it becomes `skipped` and stays out.
- **Re-insert ordering:** tickets have a `double orderKey`. New tickets get `orderKey = number`. To place a ticket after the next 3 waiting tickets: let k3 and k4 be the orderKeys of the 3rd and 4th waiting tickets. If there are at least 4, use `(k3 + k4) / 2`. If exactly 3, use `k3 + 1`. If fewer than 3, use `maxWaitingOrderKey + 1` (or `number` if none).
- Only staff move a ticket from `called` to `serving`. A called customer is not auto-confirmed.

## 6. Data model (Serverpod `.spy.yaml`; adapt to 4.x syntax)

- **Queue**: `slug` (unique), `name`, `status` (open/paused/closed), `callTimeoutSec` (default 180, min 10), `lastNumber` (int), `headSeq` (int), `headHash` (string), `avgServiceSec` (double), `sampleCount` (int), `ownerId` (the auth user id; check the 4.x auth id type).
- **Counter**: `queueId`, `name`, `active` (bool).
- **Ticket**: `queueId`, `number`, `nickname`, `tokenHash`, `status`, `orderKey` (double), `callId` (int, incremented on every call), `calledAt`, `counterId`, `servingAt`, `doneAt`, `reentries` (int), `joinedAt`. Unique on (`queueId`, `number`). Index on (`queueId`, `status`, `orderKey`).
- **LedgerEntry**: `queueId`, `seq`, `type`, `ticketNumber?`, `counterId?`, `detail?`, `tsMs` (int), `prevHash`, `hash`. Unique on (`queueId`, `seq`). **Never store nicknames here** (so nicknames can be purged without breaking the chain).
- **ServiceSample**: `queueId`, `counterId`, `hourOfDay`, `durationSec`, `createdAt`.
- Ticket tokens: 32 random bytes, base64url, shown once in the URL `/t/<token>`. **Store only the SHA-256 hash.** Look tickets up by hash.
- Retention: a scheduled job clears nicknames on tickets older than 24 hours.

## 7. The critical section (most important part of the project)

All state-changing operations (`join`, `callNext`, `startServing`, `complete`, `skip`, `leave`, timeout handling, queue open/pause/close) go through one helper, `QueueService.withQueueLock`:

1. Open a database transaction.
2. Load the **Queue row with `LockMode.forUpdate`** inside that transaction. This serialises all operations on one queue and therefore serialises the ledger chain. (Verify the exact lock API in the 4.x docs.)
3. Run the operation using the same transaction.
4. Append the ledger entry through `LedgerService.append(tx, queue, ...)`, which increments `headSeq`, computes the hash, and updates `headHash` on the locked queue row.
5. Commit.
6. **After commit only:** publish the realtime change event and schedule any FutureCalls. Never do side effects inside the transaction.

**Ledger hash** (SHA-256, hex, use the `crypto` package):

```
hash = sha256( "$queueId|$seq|$type|${ticketNumber ?? '-'}|${counterId ?? '-'}|${detail ?? '-'}|$tsMs|$prevHash" )
```

- The genesis `prevHash` is 64 zeros. `tsMs` is an integer stored in its own column and hashed as-is (never hash a `DateTime` round-tripped through the database).
- Ledger event types: `queue_opened`, `queue_paused`, `queue_closed`, `joined`, `called`, `serving_started`, `completed`, `reentered`, `skipped`, `cancelled`.
- **Receipts:** on `join`, return the ticket number, the token, and the `joined` entry's `seq` and `hash`. The ticket page shows them. The public audit page recomputes the whole chain and checks any receipt against it. This is what makes the ledger tamper-evident: an operator who rewrites history would contradict receipts customers hold. Use the words **"tamper-evident"**, never "provable" or "tamper-proof".

## 8. API surface (thin endpoints)

**Public (no auth)**
- `QueueEndpoint.info(slug)` returns the queue name, status, waiting count and the counters.
- `QueueEndpoint.join(slug, nickname)` returns a receipt `{number, token, joinSeq, joinHash}`. Rejects if the queue is not open, if the waiting cap (500) is reached, or if the caller exceeds the rate limit (10 joins per minute per IP).
- `QueueEndpoint.watch(token)` returns `Stream<TicketView>` with status, position, `etaSeconds`, called-to-counter info and time left to arrive.
- `QueueEndpoint.leave(token)`.
- `AuditEndpoint.ledger(slug, afterSeq, limit)`, `AuditEndpoint.verify(slug)` (returns `{ok, entryCount, firstBadSeq}`) and `AuditEndpoint.checkReceipt(slug, seq, hash)`.

**Staff (authenticated; owner check on every call)**
- `AdminEndpoint.createQueue(name, callTimeoutSec)`, `addCounter`, `setStatus`.
- `CounterEndpoint.callNext(counterId)` (returns the called ticket or null), `startServing(ticketId)`, `complete(ticketId, {callNext})`, `skip(ticketId)`.
- `CounterEndpoint.watchQueue(queueId)` returns `Stream<QueueSnapshot>` (waiting list, called and serving tickets, counters, average service time).

**Ownership rule:** every staff call checks that the authenticated user owns the queue. MVP: owner-only. The owner can log in on several devices and each device picks a counter.

## 9. Scheduled work (FutureCalls)

Serverpod future calls run **at least once**, so handlers must be **idempotent**.

- **CallTimeout(ticketId, callId):** scheduled after commit at `now + callTimeoutSec`. In `withQueueLock`, reload the ticket. Act only if `status == called` **and** `callId` matches. Otherwise do nothing. Then apply the grace rule (section 5) and append `reentered` or `skipped`.
- **Sweeper:** runs every 60 seconds and reschedules itself. It finds tickets in `called` whose timeout has passed and applies the same handler logic. It exists to recover from a crash between commit and scheduling. Make sure only one sweeper chain exists (use an identifier if the API supports it; check the docs).
- **Retention:** clears nicknames older than 24 hours.

## 10. Realtime

- Use Serverpod streaming endpoint methods for `watch` and `watchQueue`.
- Fan-out: after commit, publish a small "queue changed" message on a per-queue channel using Serverpod's messaging facility (verify the exact API in the docs). Each open stream recomputes **its own view from the database** on that message. Messages carry no state, so a missed message can never leave a client wrong.
- On reconnect, the client immediately gets a fresh view.

## 11. Wait-time estimate

- After each `complete`, record a `ServiceSample` (`servingAt` to `doneAt`) and update the average: `avg += alpha * (x - avg)` with `alpha = max(0.2, 1 / (sampleCount + 1))`. The starting prior is 300 seconds.
- `etaSeconds = (waitingAhead / max(activeCounters, 1)) * avgServiceSec`, plus `avgServiceSec / 2` when every active counter is busy.
- The UI shows "about N min, based on M recent services". With zero samples, show "estimate improves as we serve people". **Never seed fake history.**
- Stretch (only after M5): per-hour-of-day averages once an hour has at least 5 samples.

## 12. Auth, privacy, abuse

- Staff auth: use Serverpod's authentication module with email and password (check the 4.x docs for the current package names and setup).
- Customers use ticket tokens only. One active ticket per token. The client keeps the token in the URL so a refresh keeps the ticket.
- Rate limiting and a waiting cap as in section 8. Sanitise nicknames.
- Log no nicknames and no tokens.

## 13. Flutter Web app

Routes and screens (plain, clear, mobile-first, large tap targets):
- `/` short landing page and "Create a queue" (staff login/sign-up).
- `/q/:slug` queue info and nickname entry, then a **Join** button.
- `/t/:token` live ticket page: big number, position, ETA, status. When called: a prominent "Go to Counter X" banner with a countdown, plus vibration and a sound cue when the browser allows. Receipt (seq and hash) in a small "fairness receipt" panel. A "Leave queue" button.
- `/staff` queue list and create form. `/staff/:queueId` counter dashboard: pick a counter, big **Call next** button, the current ticket with **Start serving / Complete / Skip**, the waiting list, average service time, and a QR code for the queue link (use `qr_flutter`).
- `/audit/:slug` public audit page: chain status (verified or first bad seq), entry list, and a "check my receipt" box.
- Handle loading, empty and error states everywhere. The reconnecting state after a lost stream must be visible.

## 14. Tests (these are the "does it work" proof; write them as you build)

Run concurrency tests against a **real running server through the generated client** using `Future.wait`, so they exercise real transactions. (Serverpod's generated test helper wraps tests in a rolled-back transaction by default, which can hide concurrency issues; check the Testing docs for how to disable it if you use the helper.)

1. **50 concurrent joins** produce unique, gap-free numbers 1 to 50.
2. **Two counters calling concurrently** against 40 waiting tickets, 20 calls each, call every ticket **exactly once** (no duplicates, none skipped).
3. **Ledger integrity:** after tests 1 and 2 the chain verifies. Altering any one ledger row makes `verify` fail at exactly that `seq`. A receipt from `join` passes `checkReceipt`.
4. **Timeout:** with `callTimeoutSec = 1`, an unconfirmed called ticket returns to `waiting` behind three others, and a second miss makes it `skipped`. Running the timeout handler twice does not change the result.
5. **Grace ordering** unit tests: fewer than 3, exactly 3, and more than 3 waiting tickets.
6. **Estimator** unit tests: prior, first samples, several counters, all counters busy.
7. **Auth:** a staff call from a non-owner is rejected. Public endpoints reject invalid tokens.
- `dart analyze --fatal-infos` and `dart test` must pass before every commit. Set up CI to run both.

## 15. Demo mode

- `callTimeoutSec` is a per-queue setting. The demo queue uses about 20 seconds so the timeout can be shown in under 2 minutes. Say so on screen: "timeout is configurable; shown at 20 s".
- `tool/seed_demo.dart` creates a demo owner account and an empty demo queue. Nothing else.

## 16. Milestones and acceptance checks

**M0 — Setup (Sep 29-30).** Repo, `.gitignore`, this file, `docs/`. CI running analyze and test. `serverpod start` works. A hello endpoint is reachable from Flutter Web. **A skeleton is deployed** on a public URL (check the hackathon page for whether Serverpod Cloud is expected; otherwise a container host with managed Postgres).
*Accept:* the deployed page loads and calls the server.

**M1 — Core domain (Oct 1-3).** Models, migration, `withQueueLock`, ledger service, `join`, `callNext`, `startServing`, `complete`, `skip`, `leave`, `verify`, `checkReceipt`.
*Accept:* tests 1, 2, 3 and 7 pass.

**M2 — Realtime and screens (Oct 4-5).** Both streams, the customer ticket page, and a basic staff dashboard.
*Accept:* two browser tabs see position changes live with no manual refresh.

**M3 — Timeouts and estimator (Oct 6-7).** CallTimeout, sweeper, grace rule, estimator.
*Accept:* tests 4, 5 and 6 pass; the countdown and re-entry are visible in the UI.

**M4 — Audit, QR, polish (Oct 8).** Audit page, QR display, empty/error/reconnect states, mobile layout.
*Accept:* a full run-through on a real phone works.

**M5 — Hardening (Oct 9).** Rate limits, waiting cap, retention job, README with run and test instructions, demo seed. **Stretch, only if everything above is solid:** Web Push for "you're called" (first check for a maintained Dart web-push package).
*Accept:* a fresh clone follows the README and runs.

**M6 — Pilot and submission (Oct 10-13).** One real-world trial at a small local venue, with the venue's permission. Use real service times. Record the demo (under 2 minutes, screen plus real phone). Complete `docs/SUBMISSION.md`. Submit by **Oct 13**.

## 17. Out of scope (do not build)

WhatsApp or SMS sending, payments or deposits, offline sync, regional-language UI, multi-branch or multi-tenant admin, analytics dashboards beyond the average service time, native mobile apps. If any of these seems necessary, stop and ask.

## 18. Working agreements

- Small commits with clear messages from day one (the history is evidence the project was built in the window).
- `dart format`, `dart analyze --fatal-infos`, and tests before each commit.
- Ask before adding a dependency, and list what it is for.
- Keep endpoints thin, logic in services, and business rules on the server.
- Keep `README.md` current as you go, including exact run and test commands.
- **Log Serverpod friction** (bugs, unclear docs, missing features, confusing errors) in `docs/serverpod-feedback.md` with a short repro. It feeds the hackathon's feedback prize.
- Keep `docs/AI_USAGE.md` recording which AI tools were used and for what. The submission must disclose AI use.
- Do not show third-party logos or trademarks in the UI.

## 19. Submission checklist (maintain `docs/SUBMISSION.md`)

- **Problem and users** (short).
- **Features** (only what works).
- **How Serverpod is used:** transactional row locking for race-free calls, streaming endpoints for live updates, FutureCalls for timeouts and the sweeper, ORM and migrations, authentication, server-side ledger and estimator, tests hitting a running server.
- **How it was built**, including the AI-tool disclosure.
- **Run and test instructions**, the hosted link, and judge credentials.
- **Known limits, stated plainly:** no push notifications when a phone is locked (unless M5 stretch is done), no payments, no WhatsApp/SMS, owner-only staff model, the ledger is tamper-evident (not tamper-proof) and depends on customers keeping their receipts.
