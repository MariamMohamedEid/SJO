-- ============================================================
-- models/staging/stg_hearings.sql
-- ============================================================

with source as (
    select * from {{ source('sjc_source', 'hearings') }}
),

typed as (
    select
        hearing_id,
        case_id,
        CAST(from_unixtime(CAST(hearing_date AS BIGINT) / 1000) AS DATE) as hearing_date,
        hearing_type,
        hearing_type_en,
        judge_id,
        outcome,
        outcome_en,
        CAST(from_unixtime(CAST(next_hearing_date AS BIGINT) / 1000) AS DATE) as next_hearing_date,
        current_timestamp as _loaded_at
    from source
)

select *
from typed