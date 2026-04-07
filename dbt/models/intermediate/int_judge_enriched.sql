-- ============================================================
-- models/intermediate/int_judge_enriched.sql
-- ============================================================

with judges as (
    select * from {{ ref('stg_judges') }}
),
assignments as (
    select
        judge_id,
        court_id   as assigned_court_id,
        circuit_id as assigned_circuit_id,
        assigned_from,
        assigned_to,
        role
    from {{ ref('stg_judge_court_assignments') }}   
    where assigned_to is null
)
select
    j.judge_id,
    j.national_id,
    j.full_name,
    j.full_name_en,
    j.appointment_date,
    j.rank,
    j.rank_en,
    j.specialization,
    j.specialization_en,
    j.court_level,
    a.assigned_court_id,
    a.assigned_circuit_id,
    a.assigned_from,
    a.role as assignment_role
from judges j
left join assignments a
    on j.judge_id = a.judge_id