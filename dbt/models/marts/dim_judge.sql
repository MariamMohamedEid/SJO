-- ============================================================
-- models/marts/dim_judge.sql
-- ============================================================
select
    {{ dbt_utils.generate_surrogate_key(['judge_id']) }}    as judge_key,
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
from {{ ref('int_judge_enriched') }}