{{ config(materialized='table') }}

with sales_aggregates as (
    select
        fs.customer_id,
        fs.transaction_date,
        count(fs.id) as total_purchases,
        sum(fs.amount_paid) as total_amount_spent,
        count(distinct fs.product_id) as nb_distinct_products_purchased,
        avg(fs.amount_paid) as avg_amount
    from
        {{ ref("fact_sales") }} fs
    group by
        fs.customer_id,
        fs.transaction_date
),
most_frequently_purchased_product as (
    select
        fs.customer_id,
        fs.transaction_date,
        fs.product_id,
        p.name as most_frequently_purchased_product,
        row_number() over (partition by fs.customer_id, fs.transaction_date order by count(fs.product_id) desc) as product_rank
    from
        {{ ref("fact_sales") }} fs
    join
        {{ ref("dim_product") }} p on fs.product_id = p.id
    group by
        fs.customer_id,
        fs.transaction_date,
        fs.product_id,
        p.name
),
payment_mode_aggregates as (
    select
        fs.customer_id,
        fs.transaction_date,
        fs.payment_mode,
        row_number() over (partition by fs.customer_id, fs.transaction_date order by count(fs.payment_mode) desc) as payment_mode_rank
    from
        {{ ref("fact_sales") }} fs
    group by
        fs.customer_id,
        fs.transaction_date,
        fs.payment_mode
)
select
    s.customer_id,
    concat(c.first_name, ' ', c.last_name) as full_name,
    s.transaction_date,
    s.total_purchases,
    s.total_amount_spent,
    s.nb_distinct_products_purchased,
    pm.payment_mode as most_frequent_payment_mode,
    s.avg_amount,
    mfp.most_frequently_purchased_product
from
    sales_aggregates s
left join
    (select customer_id, transaction_date, payment_mode from payment_mode_aggregates where payment_mode_rank = 1) pm
    on s.customer_id = pm.customer_id and s.transaction_date = pm.transaction_date
left join
    (select customer_id, transaction_date, most_frequently_purchased_product from most_frequently_purchased_product where product_rank = 1) mfp
    on s.customer_id = mfp.customer_id and s.transaction_date = mfp.transaction_date
join {{ source('processing', 'dim_customer') }} c on s.customer_id = c.id
order by
    s.transaction_date,
    s.customer_id
