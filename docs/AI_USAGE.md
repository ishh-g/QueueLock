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
