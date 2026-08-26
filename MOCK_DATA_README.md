# POC data & demo script

Everything here is synthetic. The eBay policy, project register, and community posts are fabricated for this proof of concept and are not real eBay material.

## Files

| File | Goes where |
|---|---|
| `cs_contacts.csv` | Postgres table `public.cs_contacts` |
| `kb/ebay_returns_refunds_policy.md` | Supabase `documents_policy` |
| `kb/ebay_projects_2026.md` | Supabase `documents_projects` |
| `kb/seller_buyer_chatter.md` | Supabase `documents_chatter` |
| `supabase_setup.sql` | Run first — creates tables and match functions |

## Workflows

| Workflow | Trigger | Notes |
|---|---|---|
| Insight Engine | Called by another workflow | Deterministic WoW anomaly detection |
| Trend Chart | Called by another workflow | Dual-axis QuickChart, filters by country/topic/channel |
| Contribution Analysis | Called by another workflow | Decomposes a change by L1 topic |
| Customer Chat | Chat | 7 tools |
| Weekly Summary Email | Cron, Mon 07:00 | Calls Insight Engine |
| Docs loader | Form upload | Run 3× to load the KB |

The three sub-workflows must be **Active** — n8n v2 refuses to run inactive sub-workflows.

## cs_contacts

1,458 rows. Weekly, **2026-02-02 → 2026-08-03** (27 weeks). Grain: week × country × channel × L1 topic (27 × 3 × 3 × 6).

Columns: `cs_week_beg_dt` (date), `country`, `channel_type`, `l1_topic`, `sr_cnt`, `csat_sum`, `csat_response_cnt`, `rsltn_cnt`, `rsltn_response_cnt`.

Countries: US, UK, DE. Channels: Phone, Chat, Email. Topics: Returns & Refunds, Shipping & Delivery, Payments & Payouts, Listing & Selling, Account Access, Buyer & Seller Disputes.

Seeded (`random.seed(20260803)`), so regenerating reproduces it exactly.

## The planted story

One coherent narrative, not scattered anomalies.

**Baseline.** US CSAT climbs steadily from 3.90 (Feb) to 4.07 (late June) — the "increasing trend" the demo opens on.

**The event.** Faster Refund ramps to 10% of eligible US buyers on **2026-06-15**. CSAT holds for three weeks, then declines every week from **2026-07-06**:

| Week | US CSAT |
|---|---|
| 2026-06-29 | 4.07 |
| 2026-07-06 | 3.98 |
| 2026-07-13 | 3.92 |
| 2026-07-20 | 3.83 |
| 2026-07-27 | 3.77 |
| 2026-08-03 | 3.71 |

**What the drill-down finds** (2026-06-01→06-29 vs 2026-07-06→08-03, US):

- Returns & Refunds: 4.02 → 3.29, **101% of the total change**
- Payments & Payouts: 4.04 → 3.94, 8%
- Everything else: flat or slightly positive

Shares sum to ~101% — the small residual is the mix interaction term, which is normal.

**Ruling out alternatives.** All three channels move together (Phone −0.36, Chat −0.37, Email −0.35), so it isn't channel-specific. UK (+0.01) and DE (+0.05) stay flat, so it isn't seasonal or market-wide — and UK/DE are outside the ramp, which is exactly what the project register predicts.

The dataset starts 2026-02-02, so there is **no year-ago comparison**. The bot is instructed to rule out seasonality on the cross-sectional evidence above and to say that's the basis. If it claims a year-over-year comparison, it's hallucinating.

## Demo script

| # | Ask | Should happen |
|---|---|---|
| 1 | "show me the trend of CSAT for US" | `chart_trend` (metric=csat, country=US, weeks=27). Dual-axis chart, narrative about the rise then the dip from Jul 6, possible link to Faster Refund, and a one-line offer to investigate |
| 2 | "yes" | Resolves from memory to the offer just made. Runs `contribution_analysis`, returns the bar chart, names Returns & Refunds, notes all channels moved together and UK/DE didn't |
| 3 | "fill me in on eBay's most recent return and refund policy" | `policy_lookup` only. 30-day window, refund at carrier scan, Return Discrepancy claims |
| 4 | "summarize what sellers and buyers are saying about returns and refunds in the past months" | `chatter_lookup` only. Seller frustration about lack of notification, buyer praise for speed, "good feature, bad rollout" |

Worth watching in the execution log: that step 2 doesn't re-ask what you meant, and that steps 3 and 4 hit different tables.

## Known rough edges

**Docs loader is set to PDF.** Change the Default Data Loader's data type to Text for `.md` files, or convert them first.

**Sub-workflow IDs are placeholders.** After importing, re-pick the workflow in `get_weekly_signals`, `chart_trend`, `contribution_analysis`, and the email's `Run Insight Engine` node. The dropdown shows the right name while pointing at a stale ID.

**Never send an empty string** for `country`, `l1_topic`, or `channel` — use `ALL`. An empty value collapses n8n's query-parameter list and produces `there is no parameter $2`.

**Insight Engine still compares the latest two weeks only.** With the new data that's 2026-07-27 vs 2026-08-03 — one step of a gradual decline, so it may not cross the ±0.3 CSAT threshold. The weekly email will look quiet. If you want the email to headline the Faster Refund story, the threshold logic needs a multi-week trend test rather than a single WoW comparison.
