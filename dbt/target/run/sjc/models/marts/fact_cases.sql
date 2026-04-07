
  
    

    create table "iceberg"."marts"."fact_cases"
      
      WITH (format = 'PARQUET',
  partitioning = ARRAY[])
    as (
      -- ============================================================
-- models/marts/fact_cases.sql
-- ============================================================
-- Materialization: table (development)
-- Grain: one row per case
--
-- TO SWITCH TO INCREMENTAL post-development:
--   1. Change config to:
--        
--   2. Add before the final FROM:
--        
-- ============================================================

with enriched as (
    select * from "iceberg"."intermediate"."int_case_enriched"
),

dim_court as (
    select court_key, court_id
    from "iceberg"."marts"."dim_court"
),

dim_circuit as (
    select circuit_key, circuit_id
    from "iceberg"."marts"."dim_circuit"
),

dim_judge as (
    select judge_key, judge_id
    from "iceberg"."marts"."dim_judge"
),

dim_status as (
    select status_key, status_id
    from "iceberg"."marts"."dim_case_status"
)
select
    -- Surrogate primary key for the fact table
    lower(to_hex(md5(to_utf8(cast(coalesce(cast(e.case_number as varchar), '_dbt_utils_surrogate_key_null_') as varchar)))))   as case_key,
    -- Degenerate dimension (the human-readable case identifier)
    e.case_number,
    e.case_year,
    -- Surrogate foreign keys to dimensions
    dc.court_key,
    dci.circuit_key,
    dj.judge_key,
    ds.status_key,
    -- Date keys — all role-play against dim_date
    e.filing_date_key,
    e.first_hearing_date_key,
    e.judgment_date_key,
    e.closure_date_key,
    -- Denormalized partition / filter helpers
    e.court_level,
    e.case_category,
    e.status_category,
    -- Duration measures (days)
    e.case_duration_days,
    e.days_to_first_hearing,
    -- SLA measures
    e.is_sla_breached,
    e.sla_target_days,
    -- Financial measures (OMR)
    e.judicial_fees_amount,
    e.execution_revenue,
    e.claim_amount,
    -- ETL metadata
    current_date    as etl_load_date

from enriched               e
inner join dim_court        dc   on e.court_id  = dc.court_id
inner join dim_circuit      dci  on e.circuit_id = dci.circuit_id
left  join dim_judge        dj   on e.judge_id   = dj.judge_id
inner join dim_status       ds   on e.status_id  = ds.status_id
    );

  