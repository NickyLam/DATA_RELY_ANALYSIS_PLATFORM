/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a1btyhjjzf
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
create table ${iol_schema}.mpcs_a1btyhjjzf_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a1btyhjjzf;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a1btyhjjzf_op purge;
drop table ${iol_schema}.mpcs_a1btyhjjzf_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1btyhjjzf_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1btyhjjzf where 0=1;

create table ${iol_schema}.mpcs_a1btyhjjzf_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1btyhjjzf where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a1btyhjjzf_cl(
            transdt -- 登记日期
            ,transtm -- 登记时间
            ,qqdbs -- 请求单标识
            ,rwlsh -- 任务流水号
            ,zh -- 账卡号
            ,yrwlsh -- 原任务流水号
            ,updttm -- 更新时间
            ,result -- 处理结果 0-录入 1-已处理 2-处理失败 3-已登记
            ,tradetype -- 交易类型 1-紧急止付 2-解除止付
            ,openbr -- 
            ,pckno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a1btyhjjzf_op(
            transdt -- 登记日期
            ,transtm -- 登记时间
            ,qqdbs -- 请求单标识
            ,rwlsh -- 任务流水号
            ,zh -- 账卡号
            ,yrwlsh -- 原任务流水号
            ,updttm -- 更新时间
            ,result -- 处理结果 0-录入 1-已处理 2-处理失败 3-已登记
            ,tradetype -- 交易类型 1-紧急止付 2-解除止付
            ,openbr -- 
            ,pckno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.transdt, o.transdt) as transdt -- 登记日期
    ,nvl(n.transtm, o.transtm) as transtm -- 登记时间
    ,nvl(n.qqdbs, o.qqdbs) as qqdbs -- 请求单标识
    ,nvl(n.rwlsh, o.rwlsh) as rwlsh -- 任务流水号
    ,nvl(n.zh, o.zh) as zh -- 账卡号
    ,nvl(n.yrwlsh, o.yrwlsh) as yrwlsh -- 原任务流水号
    ,nvl(n.updttm, o.updttm) as updttm -- 更新时间
    ,nvl(n.result, o.result) as result -- 处理结果 0-录入 1-已处理 2-处理失败 3-已登记
    ,nvl(n.tradetype, o.tradetype) as tradetype -- 交易类型 1-紧急止付 2-解除止付
    ,nvl(n.openbr, o.openbr) as openbr -- 
    ,nvl(n.pckno, o.pckno) as pckno -- 
    ,case when
            n.qqdbs is null
            and n.rwlsh is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.qqdbs is null
            and n.rwlsh is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.qqdbs is null
            and n.rwlsh is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a1btyhjjzf_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a1btyhjjzf where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.qqdbs = n.qqdbs
            and o.rwlsh = n.rwlsh
where (
        o.qqdbs is null
        and o.rwlsh is null
    )
    or (
        n.qqdbs is null
        and n.rwlsh is null
    )
    or (
        o.transdt <> n.transdt
        or o.transtm <> n.transtm
        or o.zh <> n.zh
        or o.yrwlsh <> n.yrwlsh
        or o.updttm <> n.updttm
        or o.result <> n.result
        or o.tradetype <> n.tradetype
        or o.openbr <> n.openbr
        or o.pckno <> n.pckno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a1btyhjjzf_cl(
            transdt -- 登记日期
            ,transtm -- 登记时间
            ,qqdbs -- 请求单标识
            ,rwlsh -- 任务流水号
            ,zh -- 账卡号
            ,yrwlsh -- 原任务流水号
            ,updttm -- 更新时间
            ,result -- 处理结果 0-录入 1-已处理 2-处理失败 3-已登记
            ,tradetype -- 交易类型 1-紧急止付 2-解除止付
            ,openbr -- 
            ,pckno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a1btyhjjzf_op(
            transdt -- 登记日期
            ,transtm -- 登记时间
            ,qqdbs -- 请求单标识
            ,rwlsh -- 任务流水号
            ,zh -- 账卡号
            ,yrwlsh -- 原任务流水号
            ,updttm -- 更新时间
            ,result -- 处理结果 0-录入 1-已处理 2-处理失败 3-已登记
            ,tradetype -- 交易类型 1-紧急止付 2-解除止付
            ,openbr -- 
            ,pckno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.transdt -- 登记日期
    ,o.transtm -- 登记时间
    ,o.qqdbs -- 请求单标识
    ,o.rwlsh -- 任务流水号
    ,o.zh -- 账卡号
    ,o.yrwlsh -- 原任务流水号
    ,o.updttm -- 更新时间
    ,o.result -- 处理结果 0-录入 1-已处理 2-处理失败 3-已登记
    ,o.tradetype -- 交易类型 1-紧急止付 2-解除止付
    ,o.openbr -- 
    ,o.pckno -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a1btyhjjzf_bk o
    left join ${iol_schema}.mpcs_a1btyhjjzf_op n
        on
            o.qqdbs = n.qqdbs
            and o.rwlsh = n.rwlsh
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a1btyhjjzf_cl d
        on
            o.qqdbs = d.qqdbs
            and o.rwlsh = d.rwlsh
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_a1btyhjjzf;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a1btyhjjzf exchange partition p_19000101 with table ${iol_schema}.mpcs_a1btyhjjzf_cl;
alter table ${iol_schema}.mpcs_a1btyhjjzf exchange partition p_20991231 with table ${iol_schema}.mpcs_a1btyhjjzf_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a1btyhjjzf to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a1btyhjjzf_op purge;
drop table ${iol_schema}.mpcs_a1btyhjjzf_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a1btyhjjzf_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a1btyhjjzf',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
