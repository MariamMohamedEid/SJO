
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  -- tests/assert_closure_date_after_filing_date.sql
--
-- WHAT THIS TESTS:
--   If a case has a closure_date, it must be on or after the filing_date.
--   A closure_date before the filing_date is logically impossible and
--   indicates a data quality issue in the source or NiFi pipeline.
--
-- TRINO NOTES:
--   * Both filing_date and closure_date were cast from VARCHAR to DATE
--     in stg_cases using TRY_CAST or CAST. This test assumes that cast
--     succeeded — rows where the cast failed would have produced NULLs
--     which are excluded by the WHERE clause naturally.
--   * DATE comparison with < works correctly in Trino on DATE columns.
--   * We skip rows where closure_date IS NULL because those are open
--     cases and have no violation to check.
--   * We also skip rows where filing_date IS NULL (should not happen
--     since filing_date is NOT NULL in source, but defensive coding
--     avoids spurious test failures if a bad row slips through).
--
-- Returns offending rows. dbt expects 0 rows.

select
    case_number,
    filing_date,
    closure_date,
    date_diff('day', filing_date, closure_date)  as days_difference
from "iceberg"."staging"."stg_cases"
where closure_date  is not null
  and filing_date   is not null
  and closure_date  < filing_date
  
  
      
    ) dbt_internal_test