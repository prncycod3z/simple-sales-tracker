# User Journeys & Application Flow

_Stock & Sales Tracker — Draft v1.1_

# 1. Primary navigation

- Authentication: Sign in / Register
- Main app: Business selector and dashboard
- Products: Product list, add product, edit product
- Sales: Record sale, sales history, transaction details
- Returns: Record return, return history
- Reports: Choose Daily or Monthly, select date or month, preview report, copy/export
- Account: Registered name and sign out

# 2. First-time user journey

1. Open the application and register with the required account details.
2. Confirm or complete sign-in.
3. Create a business by entering its name.
4. Add the first product with a name and default selling price.
5. Choose Record Sale and select the product.
6. Enter quantity and sale date; optionally enter time. Confirm the unit price used for this transaction.
7. Save the sale and show a clear success state with quantity and total value.
8. Open Reports, select a month, and review the generated totals.

# 3. Returning user journey: record a sale

1. Open the app; if multiple businesses exist, select the relevant business.
2. Tap the prominent Record Sale action.
3. Search/select an existing product, or use Add Product if it does not exist.
4. Enter quantity and date; time is optional and may default to current time only if the user chooses to include it.
5. Show the price and calculated line total before saving.
6. Validate the form and save.
7. Show confirmation and provide a route to record another sale or view history.

# 4. Return journey

1. Open Returns and choose Record Return.
2. Select the product and enter the quantity returned, return date, and optional reason/condition.
3. If the return relates to a known sale, allow the user to link it to that sale where practical.
4. Review and save the return.
5. Show the return in history and keep it separate from the original sale.

# 5. Daily report journey

1. Open Reports and choose the Daily tab (also reachable from a "Today's report" shortcut on the dashboard).
2. The date defaults to today; change it with the date picker or previous/next-day buttons.
3. Show that day's transactions, per-product totals, total units, gross sales value and a separate returns section.
4. Choose Copy Text, Download TXT, or Export Word.
5. Show feedback when the copy/export action succeeds or fails.

# 6. Monthly report journey

1. Open Reports.
2. Choose a month and year; default to the current month for convenience.
3. Generate the report and show product-level and overall totals, plus the day-by-day breakdown. Selecting a day in the breakdown opens that day's daily report.
4. Choose Copy Text, Download TXT, or Export Word.
5. Show feedback when the copy/export action succeeds or fails.

# 7. Important edge cases

- No business yet: show a create-business call to action.
- No products: prompt the user to add a product before recording a sale.
- New product during sale entry: let the user add it without losing the sale form where feasible.
- Invalid quantity, missing date, or invalid price: show inline validation and prevent saving.
- No sales for selected day or month: show a zero-activity report rather than an error.
- Day with returns but no sales: show the returns section and zero sales totals.
- Future date selected in the daily report: allow it and show a zero-activity report.
- Month with returns but no sales: show the returns section and zero sales totals.
- Network/database error: preserve entered form data where feasible and explain that the record was not saved.
- Archived product: keep historical sales readable but prevent accidental new selection unless deliberately re-enabled.

# 8. Navigation principle

Optimize for the most frequent task: recording a sale. On mobile, use a compact navigation pattern and a clearly visible primary action. Avoid deep menus and avoid making users enter opening stock or received-stock quantities.
