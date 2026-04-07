-- ============================================================
-- models/staging/stg_case_status_history.sql
-- ============================================================

with source as (
    select * from {{ source('sjc_source', 'case_status_history') }}
),

typed as (
    select
        history_id,
        case_id,
        status_id,

        -- Epoch → TIMESTAMP
        CASE 
            WHEN changed_at IS NOT NULL 
            THEN CAST(from_unixtime(CAST(changed_at AS BIGINT) / 1000) AS TIMESTAMP)
        END as changed_at,

        changed_by,
        current_timestamp as _loaded_at

    from source
)

select *
from typed