/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cpes_anoclick_details
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
create table ${iol_schema}.bdms_cpes_anoclick_details_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_cpes_anoclick_details
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_anoclick_details_op purge;
drop table ${iol_schema}.bdms_cpes_anoclick_details_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_anoclick_details_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_anoclick_details where 0=1;

create table ${iol_schema}.bdms_cpes_anoclick_details_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_anoclick_details where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_anoclick_details_cl(
            id -- ID
            ,match_contract_id -- 匹配批次表ID
            ,dpc_draft_id -- 票据表ID
            ,draft_number -- 票据号码
            ,draft_amount -- 票面金额
            ,maturity_date -- 票据到期日
            ,real_due_date -- 实际到期日
            ,pay_interest -- 应付利息
            ,due_pay_interest -- 到期应付利息
            ,settle_amt -- 结算金额
            ,due_settle_amt -- 到期结算金额
            ,credit_type -- 信用主体类型: 201	政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司
            ,credit_branch -- 信用主体
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,valid_flag -- 有效标识： 0-无效 1-有效
            ,last_upd_opr -- 最后修改人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,cd_range -- 子票区间
            ,standard_amt -- 标准金额
            ,split_range -- 拆前区间
            ,cd_split -- 是否允许分包流转： 0 否 1 是
            ,org_draft_amount -- 原始票据（包）金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_anoclick_details_op(
            id -- ID
            ,match_contract_id -- 匹配批次表ID
            ,dpc_draft_id -- 票据表ID
            ,draft_number -- 票据号码
            ,draft_amount -- 票面金额
            ,maturity_date -- 票据到期日
            ,real_due_date -- 实际到期日
            ,pay_interest -- 应付利息
            ,due_pay_interest -- 到期应付利息
            ,settle_amt -- 结算金额
            ,due_settle_amt -- 到期结算金额
            ,credit_type -- 信用主体类型: 201	政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司
            ,credit_branch -- 信用主体
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,valid_flag -- 有效标识： 0-无效 1-有效
            ,last_upd_opr -- 最后修改人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,cd_range -- 子票区间
            ,standard_amt -- 标准金额
            ,split_range -- 拆前区间
            ,cd_split -- 是否允许分包流转： 0 否 1 是
            ,org_draft_amount -- 原始票据（包）金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.match_contract_id, o.match_contract_id) as match_contract_id -- 匹配批次表ID
    ,nvl(n.dpc_draft_id, o.dpc_draft_id) as dpc_draft_id -- 票据表ID
    ,nvl(n.draft_number, o.draft_number) as draft_number -- 票据号码
    ,nvl(n.draft_amount, o.draft_amount) as draft_amount -- 票面金额
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 票据到期日
    ,nvl(n.real_due_date, o.real_due_date) as real_due_date -- 实际到期日
    ,nvl(n.pay_interest, o.pay_interest) as pay_interest -- 应付利息
    ,nvl(n.due_pay_interest, o.due_pay_interest) as due_pay_interest -- 到期应付利息
    ,nvl(n.settle_amt, o.settle_amt) as settle_amt -- 结算金额
    ,nvl(n.due_settle_amt, o.due_settle_amt) as due_settle_amt -- 到期结算金额
    ,nvl(n.credit_type, o.credit_type) as credit_type -- 信用主体类型: 201	政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司
    ,nvl(n.credit_branch, o.credit_branch) as credit_branch -- 信用主体
    ,nvl(n.account_status, o.account_status) as account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,nvl(n.valid_flag, o.valid_flag) as valid_flag -- 有效标识： 0-无效 1-有效
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后修改人
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.misc, o.misc) as misc -- 备注
    ,nvl(n.reserver1, o.reserver1) as reserver1 -- 预留域1
    ,nvl(n.reserver2, o.reserver2) as reserver2 -- 预留域2
    ,nvl(n.cd_range, o.cd_range) as cd_range -- 子票区间
    ,nvl(n.standard_amt, o.standard_amt) as standard_amt -- 标准金额
    ,nvl(n.split_range, o.split_range) as split_range -- 拆前区间
    ,nvl(n.cd_split, o.cd_split) as cd_split -- 是否允许分包流转： 0 否 1 是
    ,nvl(n.org_draft_amount, o.org_draft_amount) as org_draft_amount -- 原始票据（包）金额
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
from (select * from ${iol_schema}.bdms_cpes_anoclick_details_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_cpes_anoclick_details where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.match_contract_id <> n.match_contract_id
        or o.dpc_draft_id <> n.dpc_draft_id
        or o.draft_number <> n.draft_number
        or o.draft_amount <> n.draft_amount
        or o.maturity_date <> n.maturity_date
        or o.real_due_date <> n.real_due_date
        or o.pay_interest <> n.pay_interest
        or o.due_pay_interest <> n.due_pay_interest
        or o.settle_amt <> n.settle_amt
        or o.due_settle_amt <> n.due_settle_amt
        or o.credit_type <> n.credit_type
        or o.credit_branch <> n.credit_branch
        or o.account_status <> n.account_status
        or o.valid_flag <> n.valid_flag
        or o.last_upd_opr <> n.last_upd_opr
        or o.last_upd_time <> n.last_upd_time
        or o.misc <> n.misc
        or o.reserver1 <> n.reserver1
        or o.reserver2 <> n.reserver2
        or o.cd_range <> n.cd_range
        or o.standard_amt <> n.standard_amt
        or o.split_range <> n.split_range
        or o.cd_split <> n.cd_split
        or o.org_draft_amount <> n.org_draft_amount
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_anoclick_details_cl(
            id -- ID
            ,match_contract_id -- 匹配批次表ID
            ,dpc_draft_id -- 票据表ID
            ,draft_number -- 票据号码
            ,draft_amount -- 票面金额
            ,maturity_date -- 票据到期日
            ,real_due_date -- 实际到期日
            ,pay_interest -- 应付利息
            ,due_pay_interest -- 到期应付利息
            ,settle_amt -- 结算金额
            ,due_settle_amt -- 到期结算金额
            ,credit_type -- 信用主体类型: 201	政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司
            ,credit_branch -- 信用主体
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,valid_flag -- 有效标识： 0-无效 1-有效
            ,last_upd_opr -- 最后修改人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,cd_range -- 子票区间
            ,standard_amt -- 标准金额
            ,split_range -- 拆前区间
            ,cd_split -- 是否允许分包流转： 0 否 1 是
            ,org_draft_amount -- 原始票据（包）金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_anoclick_details_op(
            id -- ID
            ,match_contract_id -- 匹配批次表ID
            ,dpc_draft_id -- 票据表ID
            ,draft_number -- 票据号码
            ,draft_amount -- 票面金额
            ,maturity_date -- 票据到期日
            ,real_due_date -- 实际到期日
            ,pay_interest -- 应付利息
            ,due_pay_interest -- 到期应付利息
            ,settle_amt -- 结算金额
            ,due_settle_amt -- 到期结算金额
            ,credit_type -- 信用主体类型: 201	政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司
            ,credit_branch -- 信用主体
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,valid_flag -- 有效标识： 0-无效 1-有效
            ,last_upd_opr -- 最后修改人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,cd_range -- 子票区间
            ,standard_amt -- 标准金额
            ,split_range -- 拆前区间
            ,cd_split -- 是否允许分包流转： 0 否 1 是
            ,org_draft_amount -- 原始票据（包）金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.match_contract_id -- 匹配批次表ID
    ,o.dpc_draft_id -- 票据表ID
    ,o.draft_number -- 票据号码
    ,o.draft_amount -- 票面金额
    ,o.maturity_date -- 票据到期日
    ,o.real_due_date -- 实际到期日
    ,o.pay_interest -- 应付利息
    ,o.due_pay_interest -- 到期应付利息
    ,o.settle_amt -- 结算金额
    ,o.due_settle_amt -- 到期结算金额
    ,o.credit_type -- 信用主体类型: 201	政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司
    ,o.credit_branch -- 信用主体
    ,o.account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,o.valid_flag -- 有效标识： 0-无效 1-有效
    ,o.last_upd_opr -- 最后修改人
    ,o.last_upd_time -- 最后修改时间
    ,o.misc -- 备注
    ,o.reserver1 -- 预留域1
    ,o.reserver2 -- 预留域2
    ,o.cd_range -- 子票区间
    ,o.standard_amt -- 标准金额
    ,o.split_range -- 拆前区间
    ,o.cd_split -- 是否允许分包流转： 0 否 1 是
    ,o.org_draft_amount -- 原始票据（包）金额
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
from ${iol_schema}.bdms_cpes_anoclick_details_bk o
    left join ${iol_schema}.bdms_cpes_anoclick_details_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_cpes_anoclick_details_cl d
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
--truncate table ${iol_schema}.bdms_cpes_anoclick_details;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_cpes_anoclick_details') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_cpes_anoclick_details drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_cpes_anoclick_details add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_cpes_anoclick_details exchange partition p_${batch_date} with table ${iol_schema}.bdms_cpes_anoclick_details_cl;
alter table ${iol_schema}.bdms_cpes_anoclick_details exchange partition p_20991231 with table ${iol_schema}.bdms_cpes_anoclick_details_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cpes_anoclick_details to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_anoclick_details_op purge;
drop table ${iol_schema}.bdms_cpes_anoclick_details_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_cpes_anoclick_details_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cpes_anoclick_details',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
