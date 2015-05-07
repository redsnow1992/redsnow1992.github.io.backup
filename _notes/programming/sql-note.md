---
layout: document
title: SQL Note
---
## 1. 可兼容的多条插入sql：使用"insert....;insert....;insert....;"

## insert 
insert into tb_operator (id, real_name, cms_user, no, department, created_at, updated_at) values(16, 'name', 'yannis', '072', 'dept', now(), now())

## where and join
~~~sql
select a.sn, concat_ws(' ~ ', date_format(a.ad_begin_at, '%Y-%m-%d'), date_format(a.ad_end_at, '%Y-%m-%d')), a.sum, c.title, d.name, d.channel, a.created_at, b.cms_user
from 
( 
  select * from tb_out_of_pocket 
  where ad_begin_at >= '20150101' and ad_end_at < '20150301' and is_deleted = false
) as a
left join tb_due b on a.due_id = b.id 
left join tb_payment_template c on b.payment_template_id = c.id 
left join tb_partner d on a.partner_id = d.id
~~~

## Alter
~~~sql
alter table table_name add column rank int(11) default 2
alter table table_name modify column rank int(11) default 2 not null
alter table tb_copyright_content 
            add column price_mode varchar(255) after right_type, 
            add column minimum_price varchar(255) after right_type, 
            add column divide_rate varchar(255) after right_type

index:
alter table table_name add index(status)
show index from ting_passport.tb_profile
~~~
## Update
~~~sql
update tb_body_content_track set beian_status = 1
where beian_status != 11
~~~
