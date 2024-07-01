{{ config(materialized='table') }}

with product_sales as (
    select
        fs.product_id,
        p.name as product_name,
        fs.transaction_date,
        count(fs.id) as total_sales
    from
        {{ ref("fact_sales") }} fs
    left join 
        {{ ref("dim_product") }} p on fs.product_id = p.id
    group by
        fs.product_id,
        p.name,
        fs.transaction_date
),
product_sales_ranked as (
    select
        product_id,
        product_name,
        transaction_date,
        total_sales,
        row_number() over (partition by transaction_date order by total_sales desc) as product_rank
    from
        product_sales
)

select * from product_sales_ranked order by transaction_date, product_rank
