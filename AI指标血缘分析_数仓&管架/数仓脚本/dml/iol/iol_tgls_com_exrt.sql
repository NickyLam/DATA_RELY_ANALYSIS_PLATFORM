/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_com_exrt
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
create table ${iol_schema}.tgls_com_exrt_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_com_exrt
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_com_exrt_op purge;
drop table ${iol_schema}.tgls_com_exrt_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_com_exrt_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_com_exrt where 0=1;

create table ${iol_schema}.tgls_com_exrt_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_com_exrt where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_com_exrt_cl(
            crcycd -- 币种代码
            ,efctdt -- 生效日期
            ,inefdt -- 失效日期
            ,exrtst -- 状态
            ,crcyna -- 中文名称
            ,crcyen -- 英文简称
            ,exunit -- 换算单位
            ,csbypr -- 钞买价
            ,csslpr -- 钞卖价
            ,exbypr -- 汇买价
            ,exslpr -- 汇卖价
            ,middpr -- 中间价
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_com_exrt_op(
            crcycd -- 币种代码
            ,efctdt -- 生效日期
            ,inefdt -- 失效日期
            ,exrtst -- 状态
            ,crcyna -- 中文名称
            ,crcyen -- 英文简称
            ,exunit -- 换算单位
            ,csbypr -- 钞买价
            ,csslpr -- 钞卖价
            ,exbypr -- 汇买价
            ,exslpr -- 汇卖价
            ,middpr -- 中间价
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.crcycd, o.crcycd) as crcycd -- 币种代码
    ,nvl(n.efctdt, o.efctdt) as efctdt -- 生效日期
    ,nvl(n.inefdt, o.inefdt) as inefdt -- 失效日期
    ,nvl(n.exrtst, o.exrtst) as exrtst -- 状态
    ,nvl(n.crcyna, o.crcyna) as crcyna -- 中文名称
    ,nvl(n.crcyen, o.crcyen) as crcyen -- 英文简称
    ,nvl(n.exunit, o.exunit) as exunit -- 换算单位
    ,nvl(n.csbypr, o.csbypr) as csbypr -- 钞买价
    ,nvl(n.csslpr, o.csslpr) as csslpr -- 钞卖价
    ,nvl(n.exbypr, o.exbypr) as exbypr -- 汇买价
    ,nvl(n.exslpr, o.exslpr) as exslpr -- 汇卖价
    ,nvl(n.middpr, o.middpr) as middpr -- 中间价
    ,case when
            n.crcycd is null
            and n.efctdt is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.crcycd is null
            and n.efctdt is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.crcycd is null
            and n.efctdt is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_com_exrt_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_com_exrt where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.crcycd = n.crcycd
            and o.efctdt = n.efctdt
where (
        o.crcycd is null
        and o.efctdt is null
    )
    or (
        n.crcycd is null
        and n.efctdt is null
    )
    or (
        o.inefdt <> n.inefdt
        or o.exrtst <> n.exrtst
        or o.crcyna <> n.crcyna
        or o.crcyen <> n.crcyen
        or o.exunit <> n.exunit
        or o.csbypr <> n.csbypr
        or o.csslpr <> n.csslpr
        or o.exbypr <> n.exbypr
        or o.exslpr <> n.exslpr
        or o.middpr <> n.middpr
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_com_exrt_cl(
            crcycd -- 币种代码
            ,efctdt -- 生效日期
            ,inefdt -- 失效日期
            ,exrtst -- 状态
            ,crcyna -- 中文名称
            ,crcyen -- 英文简称
            ,exunit -- 换算单位
            ,csbypr -- 钞买价
            ,csslpr -- 钞卖价
            ,exbypr -- 汇买价
            ,exslpr -- 汇卖价
            ,middpr -- 中间价
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_com_exrt_op(
            crcycd -- 币种代码
            ,efctdt -- 生效日期
            ,inefdt -- 失效日期
            ,exrtst -- 状态
            ,crcyna -- 中文名称
            ,crcyen -- 英文简称
            ,exunit -- 换算单位
            ,csbypr -- 钞买价
            ,csslpr -- 钞卖价
            ,exbypr -- 汇买价
            ,exslpr -- 汇卖价
            ,middpr -- 中间价
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.crcycd -- 币种代码
    ,o.efctdt -- 生效日期
    ,o.inefdt -- 失效日期
    ,o.exrtst -- 状态
    ,o.crcyna -- 中文名称
    ,o.crcyen -- 英文简称
    ,o.exunit -- 换算单位
    ,o.csbypr -- 钞买价
    ,o.csslpr -- 钞卖价
    ,o.exbypr -- 汇买价
    ,o.exslpr -- 汇卖价
    ,o.middpr -- 中间价
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
from ${iol_schema}.tgls_com_exrt_bk o
    left join ${iol_schema}.tgls_com_exrt_op n
        on
            o.crcycd = n.crcycd
            and o.efctdt = n.efctdt
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_com_exrt_cl d
        on
            o.crcycd = d.crcycd
            and o.efctdt = d.efctdt
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_com_exrt;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_com_exrt') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_com_exrt drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_com_exrt add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_com_exrt exchange partition p_${batch_date} with table ${iol_schema}.tgls_com_exrt_cl;
alter table ${iol_schema}.tgls_com_exrt exchange partition p_20991231 with table ${iol_schema}.tgls_com_exrt_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_com_exrt to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_com_exrt_op purge;
drop table ${iol_schema}.tgls_com_exrt_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_com_exrt_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_com_exrt',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
