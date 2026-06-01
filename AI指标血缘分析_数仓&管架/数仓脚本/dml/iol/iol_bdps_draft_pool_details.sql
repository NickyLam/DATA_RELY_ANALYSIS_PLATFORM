/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdps_draft_pool_details
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
create table ${iol_schema}.bdps_draft_pool_details_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdps_draft_pool_details
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_draft_pool_details_op purge;
drop table ${iol_schema}.bdps_draft_pool_details_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_draft_pool_details_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_draft_pool_details where 0=1;

create table ${iol_schema}.bdps_draft_pool_details_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_draft_pool_details where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_draft_pool_details_cl(
            id -- 
            ,contract_id -- 
            ,cancel_contract_id -- 
            ,draft_id -- 
            ,ref_id -- 
            ,dtl_status -- 
            ,misc -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,bail_acct_no -- 
            ,draft_amount_rate -- 
            ,cancel_collztn -- 
            ,ebank_pool_out_id -- 
            ,ebank_pool_in_id -- 
            ,is_problem_draft -- 
            ,serial_no -- 信贷占用流水号
            ,is_occupy -- 是否占用保贴额度 0-否 1-是
            ,billsys_out_id -- 电票质押转代保管申请ID
            ,billsys_in_id -- 电票代保管转质押申请ID
            ,account_flag -- 记账标识0-记帐失败 1-记帐成功 2-解记帐失败 3-解记帐成功 4-到期回款
            ,derive_amt -- 质押计算天数
            ,ple_day -- 质押计算天数
            ,rate -- 质押计算利率
            ,serino -- 序列号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_draft_pool_details_op(
            id -- 
            ,contract_id -- 
            ,cancel_contract_id -- 
            ,draft_id -- 
            ,ref_id -- 
            ,dtl_status -- 
            ,misc -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,bail_acct_no -- 
            ,draft_amount_rate -- 
            ,cancel_collztn -- 
            ,ebank_pool_out_id -- 
            ,ebank_pool_in_id -- 
            ,is_problem_draft -- 
            ,serial_no -- 信贷占用流水号
            ,is_occupy -- 是否占用保贴额度 0-否 1-是
            ,billsys_out_id -- 电票质押转代保管申请ID
            ,billsys_in_id -- 电票代保管转质押申请ID
            ,account_flag -- 记账标识0-记帐失败 1-记帐成功 2-解记帐失败 3-解记帐成功 4-到期回款
            ,derive_amt -- 质押计算天数
            ,ple_day -- 质押计算天数
            ,rate -- 质押计算利率
            ,serino -- 序列号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.contract_id, o.contract_id) as contract_id -- 
    ,nvl(n.cancel_contract_id, o.cancel_contract_id) as cancel_contract_id -- 
    ,nvl(n.draft_id, o.draft_id) as draft_id -- 
    ,nvl(n.ref_id, o.ref_id) as ref_id -- 
    ,nvl(n.dtl_status, o.dtl_status) as dtl_status -- 
    ,nvl(n.misc, o.misc) as misc -- 
    ,nvl(n.last_upd_oper_id, o.last_upd_oper_id) as last_upd_oper_id -- 
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 
    ,nvl(n.bail_acct_no, o.bail_acct_no) as bail_acct_no -- 
    ,nvl(n.draft_amount_rate, o.draft_amount_rate) as draft_amount_rate -- 
    ,nvl(n.cancel_collztn, o.cancel_collztn) as cancel_collztn -- 
    ,nvl(n.ebank_pool_out_id, o.ebank_pool_out_id) as ebank_pool_out_id -- 
    ,nvl(n.ebank_pool_in_id, o.ebank_pool_in_id) as ebank_pool_in_id -- 
    ,nvl(n.is_problem_draft, o.is_problem_draft) as is_problem_draft -- 
    ,nvl(n.serial_no, o.serial_no) as serial_no -- 信贷占用流水号
    ,nvl(n.is_occupy, o.is_occupy) as is_occupy -- 是否占用保贴额度 0-否 1-是
    ,nvl(n.billsys_out_id, o.billsys_out_id) as billsys_out_id -- 电票质押转代保管申请ID
    ,nvl(n.billsys_in_id, o.billsys_in_id) as billsys_in_id -- 电票代保管转质押申请ID
    ,nvl(n.account_flag, o.account_flag) as account_flag -- 记账标识0-记帐失败 1-记帐成功 2-解记帐失败 3-解记帐成功 4-到期回款
    ,nvl(n.derive_amt, o.derive_amt) as derive_amt -- 质押计算天数
    ,nvl(n.ple_day, o.ple_day) as ple_day -- 质押计算天数
    ,nvl(n.rate, o.rate) as rate -- 质押计算利率
    ,nvl(n.serino, o.serino) as serino -- 序列号
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.bdps_draft_pool_details_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdps_draft_pool_details where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.contract_id <> n.contract_id
        or o.cancel_contract_id <> n.cancel_contract_id
        or o.draft_id <> n.draft_id
        or o.ref_id <> n.ref_id
        or o.dtl_status <> n.dtl_status
        or o.misc <> n.misc
        or o.last_upd_oper_id <> n.last_upd_oper_id
        or o.last_upd_time <> n.last_upd_time
        or o.bail_acct_no <> n.bail_acct_no
        or o.draft_amount_rate <> n.draft_amount_rate
        or o.cancel_collztn <> n.cancel_collztn
        or o.ebank_pool_out_id <> n.ebank_pool_out_id
        or o.ebank_pool_in_id <> n.ebank_pool_in_id
        or o.is_problem_draft <> n.is_problem_draft
        or o.serial_no <> n.serial_no
        or o.is_occupy <> n.is_occupy
        or o.billsys_out_id <> n.billsys_out_id
        or o.billsys_in_id <> n.billsys_in_id
        or o.account_flag <> n.account_flag
        or o.derive_amt <> n.derive_amt
        or o.ple_day <> n.ple_day
        or o.rate <> n.rate
        or o.serino <> n.serino
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_draft_pool_details_cl(
            id -- 
            ,contract_id -- 
            ,cancel_contract_id -- 
            ,draft_id -- 
            ,ref_id -- 
            ,dtl_status -- 
            ,misc -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,bail_acct_no -- 
            ,draft_amount_rate -- 
            ,cancel_collztn -- 
            ,ebank_pool_out_id -- 
            ,ebank_pool_in_id -- 
            ,is_problem_draft -- 
            ,serial_no -- 信贷占用流水号
            ,is_occupy -- 是否占用保贴额度 0-否 1-是
            ,billsys_out_id -- 电票质押转代保管申请ID
            ,billsys_in_id -- 电票代保管转质押申请ID
            ,account_flag -- 记账标识0-记帐失败 1-记帐成功 2-解记帐失败 3-解记帐成功 4-到期回款
            ,derive_amt -- 质押计算天数
            ,ple_day -- 质押计算天数
            ,rate -- 质押计算利率
            ,serino -- 序列号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_draft_pool_details_op(
            id -- 
            ,contract_id -- 
            ,cancel_contract_id -- 
            ,draft_id -- 
            ,ref_id -- 
            ,dtl_status -- 
            ,misc -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,bail_acct_no -- 
            ,draft_amount_rate -- 
            ,cancel_collztn -- 
            ,ebank_pool_out_id -- 
            ,ebank_pool_in_id -- 
            ,is_problem_draft -- 
            ,serial_no -- 信贷占用流水号
            ,is_occupy -- 是否占用保贴额度 0-否 1-是
            ,billsys_out_id -- 电票质押转代保管申请ID
            ,billsys_in_id -- 电票代保管转质押申请ID
            ,account_flag -- 记账标识0-记帐失败 1-记帐成功 2-解记帐失败 3-解记帐成功 4-到期回款
            ,derive_amt -- 质押计算天数
            ,ple_day -- 质押计算天数
            ,rate -- 质押计算利率
            ,serino -- 序列号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.contract_id -- 
    ,o.cancel_contract_id -- 
    ,o.draft_id -- 
    ,o.ref_id -- 
    ,o.dtl_status -- 
    ,o.misc -- 
    ,o.last_upd_oper_id -- 
    ,o.last_upd_time -- 
    ,o.bail_acct_no -- 
    ,o.draft_amount_rate -- 
    ,o.cancel_collztn -- 
    ,o.ebank_pool_out_id -- 
    ,o.ebank_pool_in_id -- 
    ,o.is_problem_draft -- 
    ,o.serial_no -- 信贷占用流水号
    ,o.is_occupy -- 是否占用保贴额度 0-否 1-是
    ,o.billsys_out_id -- 电票质押转代保管申请ID
    ,o.billsys_in_id -- 电票代保管转质押申请ID
    ,o.account_flag -- 记账标识0-记帐失败 1-记帐成功 2-解记帐失败 3-解记帐成功 4-到期回款
    ,o.derive_amt -- 质押计算天数
    ,o.ple_day -- 质押计算天数
    ,o.rate -- 质押计算利率
    ,o.serino -- 序列号
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
from ${iol_schema}.bdps_draft_pool_details_bk o
    left join ${iol_schema}.bdps_draft_pool_details_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdps_draft_pool_details_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.bdps_draft_pool_details;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdps_draft_pool_details') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdps_draft_pool_details drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdps_draft_pool_details add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdps_draft_pool_details exchange partition p_${batch_date} with table ${iol_schema}.bdps_draft_pool_details_cl;
alter table ${iol_schema}.bdps_draft_pool_details exchange partition p_20991231 with table ${iol_schema}.bdps_draft_pool_details_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdps_draft_pool_details to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_draft_pool_details_op purge;
drop table ${iol_schema}.bdps_draft_pool_details_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdps_draft_pool_details_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdps_draft_pool_details',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
