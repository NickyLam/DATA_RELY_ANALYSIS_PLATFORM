/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_com_crcy
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
create table ${iol_schema}.tgls_com_crcy_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_com_crcy
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_com_crcy_op purge;
drop table ${iol_schema}.tgls_com_crcy_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_com_crcy_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_com_crcy where 0=1;

create table ${iol_schema}.tgls_com_crcy_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_com_crcy where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_com_crcy_cl(
            crcycd -- 币种代码
            ,crcyna -- 币种名称
            ,crcyen -- 币种数字代号
            ,crcysg -- 币种符号
            ,crcydg -- 币种小数位
            ,crcycg -- 币种找零位
            ,dibstg -- 找零标志
            ,usabtg -- 启用标志
            ,cysgdg -- 分段利息小数位
            ,isfold -- 是否折币币种
            ,convmd -- 折算方法类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_com_crcy_op(
            crcycd -- 币种代码
            ,crcyna -- 币种名称
            ,crcyen -- 币种数字代号
            ,crcysg -- 币种符号
            ,crcydg -- 币种小数位
            ,crcycg -- 币种找零位
            ,dibstg -- 找零标志
            ,usabtg -- 启用标志
            ,cysgdg -- 分段利息小数位
            ,isfold -- 是否折币币种
            ,convmd -- 折算方法类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.crcycd, o.crcycd) as crcycd -- 币种代码
    ,nvl(n.crcyna, o.crcyna) as crcyna -- 币种名称
    ,nvl(n.crcyen, o.crcyen) as crcyen -- 币种数字代号
    ,nvl(n.crcysg, o.crcysg) as crcysg -- 币种符号
    ,nvl(n.crcydg, o.crcydg) as crcydg -- 币种小数位
    ,nvl(n.crcycg, o.crcycg) as crcycg -- 币种找零位
    ,nvl(n.dibstg, o.dibstg) as dibstg -- 找零标志
    ,nvl(n.usabtg, o.usabtg) as usabtg -- 启用标志
    ,nvl(n.cysgdg, o.cysgdg) as cysgdg -- 分段利息小数位
    ,nvl(n.isfold, o.isfold) as isfold -- 是否折币币种
    ,nvl(n.convmd, o.convmd) as convmd -- 折算方法类型
    ,case when
            n.crcycd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.crcycd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.crcycd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_com_crcy_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_com_crcy where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.crcycd = n.crcycd
where (
        o.crcycd is null
    )
    or (
        n.crcycd is null
    )
    or (
        o.crcyna <> n.crcyna
        or o.crcyen <> n.crcyen
        or o.crcysg <> n.crcysg
        or o.crcydg <> n.crcydg
        or o.crcycg <> n.crcycg
        or o.dibstg <> n.dibstg
        or o.usabtg <> n.usabtg
        or o.cysgdg <> n.cysgdg
        or o.isfold <> n.isfold
        or o.convmd <> n.convmd
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_com_crcy_cl(
            crcycd -- 币种代码
            ,crcyna -- 币种名称
            ,crcyen -- 币种数字代号
            ,crcysg -- 币种符号
            ,crcydg -- 币种小数位
            ,crcycg -- 币种找零位
            ,dibstg -- 找零标志
            ,usabtg -- 启用标志
            ,cysgdg -- 分段利息小数位
            ,isfold -- 是否折币币种
            ,convmd -- 折算方法类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_com_crcy_op(
            crcycd -- 币种代码
            ,crcyna -- 币种名称
            ,crcyen -- 币种数字代号
            ,crcysg -- 币种符号
            ,crcydg -- 币种小数位
            ,crcycg -- 币种找零位
            ,dibstg -- 找零标志
            ,usabtg -- 启用标志
            ,cysgdg -- 分段利息小数位
            ,isfold -- 是否折币币种
            ,convmd -- 折算方法类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.crcycd -- 币种代码
    ,o.crcyna -- 币种名称
    ,o.crcyen -- 币种数字代号
    ,o.crcysg -- 币种符号
    ,o.crcydg -- 币种小数位
    ,o.crcycg -- 币种找零位
    ,o.dibstg -- 找零标志
    ,o.usabtg -- 启用标志
    ,o.cysgdg -- 分段利息小数位
    ,o.isfold -- 是否折币币种
    ,o.convmd -- 折算方法类型
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
from ${iol_schema}.tgls_com_crcy_bk o
    left join ${iol_schema}.tgls_com_crcy_op n
        on
            o.crcycd = n.crcycd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_com_crcy_cl d
        on
            o.crcycd = d.crcycd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_com_crcy;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_com_crcy') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_com_crcy drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_com_crcy add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_com_crcy exchange partition p_${batch_date} with table ${iol_schema}.tgls_com_crcy_cl;
alter table ${iol_schema}.tgls_com_crcy exchange partition p_20991231 with table ${iol_schema}.tgls_com_crcy_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_com_crcy to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_com_crcy_op purge;
drop table ${iol_schema}.tgls_com_crcy_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_com_crcy_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_com_crcy',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
