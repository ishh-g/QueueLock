# Pilot runbook (M6)

One real-world trial at a small local venue, with the venue's permission.
Use real service times. Goal: prove the app survives contact with reality,
and feed the demo video.

## Before (day before)

- [ ] App deployed to the hosted link and loading on your phone.
- [ ] Pick the venue: small clinic, salon or shop with a real queue.
      Ask the owner/staff for permission; explain: customers scan a QR,
      join with a nickname, no app install, no personal data kept.
- [ ] Decide the counter setup (1–2 counters) and who taps the buttons.
- [ ] Create the venue queue from your staff account. Set a timeout that
      fits the venue (default 180 s; ~20 s only for the filmed demo bit).
- [ ] Print or display the QR join link (`/q/<slug>`) where customers
      can scan it. The dashboard shows the QR.
- [ ] Charge the staff phone + a customer phone. Same Wi-Fi or mobile
      data both fine (hosted build, not LAN).

## During (30–60 min)

- [ ] Customers join with nicknames. Do NOT invent data: every ticket,
      sample and ledger entry must come from real joins and real service.
- [ ] Staff run the counter normally: Call next → Start → Done.
- [ ] Let at least one timeout happen naturally if the pace allows
      (shows the countdown + re-entry for the video).
- [ ] Complete at least ~5 services so the ETA has real samples
      ("based on N recent services" appears).
- [ ] Note anything confusing, slow or broken with timestamps.

## After

- [ ] Open `/audit/<slug>` on the venue queue: record entry count and
      verified status for the submission.
- [ ] Write 5 lines in `docs/SUBMISSION.md` (Pilot → Outcome): venue
      type, tickets served, what worked, what broke, owner quote if any.
- [ ] Keep one customer receipt and check it on the audit page on camera
      (nice 10-second demo-video beat).
- [ ] File bugs found as follow-ups; do not hot-fix during the pilot.
