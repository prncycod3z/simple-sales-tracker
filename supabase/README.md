# Supabase

Schema changes live in `migrations/` as numbered SQL files and are the only way the schema should change.

Apply with the Supabase CLI:

```bash
supabase login
supabase link --project-ref YOUR-PROJECT-REF
supabase db push
```

Or paste the file into the Supabase dashboard SQL editor for a first-time setup.

## Must-do tests before relying on RLS
Create two users (A and B) and confirm, using each user's own session (not the service role), that:
1. A cannot select, update or delete B's businesses, products, sales or returns.
2. A cannot insert a product/sale/return pointing at B's `business_id`.
3. A cannot insert a sale whose `product_id` belongs to a different business (composite FK).
4. Changing a product's `default_unit_price` leaves existing `sales.unit_price` / `line_total` unchanged.
5. Archiving a product keeps historical sales readable.
