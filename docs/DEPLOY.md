# Deploy (M6)

Primary plan: **Render (API + Postgres) + GitHub Pages (web app)** —
$0, full functionality including future calls. See `docs/RENDER.md`
for the exact runbook. Serverpod Cloud's Starter trial disables future
calls, so Cloud would need the paid Growth plan; it stays the fallback
if hosting money appears.

## One-time setup (do this now)

1. Create the account: https://console.serverpod.dev/ (free trial).
2. Commit everything and check CI is green on `main`.
3. From the repo root:
   ```sh
   serverpod cloud launch
   ```
   This installs the Cloud CLI if needed, signs you in via the browser,
   opens the Cloud Console to create the project (take the managed
   Postgres), copies the needed passwords from
   `queuelock_server/config/passwords.yaml`, and deploys.
4. If it asks about secrets: no custom secrets needed. Auth emails go
   through Serverpod Cloud's email service automatically; DB/storage
   are provisioned.

## Verify the deploy

- Open the hosted web URL (shown by launch / console).
- Sign up with a real email (the code arrives by real email now).
- Create queue → add counter → join from `/q/<slug>` on your phone →
  Call next → audit verifies.
- Paste the hosted link into `docs/SUBMISSION.md`.

## Later deploys

```sh
serverpod cloud deploy            # redeploy after changes
scloud deployment show            # follow progress (alias: serverpod cloud ...)
```

Migrations apply automatically on each deploy.

## If launch misbehaves

- `docs`: https://docs.serverpod.dev/cloud, including "Recover from a
  failed deploy".
- Self-host fallback exists (`queuelock_server/Dockerfile`, build from
  repo root: `docker build -f queuelock_server/Dockerfile .`), but Cloud
  is the plan.
