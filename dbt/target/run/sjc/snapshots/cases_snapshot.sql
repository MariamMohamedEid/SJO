
      
  
    

    create table "iceberg"."snapshots"."cases_snapshot"
      
      
    as (
      
    

    select *,
        lower(to_hex(md5(to_utf8(concat(coalesce(cast(case_id as varchar), ''), '|',coalesce(cast(updated_at as varchar), '')))))) as dbt_scd_id,
        updated_at as dbt_updated_at,
        updated_at as dbt_valid_from,
        
  
  coalesce(nullif(updated_at, updated_at), null)
  as dbt_valid_to
from (
        



select
    case_id,
    case_number,
    case_year,
    court_id,
    circuit_id,
    judge_id,
    status_id,
    filing_date,
    first_hearing_date,
    judgment_date,
    closure_date,
    judicial_fees_amount,
    execution_revenue,
    claim_amount,
    updated_at
from "iceberg"."staging"."stg_cases"

    ) sbq



    );

  
  