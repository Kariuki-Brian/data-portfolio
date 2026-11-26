-- 01_chargeoffs_by_approval_year.sql
-- SQL exercise 2 (CTEs): share of funded SBA 7(a) loans charged off within 36 months of approval, by approval year.
-- Written by Brian Kariuki. Data: SBA 7(a) FOIA file, as of 2026-09-30, table loans_raw (949,395 loans).
--
-- Decisions:
--   * Funded loans = 'P I F' (paid in full), 'EXEMPT' (disbursed, still active; status withheld under FOIA)
--     and 'CHGOFF' (charged off). COMMIT (undisbursed) and CANCLD (cancelled) never received money.
--   * CHGOFF must be in the denominator: leaving it out inflates the rate and could push it past 100%.
--   * 'P I F' is stored with spaces.

-- Stage 0: profile LoanStatus

SELECT LoanStatus, Count(*) AS Loan_Count
FROM loans_raw
GROUP BY  LoanStatus
ORDER BY Loan_Count DESC
;

-- Stage 1: funded loans (expected count: 808,187)

WITH funded_loans AS (
    SELECT ApprovalFY, ApprovalDate, LoanStatus, ChargeOffDate
    FROM loans_raw
    WHERE LoanStatus IN ('P I F', 'EXEMPT', 'CHGOFF')
)
SELECT COUNT(*) FROM funded_loans;

-- Stage 2: flag loans charged off within 36 months of approval (expected: 0 = 796,230, 1 = 11,957)
-- Trap: loans never charged off store ChargeOffDate as an empty string '', not NULL (IS NULL returns 0).
-- SQLite sorts '' before every date, so a date check alone would flag all 765,431 PIF + EXEMPT loans.
-- 21 CHGOFF loans have no ChargeOffDate; counted as 0 (not within 36m). Negligible (21 of ~12k).

WITH funded_loans AS (
    SELECT ApprovalFY, ApprovalDate, LoanStatus, ChargeOffDate
    FROM loans_raw
    WHERE LoanStatus IN ('P I F', 'EXEMPT', 'CHGOFF')
),
flagged_loans AS (
    SELECT ApprovalFY, ApprovalDate, LoanStatus, ChargeOffDate,
           CASE
             WHEN LoanStatus = 'CHGOFF'
              AND ChargeOffDate <> ''
              AND ChargeOffDate <= date(ApprovalDate, '+36 months')
             THEN 1 ELSE 0
           END AS chgoff_36m
    FROM funded_loans
)
SELECT chgoff_36m, COUNT(*)
FROM flagged_loans
GROUP BY chgoff_36m;

-- Stage 3: 36-month charge-off rate by approval year (exported to data/chargeoffs_by_fy.csv)
-- Stage 4: fair comparison window
-- Data as of 2026-09-30. Only FY2010-FY2023 loans have all had a full 36 months.
-- FY2024-2026 kept but flagged as incomplete (greyed out in the dashboard), not dropped.

WITH funded_loans AS (
    SELECT ApprovalFY, ApprovalDate, LoanStatus, ChargeOffDate
    FROM loans_raw
    WHERE LoanStatus IN ('P I F', 'EXEMPT', 'CHGOFF')
),
flagged_loans AS (
    SELECT ApprovalFY, ApprovalDate, LoanStatus, ChargeOffDate,
           CASE
             WHEN LoanStatus = 'CHGOFF'
              AND ChargeOffDate <> ''
              AND ChargeOffDate <= date(ApprovalDate, '+36 months')
             THEN 1 ELSE 0
           END AS chgoff_36m
    FROM funded_loans
)
SELECT ApprovalFY,
       COUNT(*)                                       AS loans,
       SUM(chgoff_36m)                                AS chgoffs_36m,
       ROUND(100.0 * SUM(chgoff_36m) / COUNT(*), 2)   AS pct_chgoff_36m,
       CASE
         WHEN ApprovalFY <= 2023 THEN 'Full 36 months'
         ELSE 'Still maturing'
       END AS window_status
FROM flagged_loans
GROUP BY ApprovalFY
ORDER BY ApprovalFY;
