-- tests/assert_judge_single_court.sql
--
-- WHAT THIS TESTS:
--   A judge should have at most one active (current) court assignment.
--   An active assignment means assigned_to has no end date.
--   If a judge appears more than once with no end date, they are
--   simultaneously assigned to multiple courts — a violation.
--
-- TRINO NOTES:
--   * assigned_to arrived as VARCHAR through NiFi/Parquet landing.
--     Depending on how NiFi serialized NULLs, the column may contain:
--       - SQL NULL  → use "assigned_to IS NULL"
--       - Empty string ''  → use "assigned_to = ''"
--     We guard BOTH cases with an OR to be safe across serialization
--     variations. If you have confirmed NiFi writes proper NULLs,
--     you can remove the empty-string branch.
--   * References stg_judge_court_assignment (the staged view) rather
--     than the raw source so the varchar→date cast is already applied.
--
-- Returns offending judge_ids. dbt expects 0 rows.

select
    judge_id,
    count(*) as active_assignment_count
from {{ ref('stg_judge_court_assignment') }}
where assigned_to is null
   or assigned_to = ''
group by judge_id
having count(*) > 1