# Business Requirements Document: Payment Fraud Detection

**Author:** YOUR NAME  |  **Version:** 1.0  |  **Status:** Draft

> Portfolio case study built on the public Kaggle Credit Card Fraud dataset. Stakeholders, requirements and cost figures are hypothetical and stated as assumptions.

## 1. Purpose
Reduce financial loss from fraudulent card payments while keeping the number of genuine customers blocked or sent to manual review as low as possible.

## 2. Background and Problem
A payment gateway loses money to fraud, but fraud is very rare (492 of 284,807 transactions, 0.173%), so fixed rules and manual review miss cases or flood analysts with false alarms. Analysis shows fraud is concentrated in very small transactions ($1 or less: 36.8% of all fraud), in very large ones ($500+), and in specific time windows (about 10x the average rate). A scoring model can rank transactions by risk so analysts review the riskiest first.

## 3. Stakeholders
| Stakeholder | Interest |
|---|---|
| Head of Risk | Owns fraud losses, sets risk appetite and targets |
| Fraud Operations Analyst | Reviews flagged transactions; needs a manageable queue |
| Product Manager | Protects checkout success and customer experience |
| Compliance Officer | Needs an audit trail and explainable decisions |
| Data / Engineering Team | Builds, deploys and monitors the model |

## 4. Scope
**In scope**
- Analysis of fraud patterns by amount and time
- A risk-scoring model (Logistic Regression and Random Forest compared)
- Alert threshold recommendation based on business cost
- KPI definitions and a monitoring approach

**Out of scope**
- Real-time production deployment and integration
- Card-network or regulatory reporting
- Customer communication workflows
- Chargeback dispute handling

## 5. Business Requirements
| ID | Requirement | Priority |
|---|---|---|
| BR-01 | Reduce total fraud-related cost (missed fraud plus review cost) versus having no model | Must |
| BR-02 | Detect at least 85% of fraudulent transactions | Must |
| BR-03 | Keep manual review volume manageable (under 0.5% of transactions flagged) | Must |
| BR-04 | Allow the alert threshold to be changed as costs change | Should |
| BR-05 | Provide clear KPIs for ongoing monitoring | Should |
| BR-06 | Provide a reason or key drivers for flagged transactions | Could |

## 6. Functional Requirements
| ID | Requirement | Linked BR |
|---|---|---|
| FR-01 | The system shall assign every transaction a fraud risk score between 0 and 1 | BR-01, BR-02 |
| FR-02 | Transactions at or above the alert threshold shall be sent to a review queue, ranked by score | BR-03 |
| FR-03 | The threshold shall be configurable without retraining the model | BR-04 |
| FR-04 | Analysts shall mark each reviewed alert as fraud or genuine, and the outcome shall be stored | BR-05 |
| FR-05 | A report shall show fraud rate, recall, precision, false alerts and estimated cost each period | BR-05 |
| FR-06 | The model shall expose its most influential features for review | BR-06 |

## 7. Non-Functional Requirements
- **Accuracy:** evaluated with precision, recall and PR-AUC, not accuracy (the data is 99.8% genuine)
- **Performance:** scoring fast enough not to delay payment approval (target to be agreed with engineering)
- **Auditability:** every score, threshold and analyst decision logged
- **Data protection:** only masked or anonymised card data used for analysis
- **Maintainability:** model retrained on a regular schedule (assumed monthly)

## 8. Assumptions and Constraints
- Average cost of a missed fraud is $122 (average fraud amount in the data)
- Cost of one manual review is $5 (assumed)
- Features are anonymised (V1-V28), so business meaning cannot be given for them
- Data covers 2 days only, so seasonality cannot be assessed
- Hours are measured from the start of the dataset, not clock time

## 9. Risks
| Risk | Impact | Mitigation |
|---|---|---|
| Fraud patterns change over time | Model loses accuracy | Monitor KPIs, retrain regularly |
| Test set has only 98 frauds | Results sensitive to a few cases | Report limits, retest on more data |
| Cost assumptions are wrong | Wrong threshold | Sensitivity analysis (9 scenarios) and configurable threshold |
| Too many false alerts | Analyst overload, customer friction | Cap review volume, tune threshold |
| Short data window | May not generalise | Validate on a longer period before use |

## 10. Success Metrics
See [KPI Framework](kpis.md). Headline result on test data: estimated cost reduction of 85.5% ($1,737 vs $11,956 with no model), with 87 of 98 frauds caught and 79 false alerts.
