-- ============================================================
-- models/marts/dim_case_status.sql
-- ============================================================
select
    lower(to_hex(md5(to_utf8(cast(coalesce(cast(status_id as varchar), '_dbt_utils_surrogate_key_null_') as varchar)))))   as status_key,
    status_id,
    status_code,
    status_name,
    status_name_en,
    status_category,
    is_terminal
from "iceberg"."staging"."case_statuses"     -- seed