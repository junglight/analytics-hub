-- ============================================================
-- n8n POC — Supabase setup
-- ============================================================

-- ---------- 1. Metrics table ----------
-- Create the table BEFORE importing the CSV. If you import first,
-- Supabase types every column as text and the workflows fail with
-- "operator does not exist: text - integer".

DROP TABLE IF EXISTS public.cs_contacts;

CREATE TABLE public.cs_contacts (
  cs_week_beg_dt      date,
  country             text,
  channel_type        text,
  l1_topic            text,
  sr_cnt              bigint,
  csat_sum            bigint,
  csat_response_cnt   bigint,
  rsltn_cnt           bigint,
  rsltn_response_cnt  bigint
);

CREATE INDEX idx_cs_contacts_week ON public.cs_contacts (cs_week_beg_dt);

-- Then import cs_contacts.csv via Table Editor -> Import data from CSV.
-- Verify:
--   SELECT MIN(cs_week_beg_dt), MAX(cs_week_beg_dt), COUNT(*) FROM public.cs_contacts;
--   -> 2026-02-02 | 2026-08-03 | 1458


-- ---------- 2. Vector search function ----------
-- REQUIRED. The Supabase Vector Store node can INSERT without this,
-- which is why loading the .md files worked, but RETRIEVAL calls this
-- function. Missing it produces:
--   PGRST202 Could not find the function public.match_documents(...)

CREATE EXTENSION IF NOT EXISTS vector;

CREATE OR REPLACE FUNCTION public.match_documents (
  query_embedding vector(1536),
  match_count     int    DEFAULT NULL,
  filter          jsonb  DEFAULT '{}'
) RETURNS TABLE (
  id         bigint,
  content    text,
  metadata   jsonb,
  similarity float
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT
    d.id,
    d.content,
    d.metadata,
    1 - (d.embedding <=> query_embedding) AS similarity
  FROM public.documents d
  WHERE d.metadata @> filter
  ORDER BY d.embedding <=> query_embedding
  LIMIT match_count;
END;
$$;

-- Confirm it registered:
--   SELECT routine_name FROM information_schema.routines
--   WHERE routine_schema = 'public' AND routine_name LIKE 'match_%';

-- If PGRST202 persists after creating it, PostgREST is holding a stale
-- schema cache. Force a reload:
--   NOTIFY pgrst, 'reload schema';


-- ---------- 3. Optional: clear stale chunks ----------
-- The documents table starts at id 18, so rows 1-17 are from an earlier
-- upload. If that was a previous version of the policy doc it will be
-- retrieved alongside the current one and the bot may quote both.
--
-- Inspect first:
--   SELECT id, LEFT(content, 80), metadata->>'source' FROM public.documents ORDER BY id;
--
-- Then delete if they are stale:
--   DELETE FROM public.documents WHERE id < 18;


-- ---------- 4. Notes on the single-table layout ----------
-- All three knowledge documents live in public.documents:
--   kb/ebay_returns_refunds_policy.md
--   kb/ebay_projects_2026.md
--   kb/seller_buyer_chatter.md
--
-- The three agent tools (policy_lookup, project_lookup, chatter_lookup)
-- all query this one table. They stay separate so each can send a
-- differently-scoped query, which is what keeps retrieval on target.
--
-- If a policy question starts returning Reddit posts, split into three
-- tables: duplicate the function above three times against
-- documents_policy / documents_projects / documents_chatter, and re-run
-- Docs loader once per file with the Supabase node repointed.
