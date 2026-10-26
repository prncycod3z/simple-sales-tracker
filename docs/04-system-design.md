# System Design & Data Model

_Stock & Sales Tracker — Draft v1.1_

# 1. Architecture

React + TypeScript frontend built with Vite. Supabase provides PostgreSQL, authentication, and Row Level Security. The frontend accesses Supabase through its supported client library. GitHub stores source code and change history. No custom backend server is required for the initial CRUD/reporting scope unless a later requirement needs server-side processing.

# 2. Data model

| Table      | Suggested fields                                                                                                                                                                   | Notes                                                                                                                                |
|------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|
| profiles   | id (same UUID as auth user), display_name, created_at                                                                                                                              | One profile per authenticated user; display_name is the employee name shown in reports.                                              |
| businesses | id, owner_user_id, name, created_at, updated_at                                                                                                                                    | Owned by one user in MVP; future membership table can support shared businesses.                                                     |
| products   | id, business_id, name, default_unit_price, is_archived, created_at, updated_at                                                                                                     | Product belongs to a business. Do not delete products with historical transactions; archive them.                                    |
| sales      | id, business_id, product_id, user_id, quantity, sold_on, sold_time nullable, unit_price, line_total, created_at, updated_at                                                        | Each sale is a transaction. Store the unit price used and a consistent numeric representation for money.                             |
| returns    | id, business_id, product_id, user_id, related_sale_id nullable, quantity, returned_on, reason nullable, condition nullable, unit_price nullable, return_total nullable, created_at | Separate from sales; may optionally link to the original sale. Define whether return value is recorded from the original sale price. |

# 3. Relationships

- auth.users 1:1 profiles.
- profiles/auth user 1:N businesses.
- businesses 1:N products.
- businesses 1:N sales and returns.
- products 1:N sales and returns.
- auth user 1:N sales and returns as recorder.
- sales 1:N returns is optional through returns.related_sale_id.

# 4. Data integrity

- Use UUID primary keys and foreign keys.
- Quantity must be an integer greater than zero if only whole units are supported. If fractional units are needed, use a suitable numeric type instead.
- Prices should use numeric/decimal columns, not floating-point types, for currency accuracy.
- Calculate line_total from quantity × unit_price; enforce consistency in the application and, where practical, database logic.
- Record a sale's date separately from created_at.
- Use a transaction-level price snapshot so later product price changes do not rewrite history.
- Use created_at timestamps and explicit ownership columns.
- Decide whether sales may be edited/deleted; if allowed, show confirmation and preserve auditability.

# 5. Security and Row Level Security

- Enable RLS on every table containing user or business data.
- Policies must verify ownership through businesses.owner_user_id and the signed-in auth.uid().
- For products, sales and returns, policies must verify the linked business belongs to the authenticated user.
- Never expose the Supabase service-role key in frontend code; use only the public anon/publishable key in the client.
- Validate inputs in the UI and enforce important constraints in the database as well.
- Test that User A cannot read, update, or delete User B's businesses, products, sales, or returns.

# 6. Reporting logic

## 6.1 Daily report

Select sales where `sold_on` equals the selected date and returns where `returned_on` equals the selected date, scoped to the selected business. Order sales by `sold_time` (nulls last), then `created_at`. Group by product for units and value. Overall units = sum of quantities; gross sales value = sum of stored `line_total`. Returns are aggregated separately and never subtracted from sales unless a net metric is explicitly defined.

Date handling: `sold_on` is a SQL `date` with no time zone. The "today" default is the user's local date in the browser (not UTC), so a late-evening sale in Zambia (CAT, UTC+2) is not reported on the wrong day.

## 6.2 Monthly report

- Select records by sold_on within the selected calendar month, using inclusive start and exclusive start of the next month for robust filtering.
- Group sales by product for units sold and sales value, and by `sold_on` for the day-by-day breakdown (transactions, units, value). Each day row must equal the daily report for that date.
- Overall units = sum of sale quantities for the month.
- Gross sales value = sum of stored sale line totals for the month.
- Returns are aggregated separately by returned_on for the selected month.
- Do not subtract returns from sales unless the report explicitly includes a defined net-sales metric. If returns are deducted, define whether the return is attributed to the return month or original sale month.
- Daily and monthly reports are built by pure functions (`buildDailyReport`, `buildMonthlyReport`) sharing the same aggregation helpers.
- TXT and DOCX exports must use the same report data object as the on-screen preview to prevent mismatched calculations.

# 7. Suggested frontend structure

- src/app/ — routing and application shell
- src/components/ — shared UI components
- src/features/auth/ — registration and sign-in
- src/features/businesses/ — business selection and setup
- src/features/products/ — product CRUD
- src/features/sales/ — sale entry and history
- src/features/returns/ — return entry and history
- src/features/reports/ — daily and monthly report calculation, preview and export
- src/lib/supabase.ts — Supabase client
- src/types/ — shared TypeScript types
- supabase/migrations/ — versioned database schema and policies

# 8. Deployment and configuration

- Keep local secrets in .env.local and exclude them from Git.
- Commit an .env.example containing variable names but no real secrets.
- Use GitHub for source control and choose a static frontend host compatible with Vite; Supabase remains the managed backend.
- Document local setup, environment variables, database migration steps, and deployment steps in README.md.
