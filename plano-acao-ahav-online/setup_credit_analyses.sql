create table if not exists public.credit_analyses (
  id bigserial primary key,
  client_id text,
  saved_by text,
  saved_by_name text,
  razao text,
  fantasia text,
  cnpj text,
  score integer,
  risco text,
  decisao text,
  alcada text,
  limite_sugerido numeric,
  prazo_sugerido integer,
  opinion text,
  payload jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.credit_analyses
add column if not exists client_id text;

create index if not exists credit_analyses_saved_by_idx on public.credit_analyses(saved_by);
create unique index if not exists credit_analyses_client_id_uq on public.credit_analyses(client_id) where client_id is not null;
create index if not exists credit_analyses_cnpj_idx on public.credit_analyses(cnpj);
create index if not exists credit_analyses_razao_idx on public.credit_analyses(razao);
create index if not exists credit_analyses_created_at_idx on public.credit_analyses(created_at desc);

alter table public.credit_analyses enable row level security;

drop policy if exists "credit_analyses_select" on public.credit_analyses;
drop policy if exists "credit_analyses_insert" on public.credit_analyses;
drop policy if exists "credit_analyses_update" on public.credit_analyses;
drop policy if exists "credit_analyses_delete" on public.credit_analyses;

create policy "credit_analyses_select"
on public.credit_analyses for select
to anon
using (true);

create policy "credit_analyses_insert"
on public.credit_analyses for insert
to anon
with check (true);

create policy "credit_analyses_update"
on public.credit_analyses for update
to anon
using (true)
with check (true);

create policy "credit_analyses_delete"
on public.credit_analyses for delete
to anon
using (true);
