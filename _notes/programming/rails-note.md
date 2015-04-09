---
layout: document
title: Rails Note
---
## 1. ActiveRecord分表查询
~~~ruby
100.times do |i|
  TalbeModel.table_name = "tb_table_model{i}"
  TableModel.where("")...
end
~~~
