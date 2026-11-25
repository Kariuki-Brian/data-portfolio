-- 01_bank_scorecard.sql
-- Exercise 1: one row per bank, complaints received 2023-11-01 onward (data through 2026-11-04).
-- Written by Brian Kariuki, 2026-11-05. Checked against complaints.db; results in findings.md.
--
-- Decisions:
--   * Exact company names with IN (...), not LIKE ('%discover%' also matches "Discovery Auto Sales LLC").
--   * pct_relief denominator excludes 'In progress': no outcome yet, and the open-case share differs
--     by bank (Synchrony 4.1% vs Discover 0%), so counting them as "no relief" biases the comparison.
--   * 'Untimely response' (10 rows) stays in the denominator: it is a final status.
--   * 100.0 * forces decimal math (SQLite integer division would return 0).
--   * ELSE 0 in the relief numerator so a bank with zero relief shows 0.0, not NULL.

SELECT
    "Company",
    COUNT(*) AS "Complaints",
    SUM(CASE WHEN "Timely response?" = 'Yes' THEN 1 ELSE 0 END) AS "Timely_Count",
    ROUND(100.0 * SUM(CASE WHEN "Timely response?" = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 1) AS "pct_Timely",
    ROUND(100.0 *
        SUM(CASE WHEN "Company response to consumer" IN ('Closed with monetary relief',
                                                         'Closed with non-monetary relief')
                 THEN 1 ELSE 0 END)
        / SUM(CASE WHEN "Company response to consumer" IN ('Closed with monetary relief',
                                                           'Closed with non-monetary relief',
                                                           'Untimely response',
                                                           'Closed with explanation')
                   THEN 1 END)
    , 1) AS "pct_relief"
FROM "complaints_raw"
WHERE "Date received" >= '2023-11-01'
  AND "Company" IN ('DISCOVER BANK', 'CAPITAL ONE FINANCIAL CORPORATION', 'JPMORGAN CHASE & CO.',
                    'BANK OF AMERICA, NATIONAL ASSOCIATION', 'CITIBANK, N.A.', 'WELLS FARGO & COMPANY',
                    'SYNCHRONY FINANCIAL', 'AMERICAN EXPRESS COMPANY', 'U.S. BANCORP',
                    'BARCLAYS BANK DELAWARE')
GROUP BY "Company"
ORDER BY "Complaints" DESC;

-- Equivalent pct_relief written with COUNT (NULLs created on purpose by a CASE with no ELSE):
--   ROUND(100.0 *
--       SUM(CASE WHEN "Company response to consumer" IN ('Closed with monetary relief',
--                                                        'Closed with non-monetary relief') THEN 1 ELSE 0 END)
--       / COUNT(CASE WHEN "Company response to consumer" <> 'In progress' THEN 1 END)
--   , 1) AS "pct_relief"
