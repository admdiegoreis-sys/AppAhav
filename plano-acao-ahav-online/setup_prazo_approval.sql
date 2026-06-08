alter table public.acoes
  add column if not exists prazo_original date,
  add column if not exists prazo_solicitado date,
  add column if not exists prazo_change_status text not null default 'none',
  add column if not exists prazo_change_requested_by text,
  add column if not exists prazo_change_requested_at timestamptz,
  add column if not exists prazo_change_reason text,
  add column if not exists prazo_change_reviewed_by text,
  add column if not exists prazo_change_reviewed_at timestamptz;

update public.acoes
set prazo_original = prazo
where prazo_original is null
  and prazo is not null;

notify pgrst, 'reload schema';

select
  count(*) filter (where prazo_original is not null) as atividades_com_previsao_original,
  count(*) filter (where prazo_change_status = 'pending') as solicitacoes_pendentes
from public.acoes;
