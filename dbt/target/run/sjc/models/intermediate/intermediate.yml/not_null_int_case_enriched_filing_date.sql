
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select filing_date
from "iceberg"."intermediate"."int_case_enriched"
where filing_date is null



  
  
      
    ) dbt_internal_test