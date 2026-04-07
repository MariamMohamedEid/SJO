
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select day_name
from "iceberg"."intermediate"."int_date_spine"
where day_name is null



  
  
      
    ) dbt_internal_test