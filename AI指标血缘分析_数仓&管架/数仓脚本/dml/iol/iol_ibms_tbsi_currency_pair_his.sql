/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_tbsi_currency_pair_his
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
create table ${iol_schema}.ibms_tbsi_currency_pair_his_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_tbsi_currency_pair_his
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_tbsi_currency_pair_his_op purge;
drop table ${iol_schema}.ibms_tbsi_currency_pair_his_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_tbsi_currency_pair_his_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_tbsi_currency_pair_his where 0=1;

create table ${iol_schema}.ibms_tbsi_currency_pair_his_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_tbsi_currency_pair_his where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_tbsi_currency_pair_his_cl(
            currency_1 -- 货币1
            ,currency_2 -- 货币2
            ,pe_code -- 定价环境
            ,tg_code -- 任务组代码
            ,beg_date -- 生效日期
            ,end_date -- 失效日期
            ,mk_eprice -- 估值，1单位货币1转货币2的估值
            ,mk_eprice_type -- 估值价格类型，0：无估值；1：市值估值；2：模型估值
            ,mk_cur_book -- 估值币种
            ,imp_time -- 导入时间
            ,task_rst_id -- 任务结果ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_tbsi_currency_pair_his_op(
            currency_1 -- 货币1
            ,currency_2 -- 货币2
            ,pe_code -- 定价环境
            ,tg_code -- 任务组代码
            ,beg_date -- 生效日期
            ,end_date -- 失效日期
            ,mk_eprice -- 估值，1单位货币1转货币2的估值
            ,mk_eprice_type -- 估值价格类型，0：无估值；1：市值估值；2：模型估值
            ,mk_cur_book -- 估值币种
            ,imp_time -- 导入时间
            ,task_rst_id -- 任务结果ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.currency_1, o.currency_1) as currency_1 -- 货币1
    ,nvl(n.currency_2, o.currency_2) as currency_2 -- 货币2
    ,nvl(n.pe_code, o.pe_code) as pe_code -- 定价环境
    ,nvl(n.tg_code, o.tg_code) as tg_code -- 任务组代码
    ,nvl(n.beg_date, o.beg_date) as beg_date -- 生效日期
    ,nvl(n.end_date, o.end_date) as end_date -- 失效日期
    ,nvl(n.mk_eprice, o.mk_eprice) as mk_eprice -- 估值，1单位货币1转货币2的估值
    ,nvl(n.mk_eprice_type, o.mk_eprice_type) as mk_eprice_type -- 估值价格类型，0：无估值；1：市值估值；2：模型估值
    ,nvl(n.mk_cur_book, o.mk_cur_book) as mk_cur_book -- 估值币种
    ,nvl(n.imp_time, o.imp_time) as imp_time -- 导入时间
    ,nvl(n.task_rst_id, o.task_rst_id) as task_rst_id -- 任务结果ID
    ,case when
            n.currency_1 is null
            and n.currency_2 is null
            and n.pe_code is null
            and n.tg_code is null
            and n.beg_date is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.currency_1 is null
            and n.currency_2 is null
            and n.pe_code is null
            and n.tg_code is null
            and n.beg_date is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.currency_1 is null
            and n.currency_2 is null
            and n.pe_code is null
            and n.tg_code is null
            and n.beg_date is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_tbsi_currency_pair_his_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_tbsi_currency_pair_his where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.currency_1 = n.currency_1
            and o.currency_2 = n.currency_2
            and o.pe_code = n.pe_code
            and o.tg_code = n.tg_code
            and o.beg_date = n.beg_date
where (
        o.currency_1 is null
        and o.currency_2 is null
        and o.pe_code is null
        and o.tg_code is null
        and o.beg_date is null
    )
    or (
        n.currency_1 is null
        and n.currency_2 is null
        and n.pe_code is null
        and n.tg_code is null
        and n.beg_date is null
    )
    or (
        o.end_date <> n.end_date
        or o.mk_eprice <> n.mk_eprice
        or o.mk_eprice_type <> n.mk_eprice_type
        or o.mk_cur_book <> n.mk_cur_book
        or o.imp_time <> n.imp_time
        or o.task_rst_id <> n.task_rst_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_tbsi_currency_pair_his_cl(
            currency_1 -- 货币1
            ,currency_2 -- 货币2
            ,pe_code -- 定价环境
            ,tg_code -- 任务组代码
            ,beg_date -- 生效日期
            ,end_date -- 失效日期
            ,mk_eprice -- 估值，1单位货币1转货币2的估值
            ,mk_eprice_type -- 估值价格类型，0：无估值；1：市值估值；2：模型估值
            ,mk_cur_book -- 估值币种
            ,imp_time -- 导入时间
            ,task_rst_id -- 任务结果ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_tbsi_currency_pair_his_op(
            currency_1 -- 货币1
            ,currency_2 -- 货币2
            ,pe_code -- 定价环境
            ,tg_code -- 任务组代码
            ,beg_date -- 生效日期
            ,end_date -- 失效日期
            ,mk_eprice -- 估值，1单位货币1转货币2的估值
            ,mk_eprice_type -- 估值价格类型，0：无估值；1：市值估值；2：模型估值
            ,mk_cur_book -- 估值币种
            ,imp_time -- 导入时间
            ,task_rst_id -- 任务结果ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.currency_1 -- 货币1
    ,o.currency_2 -- 货币2
    ,o.pe_code -- 定价环境
    ,o.tg_code -- 任务组代码
    ,o.beg_date -- 生效日期
    ,o.end_date -- 失效日期
    ,o.mk_eprice -- 估值，1单位货币1转货币2的估值
    ,o.mk_eprice_type -- 估值价格类型，0：无估值；1：市值估值；2：模型估值
    ,o.mk_cur_book -- 估值币种
    ,o.imp_time -- 导入时间
    ,o.task_rst_id -- 任务结果ID
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
from ${iol_schema}.ibms_tbsi_currency_pair_his_bk o
    left join ${iol_schema}.ibms_tbsi_currency_pair_his_op n
        on
            o.currency_1 = n.currency_1
            and o.currency_2 = n.currency_2
            and o.pe_code = n.pe_code
            and o.tg_code = n.tg_code
            and o.beg_date = n.beg_date
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_tbsi_currency_pair_his_cl d
        on
            o.currency_1 = d.currency_1
            and o.currency_2 = d.currency_2
            and o.pe_code = d.pe_code
            and o.tg_code = d.tg_code
            and o.beg_date = d.beg_date
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ibms_tbsi_currency_pair_his;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_tbsi_currency_pair_his') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_tbsi_currency_pair_his drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_tbsi_currency_pair_his add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_tbsi_currency_pair_his exchange partition p_${batch_date} with table ${iol_schema}.ibms_tbsi_currency_pair_his_cl;
alter table ${iol_schema}.ibms_tbsi_currency_pair_his exchange partition p_20991231 with table ${iol_schema}.ibms_tbsi_currency_pair_his_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_tbsi_currency_pair_his to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_tbsi_currency_pair_his_op purge;
drop table ${iol_schema}.ibms_tbsi_currency_pair_his_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_tbsi_currency_pair_his_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_tbsi_currency_pair_his',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
