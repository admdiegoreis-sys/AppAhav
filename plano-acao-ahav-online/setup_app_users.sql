create table if not exists public.app_users (
  id bigserial primary key,
  username text not null unique,
  full_name text,
  role text not null default 'user' check (role in ('admin', 'user')),
  active boolean not null default true,
  must_change_password boolean not null default true,
  password_hash text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.app_users
add column if not exists must_change_password boolean not null default true;

insert into public.app_users (username, full_name, role, active, must_change_password, password_hash)
values (
  'admin',
  'Administrador',
  'admin',
  true,
  false,
  '2ccb642daba2e0364c839d5667a1ae4d2d61e5b66e697ea53c99127aa3129485'
)
on conflict (username) do update set
  full_name = excluded.full_name,
  role = excluded.role,
  active = excluded.active,
  must_change_password = false,
  updated_at = now();

insert into public.app_users (username, full_name, role, active, must_change_password, password_hash)
values
  ('diego', 'Diego Reis', 'user', true, true, '99a1d6ae3aec060889049e878503439a36c6a04f2f336b268377fe8b6eb29336'),
  ('douglas', 'Douglas', 'user', true, true, '99a1d6ae3aec060889049e878503439a36c6a04f2f336b268377fe8b6eb29336'),
  ('flavia', 'Flávia', 'user', true, true, '99a1d6ae3aec060889049e878503439a36c6a04f2f336b268377fe8b6eb29336'),
  ('joao', 'João', 'user', true, true, '99a1d6ae3aec060889049e878503439a36c6a04f2f336b268377fe8b6eb29336'),
  ('gabriel', 'Gabriel', 'user', true, true, '99a1d6ae3aec060889049e878503439a36c6a04f2f336b268377fe8b6eb29336'),
  ('mayara', 'Mayara', 'user', true, true, '99a1d6ae3aec060889049e878503439a36c6a04f2f336b268377fe8b6eb29336'),
  ('analisecredito', 'Análise de Crédito', 'user', true, false, '6e65101a9cd8049a47118fda7194b211d54c5493eb52aa2db1830e862182d06d')
on conflict (username) do update set
  full_name = excluded.full_name,
  role = excluded.role,
  active = excluded.active,
  must_change_password = case
    when excluded.username = 'analisecredito' then false
    when public.app_users.password_hash = excluded.password_hash then true
    else public.app_users.must_change_password
  end,
  updated_at = now();

update public.app_users
set must_change_password = false,
    updated_at = now()
where username = 'admin';

alter table public.app_users enable row level security;

drop policy if exists "app_users_select" on public.app_users;
drop policy if exists "app_users_insert" on public.app_users;
drop policy if exists "app_users_update" on public.app_users;
drop policy if exists "app_users_delete" on public.app_users;

create policy "app_users_select"
on public.app_users for select
to anon
using (true);

create policy "app_users_insert"
on public.app_users for insert
to anon
with check (true);

create policy "app_users_update"
on public.app_users for update
to anon
using (true)
with check (true);

create policy "app_users_delete"
on public.app_users for delete
to anon
using (true);
