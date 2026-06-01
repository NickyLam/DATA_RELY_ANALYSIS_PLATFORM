/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_psp_rw_sign_grt
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
create table ${iol_schema}.icms_psp_rw_sign_grt_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_psp_rw_sign_grt
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_psp_rw_sign_grt_op purge;
drop table ${iol_schema}.icms_psp_rw_sign_grt_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_psp_rw_sign_grt_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_psp_rw_sign_grt where 0=1;

create table ${iol_schema}.icms_psp_rw_sign_grt_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_psp_rw_sign_grt where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_psp_rw_sign_grt_cl(
            serno -- 流水号
            ,evalamt -- 当时评估单价
            ,migtflag -- 
            ,signserno -- 风险预警信号流水号
            ,isfull -- 现时是否足值
            ,buildamt -- 建构价款
            ,evalnetamt -- 当时评估净值
            ,gagename -- 名称
            ,realamt -- 现时实际价值
            ,realrate -- 现时抵质押率
            ,floorarea -- 建筑面积
            ,grtaddr -- 地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_psp_rw_sign_grt_op(
            serno -- 流水号
            ,evalamt -- 当时评估单价
            ,migtflag -- 
            ,signserno -- 风险预警信号流水号
            ,isfull -- 现时是否足值
            ,buildamt -- 建构价款
            ,evalnetamt -- 当时评估净值
            ,gagename -- 名称
            ,realamt -- 现时实际价值
            ,realrate -- 现时抵质押率
            ,floorarea -- 建筑面积
            ,grtaddr -- 地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serno, o.serno) as serno -- 流水号
    ,nvl(n.evalamt, o.evalamt) as evalamt -- 当时评估单价
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.signserno, o.signserno) as signserno -- 风险预警信号流水号
    ,nvl(n.isfull, o.isfull) as isfull -- 现时是否足值
    ,nvl(n.buildamt, o.buildamt) as buildamt -- 建构价款
    ,nvl(n.evalnetamt, o.evalnetamt) as evalnetamt -- 当时评估净值
    ,nvl(n.gagename, o.gagename) as gagename -- 名称
    ,nvl(n.realamt, o.realamt) as realamt -- 现时实际价值
    ,nvl(n.realrate, o.realrate) as realrate -- 现时抵质押率
    ,nvl(n.floorarea, o.floorarea) as floorarea -- 建筑面积
    ,nvl(n.grtaddr, o.grtaddr) as grtaddr -- 地址
    ,case when
            n.serno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_psp_rw_sign_grt_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_psp_rw_sign_grt where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serno = n.serno
where (
        o.serno is null
    )
    or (
        n.serno is null
    )
    or (
        o.evalamt <> n.evalamt
        or o.migtflag <> n.migtflag
        or o.signserno <> n.signserno
        or o.isfull <> n.isfull
        or o.buildamt <> n.buildamt
        or o.evalnetamt <> n.evalnetamt
        or o.gagename <> n.gagename
        or o.realamt <> n.realamt
        or o.realrate <> n.realrate
        or o.floorarea <> n.floorarea
        or o.grtaddr <> n.grtaddr
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_psp_rw_sign_grt_cl(
            serno -- 流水号
            ,evalamt -- 当时评估单价
            ,migtflag -- 
            ,signserno -- 风险预警信号流水号
            ,isfull -- 现时是否足值
            ,buildamt -- 建构价款
            ,evalnetamt -- 当时评估净值
            ,gagename -- 名称
            ,realamt -- 现时实际价值
            ,realrate -- 现时抵质押率
            ,floorarea -- 建筑面积
            ,grtaddr -- 地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_psp_rw_sign_grt_op(
            serno -- 流水号
            ,evalamt -- 当时评估单价
            ,migtflag -- 
            ,signserno -- 风险预警信号流水号
            ,isfull -- 现时是否足值
            ,buildamt -- 建构价款
            ,evalnetamt -- 当时评估净值
            ,gagename -- 名称
            ,realamt -- 现时实际价值
            ,realrate -- 现时抵质押率
            ,floorarea -- 建筑面积
            ,grtaddr -- 地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serno -- 流水号
    ,o.evalamt -- 当时评估单价
    ,o.migtflag -- 
    ,o.signserno -- 风险预警信号流水号
    ,o.isfull -- 现时是否足值
    ,o.buildamt -- 建构价款
    ,o.evalnetamt -- 当时评估净值
    ,o.gagename -- 名称
    ,o.realamt -- 现时实际价值
    ,o.realrate -- 现时抵质押率
    ,o.floorarea -- 建筑面积
    ,o.grtaddr -- 地址
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
from ${iol_schema}.icms_psp_rw_sign_grt_bk o
    left join ${iol_schema}.icms_psp_rw_sign_grt_op n
        on
            o.serno = n.serno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_psp_rw_sign_grt_cl d
        on
            o.serno = d.serno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_psp_rw_sign_grt;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_psp_rw_sign_grt') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_psp_rw_sign_grt drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_psp_rw_sign_grt add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_psp_rw_sign_grt exchange partition p_${batch_date} with table ${iol_schema}.icms_psp_rw_sign_grt_cl;
alter table ${iol_schema}.icms_psp_rw_sign_grt exchange partition p_20991231 with table ${iol_schema}.icms_psp_rw_sign_grt_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_psp_rw_sign_grt to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_psp_rw_sign_grt_op purge;
drop table ${iol_schema}.icms_psp_rw_sign_grt_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_psp_rw_sign_grt_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_psp_rw_sign_grt',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
