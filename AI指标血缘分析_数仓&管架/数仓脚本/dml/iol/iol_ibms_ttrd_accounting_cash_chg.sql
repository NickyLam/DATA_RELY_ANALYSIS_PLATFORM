/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_accounting_cash_chg
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
whenever sqlerror continue none ;
create table ${iol_schema}.ibms_ttrd_accounting_cash_chg_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_accounting_cash_chg;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_accounting_cash_chg_op purge;
drop table ${iol_schema}.ibms_ttrd_accounting_cash_chg_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_accounting_cash_chg_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.ibms_ttrd_accounting_cash_chg where 0=1;

create table ${iol_schema}.ibms_ttrd_accounting_cash_chg_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.ibms_ttrd_accounting_cash_chg where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.ibms_ttrd_accounting_cash_chg_op(
        chg_id -- 变动Id
        ,erase_ref_chg_id -- 撤销关联变动Id
        ,tsk_id -- 任务Id
        ,chg_date -- 变动日期
        ,chg_type -- 0：指令生成；1：日生成；2：周期生成。
        ,acctg_obj_id -- 对象Id
        ,inst_id -- 指令Id
        ,cash_biz_type -- 资金指令类型
        ,ext_cash_acct_id -- 外部资金账户
        ,cash_acct_id -- 内部资金账户
        ,estd_or_real -- E：理论核算；R：实际核算。
        ,transf_type -- 转账方式
        ,currency -- 币种
        ,real_amount -- 余额
        ,real_margin -- 期货保证金
        ,update_time -- 更新时间
        ,process -- 核算过程
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.chg_id -- 变动Id
    ,n.erase_ref_chg_id -- 撤销关联变动Id
    ,n.tsk_id -- 任务Id
    ,n.chg_date -- 变动日期
    ,n.chg_type -- 0：指令生成；1：日生成；2：周期生成。
    ,n.acctg_obj_id -- 对象Id
    ,n.inst_id -- 指令Id
    ,n.cash_biz_type -- 资金指令类型
    ,n.ext_cash_acct_id -- 外部资金账户
    ,n.cash_acct_id -- 内部资金账户
    ,n.estd_or_real -- E：理论核算；R：实际核算。
    ,n.transf_type -- 转账方式
    ,n.currency -- 币种
    ,n.real_amount -- 余额
    ,n.real_margin -- 期货保证金
    ,n.update_time -- 更新时间
    ,n.process -- 核算过程
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_accounting_cash_chg_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
    right join (select * from ${itl_schema}.ibms_ttrd_accounting_cash_chg where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.chg_id = n.chg_id
            and o.tsk_id = n.tsk_id
where (
        o.chg_id is null
        and o.tsk_id is null
    )
    or (
        o.erase_ref_chg_id <> n.erase_ref_chg_id
        or o.chg_date <> n.chg_date
        or o.chg_type <> n.chg_type
        or o.acctg_obj_id <> n.acctg_obj_id
        or o.inst_id <> n.inst_id
        or o.cash_biz_type <> n.cash_biz_type
        or o.ext_cash_acct_id <> n.ext_cash_acct_id
        or o.cash_acct_id <> n.cash_acct_id
        or o.estd_or_real <> n.estd_or_real
        or o.transf_type <> n.transf_type
        or o.currency <> n.currency
        or o.real_amount <> n.real_amount
        or o.real_margin <> n.real_margin
        or o.update_time <> n.update_time
        or o.process <> n.process
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_accounting_cash_chg_cl(
            chg_id -- 变动Id
        ,erase_ref_chg_id -- 撤销关联变动Id
        ,tsk_id -- 任务Id
        ,chg_date -- 变动日期
        ,chg_type -- 0：指令生成；1：日生成；2：周期生成。
        ,acctg_obj_id -- 对象Id
        ,inst_id -- 指令Id
        ,cash_biz_type -- 资金指令类型
        ,ext_cash_acct_id -- 外部资金账户
        ,cash_acct_id -- 内部资金账户
        ,estd_or_real -- E：理论核算；R：实际核算。
        ,transf_type -- 转账方式
        ,currency -- 币种
        ,real_amount -- 余额
        ,real_margin -- 期货保证金
        ,update_time -- 更新时间
        ,process -- 核算过程
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_accounting_cash_chg_op(
            chg_id -- 变动Id
        ,erase_ref_chg_id -- 撤销关联变动Id
        ,tsk_id -- 任务Id
        ,chg_date -- 变动日期
        ,chg_type -- 0：指令生成；1：日生成；2：周期生成。
        ,acctg_obj_id -- 对象Id
        ,inst_id -- 指令Id
        ,cash_biz_type -- 资金指令类型
        ,ext_cash_acct_id -- 外部资金账户
        ,cash_acct_id -- 内部资金账户
        ,estd_or_real -- E：理论核算；R：实际核算。
        ,transf_type -- 转账方式
        ,currency -- 币种
        ,real_amount -- 余额
        ,real_margin -- 期货保证金
        ,update_time -- 更新时间
        ,process -- 核算过程
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.chg_id -- 变动Id
    ,o.erase_ref_chg_id -- 撤销关联变动Id
    ,o.tsk_id -- 任务Id
    ,o.chg_date -- 变动日期
    ,o.chg_type -- 0：指令生成；1：日生成；2：周期生成。
    ,o.acctg_obj_id -- 对象Id
    ,o.inst_id -- 指令Id
    ,o.cash_biz_type -- 资金指令类型
    ,o.ext_cash_acct_id -- 外部资金账户
    ,o.cash_acct_id -- 内部资金账户
    ,o.estd_or_real -- E：理论核算；R：实际核算。
    ,o.transf_type -- 转账方式
    ,o.currency -- 币种
    ,o.real_amount -- 余额
    ,o.real_margin -- 期货保证金
    ,o.update_time -- 更新时间
    ,o.process -- 核算过程
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ibms_ttrd_accounting_cash_chg_bk o
    left join ${iol_schema}.ibms_ttrd_accounting_cash_chg_op n
        on
            o.chg_id = n.chg_id
            and o.tsk_id = n.tsk_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ibms_ttrd_accounting_cash_chg;

-- 4.2 exchange partition
alter table ${iol_schema}.ibms_ttrd_accounting_cash_chg exchange partition p_19000101 with table ${iol_schema}.ibms_ttrd_accounting_cash_chg_cl;
alter table ${iol_schema}.ibms_ttrd_accounting_cash_chg exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_accounting_cash_chg_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_accounting_cash_chg to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_accounting_cash_chg_op purge;
drop table ${iol_schema}.ibms_ttrd_accounting_cash_chg_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_accounting_cash_chg_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_accounting_cash_chg',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
