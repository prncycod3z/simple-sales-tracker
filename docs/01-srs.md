# Software Requirements Specification

_Stock & Sales Tracker — Draft v1.1_

# 1. Purpose

Define the requirements for a mobile-first web application that helps employees maintain product lists, record sales and returned goods, and generate daily and monthly sales reports. The system is sales-focused and does not require employees to know opening stock or received-stock quantities.

# 2. Product scope

- An employee registers and signs in using an individual account.
- An employee can create one or more businesses and manage products within each business.
- Employees record sales with product, quantity, date, optional time, unit price and calculated line total.
- Employees record customer returns, including quantity, date, reason/condition where available.
- The system calculates totals from recorded transactions and generates a report for a selected day or a selected calendar month.
- Reports can be copied as plain text or exported as TXT and Word DOCX files.
- The interface is responsive, optimized for phone use, and remains usable on tablets and desktop computers.

# 3. Users and permissions

The only user role in the initial release is Employee/Account Owner. There are no manager dashboards or separate manager permissions. Each signed-in user must only access businesses and records they are authorized to access. If multiple employees need to share a business later, shared membership and roles can be added as a future feature; do not assume shared access in the MVP.

# 4. Functional requirements

| ID                                | Requirement                                                                                                                                                                                                           |
|-----------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| FR-01 Authentication              | Users can register, sign in, sign out, and access only their own authorized data.                                                                                                                                     |
| FR-02 Business management         | A user can create, view, edit, and select a business. Business name is required.                                                                                                                                      |
| FR-03 Product management          | Within a business, a user can add, view, edit, archive, and search products. Each product has a name and a default selling price. Product names should be unique within a business where practical.                   |
| FR-04 Sale entry                  | A user can record a sale by selecting a product, entering a positive quantity, selecting a sale date, optionally entering a time, and confirming the unit price. The line total is quantity multiplied by unit price. |
| FR-05 Historical price            | Each sale stores a snapshot of the unit price used at the time of the sale. Later product-price edits must not alter existing sales.                                                                                  |
| FR-06 Sale history                | Users can view and filter their business's sales by date range and product, and inspect transaction details.                                                                                                          |
| FR-07 Returns                     | A user can record a return against a product, including quantity, date, and optional reason/condition. Returns are recorded separately from sales and do not silently erase the original sale.                        |
| FR-08 Calculations                | The system calculates units sold and gross recorded sales value. It separately totals returned units and return value. Any net figure must be clearly labelled and calculated using an explicitly documented rule.    |
| FR-09 Monthly report              | A user can select a calendar month and view transaction dates, employee/account name, product-level units, unit price, line totals, totals per product, total units, and total sales value.                           |
| FR-10 Export/copy                 | Daily and monthly reports can each be copied as plain text, downloaded as .txt, or exported as a .docx document. Exported figures must match the on-screen report.                                                                |
| FR-11 Empty states and validation | The UI explains when no businesses, products, sales, or transactions exist and validates required fields with readable messages.                                                                                      |
| FR-12 Auditability                | Recorded transactions retain creation timestamps and the associated user/business identifiers. Editing or deleting transactions must not occur accidentally.                                                          |
| FR-13 Daily report | A user can select a single calendar date (default: today) and view that day's transactions: time (where recorded), product, units, unit price and line total, plus per-product totals, total units, gross sales value and a separate returns section. A day with no activity shows a zero-activity report, not an error. |
| FR-14 Daily breakdown in monthly report | The monthly report includes a day-by-day summary (date, transactions, units, gross sales value) so each daily total can be reconciled with the daily report for that date. |

# 5. Reporting rules

- Reports use the date selected for the sale, not merely the database creation timestamp.
- A daily report covers exactly one calendar date: records whose `sold_on` (or `returned_on` for returns) equals the selected date. Daily totals for a date must equal that date's row in the monthly day-by-day breakdown.
- Month boundaries are inclusive: from the first day of the selected month through the final day of that month.
- The report identifies the selected month and business.
- Product summaries show total units and total recorded sales value for each product.
- Overall totals show total units across products and total recorded sales value.
- Returned goods are displayed separately from sales. Do not label gross sales as net sales.
- If unit prices vary across transactions, calculate value from each transaction's stored unit price before aggregating.
- Currency should be configurable or clearly identified; initial display may use Zambian kwacha (ZMW/K) if confirmed by the project owner.

# 6. Non-functional requirements

- Responsive: mobile-first layout that adapts to phone, tablet and desktop widths.
- Usability: a common sale should be recordable with a short, clear form and minimal navigation.
- Security: enable Supabase Row Level Security on all user-owned tables; never rely on client-side filtering alone.
- Data integrity: quantities must be positive; prices must be non-negative; required relationships must be valid.
- Reliability: use database constraints and consistent transaction handling where applicable.
- Accessibility: visible labels, keyboard focus states, sufficient contrast, and controls with usable touch targets.
- Maintainability: modular React components, typed data models, environment variables for configuration, and clear setup instructions.
- Privacy: collect only data required for account access, product management, transactions, and reporting.

# 7. Out of scope for MVP

- Commission calculation or payroll.
- Mandatory opening stock, stock receiving, supplier management, or accurate stock-on-hand calculation.
- Yearly reports and custom date-range reports (daily and monthly reports are in scope).
- Manager roles, multi-user team permissions, and business-wide shared access.
- Payment processing, invoicing, tax calculation, and accounting integrations.

# 8. Acceptance criteria

- A newly registered user can create a business and add a product.
- The user can record a dated sale and see its quantity and value reflected in sales history.
- Changing a product's default price does not change the value of past sales.
- A return can be recorded and appears separately in the relevant report.
- Selecting a month produces correct product and overall totals for that month only.
- A user can select a date and get a daily report with that day's transactions and totals only; a day with no activity shows zeros.
- The sum of daily totals in a month equals the monthly totals.
- Copy, TXT and DOCX exports (daily and monthly) contain the same figures as the on-screen report.
- A user cannot read or modify another user's private data by changing client-side identifiers or URLs.
- Core screens work on common mobile and desktop viewport sizes.
