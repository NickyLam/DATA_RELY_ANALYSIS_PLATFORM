/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_dc_stage_observe_days
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
create table ${iol_schema}.ncbs_rb_dc_stage_observe_days_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_dc_stage_observe_days
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_dc_stage_observe_days_op purge;
drop table ${iol_schema}.ncbs_rb_dc_stage_observe_days_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_dc_stage_observe_days_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_dc_stage_observe_days where 0=1;

create table ${iol_schema}.ncbs_rb_dc_stage_observe_days_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_dc_stage_observe_days where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_dc_stage_observe_days_cl(
            client_no -- 客户编号
            ,prod_type -- 产品编号
            ,company -- 法人
            ,stage_code -- 期次代码
            ,observe_end_date -- 观察终止日期
            ,observe_start_date -- 观察起始日期
            ,tran_timestamp -- 交易时间戳
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_dc_stage_observe_days_op(
            client_no -- 客户编号
            ,prod_type -- 产品编号
            ,company -- 法人
            ,stage_code -- 期次代码
            ,observe_end_date -- 观察终止日期
            ,observe_start_date -- 观察起始日期
            ,tran_timestamp -- 交易时间戳
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.stage_code, o.stage_code) as stage_code -- 期次代码
    ,nvl(n.observe_end_date, o.observe_end_date) as observe_end_date -- 观察终止日期
    ,nvl(n.observe_start_date, o.observe_start_date) as observe_start_date -- 观察起始日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,case when
            n.prod_type is null
            and n.stage_code is null
            and n.observe_start_date is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.prod_type is null
            and n.stage_code is null
            and n.observe_start_date is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.prod_type is null
            and n.stage_code is null
            and n.observe_start_date is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_dc_stage_observe_days_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_dc_stage_observe_days where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.prod_type = n.prod_type
            and o.stage_code = n.stage_code
            and o.observe_start_date = n.observe_start_date
where (
        o.prod_type is null
        and o.stage_code is null
        and o.observe_start_date is null
    )
    or (
        n.prod_type is null
        and n.stage_code is null
        and n.observe_start_date is null
    )
    or (
        o.client_no <> n.client_no
        or o.company <> n.company
        or o.observe_end_date <> n.observe_end_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.tran_branch <> n.tran_branch
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_dc_stage_observe_days_cl(
            client_no -- 客户编号
            ,prod_type -- 产品编号
            ,company -- 法人
            ,stage_code -- 期次代码
            ,observe_end_date -- 观察终止日期
            ,observe_start_date -- 观察起始日期
            ,tran_timestamp -- 交易时间戳
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_dc_stage_observe_days_op(
            client_no -- 客户编号
            ,prod_type -- 产品编号
            ,company -- 法人
            ,stage_code -- 期次代码
            ,observe_end_date -- 观察终止日期
            ,observe_start_date -- 观察起始日期
            ,tran_timestamp -- 交易时间戳
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.client_no -- 客户编号
    ,o.prod_type -- 产品编号
    ,o.company -- 法人
    ,o.stage_code -- 期次代码
    ,o.observe_end_date -- 观察终止日期
    ,o.observe_start_date -- 观察起始日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.tran_branch -- 核心交易机构编号
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
from ${iol_schema}.ncbs_rb_dc_stage_observe_days_bk o
    left join ${iol_schema}.ncbs_rb_dc_stage_observe_days_op n
        on
            o.prod_type = n.prod_type
            and o.stage_code = n.stage_code
            and o.observe_start_date = n.observe_start_date
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_dc_stage_observe_days_cl d
        on
            o.prod_type = d.prod_type
            and o.stage_code = d.stage_code
            and o.observe_start_date = d.observe_start_date
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_dc_stage_observe_days;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_dc_stage_observe_days') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_dc_stage_observe_days drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_dc_stage_observe_days add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_dc_stage_observe_days exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_dc_stage_observe_days_cl;
alter table ${iol_schema}.ncbs_rb_dc_stage_observe_days exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_dc_stage_observe_days_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_dc_stage_observe_days to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_dc_stage_observe_days_op purge;
drop table ${iol_schema}.ncbs_rb_dc_stage_observe_days_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_dc_stage_observe_days_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_dc_stage_observe_days',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
