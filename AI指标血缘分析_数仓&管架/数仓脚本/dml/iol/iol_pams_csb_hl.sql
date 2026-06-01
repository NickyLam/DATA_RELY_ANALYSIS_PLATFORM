/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_csb_hl
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
create table ${iol_schema}.pams_csb_hl_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pams_csb_hl
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_csb_hl_op purge;
drop table ${iol_schema}.pams_csb_hl_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_csb_hl_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_csb_hl where 0=1;

create table ${iol_schema}.pams_csb_hl_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_csb_hl where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_csb_hl_cl(
            bz -- 币种
            ,qsrq -- 起始日期
            ,jsrq -- 结束日期
            ,zrmbhl -- 折人民币汇率
            ,zmyhl -- 折美元汇率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_csb_hl_op(
            bz -- 币种
            ,qsrq -- 起始日期
            ,jsrq -- 结束日期
            ,zrmbhl -- 折人民币汇率
            ,zmyhl -- 折美元汇率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.bz, o.bz) as bz -- 币种
    ,nvl(n.qsrq, o.qsrq) as qsrq -- 起始日期
    ,nvl(n.jsrq, o.jsrq) as jsrq -- 结束日期
    ,nvl(n.zrmbhl, o.zrmbhl) as zrmbhl -- 折人民币汇率
    ,nvl(n.zmyhl, o.zmyhl) as zmyhl -- 折美元汇率
    ,case when
            n.bz is null
            and n.qsrq is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.bz is null
            and n.qsrq is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.bz is null
            and n.qsrq is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.pams_csb_hl_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pams_csb_hl where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.bz = n.bz
            and o.qsrq = n.qsrq
where (
        o.bz is null
        and o.qsrq is null
    )
    or (
        n.bz is null
        and n.qsrq is null
    )
    or (
        o.jsrq <> n.jsrq
        or o.zrmbhl <> n.zrmbhl
        or o.zmyhl <> n.zmyhl
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_csb_hl_cl(
            bz -- 币种
            ,qsrq -- 起始日期
            ,jsrq -- 结束日期
            ,zrmbhl -- 折人民币汇率
            ,zmyhl -- 折美元汇率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_csb_hl_op(
            bz -- 币种
            ,qsrq -- 起始日期
            ,jsrq -- 结束日期
            ,zrmbhl -- 折人民币汇率
            ,zmyhl -- 折美元汇率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.bz -- 币种
    ,o.qsrq -- 起始日期
    ,o.jsrq -- 结束日期
    ,o.zrmbhl -- 折人民币汇率
    ,o.zmyhl -- 折美元汇率
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
from ${iol_schema}.pams_csb_hl_bk o
    left join ${iol_schema}.pams_csb_hl_op n
        on
            o.bz = n.bz
            and o.qsrq = n.qsrq
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pams_csb_hl_cl d
        on
            o.bz = d.bz
            and o.qsrq = d.qsrq
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.pams_csb_hl;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('pams_csb_hl') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.pams_csb_hl drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.pams_csb_hl add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.pams_csb_hl exchange partition p_${batch_date} with table ${iol_schema}.pams_csb_hl_cl;
alter table ${iol_schema}.pams_csb_hl exchange partition p_20991231 with table ${iol_schema}.pams_csb_hl_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_csb_hl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_csb_hl_op purge;
drop table ${iol_schema}.pams_csb_hl_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pams_csb_hl_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_csb_hl',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
