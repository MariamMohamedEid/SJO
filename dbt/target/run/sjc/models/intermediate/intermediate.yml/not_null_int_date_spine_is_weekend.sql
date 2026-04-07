
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select is_weekend
from "iceberg"."intermediate"."int_date_spine"
where is_weekend is null



  
  
      
    ) dbt_internal_test