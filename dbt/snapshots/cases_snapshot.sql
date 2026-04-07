-- snapshots/cases_snapshot.sql
--
-- WHY THIS EXISTS:
--   The cases table changes over time — status updates, judge
--   reassignments, date completions. This snapshot captures the
--   full state of each case row at every dbt run, enabling:
--     * "What was the status of case X on date Y?"
--     * Historical workload analysis per judge
--     * SLA tracking that accounts for status changes over time
--
-- STRATEGY: timestamp
--   Uses updated_at from the source table. When updated_at changes,
--   dbt closes the old record (dbt_valid_to) and inserts a new one.
--
-- HOW TO QUERY:
--   Current state only:
--     SELECT * FROM dbt_dev_snapshots.cases_snapshot
--     WHERE dbt_valid_to IS NULL
--
--   State as of a specific date:
--     SELECT * FROM dbt_dev_snapshots.cases_snapshot
--     WHERE dbt_valid_from <= '2024-06-01'
--       AND (dbt_valid_to > '2024-06-01' OR dbt_valid_to IS NULL)

{% snapshot cases_snapshot %}

{{
    config(
        target_schema = 'snapshots',
        unique_key    = 'case_id',
        strategy      = 'timestamp',
        updated_at    = 'updated_at',
    )
}}

select
    case_id,
    case_number,
    case_year,
    court_id,
    circuit_id,
    judge_id,
    status_id,
    filing_date,
    first_hearing_date,
    judgment_date,
    closure_date,
    judicial_fees_amount,
    execution_revenue,
    claim_amount,
    updated_at
from {{ ref('stg_cases') }}

{% endsnapshot %}