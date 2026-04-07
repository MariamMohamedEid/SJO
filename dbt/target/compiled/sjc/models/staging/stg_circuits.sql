-- ============================================================
-- models/staging/stg_circuits.sql
-- ============================================================

with source as (
    select * from "hive"."landing"."circuits"
),

typed as (
    select
        circuit_id,
        court_id,
        circuit_name,
        circuit_name_en,
        panel_type,         -- 'فردي' | 'ثلاثي' | 'خماسي'
        panel_type_en,      -- 'Single' | 'Panel' | 'Full Bench'
        case_category,
        current_timestamp as _loaded_at
    from source
)

select *
from typed