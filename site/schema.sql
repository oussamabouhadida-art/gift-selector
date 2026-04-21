-- ============================================================
--  Supabase schema — run this in the SQL editor once.
-- ============================================================

create table if not exists public.votes (
  id                uuid primary key default gen_random_uuid(),
  selected_options  text[] not null default '{}',
  suggested_idea    text,
  contributor_name  text,
  created_at        timestamptz not null default now()
);

-- Row Level Security: anyone can insert a vote, anyone can read aggregated
-- rows (no personal data is stored unless the voter typed their name).
alter table public.votes enable row level security;

drop policy if exists "anyone can insert" on public.votes;
create policy "anyone can insert"
  on public.votes for insert
  to anon
  with check (true);

drop policy if exists "anyone can read" on public.votes;
create policy "anyone can read"
  on public.votes for select
  to anon
  using (true);

-- Optional: aggregated view for the admin page
create or replace view public.vote_totals as
select
  unnest(selected_options) as option_id,
  count(*)                 as votes
from public.votes
group by 1
order by 2 desc;
