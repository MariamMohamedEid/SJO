
  
    

    create table "iceberg"."marts"."dim_court"
      
      WITH (format = 'PARQUET',
  partitioning = ARRAY[])
    as (
      -- ============================================================
-- models/marts/dim_court.sql
-- ============================================================
-- Materialization: table
-- Grain: one row per court (SCD Type 1 — overwrite on change)
-- ============================================================

select
    lower(to_hex(md5(to_utf8(cast(coalesce(cast(court_id as varchar), '_dbt_utils_surrogate_key_null_') as varchar)))))    as court_key,
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
from "iceberg"."intermediate"."int_court_enriched"
    );

  