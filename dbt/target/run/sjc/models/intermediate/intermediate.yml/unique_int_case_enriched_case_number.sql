
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    case_number as unique_field,
    count(*) as n_records

from "iceberg"."intermediate"."int_case_enriched"
where case_number is not null
group by case_number
having count(*) > 1



  
  
      
    ) dbt_internal_test