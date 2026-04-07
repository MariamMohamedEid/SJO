-- ============================================================
-- models/marts/dim_circuit.sql
-- ============================================================
select
    lower(to_hex(md5(to_utf8(cast(coalesce(cast(circuit_id as varchar), '_dbt_utils_surrogate_key_null_') as varchar)))))  as circuit_key,
    circuit_id,
    court_id,
    circuit_name,
    circuit_name_en,
    panel_type,
    panel_type_en,
    case_category,
    true                                                     as is_current
from "iceberg"."staging"."stg_circuits"