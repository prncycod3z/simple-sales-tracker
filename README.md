# Stock & Sales Tracker

A mobile-first web app for recording sales and returned goods and generating **daily** and **monthly** sales reports (copy, TXT, Word). Sales-focused — no opening-stock or stock-on-hand tracking.

**Status:** documentation, database schema and repo scaffolding are in place. The React app is the next step (see below).

## Stack
React + TypeScript (Vite) · Tailwind CSS · Supabase (PostgreSQL, Auth, Row Level Security) · Git + GitHub · static frontend host

## Documentation (`/docs`) — source of truth
| File | Contents |
|------|----------|
| [01-srs.md](docs/01-srs.md) | Requirements (FR-01 … FR-14), reporting rules, acceptance criteria |
| [02-user-flow.md](docs/02-user-flow.md) | Journeys, including the daily and monthly report flows |
| [03-ui-ux-design.md](docs/03-ui-ux-design.md) | Screens, components, daily and monthly report layouts |
| [04-system-design.md](docs/04-system-design.md) | Architecture, data model, RLS, reporting logic |
| [05-tech-stack.md](docs/05-tech-stack.md) | Stack, build order, definition of done |
| [open-questions.md](docs/open-questions.md) | Decisions still needed (currency, decimals, net sales, …) |

The original v1.0 `.docx` files are kept in `docs/source-v1.0-docx/`.

## Reports
- **Daily report** — pick a date (defaults to today, local time). Shows that day's sales, per-product totals, total units, gross sales value, and returns in a separate section.
- **Monthly report** — pick a month. Shows all transactions, per-product totals, overall totals, returns, and a day-by-day breakdown that reconciles with each daily report.
- Both export through the same report data object, so screen, copy, TXT and DOCX always match.

## Getting started

### 1. Database
Create a Supabase project, then apply `supabase/migrations/` (see [supabase/README.md](supabase/README.md)). Run the RLS checks listed there.

### 2. Environment
```bash
cp .env.example .env.local   # fill in the project URL and the public anon key
```
Never commit `.env.local`, and never use the service-role key in the frontend.

### 3. Create the app (first coding step)
Scaffold Vite in a temporary folder, then move it into this repo so the docs, migrations and git history are kept:
```bash
npm create vite@latest app-tmp -- --template react-ts
cp -r app-tmp/. . && rm -rf app-tmp      # don't overwrite README.md / .gitignore if prompted
npm install
npm install @supabase/supabase-js react-router-dom docx
npm install -D tailwindcss @tailwindcss/vite
npm run dev
```
Then follow the build order in [docs/05-tech-stack.md](docs/05-tech-stack.md): shell and routing → auth and businesses → products → sales → returns → **daily report** → monthly report → exports → tests → deploy.

## Working with an AI coding assistant
See [CLAUDE.md](CLAUDE.md) for the rules (small stages, DB-enforced security, no secrets, shared report object).

## Contributing
Work on a branch, open a pull request (a template is provided), and keep schema changes in new migration files.
