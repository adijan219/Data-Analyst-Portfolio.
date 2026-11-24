# User Stories: Demand Forecasting and Inventory Optimisation

Stories are grouped into epics, written in "As a / I want / so that" form, and have Given/When/Then acceptance criteria. Each links to a business requirement (BR), a KPI and the evidence in this repo. "Measured" means tested in backtest or simulation. "Designed" means specified but not built.

**Epics:** A Forecasting | B Replenishment | C Monitoring and governance
Links: [BRD](BRD.md) | [KPIs](kpis.md) | [Traceability](traceability_matrix.md)

---

## Epic A: Forecasting

### US-01 Daily demand forecast
**As an** Operations Manager, **I want** a daily demand forecast for every store-item for the next 14 days, **so that** stock matches expected sales.
**Links:** BR-03 | FR-01 | KPI: WAPE, bias | **Status:** Measured

- **Given** sales history up to the review date, **when** the weekly forecast runs, **then** a forecast exists for all 500 store-items for each of the next 14 days.
- **Given** the four rolling backtest folds, **when** accuracy is measured, **then** daily WAPE is 12% or lower (measured: 10.78%).
- **Given** the same folds, **when** bias is measured, **then** it is within +/-2% (measured: +0.06%).

### US-02 Forecast beats the simple alternatives
**As a** Finance Head, **I want** proof that the model beats simple methods, **so that** the added complexity is justified.
**Links:** BR-03 | FR-09 | KPI: WAPE | **Status:** Measured

- **Given** a seasonal baseline (last year x growth) and a weekday profile, **when** each is scored on the same folds, **then** the model has the lowest WAPE in every fold (measured: 4 of 4; 10.78% vs 15.17% and 17.96% on average).
- **Given** the result above, **when** the model is reported, **then** the gain over the seasonal baseline is stated separately from the gain over the rule of thumb.

---

## Epic B: Replenishment

### US-03 Weekly order recommendation
**As a** Procurement Lead, **I want** a recommended order quantity per store-item each week, **so that** I do not calculate orders by hand.
**Links:** BR-04 | FR-03, FR-04 | KPI: fill rate, average inventory | **Status:** Designed, simulated

- **Given** on-hand stock, open orders and the 14-day forecast, **when** the weekly run completes, **then** each store-item shows order quantity = max(0, order-up-to level - on hand - on order).
- **Given** a store-item already above its order-up-to level, **when** the run completes, **then** the recommended quantity is zero, never negative.
- **Given** the ordering cut-off, **when** recommendations are published, **then** they are available before it.

### US-04 Safety buffer sized by evidence
**As an** Operations Manager, **I want** the safety buffer to reflect measured forecast error by item volume, **so that** small items are not under-protected and large items are not over-stocked.
**Links:** BR-05 | FR-02, FR-03 | KPI: fill rate, average inventory | **Status:** Measured

- **Given** backtested 14-day errors, **when** buffers are set, **then** each volume segment uses its own factor (at P99: low 15.2%, mid 10.6%, high 10.0%).
- **Given** a request for a different service level, **when** the parameter changes, **then** the new buffers apply without retraining (FR-05).

### US-05 Less stock at the same availability
**As a** Finance Head, **I want** lower average inventory with no loss of availability, **so that** less cash is tied up in stock.
**Links:** BR-01, BR-02 | KPI: average inventory, fill rate | **Status:** Measured (simulation)

- **Given** fill-rate targets of 98%, 99% and 99.5%, **when** the policies are compared, **then** the forecast-driven policy needs at least 20% less inventory than the rule of thumb (measured: 26.7%, 27.9%, 29.5%).
- **Given** the lowest-cost settings, **when** service is compared, **then** fill rate is 99% or higher (measured: 99.96%).
- **Given** any inventory saving, **when** it is reported, **then** fill rate is reported beside it (availability guardrail).

### US-06 Decision holds if costs change
**As a** Business Owner, **I want** to see whether the conclusion survives different cost assumptions, **so that** I can decide before real costs are known.
**Links:** BR-08 | KPI: total cost | **Status:** Measured

- **Given** holding rates of 15%, 25% and 40% a year and lost margins of $2, $4 and $8, **when** the nine scenarios are run, **then** the forecast-driven policy is cheapest in all nine (measured: 26.9%-28.4% below the rule of thumb).
- **Given** each scenario, **when** results are shown, **then** the best service level is shown (measured: P95 to P99.5).

### US-07 Planner override
**As a** Procurement Lead, **I want** to override a recommendation and say why, **so that** local knowledge such as a known promotion is captured.
**Links:** BR-07 | FR-08 | KPI: none (governance) | **Status:** Designed

- **Given** a recommendation, **when** I change the quantity, **then** the original quantity, the new quantity and my reason are stored.
- **Given** a month of overrides, **when** they are reviewed, **then** repeated reasons are listed as candidate model inputs.

---

## Epic C: Monitoring and governance

### US-08 Weekly KPI report
**As a** Data Analyst, **I want** a weekly report of forecast and inventory KPIs with green/amber/red status, **so that** I can spot drift early.
**Links:** BR-06 | FR-06, FR-07 | KPI: all | **Status:** Designed (KPIs defined)

- **Given** a completed week, **when** the report runs, **then** WAPE, bias, fill rate, stockout rate and average inventory are shown by volume segment.
- **Given** a KPI beyond its amber or red threshold, **when** the report runs, **then** an alert is raised with the segment affected.

### US-09 Automatic fallback
**As an** Operations Manager, **I want** the system to fall back to the simple seasonal forecast if the model degrades, **so that** ordering is never worse than a safe default.
**Links:** BR-03 | FR-09 | KPI: WAPE | **Status:** Designed

- **Given** model WAPE above 15.2% (the seasonal baseline's backtest level) for two consecutive weeks, **when** the weekly check runs, **then** recommendations switch to the seasonal baseline and an alert is raised.
- **Given** a retrain, **when** the new model beats the baseline on the latest rolling backtest, **then** it is switched back on.

---

## Definition of Done (all stories)

- Acceptance criteria tested with a result recorded in this repo
- Numbers traceable to a notebook cell or results file
- Assumptions and limits stated beside the result
- Linked requirement, KPI and evidence updated in the [traceability matrix](traceability_matrix.md)
