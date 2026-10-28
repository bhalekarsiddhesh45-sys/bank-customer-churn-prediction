# Excel Profiling: Bank Churn

**Workbook:** `Bank_Churn_Profile.xlsx`
**Source:** `data/raw/bank_churn.csv` (untouched; loaded via Data → From Text/CSV)
**Date downloaded:** _fill in_
**Rows:** ~10,000 (table `tblBank`)

## Sheets

| Sheet | Purpose |
|---|---|
| `README` | Source, download date, what each sheet does |
| `tblBank` (data sheet) | Raw data as an Excel Table with derived columns that auto-fill |
| `DQ_Checks` | Data-quality formulas: row count, churn rate, blanks, zero balances, duplicate IDs, min/max, product-count sizes |
| `Pivots` | Seven PivotTables (Average of Exited as %, plus Count of CustomerId) |
| `Charts` | Column charts exported to `excel/charts/` |

## Derived columns and cut-offs

| Column | Cut-offs | Note |
|---|---|---|
| AgeBand | <30, 30-39, 40-49, 50-59, 60+ | Bands make pivots readable |
| HasZeroBalance | Balance = 0 → 1 | Zero-balance customers are a distinct group |
| BalanceBand | Zero, 1-99K, 100K+ | My own cut-offs |
| TenureBucket | 0-1, 2-4, 5-7, 8-10 years | Lifecycle view |
| ProductsGroup | 1, 2, 3+ | Groups 3 and 4 are tiny, so merged to avoid noisy rates |
| CreditBand | <580, 580-669, 670-739, 740+ | Common credit-tier convention, not a rule from the data |

## Pivots

Values are *Average of Exited* (formatted %) and *Count of CustomerId*.

1. Churn by Geography
2. Churn by Gender
3. Churn by AgeBand
4. Churn by ProductsGroup
5. IsActiveMember × Geography (heat map)
6. Balance held: Exited vs Sum of Balance
7. BalanceBand

## Charts

| File | Pivot |
|---|---|
| `charts/churn_by_geography.png` | Churn by Geography |
| `charts/churn_by_ageband.png` | Churn by AgeBand |
| `charts/churn_by_product.png` | Churn by ProductsGroup (counts labelled) |

![Churn by age band](charts/churn_by_ageband.png)

## Verification

- Each pivot's grand total equals the `DQ_Checks` churn rate.
- Q1 in SQL and the pandas overall churn rate should match.

## Findings (fill in after running)

- Overall churn rate: _x%_
- Highest-churn geography: _…_
- Age band where churn starts climbing: _…_
- Product-count pattern: _…_
- Zero-balance share and its churn rate: _…_

## Pitfalls avoided

- Averaged the rate column, never summed it.
- Read every rate beside its count.
- Refreshed pivots after table changes.
- Avoided `SUMPRODUCT(COUNTIF(range,range))` for duplicates (O(n²)).

> Excel was used to profile quickly and surface the zero-balance group and the small product-count groups before they could distort the model.
