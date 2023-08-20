select prefecture, sum(pop_mem), sum(pop_wom)
from
(
  select prefecture, pop as pop_mem, null as pop_wom from population as population_mem where sex = 1
  union all
  select prefecture, null as pop_mem, pop as pop_wom from population as population_wom where sex = 2
) as population_all
group by prefecture

select
  *
from
  ThreeElements
where
  date_1 = '2013-11-01'
  and flg_1 = 'T'
union all
select
  *
from
  ThreeElements
where
  date_2 = '2013-11-01'
  and flg_2 = 'T'
union all
select
  *
from
  ThreeElements
where
  date_3 = '2013-11-01'
  and flg_3 = 'T'

select
  *
from
  ThreeElements
where
  ('2013-11-01', 'T') in ((date_1, flg_1), (date_2, flg_2), (date_3, flg_3));

select
  id,
  max(case when data_type = 'A' then data_1 else null end) as data_1,
  max(case when data_type = 'A' then data_2 else null end) as data_2,
  max(case when data_type = 'B' then data_3 else null end) as data_3
from
  NonAggTbl
group by id;

select
  product_id
from
  PriceByAge
group by
  product_id
having
  sum(high_age - low_age + 1) = 101

select
  room_nbr
from
  HotelRooms
group by
  room_nbr
having
  sum(end_date - start_date) >= 10

select
  case when age < 20 then '子供'
       when age < 70 then '成人'
  else '老人' end
from
  Persons
group by
  case when age < 20 then '子供'
       when age < 70 then '成人'
  else '老人' end

select
  name,
  age,
  rank() over (partition by case when age < 20 then '子供'
                               when age < 70 then '成人'
                          else '老人' end
             order by age) as ranking
from
  Persons
order by
  age

select
  company,
  year,
  sale,
  case
    sign(sale - max(sale) over (partition by company order by year rows between 1 preceding and 1 preceding))
  when 1 then '+'
  when 0 then '='
  when -1 then '-'
  else null end as var
from
  Sales
order by
  company, year

select
  company,
  year,
  sale,
  (
    select
      max(sales_2.sale)
    from
      Sales sales_2
    where
      sales_1.company = sales_2.company
      and sales_2.year = (
        select
          max(sales_3.year)
        from
          Sales sales_3
        where
          sales_3.company = sales_1.company
          and sales_3.year < sales_1.year
      )
  ) as var
from
  Sales sales_1

select
  pcode
from
  PostalCode
where
  case when pcode = '4130033' then 7
        when pcode like '413003%' then 6
        when pcode like '41300%' then 5
        when pcode like '4130%' then 4
        when pcode like '413%' then 3
        when pcode like '41%' then 2
        when pcode like '4%' then 1
        else 0 end = (
          select
            max(case when pcode = '4130033' then 7
                when pcode like '413003%' then 6
                when pcode like '41300%' then 5
                when pcode like '4130%' then 4
                when pcode like '413%' then 3
                when pcode like '41%' then 2
                when pcode like '4%' then 1
                else 0 end)
          from
            PostalCode
        )

with recursive parent_postal_history (name, pcode, new_pcode, depth) as
(
  -- 最新の住所
  select
    name, pcode, new_pcode, 1
  from
    PostalHistory
  where
    PostalHistory.name = 'A'
    and PostalHistory.new_pcode is null
  union all
  -- 過去の住所
  select
    child.name, child.pcode, child.new_pcode, parent.depth + 1
  from
    PostalHistory as child
  inner join
    parent_postal_history as parent
  on
    child.new_pcode = parent.pcode
    and child.name = parent.name
)
select
  *
from
  parent_postal_history
where
  depth = (select max(depth) from parent_postal_history)

select
  *
from
  employees
cross join
  departments

select
  departments.dept_id
from
  departments
inner join
  employees
on
  employees.dept_id = departments.dept_id
where
  departments.dept_id = 10

select
  *,
  (
    select
      dept_name
    from
      departments
    where
      employees.dept_id = departments.dept_id
  ) as dept_name
from
  employees

select
  *
from
  departments
left outer join
  employees
on
  departments.dept_id = employees.dept_id

select
  digits1.digit * 10 + digits2.digit as num
from
  digits digits1
cross join
  digits digits2

select
  *
from
  departments
inner join
  employees
on
  employees.dept_id = departments.dept_id

select
  *
from
  table_a
inner join
  table_b
on
  table_a.col_a = table_b.col_b
inner join
  table_c
on
  table_a.col_a = table_c.col_c

select
  *
from
  departments
where
  exists (
    select
      *
    from
      employees
    where
      departments.dept_id = employees.dept_id
  )

select
  *
from
  departments
where
  not exists (
    select
      *
    from
      employees
    where
      departments.dept_id = employees.dept_id
  )

select
  *
from
  receipts
inner join
  (
    select
      cust_id,
      min(seq) as min_seq
    from
      receipts
    group by
      cust_id
  ) receipts_min_seq
on
  receipts.cust_id = receipts_min_seq.cust_id
  and receipts.seq = receipts_min_seq.min_seq

select
  *
from
  receipts
where
  seq = (
    select
      min(seq)
    from
      receipts receipts2
    where
      receipts.cust_id = receipts2.cust_id
  )

select
  cust_id,
  seq,
  price
from
(
  select
    *,
    row_number() over (partition by cust_id order by seq) as num
  from
    receipts
) receipts_num
where
  num = 1

select
  cust_id,
  sum(case when max_seq = 1 then price else 0 end) - sum(case when min_seq = 1 then price else 0 end) as gap
from
(
  select
    *,
    row_number() over (partition by cust_id order by seq) as min_seq,
    row_number() over (partition by cust_id order by seq desc) as max_seq
  from
    receipts
) tmp
where
  min_seq = 1 or max_seq = 1
group by
  cust_id

select
  receipts_min_seq.cust_id,
  receipts_max_seq.price - receipts_min_seq.price as gap
from
  receipts receipts_min_seq
inner join
(
  select
    cust_id,
    (
      select
        min(receipts2.seq)
      from
        receipts receipts2
      where
        receipts1.cust_id = receipts2.cust_id
    ) as min_seq,
    (
      select
        max(receipts3.seq)
      from
        receipts receipts3
      where
        receipts1.cust_id = receipts3.cust_id
    ) as max_seq
  from
    receipts receipts1
  group by
    cust_id
) tmp
on
  receipts_min_seq.cust_id = tmp.cust_id
  and receipts_min_seq.seq = tmp.min_seq
inner join
  receipts receipts_max_seq
on
  receipts_max_seq.cust_id = tmp.cust_id
  and receipts_max_seq.seq = tmp.max_seq

select
  companies.co_cd,
  companies.district,
  sum(shops.emp_nbr) as sum_emp
from
  companies
left outer join
  shops
on
  companies.co_cd = shops.co_cd
where
  shops.main_flg = 'Y'
group by
  companies.co_cd

select
  companies.co_cd,
  coalesce(tmp_shops.sum_emp, 0) as sum_emp
from
  companies
left outer join
(
  select
    shops.co_cd,
    sum(shops.emp_nbr) as sum_emp
  from
    shops
  where
    shops.main_flg = 'Y'
  group by
    shops.co_cd
) tmp_shops
on
  companies.co_cd = tmp_shops.co_cd

select
  student_id,
  row_number() over (order by student_id)
from
  weights

select
  student_id,
  (
    select
      count(*)
    from
      weights weights2
    where
      weights2.student_id <= weights1.student_id
  ) as seq
from
  weights weights1

select
  class,
  student_id,
  weight,
  row_number() over (order by class, student_id)
from
  weights2
order by
  class, student_id

select
  class,
  student_id,
  (
    select
      count(*)
    from
      weights2 weights2_2
    where
      weights2_2.student_id <= weights2_1.student_id
      and weights2_2.class <= weights2_1.class
  ) as seq
from
  weights2 weights2_1

update
  weights3
inner join
  (
    select
      *,
      row_number() over (partition by class order by student_id) as num
    from
      weights3
  ) tmp
on
  weights3.class = tmp.class
  and weights3.student_id = tmp.student_id
set
  weights3.seq = tmp.num

select
  avg(weights1.weight)
from
  weights weights1
cross join
  weights weights2
group by
  weights1.student_id
having
  sum(case when weights2.weight <= weights1.weight then 1 else 0 end) >= count(*) / 2
  and sum(case when weights2.weight >= weights1.weight then 1 else 0 end) >= count(*) / 2

select
  avg(weight)
from
(
  select
    weight,
    row_number() over (order by weight student_id) as small_num,
    row_number() over (order by weight student_id desc) as big_num
  from
    weights
) tmp
where
  small_num in (big_num, big_num + 1, big_num -1)

select
  avg(tmp.weight)
from
(
select
  weight,
  2 * row_number() over (order by weight) - count(*) over () as gap
from
  weights
) tmp
where
  tmp.gap between 0 and 2

select
  num + 1,
  '~',
  next_num - 1
from
(
  select
    num,
    max(num) over (order by num rows between 1 following and 1 following) as next_num
  from
    numbers
) tmp
where
  next_num > num + 1

select
  num1.num + 1 as min_num,
  min(num2.num) + 1 as max_num
from
  numbers num1
inner join
  numbers num2
on
  num2.num > num1.num
group by
  num1.num
having
  min(num2.num) > num1.num + 1


select
  min(num),
  max(num)
from
(
select
  numbers1.num as num,
  numbers1.num - count(numbers2.num) as gap
from
  numbers numbers1
inner join
  numbers numbers2
on
  numbers2.num <= numbers1.num
group by
  numbers1.num
) tmp
group by
  gap

select
  min(num) as min_num,
  max(num) as max_num
from
(
select
  numbers1.num as num,
  count(numbers2.num) as prev_count
from
  numbers numbers1
inner join
  numbers numbers2
on
  numbers1.num >= numbers2.num
group by
  numbers1.num
) tmp
group by
  num - prev_count

select
  *
from
(
  select
    start_num as start_number,
    case when end_num is null then min(end_num) over (order by seq rows between current row and unbounded following)
    else end_num end as end_number
  from
  (
    select
      case when coalesce(prev_diff, 0) <> 1 then num else null end as start_num,
      case when coalesce(next_diff, 0) <> 1 then num else null end as end_num,
      seq
    from
    (
      select
        num,
        num - min(num) over (order by num rows between 1 preceding and 1 preceding) as prev_diff,
        min(num) over (order by num rows between 1 following and 1 following) - num  as next_diff,
        row_number() over (order by num) as seq
      from
        numbers
    ) tmp1
  ) tmp2
) tmp3
where
  start_number is not null

update
  omitTbl omitTbl1
inner join
  (
    select
      omitTbl2.keycol as keycol,
      omitTbl2.seq as seq,
      min(omitTbl3.val) as min_val
    from
      omitTbl omitTbl2
    inner join
      omitTbl omitTbl3
    on
      omitTbl3.keycol = omitTbl2.keycol
      and omitTbl3.seq < omitTbl2.seq
    group by
      omitTbl2.keycol, omitTbl2.seq
  ) tmp
on
  omitTbl1.keycol = tmp.keycol
  and omitTbl1.seq = tmp.seq
set
  omitTbl1.val = tmp.min_val
where
  omitTbl1.val is null

update
  omitTbl
inner join
(
  select
    tmp.keycol,
    tmp.seq,
    omitTbl3.val
  from
  (
    select
      *,
      (
        select
          max(seq)
        from
          omitTbl omitTbl2
        where
          omitTbl1.keycol = omitTbl2.keycol
          and omitTbl2.seq <= omitTbl1.seq
          and omitTbl2.val is not null
      ) as prev_seq
    from
      omitTbl omitTbl1
  ) tmp
  inner join
    omitTbl omitTbl3
  on
    tmp.keycol = omitTbl3.keycol
    and tmp.prev_seq = omitTbl3.seq
) tmp2
on
  omitTbl.keycol = tmp2.keycol
  and omitTbl.seq = tmp2.seq
set
  omitTbl.val = tmp2.val
where
  omitTbl.val is null


update
  omitTbl
inner join
(
  select
    tmp.keycol,
    tmp.seq,
    tmp.val,
    omitTbl3.val as prev_val
  from
  (
    select
      *,
      (
        select
          max(seq)
        from
          omitTbl omitTbl2
        where
          omitTbl2.keycol = omitTbl1.keycol
          and omitTbl2.seq < omitTbl1.seq
      ) as prev_seq
    from
      omitTbl omitTbl1
  ) tmp
  inner join
    omitTbl omitTbl3
  on
    tmp.keycol = omitTbl3.keycol
    and tmp.prev_seq = omitTbl3.seq
) tmp2
on
  omitTbl.keycol = tmp2.keycol
  and omitTbl.seq = tmp2.seq
set
  omitTbl.val = null
where
  tmp2.val = tmp2.prev_val

update
  scoreCols
inner join
(
  select
    student_id,
    sum(case when subject = '英語' then score else 0 end) as score_en,
    sum(case when subject = '国語' then score else 0 end) as score_nl,
    sum(case when subject = '数学' then score else 0 end) as score_mt
  from
    scoreRows
  group by
    student_id
) tmp
on
  scoreCols.student_id = tmp.student_id
set
  scoreCols.score_en = tmp.score_en,
  scoreCols.score_mt = tmp.score_mt,
  scoreCols.score_nl = tmp.score_nl

update
  scoreRows
inner join
(
  select
    scoreRows.student_id,
    scoreRows.subject as subject,
    case when scoreRows.subject = '英語' then scoreCols.score_en
    when scoreRows.subject = '国語' then scoreCols.score_nl
    when scoreRows.subject = '数学' then scoreCols.score_mt
    else 0 end as score
  from
    scoreRows
  inner join
    scoreCols
  on
    scoreRows.student_id = scoreCols.student_id
  group by
    scoreRows.student_id, scoreRows.subject
) tmp
on
  scoreRows.student_id = tmp.student_id
  and scoreRows.subject = tmp.subject
set
  scoreRows.score = tmp.score

insert into
  stocks2
select
  *,
  case sign(price - min(price) over (partition by brand order by sale_date rows between 1 preceding and 1 preceding))
  when -1 then '下'
  when 0 then '横'
  when 1 then '上'
  else null end as trend
from
  stocks

select
  *,
  case sign(price - (
    select
      price
    from
      stocks stocks_3
    where
      stocks_1.brand = stocks_3.brand
      and stocks_3.sale_date = (
        select
          min(sale_date)
        from
          stocks stocks_2
        where
          stocks_2.brand = stocks_1.brand
          and stocks_2.sale_date < stocks_1.sale_date
      )
  ))
  when 1 then '上'
  when 0 then '横'
  when -1 then '下'
  else null end as trend
from
  stocks stocks_1

select
  *
from
  orders
where
  exists (
    select
      *
    from
      orderReceipts
    where
      orders.order_id = orderReceipts.order_id
      and orderReceipts.delivery_date >= orders.order_date + 3
  )

select
  orderReceipts.*,
  orders.order_name
from
  orders
inner join
  orderReceipts
on
  orders.order_id = orderReceipts.order_id
where
  orderReceipts.delivery_date >= orders.order_date + 3

update
  omitTbl
inner join
(
  select
    tmp.keycol,
    tmp.seq,
    omitTbl3.val
  from
  (
    select
      *,
      (
        select
          max(seq)
        from
          omitTbl omitTbl2
        where
          omitTbl2.keycol = omitTbl1.keycol
          and omitTbl2.seq <= omitTbl1.seq
          and omitTbl2.val is not null
      ) as prev_seq
    from
      omitTbl omitTbl1
  ) tmp
  inner join
    omitTbl omitTbl3
  on
    tmp.keycol = omitTbl3.keycol
    and tmp.prev_seq = omitTbl3.seq
) tmp2
on
  omitTbl.keycol = tmp2.keycol
  and omitTbl.seq = tmp2.seq
set
  omitTbl.val = tmp2.val
where
  omitTbl.val is null

update
  omitTbl
inner join
(
  select
    *,
    min(val) over (partition by keycol order by seq rows between 1 preceding and 1 preceding) as prev_val
  from
    omitTbl
) tmp
on
  omitTbl.keycol = tmp.keycol
  and omitTbl.seq = tmp.seq
set
  omitTbl.val = null
where
  tmp.val = tmp.prev_val