
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    court_id as unique_field,
    count(*) as n_records

from "iceberg"."marts"."dim_court"
where court_id is not null
group by court_id
having count(*) > 1



  
  
      
    ) dbt_internal_test