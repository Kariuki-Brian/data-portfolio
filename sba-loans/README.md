# SBA 7(a) Small-Business Loans: Early Charge-Off Rates

**Dashboard:** in progress (Tableau)

## Business question
Of the small-business loans the SBA's 7(a) program actually funded, what share went bad (were charged off)
within 36 months of approval, and how does that change by approval year?

**Audience:** a lender's credit-risk team, or anyone judging how risky a given year of SBA lending was.

## Data
[SBA 7(a) & 504 FOIA loan data](https://data.sba.gov/dataset/7-a-504-foia) (public), loan-level file as of
2026-09-30: 949,395 7(a) loans approved FY2010 to FY2026 (2009-10-01 to 2026-09-30), loaded into SQLite.

**Scope:** 808,187 funded loans, meaning loans whose money was disbursed:
- paid in full: 472,321
- EXEMPT (disbursed, status withheld under FOIA): 293,110
- charged off: 42,756

Cancelled (119,685) and undisbursed (21,523) loans are excluded, because no money went out.

## Key findings
- **About 1 in 60 funded loans charged off within 36 months.** Across FY2010 to FY2023, the years where every
  loan has had a full 36 months, 10,897 of 652,628 funded loans did (1.67%).
- **Early charge-off rates swung about 4x by approval year.** The low was FY2021 at 0.73%. The high was FY2023
  at 2.88%, the highest year in the window.
- **Recent years look safe only because they're young.** FY2026 shows 0.01% and FY2025 shows 0.29%, but most
  of those loans are months old. They're kept in the data and flagged "Still maturing" rather than compared
  with complete years.

Year-by-year table: [findings.md](findings.md).

## Files
| File | What it does |
|---|---|
| [sql/01_chargeoffs_by_approval_year.sql](sql/01_chargeoffs_by_approval_year.sql) | Builds the metric in stages with CTEs: profile loan status, define funded loans, flag 36-month charge-offs, rate by approval year, flag incomplete years |
| [data/chargeoffs_by_fy.csv](data/chargeoffs_by_fy.csv) | Output: one row per approval year with loans, 36-month charge-offs, rate and window status (17 rows) |

## Method notes
- **Charged-off loans stay in the denominator.** Dropping them would inflate the rate and could push it past 100%.
- **Empty dates aren't NULL.** Loans that never charged off store `ChargeOffDate` as an empty string, and
  SQLite sorts an empty string before every date. A date-only check would have flagged all 765,431 paid-in-full
  and EXEMPT loans as charged off. The flag therefore requires `LoanStatus = 'CHGOFF'` and a non-empty date.
- **21 charged-off loans have no charge-off date.** They're counted as not charged off within 36 months.
  That's 21 of about 12,000, so the effect is negligible.
- **Fair comparison window.** Fiscal years end September 30 and the data ends 2026-09-30. FY2023 is therefore the last
  year in which every loan has had a full 36 months. FY2024 to FY2026 are labelled "Still maturing".

## Caveats
- **Rates are a floor.** EXEMPT loans have their status withheld, so any charge-offs among them aren't visible.
- **No causes claimed.** The FY2020 to 2021 dip and the FY2023 high are reported as they appear, without
  explanation. Checking possible causes is a next step.
- **Data not in this repo.** The raw files and database aren't included, partly because they name individual
  borrowers. Only yearly totals are published here. Download the source from the link above to reproduce.
