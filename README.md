# Analytics Hub

n8n-based POC for a business performance chatbot and weekly summary email — answers natural-language questions about the business with explainable insights, no dashboards or manual SQL required.

## What it does

- **Chatbot**: answers questions on call data, trends, and drivers using an AI Agent with SQL + analytics tools and a RAG knowledge base (policy, project, chatter)
- **Weekly email**: proactively summarizes key trends and anomalies
- **Data sources**: aggregated call data (CSV, mock for now), LLM call-summary tags, and external context (industry blogs, Reddit, weather/market data)

## Environments

Dev/Prod separated as n8n Cloud **Projects** (plan doesn't support separate instances):
- `Analytics Hub - Dev`
- `Analytics Hub - Prod`

Each has its own credentials (Gmail, Supabase) — never shared between environments.

## Repo structure

```
workflows/dev/    exported Dev workflow JSON
workflows/prod/   exported Prod workflow JSON
sql/              Supabase schema (documents table + match_documents function)
```

## Knowledge base

Single Supabase `documents` table (pgvector), split by `metadata.type` = `policy` / `chatter` / `project`.

## Status

Done: version control, environments, credentials, KB, error alerting (email on failure), webhook handling, deploy flow, prod testing.

Deferred: real data ingestion (still mock CSV), explicit chatbot routing logic (left to the agent), interaction logging.
