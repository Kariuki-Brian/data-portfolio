# Findings: 36-month charge-off rate by approval year

Source: [sql/01_chargeoffs_by_approval_year.sql](sql/01_chargeoffs_by_approval_year.sql), Stage 3 and 4 output.
Data: SBA 7(a) FOIA file as of 2026-09-30. Funded loans only (paid in full, EXEMPT, charged off).

| Approval FY | Funded loans | Charged off within 36 months | Rate | Window |
|---|---:|---:|---:|---|
| 2010 | 39,913 | 936 | 2.35% | Full 36 months |
| 2011 | 45,628 | 694 | 1.52% | Full 36 months |
| 2012 | 38,889 | 530 | 1.36% | Full 36 months |
| 2013 | 40,416 | 512 | 1.27% | Full 36 months |
| 2014 | 45,962 | 637 | 1.39% | Full 36 months |
| 2015 | 55,421 | 912 | 1.65% | Full 36 months |
| 2016 | 56,789 | 1,149 | 2.02% | Full 36 months |
| 2017 | 56,079 | 1,059 | 1.89% | Full 36 months |
| 2018 | 54,195 | 902 | 1.66% | Full 36 months |
| 2019 | 45,671 | 696 | 1.52% | Full 36 months |
| 2020 | 36,464 | 299 | 0.82% | Full 36 months |
| 2021 | 45,174 | 330 | 0.73% | Full 36 months |
| 2022 | 41,776 | 793 | 1.90% | Full 36 months |
| 2023 | 50,251 | 1,448 | 2.88% | Full 36 months |
| 2024 | 60,137 | 880 | 1.46% | Still maturing |
| 2025 | 60,763 | 177 | 0.29% | Still maturing |
| 2026 | 34,659 | 3 | 0.01% | Still maturing |
| **All years** | **808,187** | **11,957** | | |
| **FY2010 to 2023** | **652,628** | **10,897** | **1.67%** | |

## Checks
- Funded loans add up to 808,187, which matches the Stage 1 count.
- Flagged and unflagged loans add up to 808,187 (796,230 + 11,957).
- 11,957 is below the 42,756 total charge-offs, as it should be: the rest charged off after month 36.
  Before the empty-date trap was fixed, the count would have been far above that total.

## Pattern in the complete years
The rate fell from 2.35% in FY2010 to 1.27% in FY2013, rose to 2.02% in FY2016, and eased to 1.52% in FY2019.
It dropped to 0.82% and 0.73% in FY2020 and FY2021, then climbed to 1.90% in FY2022 and 2.88% in FY2023.

## Open questions (not yet investigated)
- What explains the FY2020 to 2021 low and the FY2023 high? Nothing here claims a cause.
- Does the pattern hold by lender, industry (NAICS) or business age? That's planned as a next exercise.
