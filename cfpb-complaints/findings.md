# Findings — CFPB complaints

Real numbers only, each with the query that produced it (`sql/`).

- Since 2023-11-01, ~86% of all CFPB complaints (12.7M of 14.6M) name one of the three credit bureaus.
- Timely response rate, 10 banks, complaints received 2023-11-01 to 2026-11-04 (query: `sql/01_bank_scorecard.sql`):
  7 of 10 are at 99.99%+ (Chase, Discover, U.S. Bancorp, Barclays at 100%; Capital One 4 late of 87,177).
  The exceptions: Synchrony 98.2% (682 late of 38,931), Bank of America 99.2% (424 late), American Express 99.5% (140 late).
  Rounded to 1 decimal, Capital One/Citi/Wells all display 100.0 despite having late responses.
- Late responses per 10,000 complaints (same scope): Synchrony 175.2 · Bank of America 75.3 · American Express 45.4 ·
  Wells Fargo 0.9 · Capital One 0.5 · Citibank 0.2 · Chase, Discover, U.S. Bancorp, Barclays 0.
  Synchrony's late rate is ~2.3x Bank of America's and ~4x Amex's.
- **Bank scorecard** (`sql/01_bank_scorecard.sql`), complaints received 2023-11-01 to 2026-11-04.
  Relief rate = closed with monetary or non-monetary relief ÷ closed complaints (In progress excluded):

  | Company | Complaints | pct_timely | pct_relief |
  |---|---|---|---|
  | Capital One | 87,177 | 100.0 | 17.7 |
  | JPMorgan Chase | 68,916 | 100.0 | 15.9 |
  | Bank of America | 56,280 | 99.2 | 31.4 |
  | Citibank | 56,157 | 100.0 | 49.7 |
  | Wells Fargo | 56,040 | 100.0 | 20.9 |
  | Synchrony | 38,931 | 98.2 | 21.8 |
  | American Express | 30,830 | 99.5 | 28.0 |
  | Discover | 18,339 | 100.0 | 28.7 |
  | U.S. Bancorp | 16,748 | 100.0 | 34.8 |
  | Barclays | 13,281 | 100.0 | 5.0 |

  Relief rate varies ~10x across peers: Citi resolves ~half of closed complaints with relief, Barclays 1 in 20.
  This KPI separates the banks; timely response mostly doesn't.
