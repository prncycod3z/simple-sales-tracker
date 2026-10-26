# UI/UX Design Specification

_Stock & Sales Tracker — Draft v1.1_

# 1. Design direction

Create a clean, trustworthy, modern business utility. Prioritize speed, clarity, legible numbers, and comfortable one-handed mobile use. Use a restrained blue/teal accent, neutral surfaces, clear typography, and consistent spacing. Avoid visual clutter and oversized dashboards that hide the Record Sale action.

# 2. Responsive behavior

- Design phone layouts first, then adapt to tablet and desktop.
- Use full-width form fields on small screens and larger touch targets.
- Use cards or stacked rows for transaction lists on phones; use tables on wider screens where they improve scanning.
- Keep important totals visible without requiring horizontal scrolling.
- Forms must work with the mobile keyboard and use suitable input types for dates, numbers, and currency.
- Support loading, empty, success, validation-error, and network-error states.

# 3. Core screens

| Screen                              | Requirements                                                                                                                                               |
|-------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Sign in / Register                  | Email and password or the selected Supabase-supported auth method; clear errors; link between sign-in and registration.                                    |
| Business selector / Create Business | List the user's businesses; prominent Create Business action; simple business-name form.                                                                   |
| Dashboard                           | Selected business, today's and current-month units sold and sales value, quick actions for Record Sale, Products, Returns and Reports; avoid implying a stock balance. |
| Product list                        | Searchable list with product name, default price, and optionally accumulated units sold; Add Product action.                                               |
| Add/Edit Product                    | Required product name and default selling price; validation; archive option rather than destructive deletion when history exists.                          |
| Record Sale                         | Product selector with search, Add Product shortcut, quantity, date, optional time, unit price snapshot, calculated total, Save Sale action.                |
| Sales History                       | Filter by date/month and product; show date, product, quantity, unit price and line total; open transaction details.                                       |
| Record Return                       | Product, quantity, date, optional reason and condition; optional link to original sale; clear Return action.                                               |
| Reports                             | Daily / Monthly toggle. Daily: date picker with previous/next-day buttons (default today). Monthly: month/year selector. Report preview, per-product summaries, overall units/value, separate returns summary, Copy Text, Download TXT, Export Word.           |
| Account                             | Registered display name, account details supported by auth setup, and sign out.                                                                            |

# 4. Reusable UI components

- App shell and responsive navigation
- Primary and secondary buttons
- Labeled text, number, date and optional time fields
- Searchable product selector
- Product and transaction cards
- Summary metric cards
- Month/year selector and day selector with previous/next controls
- Empty-state panel
- Inline validation message and toast/confirmation
- Export action group (shared by daily and monthly reports)

# 5. Interaction rules

- Use explicit button labels such as Save Sale, Record Return, Generate Report and Download TXT.
- Display a calculated total before a sale is submitted.
- Disable submission while a request is in progress to reduce accidental duplicate records.
- Ask for confirmation before destructive or irreversible actions.
- Do not silently change a sale's historical price when the product's default price changes.
- Clearly distinguish units, unit price, sales value, returned units and returned value.
- Do not display an estimated stock balance unless reliable stock-in data is implemented.

# 6. Accessibility and content

- Every field has a persistent visible label; placeholders are not labels.
- Ensure readable contrast and visible keyboard focus.
- Use descriptive errors next to the field that needs attention.
- Format dates consistently and display currency explicitly.
- Avoid ambiguous terms: use 'Units sold' and 'Sales value' rather than a generic 'Stock' figure where appropriate.

# 7. Report layout

## 7.1 Daily report

Heading: business name, report date (with weekday), employee/account name, and generated date/time. Detail: time (if recorded, otherwise "—"), product, units, unit price, line total. Summary: per-product units and value, overall units and gross sales value. Returns: returned units and value in a separate section. Zero-activity days show "No sales recorded for this date." with zero totals.

## 7.2 Monthly report

Report heading: business name, selected month/year, employee/account name, and generated date. Main detail: date, product, units, unit price, and line total. Day-by-day summary: date, number of transactions, units, gross sales value (show or omit zero-sales days; choose one and apply consistently). Summary: per-product units and value, overall units and gross sales value. Returns: returned units and value in a separate section. If net value is included, define its calculation and label it explicitly.
