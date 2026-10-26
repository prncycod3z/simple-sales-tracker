# Instructions for AI coding assistants

Source of truth: the documents in `/docs` (`01-srs.md` … `05-tech-stack.md`). Read the relevant one before implementing a feature. If code and docs disagree, ask — do not silently pick one. Open decisions are listed in `docs/open-questions.md`.

## Rules
- Build in small, verifiable stages (see the MVP order in `docs/05-tech-stack.md`). One feature per change.
- Authentication, ownership and RLS must be enforced in the database, never only in the UI.
- Schema changes go in a new numbered file under `supabase/migrations/`. Never edit an applied migration.
- Never commit secrets. Only the public anon/publishable key may be used in the client.
- Money uses `numeric` in the database and is handled as exact decimals (not floats) in code.
- Reports: daily and monthly reports are built by pure functions from one report data object; on-screen preview, copy, TXT and DOCX must all render from that same object. Returns are shown separately and never subtracted from sales unless a net metric is explicitly defined.
- "Today" is the user's local date, not UTC.
- Use the labels "Units sold" and "Sales value". Never show a stock balance.
- After each feature: run the app, inspect the diff, test the happy path and edge cases, and explain important files and decisions.
