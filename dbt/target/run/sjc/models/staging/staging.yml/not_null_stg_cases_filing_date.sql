
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select filing_date
from "iceberg"."staging"."stg_cases"
where filing_date is null



  
  
      
    ) dbt_internal_test