with duplicated_products as (
    select
    product_id as id,
    product_name as name,
    product_price as price,
    brand_name as brand,
    product_discount as discount,
    category_id,
    description,
    supplier,
    department,
    brand_description,
    brand_headquarters,
    brand_employees_number
from
    {{ source('landing', 'sales') }}

)
select distinct * from duplicated_products