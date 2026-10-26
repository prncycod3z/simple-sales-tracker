# Technology Stack & Implementation Notes

_Stock & Sales Tracker — Draft v1.1_

# 1. Selected stack

| Layer            | Technology                                                    | Reason / usage                                                                                           |
|------------------|---------------------------------------------------------------|----------------------------------------------------------------------------------------------------------|
| Frontend         | React + TypeScript                                            | Component-based responsive UI and type safety.                                                           |
| Build tooling    | Vite                                                          | Fast local development and production build.                                                             |
| Styling          | Tailwind CSS (recommended)                                    | Responsive utility styling and consistent spacing; use a small design system rather than one-off styles. |
| UI primitives    | Accessible component library or lightweight custom components | Choose one approach at setup; avoid mixing multiple component libraries unnecessarily.                   |
| Backend platform | Supabase                                                      | Managed PostgreSQL, Auth, and Row Level Security.                                                        |
| Database         | Supabase PostgreSQL                                           | Relational data for businesses, products, sales, and returns.                                            |
| Exports          | Browser text generation + DOCX generation library             | Copyable text, TXT download, and Word DOCX export.                                                       |
| Version control  | Git + GitHub                                                  | Branches/commits, issue tracking if useful, and repository history.                                      |
| Hosting          | Static frontend host compatible with Vite                     | Deploy the built frontend; Supabase hosts the backend services.                                          |

# 2. Important clarification

Supabase is not the frontend framework. React renders the interface. Supabase provides backend services such as authentication and database access.

# 3. MVP development order

1. Create the GitHub repository and initialize React + TypeScript with Vite.
2. Set up styling, routing, responsive app shell, and reusable form components.
3. Create the Supabase project and configure environment variables.
4. Implement database migrations, foreign keys, constraints, and Row Level Security policies.
5. Implement authentication and business creation.
6. Implement product management.
7. Implement sale entry, sales history, price snapshots, and totals.
8. Implement return entry and separate return summaries.
9. Implement daily report calculation and preview, then monthly report calculation (with day-by-day breakdown) and preview.
10. Implement copy text, TXT export, and DOCX export for both daily and monthly reports.
11. Test responsive layouts, validation, data isolation, date boundaries (month ends and the local-date "today"), price changes, and daily/monthly report calculations.
12. Write README setup instructions and deploy.

# 4. Vibe-coding rules

- Build in small, verifiable stages instead of asking an AI to generate the entire app at once.
- Keep the project documents in the repository under /docs and ask the coding assistant to treat them as the source of truth.
- After each feature, run the app, inspect the diff, and test the main happy path plus edge cases.
- Do not accept a UI-only implementation for authentication, ownership, or RLS requirements.
- Never commit service-role keys, passwords, or production secrets.
- Use database migrations for schema changes so setup can be reproduced.
- Require the coding assistant to explain important files and decisions so the project remains maintainable.

# 5. Definition of done

- The user can register, create a business, and add products.
- Sales and returns are saved persistently and associated with the correct business and user.
- Daily and monthly reports display correct units and monetary totals, and daily totals sum to the monthly totals.
- Copy, TXT and DOCX outputs match the report preview.
- RLS prevents cross-user access.
- Core workflows work on phone and desktop widths.
- Repository contains setup instructions and no committed secrets.
