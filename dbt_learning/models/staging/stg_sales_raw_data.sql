WITH sales_raw_source_data as (
    SELECT * FROM {{ source("raw_source", "raw_sales") }}
),

final as (
    SELECT * FROM sales_raw_source_data
    WHERE product_id is not NULL and quantity is not NULL
)

SELECT * FROM final