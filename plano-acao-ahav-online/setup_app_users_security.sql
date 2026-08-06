-- Hardening de segurança para public.app_users
-- Rode este script no SQL Editor do Supabase (projeto do AppAhav) DEPOIS de publicar
-- a versão atualizada do index.html (o app já foi ajustado para não depender mais
-- de ler password_hash/password_plain diretamente nem de gravar password_plain).

-- 1) Remove senha em texto puro já armazenada e para de guardar esse dado
update public.app_users set password_plain = null where password_plain is not null;
alter table public.app_users drop column if exists password_plain;

-- 2) Impede que a anon key leia a coluna password_hash via REST direto
--    (privilégio em nível de coluna — as demais colunas continuam legíveis
--    normalmente pelo app; qualquer select=password_hash feito por fora
--    passa a retornar "permission denied for column password_hash")
revoke select (password_hash) on public.app_users from anon;

-- 3) Função de verificação de login: roda com privilégio do dono (SECURITY DEFINER),
--    então ela consegue comparar o hash internamente sem nunca devolver a coluna
--    password_hash para quem chamou.
create or replace function public.verify_login(p_username text, p_password_hash text)
returns table (
  username text,
  full_name text,
  role text,
  active boolean,
  must_change_password boolean,
  permissions jsonb,
  access jsonb,
  gente_empresas jsonb
)
language sql
security definer
set search_path = public
as $$
  select username, full_name, role, active, must_change_password, permissions, access, gente_empresas
  from public.app_users
  where username = p_username
    and password_hash = p_password_hash
    and active = true;
$$;

grant execute on function public.verify_login(text, text) to anon;

-- Observação: INSERT/UPDATE/DELETE em app_users continuam liberados para a anon key
-- (necessário hoje porque o app não usa Supabase Auth — não há como o banco distinguir
-- "é o painel do admin" de "é qualquer outra pessoa com a mesma chave pública"). Isso
-- é uma limitação estrutural, não desta correção específica: a solução definitiva é
-- migrar para autenticação real do Supabase (Supabase Auth), o que foi deixado como
-- recomendação separada e não foi implementado nesta sessão.
