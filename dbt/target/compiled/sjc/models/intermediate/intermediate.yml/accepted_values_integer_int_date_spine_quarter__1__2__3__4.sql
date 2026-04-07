

select quarter
from "iceberg"."intermediate"."int_date_spine"
where quarter not in (
    1, 2, 3, 4
)

