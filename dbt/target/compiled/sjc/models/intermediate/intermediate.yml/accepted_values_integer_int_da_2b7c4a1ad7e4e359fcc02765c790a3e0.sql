

select year
from "iceberg"."intermediate"."int_date_spine"
where year not in (
    2020, 2021, 2022, 2023, 2024, 2025, 2026, 2027, 2028, 2029, 2030
)

