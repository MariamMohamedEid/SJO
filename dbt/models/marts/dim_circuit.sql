-- ============================================================
-- models/marts/dim_circuit.sql
-- ============================================================
select
    {{ dbt_utils.generate_surrogate_key(['circuit_id']) }}  as circuit_key,
    circuit_id,
    court_id,
    circuit_name,
    circuit_name_en,
    panel_type,
    panel_type_en,
    case_category,
    true                                                     as is_current
from {{ ref('stg_circuits') }}