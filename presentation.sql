-- Overall Statistics --
select count(*), 
       round(avg(outcome_2), 2) second_order
       
  from mart_prediction_1
 where 1=1
   and trunc(order_dt) between '01-JAN-2018' and '31-DEC-2018'
  ;

------------------------------------------------------------------------------------------------
-- Profiles
------------------------------------------------------------------------------------------------
select profiledesc, 
       count(*) cnt, 
       round(avg(outcome_2), 2) outcome 
  
  from mart_prediction_1
 where 1=1 
   and trunc(order_dt) between '01-JAN-2018' and '31-DEC-2018'
 group by profiledesc
 order by outcome desc
;    

------------------------------------------------------------------------------------------------
-- Quarters
------------------------------------------------------------------------------------------------
select quarter, 
       count(*) cnt, 
       round(avg(outcome_2), 2) outcome 
  
  from mart_prediction_1
 where 1=1 
   and trunc(order_dt) between '01-JAN-2018' and '31-DEC-2018'
 group by quarter
 order by quarter asc
;   

------------------------------------------------------------------------------------------------
-- Channel
------------------------------------------------------------------------------------------------
with tbl
as
(
    select new_channel, 
           outcome_2,
           case 
               when new_channel not in ('Affiliate', 'Fed Gov Direct') then 'Other'
               when new_channel is null then 'Other'
               else new_channel
           end as new_channel_v2
          
      from mart_prediction_1
     where 1=1 
       and trunc(order_dt) between '01-JAN-2018' and '31-DEC-2018'
)

select new_channel_v2,
       count(*),
       round(avg(outcome_2), 2)
       
  from tbl
 where 1=1
 group by new_channel_v2
;

------------------------------------------------------------------------------------------------
-- Month
------------------------------------------------------------------------------------------------
with tbl
as
(
    select new_channel, 
           outcome_2,
           extract(month from order_dt) mon
          
      from mart_prediction_1
     where 1=1 
       and trunc(order_dt) between '01-JAN-2018' and '31-DEC-2018'
)

select mon,
       count(*),
       round(avg(outcome_2), 2)
       
  from tbl
 where 1=1
 group by mon
 order by mon
; 
 
 
------------------------------------------------------------------------------------------------
-- Catalogue
------------------------------------------------------------------------------------------------
select * from mart_prediction_1;
with tbl
as
(
    select new_channel, 
           outcome_2,
           USERGROUP_V2
          
      from mart_prediction_1
     where 1=1 
       and trunc(order_dt) between '01-JAN-2018' and '31-DEC-2018'
)

select USERGROUP_V2,
       count(*),
       round(avg(outcome_2), 2)
       
  from tbl
 where 1=1
 group by USERGROUP_V2
 order by USERGROUP_V2
;  
 
 
------------------------------------------------------------------------------------------------
-- Spending Limit
------------------------------------------------------------------------------------------------
select median(SPENDING_LIMIT_INITIAL_V2) from mart_prediction_1;
with tbl
as
(
    select SPENDING_LIMIT_INITIAL_V2, 
           outcome_2,
           case 
               when SPENDING_LIMIT_INITIAL_V2 is null then 0
               when SPENDING_LIMIT_INITIAL_V2 <= 1000 then 1
               when SPENDING_LIMIT_INITIAL_V2 <= 2000 then 2
               when SPENDING_LIMIT_INITIAL_V2 <= 3000 then 3
               when SPENDING_LIMIT_INITIAL_V2 <= 4000 then 4
               else 5
           end     SPENDING_LIMIT_INITIAL_V3
          
          
      from mart_prediction_1
     where 1=1 
       and trunc(order_dt) between '01-JAN-2018' and '31-DEC-2018'
)

select SPENDING_LIMIT_INITIAL_V3,
       count(*),
       round(avg(outcome_2), 2)
       
  from tbl
 where 1=1
 group by SPENDING_LIMIT_INITIAL_V3
 order by SPENDING_LIMIT_INITIAL_V3
;   
 
 
------------------------------------------------------------------------------------------------
-- Time since registration
------------------------------------------------------------------------------------------------
select * from mart_prediction_1;
with tbl
as
(
    select outcome_2,
           case 
               when TIME_BETWEEN_REG_FIRST <= 2 then 1
               when TIME_BETWEEN_REG_FIRST <= 48 then 2
               when TIME_BETWEEN_REG_FIRST <= 300 then 3
               else 4
           end TIME_BETWEEN_REG_FIRST_V2
          
          
      from mart_prediction_1
     where 1=1 
       and trunc(order_dt) between '01-JAN-2018' and '31-DEC-2018'
)

select TIME_BETWEEN_REG_FIRST_V2,
       count(*),
       round(avg(outcome_2), 2)
       
  from tbl
 where 1=1
 group by TIME_BETWEEN_REG_FIRST_V2
 order by TIME_BETWEEN_REG_FIRST_V2
;    
 
 
------------------------------------------------------------------------------------------------
-- Departments
------------------------------------------------------------------------------------------------  
select 'Electronics' as dept,
       is_dept_electronics bin, 
       count(*) cnt, 
       round(avg(outcome_2), 2) outcome 
  
  from mart_prediction_1
 where 1=1 
 group by is_dept_electronics
 union all
select 'Furniture' as dept,
       is_dept_furniture bin, 
       count(*) cnt, 
       round(avg(outcome_2), 2) outcome 
  
  from mart_prediction_1
 where 1=1 
 group by is_dept_furniture
 union all 
select 'Computers' as dept,
       IS_DEPT_COMPUTERS bin, 
       count(*) cnt, 
       round(avg(outcome_2), 2) outcome 
  
  from mart_prediction_1
 where 1=1 
 group by IS_DEPT_COMPUTERS
union all
select 'Baby and Kids' as dept,
       IS_DEPT_BABY_AND_KIDS bin, 
       count(*) cnt, 
       round(avg(outcome_2), 2) outcome 
  
  from mart_prediction_1
 where 1=1 
 group by IS_DEPT_BABY_AND_KIDS
  ;
  
  

  
  
------------------------------------------------------------------------------------------------
-- Departments
------------------------------------------------------------------------------------------------  





with tbl
as
(
    select case
              when tbl.next_order_days <= 30 then 1
              when tbl.next_order_days <= 60 then 2
              when tbl.next_order_days <= 90 then 3
              when tbl.next_order_days <= 120 then 4
              when tbl.next_order_days <= 150 then 5
              when tbl.next_order_days <= 180 then 6
              else 7
           end as slab,   
           tbl.*
           
      from mart_prediction_1 tbl
     where 1=1 
       and tbl.next_order_days is not null
)
select slab, count(*)
  from tbl
  group by slab
  order by slab
;




with tbl
as
(
    select case
              when tbl.next_order_days <= 30 then 1
              when tbl.next_order_days <= 60 then 2
              when tbl.next_order_days <= 90 then 3
              when tbl.next_order_days <= 120 then 4
              when tbl.next_order_days <= 150 then 5
              when tbl.next_order_days <= 180 then 6
              else 7
           end as slab,   
           tbl.*
           
      from mart_prediction_1 tbl
     where 1=1 
       and tbl.next_order_days is not null
)
select round(avg(next_order_days)) avg, median(next_order_days) 
  from tbl
;


with tbl
as
(
    select case
              when tbl.next_order_days <= 30 then 1
              when tbl.next_order_days <= 60 then 2
              when tbl.next_order_days <= 90 then 3
              when tbl.next_order_days <= 120 then 4
              when tbl.next_order_days <= 150 then 5
              when tbl.next_order_days <= 180 then 6
              else 7
           end as slab,   
           tbl.*
           
      from mart_prediction_1 tbl
     where 1=1 
       and tbl.next_order_days is not null
)
select next_order_days, count(*) 
  from tbl
  group by next_order_days
  order by next_ordeR_days
;




  