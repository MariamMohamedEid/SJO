
  
    

    create table "iceberg"."staging"."stg_courts__dbt_tmp"
      
      WITH (format = 'PARQUET',
  partitioning = ARRAY[])
    as (
      -- ============================================================
-- models/staging/stg_courts.sql
-- ============================================================

with source as (
    select * from "hive"."landing"."courts"
),

typed as (
    select
        court_id,
        court_name,
        court_name_en,
        court_level,
        wilayat_id,
        governorate_id,
        CAST(panel_size AS INTEGER) as panel_size,
        current_timestamp as _loaded_at
    from source
)

select *
from typed
    );

  