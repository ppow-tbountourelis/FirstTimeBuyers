
with tbl
as
(
    select order_id, 
           order_dt, 
           extract(year from order_dt) year,
           next_order_dt,
           trunc(next_order_dt) - trunc(order_dt) as days_to_next_order
           
      from mart_order
     where 1=1
       and order_number = 1
       and trunc(order_dt) between '01-JAN-2017' and '31-DEC-2019'
)
select year,
       count(*) orders, 
       sum(case when days_to_next_order is not null then 1 else 0 end) as second_order, 
       round(sum(case when days_to_next_order is not null then 1 else 0 end) / count(*), 3) as conv,   
       round(avg(days_to_next_order)),
       round(median(days_to_next_order)),
       
       sum(case when days_to_next_order <= 120 then 1 else 0 end)/ count(*) as percent_within_120_days
  
  from tbl
 group by year 
;



with tbl
as
(
    select order_id, 
           order_dt, 
           extract(year from order_dt) year,
           next_order_dt,
           trunc(order_dt) - trunc(prev_order_dt) as days_since_last_order
           
      from mart_order
     where 1=1
       and order_number = 2
       and trunc(order_dt) between '01-JAN-2017' and '31-DEC-2019'
)
select year,
       count(*) orders, 
       --sum(case when days_to_next_order is not null then 1 else 0 end) as second_order, 
       --round(sum(case when days_to_next_order is not null then 1 else 0 end) / count(*), 3) as conv,   
       round(avg(days_since_last_order)) as avg,
       round(median(days_since_last_order)) as median
       
       --sum(case when days_to_next_order <= 120 then 1 else 0 end)/ count(*) as percent_within_120_days
  
  from tbl
 group by year 
;