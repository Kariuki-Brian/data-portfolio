# Bank Complaints Relief Analysis

**Dashboard:** https://public.tableau.com/views/BankComplaintsReliefAnalysis/Dashboard1

## Business question
How do the largest U.S. banks and card issuers compare on consumer complaints: how many they get,
what people complain about, and how well they resolve them?

**Audience:** a bank's customer-experience or compliance team benchmarking itself against peers.

## Data
[CFPB Consumer Complaint Database](https://www.consumerfinance.gov/data-research/consumer-complaints/) (public).
Full file downloaded 2026-11-04: 18,908,088 complaints, 2011-12-01 to 2026-11-04, loaded into SQLite.

**Scope:** 442,699 complaints received 2023-11-01 to 2026-11-04 against 10 banks and card issuers:
Capital One, JPMorgan Chase, Bank of America, Citibank, Wells Fargo, Synchrony, American Express,
Discover, U.S. Bancorp and Barclays.

## Key findings
- **Relief rates vary about 10x across peers.** Citi closed 49.7% of complaints with monetary or non-monetary
  relief; Barclays closed 5.0%. Relief rate separates the banks far better than timely response does.
- **Timely response barely differs.** 7 of 10 banks responded on time to 99.99%+ of complaints. Synchrony (98.2%)
  and Bank of America (99.2%) were the exceptions.
- **A January 2025 spike traces to one bank.** Complaints jumped to 19,960 that month (vs. about 10-11k around it);
  Capital One alone had 7,601, concentrated in a two-day surge.

Full scorecard and supporting numbers: [findings.md](findings.md).

## Files
| File | What it does |
|---|---|
| [sql/01_bank_scorecard.sql](sql/01_bank_scorecard.sql) | One row per bank: complaint volume, timely-response rate and relief rate, with the reasoning for each definition |
| [sql/02_tableau_extract.sql](sql/02_tableau_extract.sql) | Aggregates the 10-bank scope into the extract that feeds the dashboard |
| [data/cfpb_bank_complaints.csv](data/cfpb_bank_complaints.csv) | That extract: monthly counts by bank, product, issue and outcome (31,976 rows) |

## Method notes
- Exact company names (`IN (...)`), not `LIKE`: `'%discover%'` also matches unrelated companies.
- Relief rate excludes complaints still "In progress": they have no outcome yet, and the open-case share differs by bank.
- Rates are calculated in Tableau, not precomputed in SQL, so they stay correct at any filter level.

## Caveats
Raw counts favor bigger banks; complaints are not normalized by customer count. The CFPB does not verify complaints.
The raw 11 GB database isn't in this repo. Download the source file from the link above to reproduce.
