/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_zxz_org_iqp_rel
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
create table ${iol_schema}.icms_zxz_org_iqp_rel_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_zxz_org_iqp_rel
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_zxz_org_iqp_rel_op purge;
drop table ${iol_schema}.icms_zxz_org_iqp_rel_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_zxz_org_iqp_rel_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_zxz_org_iqp_rel where 0=1;

create table ${iol_schema}.icms_zxz_org_iqp_rel_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_zxz_org_iqp_rel where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_zxz_org_iqp_rel_cl(
            serno_zh -- 总行审批流水号
            ,serno_fh -- 分行审批流水号
            ,approve_status -- 总行审批状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_zxz_org_iqp_rel_op(
            serno_zh -- 总行审批流水号
            ,serno_fh -- 分行审批流水号
            ,approve_status -- 总行审批状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serno_zh, o.serno_zh) as serno_zh -- 总行审批流水号
    ,nvl(n.serno_fh, o.serno_fh) as serno_fh -- 分行审批流水号
    ,nvl(n.approve_status, o.approve_status) as approve_status -- 总行审批状态
    ,case when
            n.serno_zh is null
            and n.serno_fh is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serno_zh is null
            and n.serno_fh is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serno_zh is null
            and n.serno_fh is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_zxz_org_iqp_rel_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_zxz_org_iqp_rel where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serno_zh = n.serno_zh
            and o.serno_fh = n.serno_fh
where (
        o.serno_zh is null
        and o.serno_fh is null
    )
    or (
        n.serno_zh is null
        and n.serno_fh is null
    )
    or (
        o.approve_status <> n.approve_status
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_zxz_org_iqp_rel_cl(
            serno_zh -- 总行审批流水号
            ,serno_fh -- 分行审批流水号
            ,approve_status -- 总行审批状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_zxz_org_iqp_rel_op(
            serno_zh -- 总行审批流水号
            ,serno_fh -- 分行审批流水号
            ,approve_status -- 总行审批状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serno_zh -- 总行审批流水号
    ,o.serno_fh -- 分行审批流水号
    ,o.approve_status -- 总行审批状态
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
from ${iol_schema}.icms_zxz_org_iqp_rel_bk o
    left join ${iol_schema}.icms_zxz_org_iqp_rel_op n
        on
            o.serno_zh = n.serno_zh
            and o.serno_fh = n.serno_fh
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_zxz_org_iqp_rel_cl d
        on
            o.serno_zh = d.serno_zh
            and o.serno_fh = d.serno_fh
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_zxz_org_iqp_rel;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_zxz_org_iqp_rel') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_zxz_org_iqp_rel drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_zxz_org_iqp_rel add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_zxz_org_iqp_rel exchange partition p_${batch_date} with table ${iol_schema}.icms_zxz_org_iqp_rel_cl;
alter table ${iol_schema}.icms_zxz_org_iqp_rel exchange partition p_20991231 with table ${iol_schema}.icms_zxz_org_iqp_rel_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_zxz_org_iqp_rel to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_zxz_org_iqp_rel_op purge;
drop table ${iol_schema}.icms_zxz_org_iqp_rel_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_zxz_org_iqp_rel_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_zxz_org_iqp_rel',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
