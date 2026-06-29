{% macro pence_to_pounds(column) %}
    round(cast({{ column }} as numeric) / 100.0, 2)
{% endmacro %}
