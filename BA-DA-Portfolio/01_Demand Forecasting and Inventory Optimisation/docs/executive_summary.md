# Executive Summary: Replace the 28-Day Rule of Thumb with Forecast-Driven Replenishment

**Prepared for:** Operations Manager and Finance Head (hypothetical)  |  **Prepared by:** YOUR NAME  |  **Evidence:** backtests and a simulation on public data

## Recommendation

Move weekly ordering from "14 days of the last 28 days' average sales" to an order-up-to level built from a demand forecast plus a measured safety buffer. Run it as a staged pilot first. In simulation this holds **26.7%-29.5% less inventory** at the same fill rate (98%-99.5%) and lowers total cost by **27.9%**, of which 17.4 points come from using any seasonal forecast and 10.5 from the model.

## Situation, Complication, Resolution

**Situation.** Ten stores each carry 50 items. Orders are placed weekly with a 7-day lead time, using a trailing-average rule.

**Complication.** Demand is strongly seasonal: Sundays run about 50% above Mondays and July about 88% above January. A trailing average lags these swings, so the rule needs a +15% buffer to stay available, which ties up cash (171,971 units on hand on average in simulation).

**Resolution.** Forecast each store-item daily (10.8% WAPE vs 15.2% for the best simple baseline), measure how wrong 14-day demand tends to be (3.1%-4.0%), and hold exactly the buffer that error justifies, larger for low-volume items and smaller for high-volume ones.

## Evidence (held-out period Oct 15-Dec 31 2017, base cost assumptions)

| Policy | Avg inventory (units) | Fill rate | Simulated cost |
|---|---|---|---|
| Rule of thumb | 171,971 | 99.96% | $95,097 |
| Seasonal baseline (last year x growth) | 137,791 | 99.94% | $78,532 |
| Forecast model + safety stock | 122,145 | 99.96% | $68,528 |

The model stays cheapest in all 9 cost scenarios tested (holding 15%-40% a year, lost margin $2-$8 per unit): 26.9%-28.4% below the rule of thumb and 9.5%-16.9% below the seasonal baseline.

## How much to trust it

- **Strengths:** leakage-free rolling validation, a fair seasonal comparator, results stress-tested across cost assumptions.
- **Cautions:** one season of test data; costs and the 7-day lead time are assumptions; the best settings were chosen on the test period for all three policies, so absolute costs are optimistic (the fixed-fill-rate comparison is not affected); the dataset is unusually regular.
- **Bottom line:** the direction is credible, the exact size of the saving is not yet proven. The pilot exists to prove it.

## Proposed pilot (assumed durations)

1. **Weeks 1-2, data check:** confirm lead times, unit costs and whether past stockouts hid demand.
2. **Weeks 3-6, shadow mode:** produce recommendations alongside current orders, change nothing, compare.
3. **Weeks 7-14, matched-control pilot:** about 20% of store-items on the new policy, the rest on the old rule.
4. **Go if:** average inventory at least 15% below control, fill rate at least 99%, WAPE at most 12%.
5. **Stop or fall back if:** fill rate below 98% for two consecutive weeks, or WAPE above 15.2% (worse than the seasonal baseline) for two weeks.

## Decisions requested

1. Confirm the real supplier lead time and ordering cadence.
2. Confirm the cost of a lost sale and the holding rate, so the service level can be set properly.
3. Agree service-level targets by volume segment.
4. Approve the pilot scope and the go/stop criteria above.

Detail: [README](../README.md) | [BRD](BRD.md) | [KPIs](kpis.md)
