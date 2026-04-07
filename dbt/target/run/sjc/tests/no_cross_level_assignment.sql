
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  -- tests/assert_no_cross_level_assignment.sql
--
-- WHAT THIS TESTS:
--   No case filed at a First Instance court should be assigned to
--   an Appeal or Supreme Court judge. This enforces the judicial
--   hierarchy rule: new filings always go to First Instance judges.
--
-- TRINO NOTES:
--   * String comparisons in Trino are case-sensitive by default.
--     'First Instance' must match exactly what is stored in court_level.
--     Verify the casing in your stg_courts and stg_judges models.
--   * judge_id in stg_cases may be NULL (unassigned cases). The inner
--     join on stg_judges naturally excludes those rows — only assigned
--     cases are checked. This is the correct behavior.
--   * If court_level values differ between stg_courts and stg_judges
--     due to upstream encoding differences, normalize them in staging
--     with UPPER() or explicit CASE statements before this test runs.
--
-- Returns violation rows. dbt expects 0 rows.

select
    c.case_number,
    c.court_id,
    c.judge_id,
    co.court_level      as case_court_level,
    j.court_level       as judge_court_level
from "iceberg"."staging"."stg_cases"     c
join "iceberg"."staging"."stg_courts"    co  on c.court_id = co.court_id
join "iceberg"."staging"."stg_judges"    j   on c.judge_id  = j.judge_id
where co.court_level = 'First Instance'
  and j.court_level != 'First Instance'
  
  
      
    ) dbt_internal_test