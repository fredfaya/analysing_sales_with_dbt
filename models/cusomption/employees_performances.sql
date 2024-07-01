{{ config(materialized='table') }}

with daily_employee_sales as (
    select
        fs.employee_id,
        fs.transaction_date,
        count(fs.id) as total_sales,
        count(distinct fs.customer_id) as distinct_customers_served,
        sum(fs.amount_paid) as total_revenue
    from
        {{ ref("fact_sales") }} fs
    group by
        fs.employee_id,
        fs.transaction_date
)
select
    des.employee_id,
    e.first_name,
    e.last_name,
    des.transaction_date,
    des.total_sales,
    des.distinct_customers_served,
    des.total_revenue
from
    daily_employee_sales des
join
    {{ ref("dim_employee") }} e on des.employee_id = e.id
order by
    des.transaction_date,
    des.total_sales desc
