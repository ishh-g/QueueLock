# Host on Render (free) + GitHub Pages (free)

Architecture: API + Postgres on Render (Docker, git push to deploy),
Flutter web as a GitHub Pages static site (never sleeps). Total cost $0.
Future calls run inside our own server, so timeouts/sweeper work fully —
unlike Serverpod Cloud's Starter plan.

Caveats (also stated in the submission): the free API service sleeps
after 15 idle minutes (~1 min wake on first hit; streams reconnect —
set up the UptimeRobot ping below to prevent sleep entirely). The free
Postgres expires 30 days after creation: create it in early October so
it covers judging (to Oct 20).

## 0. Push the code to GitHub

```cmd
cd C:\src\QueueLock
git remote add origin https://github.com/<you>/queuelock.git
git push -u origin master
```

Then in the GitHub repo: Settings -> Pages -> Source: **GitHub Actions**.
Settings -> Secrets and variables -> Actions -> Variables:

- `API_URL` = `https://queuelock-api.onrender.com` (your API service URL)
- `PAGES_BASE` = `/queuelock` (repo name, leading slash)

The `Web` workflow builds + publishes the app on every push to main.
Verify `https://<you>.github.io/queuelock/` loads the landing page.

## 1. Postgres on Render

Dashboard -> New -> PostgreSQL, Free plan. Note the connection pieces
(Host, Port, Database, Username, Password). Create it in early October.

## 2. API web service on Render

Dashboard -> New -> Web Service -> connect the repo. Settings:

- Runtime: **Docker**. Dockerfile path:
  `queuelock_server/Dockerfile` (it builds from the repo root).
- Instance: Free. Port: Render injects `PORT` (default 10000) — set
  `SERVERPOD_API_SERVER_PORT` to the same value (10000) so the API
  server listens where Render expects. Our server binds all interfaces.
- Health check: leave empty (the API port speaks the Serverpod
  protocol, not plain-HTTP 200s). Render marks the service live when
  the port accepts connections.
- Environment variables (all of these):

| Key | Value |
|---|---|
| `SERVERPOD_DATABASE_HOST` | Render Postgres host |
| `SERVERPOD_DATABASE_PORT` | Render Postgres port |
| `SERVERPOD_DATABASE_NAME` | Render Postgres database |
| `SERVERPOD_DATABASE_USER` | Render Postgres user |
| `SERVERPOD_DATABASE_REQUIRE_SSL` | `true` |
| `SERVERPOD_API_SERVER_PORT` | `10000` (must match Render `PORT`) |
| `SERVERPOD_API_SERVER_PUBLIC_HOST` | `<service>.onrender.com` (no scheme) |
| `SERVERPOD_API_SERVER_PUBLIC_PORT` | `443` |
| `SERVERPOD_API_SERVER_PUBLIC_SCHEME` | `https` |
| `SERVERPOD_WEB_SERVER_PUBLIC_HOST` | `<service>.onrender.com` |
| `SERVERPOD_WEB_SERVER_PUBLIC_PORT` | `443` |
| `SERVERPOD_WEB_SERVER_PUBLIC_SCHEME` | `https` |
| `SERVERPOD_APPLY_MIGRATIONS` | `true` |
| `SERVERPOD_PASSWORD_database` | Render Postgres password |
| `SERVERPOD_PASSWORD_serviceSecret` | fresh random 32 chars |
| `SERVERPOD_PASSWORD_emailSecretHashPepper` | fresh random 32 chars |
| `SERVERPOD_PASSWORD_jwtHmacSha512PrivateKey` | fresh random 44 chars |
| `SERVERPOD_PASSWORD_jwtRefreshTokenHashPepper` | fresh random 32 chars |

(Generate randoms with `openssl rand -base64 32` or any password tool.
Never commit them.)

Deploy. Watch the logs: migrations apply, then
`WebServer listening` / API up. First Docker build takes ~10 min.

## 3. Seed judge accounts (no email needed to log in)

Off-Cloud there is no email sender, so sign-up-by-email cannot deliver
codes. Pre-create the accounts with the seed script against production
from your PC (DB must be reachable — Render Postgres has a public host):

```cmd
set SERVERPOD_DATABASE_HOST=<pg host>
set SERVERPOD_DATABASE_PORT=<pg port>
set SERVERPOD_DATABASE_NAME=<pg db>
set SERVERPOD_DATABASE_USER=<pg user>
set SERVERPOD_DATABASE_REQUIRE_SSL=true
set SERVERPOD_PASSWORD_database=<pg password>
set SERVERPOD_PASSWORD_emailSecretHashPepper=<same as Render>
set SERVERPOD_PASSWORD_jwtHmacSha512PrivateKey=<same as Render>
set SERVERPOD_PASSWORD_jwtRefreshTokenHashPepper=<same as Render>
cd queuelock_server
dart run ../tool/seed_demo.dart --mode production --role maintenance --apply-migrations
```

Judges log in (not sign up) with the printed demo credentials.

## 4. Point the web app at the API + prevent sleep

- The Pages build already bakes `API_URL` in (step 0). After the API is
  live, re-push (or re-run the Web workflow) so the value is current.
- UptimeRobot (free): monitor `https://<service>.onrender.com/` every
  5 min. This keeps the free service awake (750 free hours/month covers
  24/7). Without it, first judge visit waits ~1 min and streams start
  reconnecting — acceptable but worse.

## 5. Verify end to end

- Pages URL loads; staff login (seeded account) works.
- Create queue → join from phone → call → countdown → done.
- `/audit/<slug>` verifies. Receipt checks out.
- Paste both URLs into `docs/SUBMISSION.md`.
