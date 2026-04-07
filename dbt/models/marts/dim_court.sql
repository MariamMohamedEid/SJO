-- ============================================================
-- models/marts/dim_court.sql
-- ============================================================
-- Materialization: table
-- Grain: one row per court (SCD Type 1 — overwrite on change)
-- ============================================================

select
    {{ dbt_utils.generate_surrogate_key(['court_id']) }}    as court_key,
    court_id,
    court_name,
    court_name_en,
    court_level,
    panel_size,
    wilayat_id,
    wilayat_name,
    wilayat_name_en,
    governorate_id,
    governorate_name,
    governorate_name_en,
    governorate_code,
    true                                                     as is_current
from {{ ref('int_court_enriched') }}