alter table public.app_users
  add column if not exists gente_empresas text[] not null default '{}';

update public.app_users
set
  permissions = array['gente']::text[],
  gente_empresas = array['REDE EPI']::text[]
where username = 'leandro';

notify pgrst, 'reload schema';

select username, full_name, permissions, gente_empresas
from public.app_users
where username = 'leandro';
