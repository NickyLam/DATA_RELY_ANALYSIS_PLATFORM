/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_iers_fip_docview_b
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
create table ${iol_schema}.iers_fip_docview_b_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.iers_fip_docview_b
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_fip_docview_b_op purge;
drop table ${iol_schema}.iers_fip_docview_b_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_fip_docview_b_op nologging
for exchange with table
${iol_schema}.iers_fip_docview_b;

create table ${iol_schema}.iers_fip_docview_b_cl nologging
for exchange with table
${iol_schema}.iers_fip_docview_b;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_fip_docview_b_cl(
            desdocvalue -- 目标档案值
            ,dr -- 删除标志
            ,factorvalue1 -- 来源档案值1
            ,factorvalue2 -- 来源档案值2
            ,factorvalue3 -- 来源档案值3
            ,factorvalue4 -- 来源档案值4
            ,factorvalue5 -- 来源档案值5
            ,factorvalue6 -- 来源档案值6
            ,factorvalue7 -- 来源档案值7
            ,factorvalue8 -- 来源档案值8
            ,factorvalue9 -- 来源档案值9
            ,indexnumber -- 序号
            ,pk_classview -- 对照表_主键
            ,pk_classview_b -- 对象标识
            ,pk_org -- 来源组织
            ,ts -- 时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_fip_docview_b_op(
            desdocvalue -- 目标档案值
            ,dr -- 删除标志
            ,factorvalue1 -- 来源档案值1
            ,factorvalue2 -- 来源档案值2
            ,factorvalue3 -- 来源档案值3
            ,factorvalue4 -- 来源档案值4
            ,factorvalue5 -- 来源档案值5
            ,factorvalue6 -- 来源档案值6
            ,factorvalue7 -- 来源档案值7
            ,factorvalue8 -- 来源档案值8
            ,factorvalue9 -- 来源档案值9
            ,indexnumber -- 序号
            ,pk_classview -- 对照表_主键
            ,pk_classview_b -- 对象标识
            ,pk_org -- 来源组织
            ,ts -- 时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.desdocvalue, o.desdocvalue) as desdocvalue -- 目标档案值
    ,nvl(n.dr, o.dr) as dr -- 删除标志
    ,nvl(n.factorvalue1, o.factorvalue1) as factorvalue1 -- 来源档案值1
    ,nvl(n.factorvalue2, o.factorvalue2) as factorvalue2 -- 来源档案值2
    ,nvl(n.factorvalue3, o.factorvalue3) as factorvalue3 -- 来源档案值3
    ,nvl(n.factorvalue4, o.factorvalue4) as factorvalue4 -- 来源档案值4
    ,nvl(n.factorvalue5, o.factorvalue5) as factorvalue5 -- 来源档案值5
    ,nvl(n.factorvalue6, o.factorvalue6) as factorvalue6 -- 来源档案值6
    ,nvl(n.factorvalue7, o.factorvalue7) as factorvalue7 -- 来源档案值7
    ,nvl(n.factorvalue8, o.factorvalue8) as factorvalue8 -- 来源档案值8
    ,nvl(n.factorvalue9, o.factorvalue9) as factorvalue9 -- 来源档案值9
    ,nvl(n.indexnumber, o.indexnumber) as indexnumber -- 序号
    ,nvl(n.pk_classview, o.pk_classview) as pk_classview -- 对照表_主键
    ,nvl(n.pk_classview_b, o.pk_classview_b) as pk_classview_b -- 对象标识
    ,nvl(n.pk_org, o.pk_org) as pk_org -- 来源组织
    ,nvl(n.ts, o.ts) as ts -- 时间戳
    ,case when
            n.pk_classview_b is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_classview_b is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_classview_b is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.iers_fip_docview_b_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.iers_fip_docview_b where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_classview_b = n.pk_classview_b
where (
        o.pk_classview_b is null
    )
    or (
        n.pk_classview_b is null
    )
    or (
        o.desdocvalue <> n.desdocvalue
        or o.dr <> n.dr
        or o.factorvalue1 <> n.factorvalue1
        or o.factorvalue2 <> n.factorvalue2
        or o.factorvalue3 <> n.factorvalue3
        or o.factorvalue4 <> n.factorvalue4
        or o.factorvalue5 <> n.factorvalue5
        or o.factorvalue6 <> n.factorvalue6
        or o.factorvalue7 <> n.factorvalue7
        or o.factorvalue8 <> n.factorvalue8
        or o.factorvalue9 <> n.factorvalue9
        or o.indexnumber <> n.indexnumber
        or o.pk_classview <> n.pk_classview
        or o.pk_org <> n.pk_org
        or o.ts <> n.ts
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_fip_docview_b_cl(
            desdocvalue -- 目标档案值
            ,dr -- 删除标志
            ,factorvalue1 -- 来源档案值1
            ,factorvalue2 -- 来源档案值2
            ,factorvalue3 -- 来源档案值3
            ,factorvalue4 -- 来源档案值4
            ,factorvalue5 -- 来源档案值5
            ,factorvalue6 -- 来源档案值6
            ,factorvalue7 -- 来源档案值7
            ,factorvalue8 -- 来源档案值8
            ,factorvalue9 -- 来源档案值9
            ,indexnumber -- 序号
            ,pk_classview -- 对照表_主键
            ,pk_classview_b -- 对象标识
            ,pk_org -- 来源组织
            ,ts -- 时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_fip_docview_b_op(
            desdocvalue -- 目标档案值
            ,dr -- 删除标志
            ,factorvalue1 -- 来源档案值1
            ,factorvalue2 -- 来源档案值2
            ,factorvalue3 -- 来源档案值3
            ,factorvalue4 -- 来源档案值4
            ,factorvalue5 -- 来源档案值5
            ,factorvalue6 -- 来源档案值6
            ,factorvalue7 -- 来源档案值7
            ,factorvalue8 -- 来源档案值8
            ,factorvalue9 -- 来源档案值9
            ,indexnumber -- 序号
            ,pk_classview -- 对照表_主键
            ,pk_classview_b -- 对象标识
            ,pk_org -- 来源组织
            ,ts -- 时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.desdocvalue -- 目标档案值
    ,o.dr -- 删除标志
    ,o.factorvalue1 -- 来源档案值1
    ,o.factorvalue2 -- 来源档案值2
    ,o.factorvalue3 -- 来源档案值3
    ,o.factorvalue4 -- 来源档案值4
    ,o.factorvalue5 -- 来源档案值5
    ,o.factorvalue6 -- 来源档案值6
    ,o.factorvalue7 -- 来源档案值7
    ,o.factorvalue8 -- 来源档案值8
    ,o.factorvalue9 -- 来源档案值9
    ,o.indexnumber -- 序号
    ,o.pk_classview -- 对照表_主键
    ,o.pk_classview_b -- 对象标识
    ,o.pk_org -- 来源组织
    ,o.ts -- 时间戳
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
from ${iol_schema}.iers_fip_docview_b_bk o
    left join ${iol_schema}.iers_fip_docview_b_op n
        on
            o.pk_classview_b = n.pk_classview_b
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.iers_fip_docview_b_cl d
        on
            o.pk_classview_b = d.pk_classview_b
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.iers_fip_docview_b;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('iers_fip_docview_b') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.iers_fip_docview_b drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.iers_fip_docview_b add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.iers_fip_docview_b exchange partition p_${batch_date} with table ${iol_schema}.iers_fip_docview_b_cl;
alter table ${iol_schema}.iers_fip_docview_b exchange partition p_20991231 with table ${iol_schema}.iers_fip_docview_b_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.iers_fip_docview_b to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_fip_docview_b_op purge;
drop table ${iol_schema}.iers_fip_docview_b_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.iers_fip_docview_b_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'iers_fip_docview_b',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
