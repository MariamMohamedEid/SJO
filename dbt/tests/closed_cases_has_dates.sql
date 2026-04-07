-- tests/assert_closed_case_has_dates.sql
--
-- WHAT THIS TESTS:
--   Any case with a terminal status (JUDGED, SETTLED, WITHDRAWN,
--   DISMISSED) must have both a judgment_date and a closure_date.
--   A closed case without these dates is incomplete data.
--
-- TRINO NOTES:
--   * References stg_case_statuses (not the seed) because Trino
--     does not support dbt seeds the same way PostgreSQL does.
--     If you are using seeds via a separate connector, swap back
--     to {{ ref('case_statuses') }}.
--   * is_terminal is a BOOLEAN column in Parquet — Trino handles
--     it correctly. TRUE is explicit and unambiguous.
--   * judgment_date and closure_date were cast from VARCHAR to DATE
--     in stg_cases. NULL checks work on DATE columns in Trino.
--
-- Returns offending rows. dbt expects 0 rows.

select
    c.case_number,
    c.status_id,
    s.status_code,
    c.judgment_date,
    c.closure_date
from {{ ref('stg_cases') }}         c
join {{ ref('stg_case_statuses') }} s  on c.status_id = s.status_id
where s.is_terminal = TRUE
  and (
      c.closure_date  is null
   or c.judgment_date is null
  )