# Business Requirements Document: Demand Forecasting and Inventory Optimisation

> Portfolio case study on the public Kaggle Store Item Demand dataset. Stakeholders, costs and process details are hypothetical and labelled as assumptions. Results are simulation-based.

## Document Control

| Version | Date | Author | Change |
|---|---|---|---|
| 1.0 | Nov 2026 | Aditya Pandey | Initial draft |
| 2.0 | Nov 2026 | Aditya Pandey | Added measurable objectives, data requirements, assumption and risk registers, business case, pilot plan, glossary |

**Status:** Draft for discussion. **Related:** [Executive summary](executive_summary.md) | [User stories](user_stories.md) | [KPIs](kpis.md) | [Process flow](process_flow.md) | [Traceability](traceability_matrix.md)

## 1. Executive Summary

Replace a trailing-average ordering rule with a forecast-driven order-up-to policy that uses a measured safety buffer. In simulation on a held-out quarter, this cut average inventory by 26.7%-29.5% at the same fill rate and total cost by 27.9% under base assumptions. This document defines what the business needs, how success is measured, and how to pilot safely.

## 2. Business Context and Problem

A multi-store distributor (10 stores, 50 items, 500 store-item series) orders weekly with a 7-day lead time. The current rule holds about 14 days of the last 28 days' average sales. Demand is strongly seasonal (Sunday about 50% above Monday, July about 88% above January, rising trend), and the rule lags these movements.

**Problem statement:** the current rule needs about 172,000 units of average stock to reach 99.96% fill rate in simulation; a forecast-driven policy needs about 122,000 for the same service.

## 3. Objectives and Success Criteria

| ID | Objective (SMART) | Measure | Target | Test result |
|---|---|---|---|---|
| O-1 | Reduce average inventory without reducing service | Avg units on hand at equal fill rate vs current rule | 20% or more lower | 26.7%-29.5% lower (simulation) |
| O-2 | Keep products available | Fill rate | 99% or higher | 99.96% |
| O-3 | Forecast accurately | Daily WAPE, store-item | 12% or lower | 10.78% (4-fold backtest) |
| O-4 | Forecast without systematic bias | Bias | Within +/-2% | +0.06% |
| O-5 | Make the decision robust | Cost advantage across cost scenarios | Positive in all scenarios | Positive in 9 of 9 |

## 4. Scope

| In scope | Rationale |
|---|---|
| Daily demand forecasts for 500 store-item series | Core input to ordering |
| Safety-stock factors by volume segment | Converts forecast error into a buffer |
| Weekly order-up-to recommendation | The decision being improved |
| Simulation, KPI definitions, cost sensitivity | Evidence and monitoring |

| Out of scope | Rationale |
|---|---|
| Supplier selection and price negotiation | Different decision |
| Promotion, new-product and end-of-life forecasting | Data not available |
| Transfers between stores | Adds network complexity |
| Live ERP integration | Not needed to prove value |

## 5. Stakeholders

| Stakeholder | Influence | Interest | Success looks like |
|---|---|---|---|
| Operations Manager | High | High | Items available; manageable weekly workload |
| Procurement Lead | Medium | High | Clear weekly order quantities; ability to override |
| Finance Head | High | Medium | Less cash tied up in stock |
| Store Managers | Low | High | Fewer empty shelves |
| Business Owner | High | Medium | Lower cost, no lost sales, simple to explain |
| Data Team | Low | High | Maintainable model with clear monitoring |

## 6. Current State and Proposed Solution

**Current:** weekly order = 14 days x trailing 28-day average x (1 + informal buffer). **Proposed:** weekly order = max(0, S - on hand - on order), where S = 14-day forecast x (1 + safety factor for the item's volume segment). See [process flow](process_flow.md).

## 7. Requirements

### 7.1 Business requirements

| ID | Requirement | Priority | Source | Rationale | Verification |
|---|---|---|---|---|---|
| BR-01 | Hold at least 20% less average inventory than the current rule at equal service | Must | Finance Head | Working capital | Simulation, then pilot vs control |
| BR-02 | Keep fill rate at 99% or higher | Must | Ops Manager, Store Managers | Lost sales hurt revenue | Simulation, then pilot |
| BR-03 | Daily forecast WAPE of 12% or lower | Must | Ops Manager | Accuracy drives buffer size | Rolling backtest |
| BR-04 | Weekly recommended order quantity per store-item | Must | Procurement Lead | Replaces manual calculation | Design review, shadow mode |
| BR-05 | Service level adjustable by volume segment | Should | Ops Manager | Items differ in importance | Parameter test |
| BR-06 | Recurring KPI monitoring with thresholds | Should | Finance, Data Team | Detect drift early | Report review |
| BR-07 | Planner override with recorded reason | Could | Procurement Lead | Capture local knowledge | Design review |
| BR-08 | Decision documented as robust to cost assumptions | Should | Business Owner | Costs are uncertain | Sensitivity analysis |

### 7.2 Functional requirements

| ID | Requirement | Linked BR |
|---|---|---|
| FR-01 | Forecast each store-item for at least the next 14 days | BR-03, BR-04 |
| FR-02 | Classify each series as low, mid or high volume from trailing sales | BR-05 |
| FR-03 | Compute order-up-to level S = 14-day forecast x (1 + segment safety factor) | BR-01, BR-05 |
| FR-04 | Compute order quantity = max(0, S - on hand - on order) | BR-04 |
| FR-05 | Allow the service level (P90-P99.5) to change without retraining | BR-05 |
| FR-06 | Produce a weekly KPI report by segment | BR-06 |
| FR-07 | Raise an alert when a KPI crosses its amber or red threshold | BR-06 |
| FR-08 | Store each override: original quantity, new quantity, reason | BR-07 |
| FR-09 | Retrain quarterly and re-validate on rolling origins; fall back to the seasonal baseline if the model is worse than it | BR-03 |

### 7.3 Non-functional requirements (proposed)

| ID | Requirement |
|---|---|
| NFR-01 | No leakage: every input must be available at forecast time |
| NFR-02 | Reproducible: fixed random seed, versioned code and data extracts |
| NFR-03 | Auditable: forecasts, factors and recommendations stored weekly |
| NFR-04 | Explainable: top features reported with each retrain |
| NFR-05 | Weekly run completes before the ordering cut-off (exact time to be agreed) |

## 8. Data Requirements

| Data | Status | Use |
|---|---|---|
| Daily unit sales by store-item | Available (913,000 rows, 2013-2017, no missing values) | Forecasting, error measurement |
| On-hand inventory, open orders | Not available | Order quantity (FR-04) |
| Supplier lead times and variability | Not available (7 days assumed) | Protection window |
| Unit cost, selling price, holding rate | Not available (assumed) | Cost evaluation |
| Promotions, stockout flags | Not available | Avoid treating censored sales as demand |

**Quality checks to run on real data:** completeness by day, duplicates, negative or extreme values, days with stockouts, item launches and discontinuations.

## 9. Assumptions, Constraints and Dependencies

### Assumptions register

| ID | Assumption | Basis | Stress-tested? | To validate with |
|---|---|---|---|---|
| A-01 | Observed sales equal demand | Dataset has no stockout flags | No | Data Team |
| A-02 | Lead time is a fixed 7 days | Placeholder | No | Procurement Lead |
| A-03 | Orders placed weekly | Placeholder | No | Procurement Lead |
| A-04 | Unmet demand is lost, not backordered | Typical retail | No | Ops Manager |
| A-05 | Unit cost $10 | Placeholder | Indirectly (rates scaled) | Finance Head |
| A-06 | Holding cost 25% of unit cost per year | Common planning rate | Yes (15%-40%) | Finance Head |
| A-07 | Lost sale costs $4 margin per unit | Placeholder | Yes ($2-$8) | Finance Head |
| A-08 | No order cost, minimum order or shelf-life limits | Simplification | No | Procurement Lead |
| A-09 | All 500 series weighted equally | Simplification | No | Finance Head |
| A-10 | Forecast made once, from inputs at least 92 days old | Study design | n/a (conservative for the model) | Data Team |

**Constraints:** public dataset only; no real cost data; results are simulation-based.
**Dependencies (for a real rollout):** inventory and open-order feed from the ordering system; agreed lead-time data; owner for weekly review.

## 10. Risk Register

| ID | Risk | Likelihood | Impact | Mitigation | Owner |
|---|---|---|---|---|---|
| R-01 | Demand shifts (promotions, new items, shocks) raise forecast error | Medium | High | Weekly WAPE and bias alerts; fallback to baseline; planner overrides | Data Team |
| R-02 | Real lead time longer or more variable than 7 days | Medium | High | Re-estimate safety factors on actual lead times before pilot | Procurement Lead |
| R-03 | Cost assumptions wrong | Medium | Medium | Sensitivity analysis done; set service level after real costs known | Finance Head |
| R-04 | Evidence from one test season overstates the gain | Medium | Medium | Shadow mode and matched-control pilot | Data Team |
| R-05 | Past stockouts hid demand, so sales understate it | Medium | Medium | Data check in pilot week 1-2; flag stockout days | Data Team |
| R-06 | Planners distrust the model | Medium | High | Show seasonal baseline alongside; allow overrides; start in shadow mode | Ops Manager |
| R-07 | Inventory or order data feed late or wrong | Medium | Medium | Data quality checks before each run | Data Team |
| R-08 | Settings tuned on the test period inflate absolute savings | High (present) | Medium | Select settings on a validation period; confirm in pilot | Data Team |

## 11. Business Case

| Measure (78-day simulation, 500 series, base assumptions) | Rule of thumb | Forecast-driven | Change |
|---|---|---|---|
| Average inventory (units) | 171,971 | 122,145 | -29.0% |
| Simulated cost | $95,097 | $68,528 | -27.9% ($26,569) |
| Fill rate | 99.96% | 99.96% | no loss |

- Against the seasonal baseline: 11.4% less inventory and 12.7% lower cost.
- Across 9 cost scenarios: 26.9%-28.4% lower cost than the rule of thumb, 9.5%-16.9% lower than the baseline.
- **Read the percentages, not the dollars.** Dollar figures rest on an assumed $10 unit cost. Implementation and running costs are not estimated here.
- Of the 27.9% saving, 17.4 points come from using any seasonal forecast, so a low-effort baseline captures most of it.

## 12. Implementation Approach

| Phase | Duration (assumed) | Activity | Exit gate |
|---|---|---|---|
| 0. Data check | 2 weeks | Confirm lead times, costs, stockout history, data feeds | Assumptions A-01 to A-07 confirmed or revised |
| 1. Shadow mode | 4 weeks | Generate recommendations beside current orders; no change | WAPE 12% or lower on live data |
| 2. Matched pilot | 8 weeks | About 20% of store-items on the new policy; the rest on the old rule | Inventory at least 15% below control, fill rate 99% or higher |
| 3. Rollout | By segment | Extend high-volume, then mid, then low | KPIs green for 4 weeks |

**Stop or fall back** if fill rate stays below 98% for two consecutive weeks, or WAPE exceeds 15.2% (worse than the seasonal baseline) for two weeks.

## 13. Open Questions

1. What are the real lead times, and how much do they vary?
2. Do historical sales understate demand because of stockouts?
3. Are there promotions, perishables or minimum order quantities?
4. What does a lost sale really cost, including customer goodwill?
5. Who owns the weekly review and the override decisions?

## 14. Glossary

| Term | Meaning |
|---|---|
| WAPE | Sum of absolute forecast errors divided by sum of actual sales |
| Bias | Net over- or under-forecast as a share of sales; positive means forecast too high |
| MASE | Error scaled by a simple weekly naive forecast's in-sample error |
| Fill rate | Share of demanded units that were available |
| Order-up-to level (S) | Target stock position at each weekly review |
| Safety factor | Extra share of forecast demand held as a buffer |
| P95, P99 | Buffer sized to cover 95% or 99% of backtested 14-day demand outcomes |
| Lead time | Days between placing and receiving an order |
| Rolling-origin validation | Repeatedly train on the past and test on the next window, moving forward in time |
