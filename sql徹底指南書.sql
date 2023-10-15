-- 1 case式
select
  case pref_name
    when '徳島' then '四国'
    when '香川' then '四国'
    when '愛媛' then '四国'
    when '高知' then '四国'
    when '福岡' then '九州'
    when '佐賀' then '九州'
    when '長崎' then '九州'
  else 'その他' end as 地方名,
  sum(population) as 人口
from
  poptbl
group by
  case pref_name
    when '徳島' then '四国'
    when '香川' then '四国'
    when '愛媛' then '四国'
    when '高知' then '四国'
    when '福岡' then '九州'
    when '佐賀' then '九州'
    when '長崎' then '九州'
  else 'その他' end
order by
  pref_name

select
  case when population < 100 then '01'
       when population < 200 then '02'
       when population < 300 then '03'
  else '04' end as class,
  count(*) as cnt
from
  poptbl
group by
  case when population < 100 then '01'
       when population < 200 then '02'
       when population < 300 then '03'
  else '04' end
order by
  class

select
  pref_name,
  sum(case sex when '1' then population else 0 end) as 男,
  sum(case sex when '2' then population else 0 end) as 女
from
  poptbl2
group by
  pref_name
order by
  pref_name

select
  pref_name,
  case sex when '1' then population else null end as 男,
  case sex when '2' then population else null end as 女
from
  poptbl2
order by
  pref_name

update
  personnel
set
  salary = (
    case when salary >= 300000 then salary * 0.9
         when salary between 250000 and 27999 then salary * 1.2
    else salary end
  )

update
  sometable
set
  p_key = (
    case p_key
      when 'a' then 'b'
      when 'b' then 'a'
    else p_key end
  )
where
  p_key in ('a', 'b')

select
  course_name,
  case when exists (
    select
      *
    from
      opencourses
    where
      coursemaster.course_id = opencourses.course_id
      and opencourses.month = '201806'
  ) then '○'
  else '×' end as 6月,
  case when exists (
    select
      *
    from
      opencourses
    where
      coursemaster.course_id = opencourses.course_id
      and opencourses.month = '201807'
  ) then '○'
  else '×' end as 7月,
  case when exists (
    select
      *
    from
      opencourses
    where
      coursemaster.course_id = opencourses.course_id
      and opencourses.month = '201808'
  ) then '○'
  else '×' end as 8月
from
  coursemaster
order by
  course_name

select
  std_id,
  case when count(*) = 1 then max(club_id)
  else max(case main_club_flg when 'Y' then club_id else null end) end as club_id
from
  studentclub
group by
  std_id
order by
  std_id

-- 2 window関数
select
  shohin_id,
  avg(hanbai_tanka) over (order by hanbai_tanka rows between 2 preceding and current row) as moving_avg
from
  shohin
order by
  shohin_id

select
  shohin_id,
  avg(hanbai_tanka) over w as moving_avg,
  sum(hanbai_tanka) over w as moving_sum
from
  shohin
window w as (
  order by
    hanbai_tanka
  rows
    between 2 preceding and current row
)
order by
  shohin_id

select
  sample_date,
  max(sample_date) over (
    order by
      sample_date
    rows
      between 1 preceding and 1 preceding
  ) as previous_date
from
  loadsample
order by
  sample_date

select
  sample_date,
  max(sample_date) over w as latest_date,
  max(load_val) over w as latest_load_val
from
  loadsample
window w as (
  order by
    sample_date
  rows
    between 1 preceding and 1 preceding
)
order by
  sample_date

select
  sample_date,
  max(sample_date) over (
    order by
      sample_date
    rows
      between 1 following and 1 following
  ) as next_date
from
  loadsample
order by
  sample_date

select
  sample_date,
  min(sample_date) over (
    order by
      sample_date
    range
      between interval '1' day preceding and interval '1' day preceding
  ) as 1_day_before
from
  loadsample
order by
  sample_date

select
  sample_date,
  min(sample_date) over (
    order by
      sample_date
    range
      between interval '1' day preceding and interval '1' day preceding
  ) as 1_day_before,
  min(sample_date) over (
    order by
      sample_date
    range
      between interval '2' day preceding and interval '2' day preceding
  ) as 2_day_before,
  min(sample_date) over (
    order by
      sample_date
    range
      between interval '3' day preceding and interval '3' day preceding
  ) as 3_day_before
from
  loadsample
order by
  sample_date

select
  products1.name as name1,
  products2.name as name2
from
  products products1
cross join
  products products2
order by
  name1

select
  products1.name as name1,
  products2.name as name2
from
  products products1
inner join
  products products2
on
  products1.name <> products2.name
order by
  name1

select
  products1.name as name1,
  products2.name as name2
from
  products products1
inner join
  products products2
on
  products1.name > products2.name
order by
  name1

select
  p1.name,
  p2.name,
  p3.name
from
  products p1
inner join
  products p2
on
  p1.name > p2.name
inner join
  products p3
on
  p2.name > p3.name

delete from
  products p1
where rowid < (
  select
    max(rowid)
  from
    products p2
  where
    p1.name = p2.name
    and p1.price = p2.price
)

delete from
  products p1
where
  exists (
    select
      *
    from
      products p2
    where
      p1.name = p2.name
      and p1.price = p2.price
      and p1.price < p2.price
  )

select
  a1.name,
  a2.name,
  a1.family_id,
  a1.address,
  a2.address
from
  addresses a1
inner join
  addresses a2
on
  a1.family_id = a2.family_id
  and a1.address <> a2.address
  and a1.name > a2.name
order by
  a1.name

select
  p1.name,
  p2.name,
  p1.price
from
  products p1
inner join
  products p2
on
  p1.price = p2.price
  and p1.name > p2.name
order by
  p1.name, p2.name desc

select
  p1.name,
  p1.price
from
  products p1
inner join
  products p2
on
  p1.price = p2.price
  and p1.name <> p2.name
group by
  p1.name, p1.price

select
  a1.family_id
from
  addresses a1
where
  exists (
    select
      *
    from
      addresses a2
    where
      a1.family_id = a2.family_id
      and a1.address <> a2.address
  )
group by
  a1.family_id

select
  name,
  price,
  rank() over (order by price)
from
  products
order by
  price

select
  name,
  price,
  (
    select
      count(*) + 1
    from
      products p2
    where
      p1.price > p2.price
  ) as ranking,
  (
    select
      count(distinct p3.price) + 1
    from
      products p3
    where
      p1.price > p3.price
  ) as dense_ranking
from
  products p1
order by
  price

select
  p1.name,
  p1.price,
  count(p2.price) + 1 as ranking,
  count(distinct p2.price) + 1 as dense_ranking
from
  products p1
left outer join
  products p2
on
  p1.price > p2.price
group by
  p1.name, p1.price
order by
  p1.price

-- 4. 3値論理
select
  *
from
  students
where
  age = 20 or age <> 20 or age is null

case when col_1 = 1 then 1
     when colo_1 = null then 2
     else 0
end

select
  *
from
  class_a
where
  not in (
    select
      age
    from
      class_b
    where
      city = '東京'
  )
order by
  name

select
  *
from
  class_a
where
  not exists (
    select
      *
    from
      class_b
    where
      class_a.age = class_b.age
      and class_b.city = '東京'
  )
order by
  name

select
  *
from
  class_a
where
  age < coalesce((
    select
      min(age)
    from
      class_b
    where
      city = '東京'
  ), 1000)
order by
  name

select
  *
from
  class_a
where
  age < (
    select
      coalesce(avg(age), 1000)
    from
      class_b
    where
      city = '東京'
  )

-- 5.exists
select
  m1.meeting as meeting,
  m2.person as person
from
  meetings m1
cross join
  meetings m2
group by
  m1.meeting, m2.person
having
  not exists (
    select
      *
    from
      meetings m3
    where
      m1.meeting = m3.meeting
      and m2.person = m3.person
  )

select
  m1.meeting as meeting,
  m2.person as person
from
  meetings m1
cross join
  meetings m2
group by
  m1.meeting, m2.person
except
select
  *
from
  meetings

select
  student_id
from
  testscores t1
group by
  student_id
having
  not exists (
    select
      *
    from
      testscores t2
    where
      t1.student_id = t2.student_id
      and score < 50
  )

select
  student_id
from
  testscores t1
where
  subject in ('算数', '国語')
group by
  student_id
having
  not exists (
    select
      *
    from
      testscores t2
    where
      t1.student_id = t2.student_id
      and case when subject = '算数' and score < 80 then true
               when subject = '国語' and score < 50 then true
               else false
          end
  )
  and count(*) = 2

select
  student_id
from
  testscores t1
group by
  student_id
having
  case when max(subject) = '算数' and max(score) < 80 then false
       when max(subject) = '国語' and max(score) < 50 then false
       else true
  end

select
  project_id
from
  projects
group by
  project_id
having
  sum(case when step_nbr <= 1 and status = '完了' then 1
           when step_nbr >= 2 and status = '待機' then 1
           else 0
      end) = count(*)

select
  project_id
from
  projects p1
where
  not exists (
    select
      *
    from
      projects p2
    where
      p1.project_id = p2.project_id
      and case when step_nbr <= 1 and status = '待機' then true
               when step_nbr >= 2 and status = '完了' then true
               else false
          end
  )


select
  student_id
from
  testscores
group by
  student_id
having
  sum(case subject when '算数' then score else 0 end) >= 80
  and sum(case subject when '国語' then score else 0 end) >= 50

select
  *
from
  testscores t1
where
  not exists (
    select
      *
    from
      testscores t2
    where
      t1.student_id = t2.student_id
      and case when subject = '算数' and score < 80 then true
               when subject = '国語' and score < 50 then true
               else false
          end
  )
  and 2 = (
    select
      count(*)
    from
      testscores t3
    where
      t1.student_id = t3.student_id
      and subject in ('国語', '算数')
  )

-- 6.having
select
  '歯抜け' as gap
from
  seqtbl
having
  count(*) <> max(seq)

select
  case when count(*) <> max(seq) then '歯抜け'
       else '連番'
  end
from
  seqtbl

select
  min(seq) + 1
from
  seqtbl
where
  seq + 1 not in (select seq from seqtbl)

select

select
  '歯抜け'
from
  seqtbl
having
  count(*) + min(seq) - 1 <> max(seq)

select
  case when count(*) + min(seq) - 1 = max(seq) then '歯抜けなし'
       else '歯抜け'
  end
from
  seqtbl

select
  case when count(*) = 0 or min(seq) = 1 then 1
       else (
        select
          min(seq)
        from
          seqtbl s1
        where
          not exists (
            select
              *
            from
              seqtbl s2
            where
              s1.seq + 1 = s2.seq
          )
       )
  end as gap
from
  seqtbl

select
  income
from
  graduates
group by
  income
having
  count(*) = (
    select
      max(cnt)
    from
    (
      select
        count(*) as cnt
      from
        graduates
      group by
        income
    ) tmp1
  )

select
  dpt
from
  students
group by
  dpt
having
  count(*) = count(sbmt_date)

select
  dpt
from
  students
group by
  dpt
having
  count(*) = sum(case when sbmt_date is not null then 1 else 0 end)

select
  *
from
  students s1
where
  not exists (
    select
      *
    from
      students s2
    where
      s1.student_id = s2.student_id
      and sbmt_date is null
  )

select
  class
from
  testResults
group by
  class
having
  sum(case when score >= 80 then 1 else 0 end) >= count(*) * 0.75

select
  class
from
  testResults
where
  score >= 50
group by
  class
having
  sum(case when sex = '男' then 1 else 0 end) > sum(case when sex = '女' then 1 else 0 end)

select
  *
from
  testResults t1
where
  exists (
    select
      '定数'
    from
      testResults t2
    where
      score >= 50
      and t1.class = t2.class
    having
      sum(case when sex = '男' then 1 else 0 end) > sum(case when sex = '女' then 1 else 0 end)
  )


select
  class
from
  testResults
group by
  class
having
  avg(case when sex = '女' then 1 else null end) > avg(case when sex = '男' then 1 else null end)

select
  *
from
  teams t1
where
  not exists (
    select
      *
    from
      teams t2
    where
      t1.team_id = t2.team_id
      and status <> '待機'
  )

select
  team_id
from
  teams
group by
  team_id
having
  count(*) = sum(case status when '待機' then 1 else null end)

select
  team_id
from
  teams
group by
  team_id
having
  max(status) = '待機'
  and min(status) = '待機'

select
  team_id,
  case when max(status) = '待機' and min(status) = '待機' then '出動可能'
       else '出動不可'
  end as status_text
from
  teams
group by
  team_id

select
  center
from
  materials
group by
  center
having
  count(*) = count(distinct material)

select
  center,
  case when count(*) = count(distinct material) then 'ダブりなし'
       else 'ダブりあり'
  end as text
from
  materials
group by
  center

select
  *
from
  materials m1
where
  exists (
    select
      *
    from
      materials m2
    where
      m1.center = m2.center
      and m1.material = m2.material
      and m1.receive_date <> m2.receive_date
  )

select
  shop
from
  shopItems
inner join
  items
on
  shopItems.item = items.item
group by
  shop
having
  count(*) = (
    select
      count(*)
    from
      items
  )

select
  shop
from
  shopItems
left outer join
  items
on
  shopItems.item = items.item
group by
  shop
having
  count(*) = count(items.item)
  and count(*) = (select count(*) from items)

select
  student_id,
  dpt,
  sbmt_date
from
(
select
  *,
  count(*) over (partition by dpt) cnt,
  count(sbmt_date) over (partition by dpt) cnt_sbmt_date
from
  students
) tmp
where
  cnt = cnt_sbmt_date

-- 7.ウィンドウ関数
select
  *
from
  sales s1
where
  sale = (
    select
      sale
    from
      sales s2
    where
      s2.year = s1.year - 1
  )

select
  *
from
(
select
  year,
  sale,
  max(sale) over (order by year range between 1 preceding and 1 preceding) as prev_sale
from
  sales
) tmp
where
  sale = prev_sale

select
  year,
  sale,
  case sign(sale - prev_sale)
    when 1 then '上'
    when 0 then '真ん中'
    when -1 then '下'
    else null
  end
from
(
select
  year,
  sale,
  max(sale) over (order by year range between 1 preceding and 1 preceding) as prev_sale
from
  sales
) tmp

select
  *
from
  sales s1
where
  sale = (
    select
      sale
    from
      sales s3
    where
      s3.year = (
        select
          max(s2.year)
        from
          sales s2
        where
          s2.year < s1.year
      )
  )

select
  *
from
(
  select
    *,
    max(sale) over (order by year rows between 1 preceding and 1 preceding) as prev_sale
  from
    sales
) tmp
where
  sale = prev_sale

select
  *
from
  shohin s1
where
  hanbai_tanka > (
    select
      avg(hanbai_tanka)
    from
      shohin s2
    where
      s1.shohin_bunrui = s2.shohin_bunrui
  )
order by
  shohin_id

select
  *
from
(
select
  *,
  avg(hanbai_tanka) over (partition by shohin_bunrui) as avg_hanbai_tanka
from
  shohin
) tmp
where
  hanbai_tanka > avg_hanbai_tanka

end_date < 自分.start_date or 自分.end_date < start_date
end_date >= 自分.start_date and 自分.end_date >= start_date

select
  *
from
  reservations r1
where
  exists (
    select
      *
    from
      reservations r2
    where
      r1.reserver <> r2.reserver
      and r2.end_date >= r1.start_date and r1.end_date >= r2.start_date
  )

select
  *
from
(
select
  *,
  max(start_date) over (order by start_date, end_date rows between 1 following and 1 following) as next_start_date,
  max(reserver) over (order by start_date, end_date rows between 1 following and 1 following) as next_reserver
from
  reservations
) tmp
where
  next_start_date between start_date and end_date

select
  name,
  case when sum(case course when 'SQL入門' then 1 else null end) = 1 then '○'
       else null
  end as 'SQL入門',
  case when sum(case course when 'UNIX基礎' then 1 else null end) = 1 then '○'
       else null
  end as 'UNIX基礎',
  case when sum(case course when 'Java中級' then 1 else null end) = 1 then '○'
       else null
  end as 'Java中級'
from
  courses
group by
  name
order by
  name

select
  name,
  case
    when exists (
      select
        *
      from
        courses c2
      where
        c1.name = c2.name
        and c2.course = 'SQL入門'
    ) then '○'
    else null
  end as 'SQL入門',
  case
    when exists (
      select
        *
      from
        courses c3
      where
        c1.name = c3.name
        and c3.course = 'UNIX基礎'
    ) then '○'
    else null
  end as 'UNIX基礎'
from
  courses c1
group by
  name

select
  c1.name,
  case when c2.name is not null then '○' else null end as 'SQL入門',
  case when c3.name is not null then '○' else null end as 'UNIX基礎',
  case when c4.name is not null then '○' else null end as 'Java入門'
from (
  select
    distinct name
  from
    courses
) c1
left outer join
  (
    select
      name
    from
      courses
    where
      course = 'SQL入門'
  ) c2
on
  c1.name = c2.name
left outer join
  (
    select
      name
    from
      courses
    where
      course = 'UNIX基礎'
  ) c3
on
  c1.name = c3.name
left outer join
  (
    select
      name
    from
      courses
    where
      course = 'Java中級'
  ) c4
on
  c1.name = c4.name

select
  employee, child_1
from
  personnel
union all
select
  employee, child_2
from
  personnel
union all
select
  employee, child_3
from
  personnel
order by
  employee


select
  personnel.employee,
  tmp2.child
from
  personnel
left outer join
  (
    select
      tmp1.employee,
      tmp1.child
    from
      (
        select
          employee, child_1 as child
        from
          personnel
        union all
        select
          employee, child_2 as child
        from
          personnel
        union all
        select
          employee, child_3 as child
        from
          personnel
      ) tmp1
    where
      tmp1.child is not null
  ) tmp2
on
  personnel.employee = tmp2.employee

select
  *
from
  reservations r1
where
  exists (
    select
      *
    from
      reservations r2
    where
      r1.reserver <> r2.reserver
      and (
        r2.end_date >= r1.start_date
        and r1.end_date >= r2.start_date)
      
  )
order by
  reserver

select
  *
from
(
select
  *,
  max(start_date) over (order by start_date, end_date rows between 1 following and 1 following) as next_reserver_start_date,
  max(reserver) over (order by start_date, end_date rows between 1 following and 1 following) as next_reserver
from
  reservations
) tmp
where
  next_reserver_start_date <= end_date
order by
  reserver

select
  *
from
  shohin s1
where
  hanbai_tanka > (
    select
      avg(hanbai_tanka)
    from
      shohin s2
    where
      s1.shohin_bunrui = s2.shohin_bunrui
  )
order by
  shohin_id

select
  *
from
(
  select
    *,
    avg(hanbai_tanka) over (partition by shohin_bunrui) as avg_hanbai_tanka
  from
    shohin
) tmp
where
  hanbai_tanka > avg_hanbai_tanka
order by
  shohin_id

select
  name,
  case when sum(case when course = 'SQL入門' then 1 else null end) = 1 then '○'
       else null
  end as 'SQL入門',
  case when sum(case when course = 'UNIX基礎' then 1 else null end) = 1 then '○'
       else null
  end as 'UNIX基礎',
  case when sum(case when course = 'Java中級' then 1 else null end) = 1 then '○'
       else null
  end as 'Java中級'
from
  courses
group by
  name
order by
  name

select
  max(tblage.age_range),
  max(tblsex.sex),
  sum(case when tblpop.pref_name in ('秋田', '青森') then tblpop.population else null end) as '東北',
  sum(case when tblpop.pref_name in ('東京', '千葉') then tblpop.population else null end) as '関東'
from
  tblage
cross join
  tblsex
left outer join
  tblpop
on
  tblage.age_class = tblpop.age_class
  and tblsex.sex_cd = tblpop.sex_cd
group by
  tblage.age_class, tblsex.sex_cd
order by
  tblage.age_class, tblsex.sex_cd desc

select
  items.item_no,
  sum(quantity)
from
  items
left outer join
  saleshistory
on
  items.item_no = saleshistory.item_no
group by
  items.item_no
order by
  items.item_no

select
  item_no,
  (
    select
      sum(quantity)
    from
      saleshistory
    where
      items.item_no = saleshistory.item_no
  )
from
  items

select
  coalesce(class_a.id, class_b.id) as id,
  class_a.name,
  class_b.name
from
  class_a
full outer join
  class_b
on
  class_a.id = class_b.id
order by
  id

select
  class_a.id as id,
  class_a.name,
  class_b.name
from
  class_a
left outer join
  class_b
on
  class_a.id = class_b.id
union
select
  class_b.id as id,
  class_a.name,
  class_b.name
from
  class_b
left outer join
  class_a
on
  class_b.id = class_a.id

select
  class_a.id,
  class_a.name
from
  class_a
left outer join
  class_b
on
  class_a.id = class_b.id
where
  class_b.id is null
order by
  class_a.id

select
  class_b.id,
  class_b.name
from
  class_b
left outer join
  class_a
on
  class_b.id = class_a.id
where
  class_a.id is null
order by
  class_b.id

select
  shop,
  item
from
  shopItems si1
where
  not exists (
    select
      items.item
    from
      items
    left outer join
      shopItems si2
    on
      items.item = si2.item
      and si1.shop = si2.shop
    where
      si2.item is null
  )

-- 9.集合演算
select
  count(*)
from
(
select
  *
from
  tbl_a
union
select
  *
from
  tbl_b
) tmp

select
  case count(*)
    when 0 then '同じ'
    else '違う'
  end as result
from
(
  (
    select
      *
    from
      tbl_a
    union
    select
      *
    from
      tbl_b
  )
  except
  (
    select
      *
    from
      tbl_a
    intersect
    select
      *
    from
      tbl_b
  ) 
) tmp

(
  select
    *
  from
    tbl_a
  except
  select
    *
  from
    tbl_b
)
union all
(
  select
    *
  from
    tbl_b
  except
  select
    *
  from
    tbl_a
)

select
  *
from
  empskills es1
where
  not exists (
    select
      skill
    from
      skills
    except
    select
      skill
    from
      empskills es2
    where
      es1.emp = es2.emp
  )

select
  sup1.sup,
  sup2.sup
from
  supparts sup1
cross join
  supparts sup2
where
  sup1.sup < sup2.sup
  and sup1.part = sup2.part
group by
  sup1.sup, sup2.sup
having
  count(*) = (
    select
      count(*)
    from
      supparts sup3
    where
      sup1.sup = sup3.sup
  )
  and count(*) = (
    select
      count(*)
    from
      supparts sup4
    where
      sup2.sup = sup4.sup
  )

select
  case count(*)
    when 0 then '同じ'
    else '違う'
  end as result
from
(
(
  select
    *
  from
    tbl_a
  union
  select
    *
  from
    tbl_b
)
except
(
  select
    *
  from
    tbl_a
  intersect
  select
    *
  from
    tbl_b
)
) tmp3

-- 10.数列
select
  d1.digit * 10 + d2.digit as num
from
  digits d1
cross join
  digits d2
order by
  num


select
  d1.digit * 100 + d2.digit * 10 + d3.digit as seq
from
  digits d1
cross join
  digits d2
cross join
  digits d3
where
  d1.digit * 100 + d2.digit * 10 + d3.digit between 1 and 542
order by
  seq

with recursive seq as
(
  select 0 as num
  union all
  select
    num + 1
  from
    seq
  where
    num < 542
)
select
  *
from
  seq

with recursive seq as
(
  select (select min(seq) from seqtbl) as num
  union all
  select
    num + 1
  from
    seq
  where
    num < (select max(seq) from seqtbl)
)
select
  *
from
  seq
except
select
  *
from
  seqtbl

select
  *
from
  seats s1
where
  status = '空'
  and 3 = (
    select
      count(*)
    from
      seats s2
    where
      s2.seat between s1.seat - 1 and s1.seat + 1
      and s2.status = '空'
  )
order by
  seat

select
  s1.seat as start,
  s2.seat as end
from
  seats s1
inner join
  seats s2
on
  s2.seat = s1.seat + 2
where
  s1.status = '空'
  and not exists (
    select
      *
    from
      seats s3
    where
      s3.seat between s1.seat and s2.seat
      and status = '占'
  )

select
  seat,
  end_seat
from
(
select
  seat,
  max(seat) over (order by seat rows between 2 following and 2 following) as end_seat
from
  seats
where
  status = '空'
) tmp
where
  seat + 2 = end_seat

select
  s1.seat,
  s2.seat
from
  seats2 s1
inner join
  seats2 s2
on
  s2.seat = s1.seat + 2
  and s2.line_id = s1.line_id
where
  not exists (
    select
      *
    from
      seats2 s3
    where
      s3.seat between s1.seat and s2.seat
      and status = '占'
  )

select
  *
from
(
select
  seat,
  max(seat) over (partition by line_id order by seat rows between 2 following and 2 following) as end_seat
from
  seats2
where
  status = '空'
) tmp
where
  seat + 2 = end_seat

select
  s1.seat as start,
  s2.seat as end
from
  seats2 s1
inner join
  seats2 s2
on
  s2.seat = s1.seat + 2
  and s2.line_id = s1.line_id
where
  not exists (
    select
      *
    from
      seats2 s3
    where
      s3.seat between s1.seat and s2.seat
      and s3.status = '占'
  )
order by
  start

select
  *
from
(
select
  seat,
  max(seat) over (partition by line_id order by seat rows between 2 following and 2 following) as end_seat
from
  seats2
where
  status = '空'
) tmp
where
  seat + 2 = end_seat
order by
  seat

select
  deal_date,
  price,
  case sign(price - prev_price)
    when 1 then '上昇'
    else null
  end as result
from
  (
    select
      *,
      max(price) over (order by deal_date rows between 1 preceding and 1 preceding) as prev_price
    from
      mystock
  ) tmp
order by
  deal_date

select
  deal_date,
  price
from
  mystock m1
where
  price > (
    select
      m2.price
    from
      mystock m2
    where
      m2.deal_date = (
        select
          max(m3.deal_date)
        from
          mystock m3
        where
          m3.deal_date < m1.deal_date
      )
  )

-- 11.性能
select
  *
from
  class_a
where
  id in (select id from class_b)

select
  *
from
  class_a
where
  exists (
    select
      *
    from
      class_b
    where
      class_a.id = class_b.id
  )

select
  *
from
  class_a
inner join
  class_b
on
  class_a.id = class_b.id

select
  *
from
  items
inner join
  saleshistory
on
  items.item_no = saleshistory.item_no
group by
  items.item_no

select
  *
from
  items
where
  exists (
    select
      *
    from
      saleshistory
    where
      items.item_no = saleshistory.item_now
  )

select
  sale_date
from
  saleshistory
where
  sale_date = '2018-10-01'
group by
  sale_date

-- 演習問題1
select
  case when x >= y and x >= z then x
       when y >= x and y >= z then Y
       else z end as max_colum
from
  greatests

select
  case when z > (
    case when x > y then x else y end
  ) then z
  else case when x > y then x else y end
from
  greatests

select
  case when sex = '1' then '男' else '女' end as '性別',
  count(population) as '全国',
  sum(case pref_name when '徳島' then population else null end) as '徳島',
  sum(case when pref_name in ('徳島', '香川', '愛媛', '高知') then population else null end) as '四国'
from
  PopTbl2
group by
  sex

select
  *
from
  greatests
order by
  case key
    when 'A' then 2
    when 'B' then 1
    when 'C' then 4
    else 3
  end

-- 演習2
select
  server,
  sample_date,
  sum(load_val) over () as sum_load
from
  ServerLoadSample

select
  server,
  sample_date,
  sum(load_val) over (partition by server) as sum_load
from
  ServerLoadSample

-- 演習3
select
  p1.name as name_1,
  p2.name as name_2
from
  products p1
inner join
  products p2
on
  p1.name <= p2.name

select
  name,
  price,
  (
    select
      count(*)
    from
      Products p2
    where
      p2.price >= p1.price
  ) as ranking
from
  Products p1
order by
  ranking

select
  *,
  (
    select
      count(distinct p2.price) + 1
    from
      Products p2
    where
      p2.price < p1.price
  ) as ranking
from
  Products p1
order by
  ranking

select
  *
from
  ArrayTbl2 at1
where
  not exists (
    select
      *
    from
      ArrayTbl2 at2
    where
      at1.kkey = at2.kkey
      and (at2.val <> 1 or at2.val is null)
  )

select
  kkey,
  max(val) as val
from
  ArrayTbl2 at1
group by
  at1.kkey
having
  sum(case when at1.val = 1 then 1 else null end) = (
    select
      count(*)
    from
      ArrayTbl2 at2
    where
      at1.kkey = at2.kkey
  )

select
  kkey,
  min(val) as val
from
  ArrayTbl2
group by
  kkey
having
  max(val) = min(val)

select
  *
from
  Numbers n1
where
  not exists (
    select
      *
    from
      Numbers n2
    where
      n2.num < n1.num / 2
      and n2.num <> 1
      and n1.num % n2.num = 0
  )

select
  case when max(seq) - min(seq) + 1 = count(*) then '歯抜けなし'
       else '歯抜けあり'
  end
from
  SeqTbl
limit 1

select
  prev_seq + 1,
  seq - 1
from
(
  select
    seq,
    (
      select
        max(st3.seq)
      from
        SeqTbl st3
      where
        st3.seq < st2.seq
    ) as prev_seq
  from
    SeqTbl st2
) tmp
where
  prev_seq < seq - 1

select
  dpt
from
  Students
group by
  dpt
having
  sum(case when sbmt_date <= '2018-09-30' then 1 else null end) = count(*)

select
  ShopItems.shop,
  count(*) as my_items,
  (select count(*) from Items) - count(*) as diff_count
from
  ShopItems
inner join
  Items
on
  ShopItems.item = Items.item
group by
  ShopItems.shop
