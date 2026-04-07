
  
    

    create table "iceberg"."marts"."dim_date"
      
      WITH (format = 'PARQUET',
  partitioning = ARRAY[])
    as (
      -- ============================================================
-- models/marts/dim_date.sql
-- ============================================================
select * from "iceberg"."intermediate"."int_date_spine"
    );

  