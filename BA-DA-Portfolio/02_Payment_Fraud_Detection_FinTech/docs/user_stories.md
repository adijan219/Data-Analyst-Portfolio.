# User Stories: Payment Fraud Detection

Priority uses MoSCoW. Figures come from the project analysis (test set: 56,962 transactions, 98 frauds).

### US-01 Fraud risk score (Must)
As a **Fraud Operations Analyst**, I want every transaction to receive a risk score, so that I can focus on the riskiest cases first.
- [ ] Each transaction has a score between 0 and 1
- [ ] Scores can be sorted from highest to lowest risk
- [ ] Random Forest model used (PR-AUC 0.858 vs 0.716 for Logistic Regression)

### US-02 Review queue (Must)
As a **Fraud Operations Analyst**, I want transactions above the alert threshold placed in a ranked queue, so that my daily workload is manageable.
- [ ] Queue contains only transactions at or above the threshold
- [ ] At the recommended threshold, flagged volume is about 0.3% of transactions (166 of 56,962 in testing)
- [ ] Each queue item shows score, amount and time

### US-03 Fraud and loss overview (Must)
As the **Head of Risk**, I want to see fraud rate, fraud value and loss trends, so that I can set risk targets.
- [ ] Report shows fraud rate (baseline 0.173%) and total fraud value (baseline $60,128)
- [ ] Report shows recall, precision and estimated cost versus no model
- [ ] Updated at least monthly

### US-04 Adjustable threshold (Should)
As the **Head of Risk**, I want to change the alert threshold when costs change, so that I can balance missed fraud against review workload.
- [ ] Threshold can be changed without retraining
- [ ] A table shows expected caught, missed and false alerts for each threshold
- [ ] Sensitivity results (fraud cost $50-$300, review cost $2-$20) are available for reference

### US-05 Low-value fraud rule (Should)
As a **Risk Analyst**, I want small transactions of $1 or less examined for card-testing patterns, so that fraud can be stopped before larger attempts.
- [ ] Analysis confirms 36.8% of fraud is $1 or less (181 of 492)
- [ ] Proposed rule or extra monitoring documented
- [ ] Impact on genuine small payments estimated

### US-06 Protect genuine customers (Should)
As a **Product Manager**, I want to know how many genuine customers get flagged, so that checkout experience is protected.
- [ ] False alerts reported (79 in testing at the recommended threshold)
- [ ] False positive rate reported (about 0.14%)
- [ ] Trade-off with recall documented

### US-07 Audit trail (Must)
As a **Compliance Officer**, I want every score and review decision recorded, so that decisions can be audited.
- [ ] Score, threshold and analyst decision stored per alert
- [ ] Records retrievable by transaction ID

### US-08 Feedback loop (Could)
As a **Data Scientist**, I want analyst outcomes fed back into the data, so that the model can be retrained on confirmed cases.
- [ ] Confirmed fraud and genuine labels stored
- [ ] Retraining schedule defined (assumed monthly)
