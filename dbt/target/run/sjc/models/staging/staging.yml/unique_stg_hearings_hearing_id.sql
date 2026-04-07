
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    hearing_id as unique_field,
    count(*) as n_records

from "iceberg"."staging"."stg_hearings"
where hearing_id is not null
group by hearing_id
having count(*) > 1



  
  
      
    ) dbt_internal_test