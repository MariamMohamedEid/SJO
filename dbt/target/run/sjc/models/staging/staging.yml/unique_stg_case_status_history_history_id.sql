
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    history_id as unique_field,
    count(*) as n_records

from "iceberg"."staging"."stg_case_status_history"
where history_id is not null
group by history_id
having count(*) > 1



  
  
      
    ) dbt_internal_test