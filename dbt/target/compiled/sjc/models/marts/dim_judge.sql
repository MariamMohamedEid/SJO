-- ============================================================
-- models/marts/dim_judge.sql
-- ============================================================
select
    lower(to_hex(md5(to_utf8(cast(coalesce(cast(judge_id as varchar), '_dbt_utils_surrogate_key_null_') as varchar)))))    as judge_key,
    judge_id,
    full_name                   as judge_name,
    full_name_en                as judge_name_en,
    appointment_date,
    rank,
    rank_en,
    specialization,             -- nullable
    specialization_en,          -- nullable
    court_level,
    assigned_court_id,
    assigned_circuit_id,
    true                        as is_current
from "iceberg"."intermediate"."int_judge_enriched"