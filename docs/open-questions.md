# Open questions / decisions needed

Carried over from the v1.0 pack, plus items raised while adding daily reports. Resolve each before the related feature is built.

| # | Decision | Default used for now | Affects |
|---|----------|----------------------|---------|
| 1 | Currency: is Zambian kwacha (ZMW / K) the default? | Display ZMW, keep currency in one config constant | Reports, UI |
| 2 | Quantity: whole units only, or decimals (kg, litres)? | Whole units (`integer`) | `sales`, `returns` |
| 3 | Shared business access for several employees | Single owner per business (MVP) | RLS, `businesses` |
| 4 | Net sales (sales minus returns): needed? If so, are returns attributed to return month or original sale month? | Not shown; gross sales and returns shown separately | Reports |
| 5 | Can sales/returns be edited or deleted? | Owner may edit/delete (UI must confirm); `updated_at` is tracked. For stricter audit, remove the update/delete policies and use reversing entries | FR-12, RLS |
| 6 | Return value: priced from the original sale, or entered manually? | Optional `unit_price` on the return | `returns` |
| 7 | Daily report: should the employee name be the account's display name only? | Yes | Reports |
| 8 | Monthly day-by-day breakdown: show zero-sales days or omit them? | Omit zero days (decide and keep consistent) | Monthly report |
| 9 | Hosting target for the static frontend (Vercel, Netlify, Cloudflare Pages, …) | Undecided | Deployment |
