/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_fkd_half_year_info
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
create table ${iol_schema}.icms_fkd_half_year_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_fkd_half_year_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_fkd_half_year_info_op purge;
drop table ${iol_schema}.icms_fkd_half_year_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_fkd_half_year_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_fkd_half_year_info where 0=1;

create table ${iol_schema}.icms_fkd_half_year_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_fkd_half_year_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_fkd_half_year_info_cl(
            pk_no -- 流水号
            ,halfyearamt -- 半年审额度
            ,outstndlmt -- 已用额度
            ,applytime -- 半年审时间
            ,crdappamt -- 额度合同授信额度
            ,lmtserno -- 额度合同号
            ,applydate -- 半年审日期
            ,residuallmt -- 可用额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_fkd_half_year_info_op(
            pk_no -- 流水号
            ,halfyearamt -- 半年审额度
            ,outstndlmt -- 已用额度
            ,applytime -- 半年审时间
            ,crdappamt -- 额度合同授信额度
            ,lmtserno -- 额度合同号
            ,applydate -- 半年审日期
            ,residuallmt -- 可用额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.pk_no, o.pk_no) as pk_no -- 流水号
    ,nvl(n.halfyearamt, o.halfyearamt) as halfyearamt -- 半年审额度
    ,nvl(n.outstndlmt, o.outstndlmt) as outstndlmt -- 已用额度
    ,nvl(n.applytime, o.applytime) as applytime -- 半年审时间
    ,nvl(n.crdappamt, o.crdappamt) as crdappamt -- 额度合同授信额度
    ,nvl(n.lmtserno, o.lmtserno) as lmtserno -- 额度合同号
    ,nvl(n.applydate, o.applydate) as applydate -- 半年审日期
    ,nvl(n.residuallmt, o.residuallmt) as residuallmt -- 可用额度
    ,case when
            n.pk_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_fkd_half_year_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_fkd_half_year_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_no = n.pk_no
where (
        o.pk_no is null
    )
    or (
        n.pk_no is null
    )
    or (
        o.halfyearamt <> n.halfyearamt
        or o.outstndlmt <> n.outstndlmt
        or o.applytime <> n.applytime
        or o.crdappamt <> n.crdappamt
        or o.lmtserno <> n.lmtserno
        or o.applydate <> n.applydate
        or o.residuallmt <> n.residuallmt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_fkd_half_year_info_cl(
            pk_no -- 流水号
            ,halfyearamt -- 半年审额度
            ,outstndlmt -- 已用额度
            ,applytime -- 半年审时间
            ,crdappamt -- 额度合同授信额度
            ,lmtserno -- 额度合同号
            ,applydate -- 半年审日期
            ,residuallmt -- 可用额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_fkd_half_year_info_op(
            pk_no -- 流水号
            ,halfyearamt -- 半年审额度
            ,outstndlmt -- 已用额度
            ,applytime -- 半年审时间
            ,crdappamt -- 额度合同授信额度
            ,lmtserno -- 额度合同号
            ,applydate -- 半年审日期
            ,residuallmt -- 可用额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.pk_no -- 流水号
    ,o.halfyearamt -- 半年审额度
    ,o.outstndlmt -- 已用额度
    ,o.applytime -- 半年审时间
    ,o.crdappamt -- 额度合同授信额度
    ,o.lmtserno -- 额度合同号
    ,o.applydate -- 半年审日期
    ,o.residuallmt -- 可用额度
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
from ${iol_schema}.icms_fkd_half_year_info_bk o
    left join ${iol_schema}.icms_fkd_half_year_info_op n
        on
            o.pk_no = n.pk_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_fkd_half_year_info_cl d
        on
            o.pk_no = d.pk_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_fkd_half_year_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_fkd_half_year_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_fkd_half_year_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_fkd_half_year_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_fkd_half_year_info exchange partition p_${batch_date} with table ${iol_schema}.icms_fkd_half_year_info_cl;
alter table ${iol_schema}.icms_fkd_half_year_info exchange partition p_20991231 with table ${iol_schema}.icms_fkd_half_year_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_fkd_half_year_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_fkd_half_year_info_op purge;
drop table ${iol_schema}.icms_fkd_half_year_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_fkd_half_year_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_fkd_half_year_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
