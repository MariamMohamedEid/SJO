
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select filing_date_key
from "iceberg"."marts"."fact_cases"
where filing_date_key is null



  
  
      
    ) dbt_internal_test