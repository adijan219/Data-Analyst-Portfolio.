# Process Flow

## As-Is
Sales and finance track performance in separate spreadsheets with no shared view.

```mermaid
flowchart LR
  A[Start] --> B[Current manual step]
  B --> C[Decision]
  C -->|Yes| D[Outcome A]
  C -->|No| E[Outcome B]
```

## To-Be
One dashboard shows revenue, margin, discounts and account health.

```mermaid
flowchart LR
  A[Start] --> B[Automated data step]
  B --> C[Analysis / rule]
  C --> D[Action by stakeholder]
```

Edit the diagrams so they match your own process. GitHub renders them automatically.
