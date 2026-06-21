WITH customers_raw_source_data as (
    SELECT * FROM {{ source("raw_source", "customers") }}
),

final as (
    SELECT * FROM customers_raw_source_data
)

SELECT * FROM final