# KPI Framework: Payment Fraud Detection

Current values come from the project analysis. Random Forest, threshold chosen on a validation set (0.04), results measured on the untouched test set (56,962 transactions, 98 frauds). Targets are proposed, not mandated.

| KPI | Definition | Current value | Proposed target |
|---|---|---|---|
| Fraud rate | Fraud transactions / total transactions | 0.173% (492 of 284,807) | Monitor trend, no target |
| Total fraud value | Sum of fraudulent amounts | $60,128 | Reduce over time |
| Recall (detection rate) | Frauds flagged / all frauds | 88.8% (87 of 98) | 85% or higher |
| Precision | Frauds flagged / all flagged | 52.4% (87 of 166) | 50% or higher |
| False positive rate | Genuine flagged / all genuine | 0.14% (79 of 56,864) | Below 0.2% |
| Review workload | Flagged transactions / total | 0.29% (166 of 56,962) | Below 0.5% |
| Missed fraud | Frauds not flagged | 11 of 98 | Decrease |
| PR-AUC | Area under precision-recall curve | 0.858 (LogReg: 0.716) | 0.80 or higher |
| Estimated total cost | Missed fraud x $122 + false alerts x $5 | $1,737 | Lower is better |
| Cost reduction vs no model | 1 - (model cost / no-model cost) | 85.5% ($1,737 vs $11,956) | 75% or higher |

## Supporting analysis
- **Sensitivity:** cost reduction stays between 78.8% and 88.2% across 9 scenarios (fraud cost $50-$300, review cost $2-$20)
- **Fraud by amount:** $0-1: 0.594% | $1-10: 0.097% | $10-100: 0.088% | $100-500: 0.201% | $500+: 0.383%
- **Small-amount fraud:** 36.8% of all fraud is $1 or less
- **Peak risk hours (relative to dataset start):** hour 2 at 1.713%, hour 4 at 1.041%

## Notes and limitations
- The $122 missed-fraud cost and $5 review cost are assumptions
- Only 98 frauds in the test set, so metrics can move noticeably with a few cases
- Targets should be agreed with the business before use
