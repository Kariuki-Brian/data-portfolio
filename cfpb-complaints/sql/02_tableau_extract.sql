-- 02_tableau_extract.sql
-- Builds the CSV that feeds the Tableau dashboard (Tableau Public can't connect to SQLite).
-- Same scope as 01_bank_scorecard.sql: 10 banks, complaints received 2023-11-01 onward.
-- One row per month x bank x product x issue x response x timely, with a complaint count.
-- Aggregating here shrinks ~444k complaints to a few tens of thousands of rows; Tableau sums them back up.
-- Rates (relief %, late per 10k) are NOT precomputed: they're calculated fields in Tableau, so they
-- stay correct at whatever level the view is filtered to (a rate of rates would be wrong).

WITH scoped AS (
    SELECT *
    FROM complaints_raw
    WHERE "Date received" >= '2023-11-01'
      AND "Company" IN ('DISCOVER BANK', 'CAPITAL ONE FINANCIAL CORPORATION', 'JPMORGAN CHASE & CO.',
                        'BANK OF AMERICA, NATIONAL ASSOCIATION', 'CITIBANK, N.A.', 'WELLS FARGO & COMPANY',
                        'SYNCHRONY FINANCIAL', 'AMERICAN EXPRESS COMPANY', 'U.S. BANCORP',
                        'BARCLAYS BANK DELAWARE')
)
SELECT
    substr("Date received", 1, 7) || '-01'                     AS month,      -- first day of the month
    CASE "Company"
        WHEN 'CAPITAL ONE FINANCIAL CORPORATION'     THEN 'Capital One'
        WHEN 'JPMORGAN CHASE & CO.'                  THEN 'JPMorgan Chase'
        WHEN 'BANK OF AMERICA, NATIONAL ASSOCIATION' THEN 'Bank of America'
        WHEN 'CITIBANK, N.A.'                        THEN 'Citibank'
        WHEN 'WELLS FARGO & COMPANY'                 THEN 'Wells Fargo'
        WHEN 'SYNCHRONY FINANCIAL'                   THEN 'Synchrony'
        WHEN 'AMERICAN EXPRESS COMPANY'              THEN 'American Express'
        WHEN 'DISCOVER BANK'                         THEN 'Discover'
        WHEN 'U.S. BANCORP'                          THEN 'U.S. Bank'
        WHEN 'BARCLAYS BANK DELAWARE'                THEN 'Barclays'
    END                                                        AS bank,
    "Product"                                                  AS product,
    "Issue"                                                    AS issue,
    "Company response to consumer"                             AS response,
    "Timely response?"                                         AS timely,
    COUNT(*)                                                   AS complaints
FROM scoped
GROUP BY 1, 2, 3, 4, 5, 6
ORDER BY 1, 2;
