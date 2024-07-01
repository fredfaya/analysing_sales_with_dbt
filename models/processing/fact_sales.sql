select
    id,
    customer_id,
    product_id,
    employee_id,
    quantity,
    total_amount,
    total_discount,
    amount_paid,
    payment_mode,
    transaction_date
from
    {{ source('landing', 'sales') }}


