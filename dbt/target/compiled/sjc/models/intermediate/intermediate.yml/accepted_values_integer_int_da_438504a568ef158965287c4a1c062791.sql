

select day_of_week
from "iceberg"."intermediate"."int_date_spine"
where day_of_week not in (
    1, 2, 3, 4, 5, 6, 7
)

