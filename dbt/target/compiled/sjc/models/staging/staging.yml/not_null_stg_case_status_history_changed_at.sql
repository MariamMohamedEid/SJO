
    
    



select changed_at
from "iceberg"."staging"."stg_case_status_history"
where changed_at is null


