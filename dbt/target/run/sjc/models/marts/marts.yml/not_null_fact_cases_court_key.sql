
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select court_key
from "iceberg"."marts"."fact_cases"
where court_key is null



  
  
      
    ) dbt_internal_test