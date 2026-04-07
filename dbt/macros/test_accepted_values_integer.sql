{% test accepted_values_integer(model, column_name, values) %}

select {{ column_name }}
from {{ model }}
where {{ column_name }} not in (
    {{ values | join(', ') }}
)

{% endtest %}
