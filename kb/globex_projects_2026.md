# Globex Product Initiatives — 2026 Launch Register

> **FICTIONAL DOCUMENT.** Globex is an invented online marketplace. Every project below was written for a portfolio demonstration.

**Document type:** Project register
**Owner:** Product Operations
**Last updated:** 2026-08-03

This register lists 2026 initiatives that materially change customer-facing behaviour, with launch and ramp dates. Support analytics teams use it to correlate metric movements with product changes.

---

## Project Halo

**Status:** Ramping
**Primary L1 topic affected:** Returns & Refunds
**Secondary L1 topic affected:** Payments & Payouts
**Markets:** US only
**Owner:** Trust & Payments

### What it does

Issues a buyer's refund at the carrier's first acceptance scan of the return parcel, rather than when the item is delivered back to the seller. Cuts buyer wait time by 5 to 9 days.

### Ramp schedule

| Date | Ramp | Note |
|---|---|---|
| 2026-05-04 | Internal dogfood | Employees only, no external traffic |
| 2026-06-15 | **10% of eligible US buyers** | First external exposure |
| Q4 2026 (planned) | Expansion under review | Gated on CSAT recovery |

### Known risks flagged at launch

1. **Sellers are debited before the item is back in hand.** The payout deduction occurs at carrier scan. Sellers see money leave their balance while the parcel is still in transit.
2. **No advance seller notification.** Cohort membership is not surfaced on the order detail page in the current release. Sellers cannot tell which returns will refund early.
3. **Return Discrepancy claim is a new flow.** Sellers who receive a wrong or damaged item must use a process that did not exist before 2026-06-15, and awareness is low.

Risks 1 and 2 were accepted at launch on the basis that the affected volume would be small at 10%. The launch review noted that seller-side CSAT was the metric most likely to degrade, and set a review checkpoint for early August 2026.

### Observed impact

Support contacts tagged Returns & Refunds in the US rose modestly following the 2026-06-15 ramp. A sustained CSAT decline in the same segment began the week of **2026-07-06**, roughly three weeks after ramp — consistent with the lag between a return being initiated, the refund firing at scan, and the seller contacting support. The decline is confined to the US, which is the only market in the ramp.

---

## Unified Listing Editor

**Status:** Launched
**Primary L1 topic affected:** Listing & Selling
**Markets:** US, UK, DE
**Launch:** 2026-03-02, 100% from day one

Consolidated the bulk editor and single-listing editor into one interface. Listing & Selling CSAT improved gradually through Q2 2026. No adverse effects recorded.

---

## Two-Factor Enforcement for High-Value Sellers

**Status:** Launched
**Primary L1 topic affected:** Account Access
**Markets:** US, UK, DE
**Launch:** 2026-04-13, phased over three weeks to 100%

Mandatory two-factor authentication for sellers with over USD 10,000 in trailing 90-day GMV. Produced a brief rise in Account Access contacts during the phase-in, which normalised by mid-May 2026.

---

## Carrier Rate Refresh

**Status:** Launched
**Primary L1 topic affected:** Shipping & Delivery
**Markets:** US, UK, DE
**Launch:** 2026-02-16

Annual renegotiation of discounted shipping rates. No measurable support impact.

---

## Reading this register

When a metric moves, check three things before attributing the change to a project:

1. **Topic alignment** — does the project's primary L1 topic match the segment that moved?
2. **Market alignment** — is the affected market in the project's scope? A change in a market outside the ramp is not caused by that ramp.
3. **Date alignment** — allow two to four weeks between a ramp and a customer-sentiment effect. Contact-volume effects appear faster than CSAT effects, because CSAT requires a completed interaction and a survey response.

A project is only a plausible driver when all three align.