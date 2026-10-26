-- Stock & Sales Tracker — initial schema, constraints and Row Level Security.
-- Implements docs/04-system-design.md. Assumptions (see docs/open-questions.md):
--   * whole-unit quantities, single owner per business, owner may edit/delete.

-- ---------------------------------------------------------------- helpers
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- ---------------------------------------------------------------- profiles
create table public.profiles (
  id           uuid primary key references auth.users (id) on delete cascade,
  display_name text not null check (length(btrim(display_name)) > 0),
  created_at   timestamptz not null default now()
);

-- Create a profile automatically when a user registers.
-- Pass display_name in sign-up options.data; falls back to the email prefix.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id, display_name)
  values (
    new.id,
    coalesce(
      nullif(btrim(new.raw_user_meta_data ->> 'display_name'), ''),
      nullif(split_part(coalesce(new.email, ''), '@', 1), ''),
      'User'
    )
  );
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- -------------------------------------------------------------- businesses
create table public.businesses (
  id            uuid primary key default gen_random_uuid(),
  owner_user_id uuid not null default auth.uid() references auth.users (id) on delete restrict,
  name          text not null check (length(btrim(name)) > 0),
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);
create index businesses_owner_idx on public.businesses (owner_user_id);
create trigger businesses_updated_at before update on public.businesses
  for each row execute function public.set_updated_at();

-- ---------------------------------------------------------------- products
create table public.products (
  id                 uuid primary key default gen_random_uuid(),
  business_id        uuid not null references public.businesses (id) on delete restrict,
  name               text not null check (length(btrim(name)) > 0),
  default_unit_price numeric(12, 2) not null check (default_unit_price >= 0),
  is_archived        boolean not null default false,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now(),
  -- lets sales/returns prove a product belongs to the same business
  unique (id, business_id)
);
-- Product names unique within a business (case-insensitive) among active products.
create unique index products_business_name_active_uq
  on public.products (business_id, lower(btrim(name))) where not is_archived;
create trigger products_updated_at before update on public.products
  for each row execute function public.set_updated_at();

-- ------------------------------------------------------------------- sales
create table public.sales (
  id          uuid primary key default gen_random_uuid(),
  business_id uuid not null,
  product_id  uuid not null,
  user_id     uuid not null default auth.uid() references auth.users (id) on delete restrict,
  quantity    integer not null check (quantity > 0),
  sold_on     date not null,                       -- the date the user selected (report date)
  sold_time   time,                                -- optional
  unit_price  numeric(12, 2) not null check (unit_price >= 0),   -- price snapshot
  line_total  numeric(14, 2) generated always as (quantity * unit_price) stored,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now(),
  foreign key (product_id, business_id) references public.products (id, business_id) on delete restrict,
  unique (id, business_id)
);
-- Serves both daily (sold_on = d) and monthly (sold_on >= start and < next month) reports.
create index sales_business_sold_on_idx on public.sales (business_id, sold_on);
create index sales_product_idx on public.sales (product_id);
create trigger sales_updated_at before update on public.sales
  for each row execute function public.set_updated_at();

-- ----------------------------------------------------------------- returns
create table public.returns (
  id              uuid primary key default gen_random_uuid(),
  business_id     uuid not null,
  product_id      uuid not null,
  user_id         uuid not null default auth.uid() references auth.users (id) on delete restrict,
  related_sale_id uuid,                            -- optional link to the original sale
  quantity        integer not null check (quantity > 0),
  returned_on     date not null,
  reason          text,
  condition       text,
  unit_price      numeric(12, 2) check (unit_price >= 0),
  return_total    numeric(14, 2) generated always as (quantity * unit_price) stored, -- null when unit_price is null
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),
  foreign key (product_id, business_id) references public.products (id, business_id) on delete restrict,
  -- MATCH SIMPLE: not enforced when related_sale_id is null
  foreign key (related_sale_id, business_id) references public.sales (id, business_id) on delete restrict
);
create index returns_business_returned_on_idx on public.returns (business_id, returned_on);
create index returns_product_idx on public.returns (product_id);
create trigger returns_updated_at before update on public.returns
  for each row execute function public.set_updated_at();

-- ------------------------------------------------------- row level security
alter table public.profiles   enable row level security;
alter table public.businesses enable row level security;
alter table public.products   enable row level security;
alter table public.sales      enable row level security;
alter table public.returns    enable row level security;

-- profiles: a user can read and update only their own profile (insert is done by the trigger).
create policy profiles_select_own on public.profiles
  for select to authenticated using (id = (select auth.uid()));
create policy profiles_update_own on public.profiles
  for update to authenticated
  using (id = (select auth.uid())) with check (id = (select auth.uid()));

-- businesses: owner only.
create policy businesses_select_own on public.businesses
  for select to authenticated using (owner_user_id = (select auth.uid()));
create policy businesses_insert_own on public.businesses
  for insert to authenticated with check (owner_user_id = (select auth.uid()));
create policy businesses_update_own on public.businesses
  for update to authenticated
  using (owner_user_id = (select auth.uid())) with check (owner_user_id = (select auth.uid()));
-- No delete policy in the MVP: businesses are not deletable from the client.

-- products / sales / returns: allowed only when the linked business belongs to the caller.
create policy products_select_own on public.products
  for select to authenticated using (
    exists (select 1 from public.businesses b
            where b.id = products.business_id and b.owner_user_id = (select auth.uid())));
create policy products_insert_own on public.products
  for insert to authenticated with check (
    exists (select 1 from public.businesses b
            where b.id = products.business_id and b.owner_user_id = (select auth.uid())));
create policy products_update_own on public.products
  for update to authenticated
  using (exists (select 1 from public.businesses b
                 where b.id = products.business_id and b.owner_user_id = (select auth.uid())))
  with check (exists (select 1 from public.businesses b
                      where b.id = products.business_id and b.owner_user_id = (select auth.uid())));
-- No delete policy on products: archive instead (is_archived).

create policy sales_select_own on public.sales
  for select to authenticated using (
    exists (select 1 from public.businesses b
            where b.id = sales.business_id and b.owner_user_id = (select auth.uid())));
create policy sales_insert_own on public.sales
  for insert to authenticated with check (
    user_id = (select auth.uid())
    and exists (select 1 from public.businesses b
                where b.id = sales.business_id and b.owner_user_id = (select auth.uid())));
create policy sales_update_own on public.sales
  for update to authenticated
  using (exists (select 1 from public.businesses b
                 where b.id = sales.business_id and b.owner_user_id = (select auth.uid())))
  with check (user_id = (select auth.uid())
              and exists (select 1 from public.businesses b
                          where b.id = sales.business_id and b.owner_user_id = (select auth.uid())));
create policy sales_delete_own on public.sales
  for delete to authenticated using (
    exists (select 1 from public.businesses b
            where b.id = sales.business_id and b.owner_user_id = (select auth.uid())));

create policy returns_select_own on public.returns
  for select to authenticated using (
    exists (select 1 from public.businesses b
            where b.id = returns.business_id and b.owner_user_id = (select auth.uid())));
create policy returns_insert_own on public.returns
  for insert to authenticated with check (
    user_id = (select auth.uid())
    and exists (select 1 from public.businesses b
                where b.id = returns.business_id and b.owner_user_id = (select auth.uid())));
create policy returns_update_own on public.returns
  for update to authenticated
  using (exists (select 1 from public.businesses b
                 where b.id = returns.business_id and b.owner_user_id = (select auth.uid())))
  with check (user_id = (select auth.uid())
              and exists (select 1 from public.businesses b
                          where b.id = returns.business_id and b.owner_user_id = (select auth.uid())));
create policy returns_delete_own on public.returns
  for delete to authenticated using (
    exists (select 1 from public.businesses b
            where b.id = returns.business_id and b.owner_user_id = (select auth.uid())));
