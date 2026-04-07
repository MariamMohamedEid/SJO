
  
    

    create table "iceberg"."staging"."stg_judges__dbt_tmp"
      
      WITH (format = 'PARQUET',
  partitioning = ARRAY[])
    as (
      -- models/staging/stg_judges.sql
with source as (
    select * from "hive"."landing"."judges"
),

typed as (
    select
        judge_id,
        national_id,
        first_name,
        last_name,
        full_name,
        first_name_en,
        last_name_en,
        full_name_en,
        CAST(from_unixtime(CAST(appointment_date AS BIGINT) / 1000) AS DATE) as appointment_date,
        rank,
        rank_en,
        specialization,
        specialization_en,
        court_level,
        CAST(from_unixtime(CAST(created_at AS BIGINT) / 1000) AS TIMESTAMP) as created_at,
        CAST(from_unixtime(CAST(updated_at AS BIGINT) / 1000) AS TIMESTAMP) as updated_at,
        current_timestamp                 as _loaded_at
    from source
)

select * from typed
    );

  