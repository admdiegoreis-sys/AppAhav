create table if not exists public.smartmold_state (
  key text primary key,
  state jsonb not null,
  updated_by text,
  updated_at timestamptz not null default now()
);

alter table public.smartmold_state enable row level security;

drop policy if exists "smartmold_state_read_all" on public.smartmold_state;
create policy "smartmold_state_read_all"
on public.smartmold_state
for select
using (true);

drop policy if exists "smartmold_state_insert_all" on public.smartmold_state;
create policy "smartmold_state_insert_all"
on public.smartmold_state
for insert
with check (true);

drop policy if exists "smartmold_state_update_all" on public.smartmold_state;
create policy "smartmold_state_update_all"
on public.smartmold_state
for update
using (true)
with check (true);
