-- ============================================================
-- models/marts/dim_case_status.sql
-- ============================================================
select
    {{ dbt_utils.generate_surrogate_key(['status_id']) }}   as status_key,
    status_id,
    status_code,
    status_name,
    status_name_en,
    status_category,
    is_terminal
from {{ ref('case_statuses') }}     -- seed