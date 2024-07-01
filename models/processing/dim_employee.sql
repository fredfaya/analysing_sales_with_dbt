with duplicated_employees as (
    select
    employee_id as id,
    employee_first_name as first_name,
    employee_last_name as last_name,
    employee_contact_id as contact_id,
    employee_email as email,
    employee_phone as phone,
    employee_address as address,
    employee_department as department,
    employee_salary as salary,
    employee_joining_date as joining_date,
    employee_last_working_date as last_working_date
from
    {{ source('landing', 'sales') }}
)
select distinct * from duplicated_employees
