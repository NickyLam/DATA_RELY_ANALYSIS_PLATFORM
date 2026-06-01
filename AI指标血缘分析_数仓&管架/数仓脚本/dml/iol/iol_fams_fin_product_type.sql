/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_fin_product_type
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.fams_fin_product_type_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_fin_product_type
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_fin_product_type_op purge;
drop table ${iol_schema}.fams_fin_product_type_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_fin_product_type_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_fin_product_type where 0=1;

create table ${iol_schema}.fams_fin_product_type_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_fin_product_type where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_fin_product_type_cl(
            finprod_id -- 金融产品代码
            ,branch -- 分支序号
            ,type_1 -- 分类1
            ,type_2 -- 分类2
            ,type_3 -- 分类3
            ,type_4 -- 分类4
            ,type_5 -- 分类5
            ,type_6 -- 投管一级类型
            ,type_7 -- 投管二级类型
            ,type_8 -- 分类8（投管资产大类）
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,type_9 -- 行内二级类型
            ,type_10 -- 行内三级类型
            ,type_11 -- 行内四级类型
            ,type_12 -- 行内五级类型
            ,type_13 -- 风险资产分类1
            ,type_14 -- 风险资产分类2
            ,type_15 -- 风险资产分类3
            ,type_16 -- 风险资产分类4
            ,type_17 -- 风险资产分类5
            ,std_prod_id -- 行内标准产品编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_fin_product_type_op(
            finprod_id -- 金融产品代码
            ,branch -- 分支序号
            ,type_1 -- 分类1
            ,type_2 -- 分类2
            ,type_3 -- 分类3
            ,type_4 -- 分类4
            ,type_5 -- 分类5
            ,type_6 -- 投管一级类型
            ,type_7 -- 投管二级类型
            ,type_8 -- 分类8（投管资产大类）
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,type_9 -- 行内二级类型
            ,type_10 -- 行内三级类型
            ,type_11 -- 行内四级类型
            ,type_12 -- 行内五级类型
            ,type_13 -- 风险资产分类1
            ,type_14 -- 风险资产分类2
            ,type_15 -- 风险资产分类3
            ,type_16 -- 风险资产分类4
            ,type_17 -- 风险资产分类5
            ,std_prod_id -- 行内标准产品编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.finprod_id, o.finprod_id) as finprod_id -- 金融产品代码
    ,nvl(n.branch, o.branch) as branch -- 分支序号
    ,nvl(n.type_1, o.type_1) as type_1 -- 分类1
    ,nvl(n.type_2, o.type_2) as type_2 -- 分类2
    ,nvl(n.type_3, o.type_3) as type_3 -- 分类3
    ,nvl(n.type_4, o.type_4) as type_4 -- 分类4
    ,nvl(n.type_5, o.type_5) as type_5 -- 分类5
    ,nvl(n.type_6, o.type_6) as type_6 -- 投管一级类型
    ,nvl(n.type_7, o.type_7) as type_7 -- 投管二级类型
    ,nvl(n.type_8, o.type_8) as type_8 -- 分类8（投管资产大类）
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.type_9, o.type_9) as type_9 -- 行内二级类型
    ,nvl(n.type_10, o.type_10) as type_10 -- 行内三级类型
    ,nvl(n.type_11, o.type_11) as type_11 -- 行内四级类型
    ,nvl(n.type_12, o.type_12) as type_12 -- 行内五级类型
    ,nvl(n.type_13, o.type_13) as type_13 -- 风险资产分类1
    ,nvl(n.type_14, o.type_14) as type_14 -- 风险资产分类2
    ,nvl(n.type_15, o.type_15) as type_15 -- 风险资产分类3
    ,nvl(n.type_16, o.type_16) as type_16 -- 风险资产分类4
    ,nvl(n.type_17, o.type_17) as type_17 -- 风险资产分类5
    ,nvl(n.std_prod_id, o.std_prod_id) as std_prod_id -- 行内标准产品编号
    ,case when
            n.finprod_id is null
            and n.branch is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.finprod_id is null
            and n.branch is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.finprod_id is null
            and n.branch is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_fin_product_type_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_fin_product_type where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.finprod_id = n.finprod_id
            and o.branch = n.branch
where (
        o.finprod_id is null
        and o.branch is null
    )
    or (
        n.finprod_id is null
        and n.branch is null
    )
    or (
        o.type_1 <> n.type_1
        or o.type_2 <> n.type_2
        or o.type_3 <> n.type_3
        or o.type_4 <> n.type_4
        or o.type_5 <> n.type_5
        or o.type_6 <> n.type_6
        or o.type_7 <> n.type_7
        or o.type_8 <> n.type_8
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
        or o.type_9 <> n.type_9
        or o.type_10 <> n.type_10
        or o.type_11 <> n.type_11
        or o.type_12 <> n.type_12
        or o.type_13 <> n.type_13
        or o.type_14 <> n.type_14
        or o.type_15 <> n.type_15
        or o.type_16 <> n.type_16
        or o.type_17 <> n.type_17
        or o.std_prod_id <> n.std_prod_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_fin_product_type_cl(
            finprod_id -- 金融产品代码
            ,branch -- 分支序号
            ,type_1 -- 分类1
            ,type_2 -- 分类2
            ,type_3 -- 分类3
            ,type_4 -- 分类4
            ,type_5 -- 分类5
            ,type_6 -- 投管一级类型
            ,type_7 -- 投管二级类型
            ,type_8 -- 分类8（投管资产大类）
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,type_9 -- 行内二级类型
            ,type_10 -- 行内三级类型
            ,type_11 -- 行内四级类型
            ,type_12 -- 行内五级类型
            ,type_13 -- 风险资产分类1
            ,type_14 -- 风险资产分类2
            ,type_15 -- 风险资产分类3
            ,type_16 -- 风险资产分类4
            ,type_17 -- 风险资产分类5
            ,std_prod_id -- 行内标准产品编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_fin_product_type_op(
            finprod_id -- 金融产品代码
            ,branch -- 分支序号
            ,type_1 -- 分类1
            ,type_2 -- 分类2
            ,type_3 -- 分类3
            ,type_4 -- 分类4
            ,type_5 -- 分类5
            ,type_6 -- 投管一级类型
            ,type_7 -- 投管二级类型
            ,type_8 -- 分类8（投管资产大类）
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,type_9 -- 行内二级类型
            ,type_10 -- 行内三级类型
            ,type_11 -- 行内四级类型
            ,type_12 -- 行内五级类型
            ,type_13 -- 风险资产分类1
            ,type_14 -- 风险资产分类2
            ,type_15 -- 风险资产分类3
            ,type_16 -- 风险资产分类4
            ,type_17 -- 风险资产分类5
            ,std_prod_id -- 行内标准产品编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.finprod_id -- 金融产品代码
    ,o.branch -- 分支序号
    ,o.type_1 -- 分类1
    ,o.type_2 -- 分类2
    ,o.type_3 -- 分类3
    ,o.type_4 -- 分类4
    ,o.type_5 -- 分类5
    ,o.type_6 -- 投管一级类型
    ,o.type_7 -- 投管二级类型
    ,o.type_8 -- 分类8（投管资产大类）
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
    ,o.type_9 -- 行内二级类型
    ,o.type_10 -- 行内三级类型
    ,o.type_11 -- 行内四级类型
    ,o.type_12 -- 行内五级类型
    ,o.type_13 -- 风险资产分类1
    ,o.type_14 -- 风险资产分类2
    ,o.type_15 -- 风险资产分类3
    ,o.type_16 -- 风险资产分类4
    ,o.type_17 -- 风险资产分类5
    ,o.std_prod_id -- 行内标准产品编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.fams_fin_product_type_bk o
    left join ${iol_schema}.fams_fin_product_type_op n
        on
            o.finprod_id = n.finprod_id
            and o.branch = n.branch
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_fin_product_type_cl d
        on
            o.finprod_id = d.finprod_id
            and o.branch = d.branch
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fams_fin_product_type;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fams_fin_product_type') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fams_fin_product_type drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fams_fin_product_type add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fams_fin_product_type exchange partition p_${batch_date} with table ${iol_schema}.fams_fin_product_type_cl;
alter table ${iol_schema}.fams_fin_product_type exchange partition p_20991231 with table ${iol_schema}.fams_fin_product_type_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_fin_product_type to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_fin_product_type_op purge;
drop table ${iol_schema}.fams_fin_product_type_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_fin_product_type_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_fin_product_type',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
