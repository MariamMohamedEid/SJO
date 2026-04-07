

select month
from "iceberg"."intermediate"."int_date_spine"
where month not in (
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
)

