/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cpes_redsct_details
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
create table ${iol_schema}.bdms_cpes_redsct_details_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_cpes_redsct_details
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_redsct_details_op purge;
drop table ${iol_schema}.bdms_cpes_redsct_details_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_redsct_details_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_redsct_details where 0=1;

create table ${iol_schema}.bdms_cpes_redsct_details_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_redsct_details where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_redsct_details_cl(
            id -- ID
            ,contract_id -- 批次表ID
            ,draft_id -- 票据表ID
            ,draft_amount -- 票面金额
            ,maturity_date -- 票据到期日
            ,real_due_date -- 实际到期日
            ,tenor_days -- 剩余期限
            ,pay_interest -- 应付利息
            ,settle_amt -- 结算金额
            ,due_settle_amt -- 到期结算金额
            ,credit_status -- 额度占用状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败
            ,details_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 09 再贴现拒绝签收
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,valid_flag -- 有效标识： 0 无效 1 有效
            ,is_discount -- 是否转贴现票据： 0 否 1 是
            ,is_allopatric -- 是否异地票据： 0 否 1 是
            ,is_meet_policy -- 是否符合政策标准： 0 否 1 是
            ,is_refuse -- 是否拒绝： 0 否 1 是
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,process_code -- 处理结果码
            ,process_msg -- 处理结果说明
            ,cpes_lock_flag -- 票交所锁定标识： 0 未锁定 1 已锁定
            ,msg_note -- 报文备注
            ,due_pay_interest -- 到期应付利息
            ,cd_range -- 子票区间
            ,standard_amt -- 标准金额
            ,split_range -- 拆前区间
            ,cd_split -- 是否允许分包流转： 0 否 1 是
            ,draft_number -- 票据（包）号
            ,org_draft_amount -- 原始票据（包）金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_redsct_details_op(
            id -- ID
            ,contract_id -- 批次表ID
            ,draft_id -- 票据表ID
            ,draft_amount -- 票面金额
            ,maturity_date -- 票据到期日
            ,real_due_date -- 实际到期日
            ,tenor_days -- 剩余期限
            ,pay_interest -- 应付利息
            ,settle_amt -- 结算金额
            ,due_settle_amt -- 到期结算金额
            ,credit_status -- 额度占用状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败
            ,details_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 09 再贴现拒绝签收
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,valid_flag -- 有效标识： 0 无效 1 有效
            ,is_discount -- 是否转贴现票据： 0 否 1 是
            ,is_allopatric -- 是否异地票据： 0 否 1 是
            ,is_meet_policy -- 是否符合政策标准： 0 否 1 是
            ,is_refuse -- 是否拒绝： 0 否 1 是
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,process_code -- 处理结果码
            ,process_msg -- 处理结果说明
            ,cpes_lock_flag -- 票交所锁定标识： 0 未锁定 1 已锁定
            ,msg_note -- 报文备注
            ,due_pay_interest -- 到期应付利息
            ,cd_range -- 子票区间
            ,standard_amt -- 标准金额
            ,split_range -- 拆前区间
            ,cd_split -- 是否允许分包流转： 0 否 1 是
            ,draft_number -- 票据（包）号
            ,org_draft_amount -- 原始票据（包）金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.contract_id, o.contract_id) as contract_id -- 批次表ID
    ,nvl(n.draft_id, o.draft_id) as draft_id -- 票据表ID
    ,nvl(n.draft_amount, o.draft_amount) as draft_amount -- 票面金额
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 票据到期日
    ,nvl(n.real_due_date, o.real_due_date) as real_due_date -- 实际到期日
    ,nvl(n.tenor_days, o.tenor_days) as tenor_days -- 剩余期限
    ,nvl(n.pay_interest, o.pay_interest) as pay_interest -- 应付利息
    ,nvl(n.settle_amt, o.settle_amt) as settle_amt -- 结算金额
    ,nvl(n.due_settle_amt, o.due_settle_amt) as due_settle_amt -- 到期结算金额
    ,nvl(n.credit_status, o.credit_status) as credit_status -- 额度占用状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败
    ,nvl(n.details_status, o.details_status) as details_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 09 再贴现拒绝签收
    ,nvl(n.account_status, o.account_status) as account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,nvl(n.valid_flag, o.valid_flag) as valid_flag -- 有效标识： 0 无效 1 有效
    ,nvl(n.is_discount, o.is_discount) as is_discount -- 是否转贴现票据： 0 否 1 是
    ,nvl(n.is_allopatric, o.is_allopatric) as is_allopatric -- 是否异地票据： 0 否 1 是
    ,nvl(n.is_meet_policy, o.is_meet_policy) as is_meet_policy -- 是否符合政策标准： 0 否 1 是
    ,nvl(n.is_refuse, o.is_refuse) as is_refuse -- 是否拒绝： 0 否 1 是
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后操作人
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.misc, o.misc) as misc -- 备注
    ,nvl(n.reserver1, o.reserver1) as reserver1 -- 预留域1
    ,nvl(n.reserver2, o.reserver2) as reserver2 -- 预留域2
    ,nvl(n.process_code, o.process_code) as process_code -- 处理结果码
    ,nvl(n.process_msg, o.process_msg) as process_msg -- 处理结果说明
    ,nvl(n.cpes_lock_flag, o.cpes_lock_flag) as cpes_lock_flag -- 票交所锁定标识： 0 未锁定 1 已锁定
    ,nvl(n.msg_note, o.msg_note) as msg_note -- 报文备注
    ,nvl(n.due_pay_interest, o.due_pay_interest) as due_pay_interest -- 到期应付利息
    ,nvl(n.cd_range, o.cd_range) as cd_range -- 子票区间
    ,nvl(n.standard_amt, o.standard_amt) as standard_amt -- 标准金额
    ,nvl(n.split_range, o.split_range) as split_range -- 拆前区间
    ,nvl(n.cd_split, o.cd_split) as cd_split -- 是否允许分包流转： 0 否 1 是
    ,nvl(n.draft_number, o.draft_number) as draft_number -- 票据（包）号
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
from (select * from ${iol_schema}.bdms_cpes_redsct_details_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_cpes_redsct_details where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.draft_id <> n.draft_id
        or o.draft_amount <> n.draft_amount
        or o.maturity_date <> n.maturity_date
        or o.real_due_date <> n.real_due_date
        or o.tenor_days <> n.tenor_days
        or o.pay_interest <> n.pay_interest
        or o.settle_amt <> n.settle_amt
        or o.due_settle_amt <> n.due_settle_amt
        or o.credit_status <> n.credit_status
        or o.details_status <> n.details_status
        or o.account_status <> n.account_status
        or o.valid_flag <> n.valid_flag
        or o.is_discount <> n.is_discount
        or o.is_allopatric <> n.is_allopatric
        or o.is_meet_policy <> n.is_meet_policy
        or o.is_refuse <> n.is_refuse
        or o.last_upd_opr <> n.last_upd_opr
        or o.last_upd_time <> n.last_upd_time
        or o.misc <> n.misc
        or o.reserver1 <> n.reserver1
        or o.reserver2 <> n.reserver2
        or o.process_code <> n.process_code
        or o.process_msg <> n.process_msg
        or o.cpes_lock_flag <> n.cpes_lock_flag
        or o.msg_note <> n.msg_note
        or o.due_pay_interest <> n.due_pay_interest
        or o.cd_range <> n.cd_range
        or o.standard_amt <> n.standard_amt
        or o.split_range <> n.split_range
        or o.cd_split <> n.cd_split
        or o.draft_number <> n.draft_number
        or o.org_draft_amount <> n.org_draft_amount
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_redsct_details_cl(
            id -- ID
            ,contract_id -- 批次表ID
            ,draft_id -- 票据表ID
            ,draft_amount -- 票面金额
            ,maturity_date -- 票据到期日
            ,real_due_date -- 实际到期日
            ,tenor_days -- 剩余期限
            ,pay_interest -- 应付利息
            ,settle_amt -- 结算金额
            ,due_settle_amt -- 到期结算金额
            ,credit_status -- 额度占用状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败
            ,details_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 09 再贴现拒绝签收
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,valid_flag -- 有效标识： 0 无效 1 有效
            ,is_discount -- 是否转贴现票据： 0 否 1 是
            ,is_allopatric -- 是否异地票据： 0 否 1 是
            ,is_meet_policy -- 是否符合政策标准： 0 否 1 是
            ,is_refuse -- 是否拒绝： 0 否 1 是
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,process_code -- 处理结果码
            ,process_msg -- 处理结果说明
            ,cpes_lock_flag -- 票交所锁定标识： 0 未锁定 1 已锁定
            ,msg_note -- 报文备注
            ,due_pay_interest -- 到期应付利息
            ,cd_range -- 子票区间
            ,standard_amt -- 标准金额
            ,split_range -- 拆前区间
            ,cd_split -- 是否允许分包流转： 0 否 1 是
            ,draft_number -- 票据（包）号
            ,org_draft_amount -- 原始票据（包）金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_redsct_details_op(
            id -- ID
            ,contract_id -- 批次表ID
            ,draft_id -- 票据表ID
            ,draft_amount -- 票面金额
            ,maturity_date -- 票据到期日
            ,real_due_date -- 实际到期日
            ,tenor_days -- 剩余期限
            ,pay_interest -- 应付利息
            ,settle_amt -- 结算金额
            ,due_settle_amt -- 到期结算金额
            ,credit_status -- 额度占用状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败
            ,details_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 09 再贴现拒绝签收
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,valid_flag -- 有效标识： 0 无效 1 有效
            ,is_discount -- 是否转贴现票据： 0 否 1 是
            ,is_allopatric -- 是否异地票据： 0 否 1 是
            ,is_meet_policy -- 是否符合政策标准： 0 否 1 是
            ,is_refuse -- 是否拒绝： 0 否 1 是
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,process_code -- 处理结果码
            ,process_msg -- 处理结果说明
            ,cpes_lock_flag -- 票交所锁定标识： 0 未锁定 1 已锁定
            ,msg_note -- 报文备注
            ,due_pay_interest -- 到期应付利息
            ,cd_range -- 子票区间
            ,standard_amt -- 标准金额
            ,split_range -- 拆前区间
            ,cd_split -- 是否允许分包流转： 0 否 1 是
            ,draft_number -- 票据（包）号
            ,org_draft_amount -- 原始票据（包）金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.contract_id -- 批次表ID
    ,o.draft_id -- 票据表ID
    ,o.draft_amount -- 票面金额
    ,o.maturity_date -- 票据到期日
    ,o.real_due_date -- 实际到期日
    ,o.tenor_days -- 剩余期限
    ,o.pay_interest -- 应付利息
    ,o.settle_amt -- 结算金额
    ,o.due_settle_amt -- 到期结算金额
    ,o.credit_status -- 额度占用状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败
    ,o.details_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 09 再贴现拒绝签收
    ,o.account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,o.valid_flag -- 有效标识： 0 无效 1 有效
    ,o.is_discount -- 是否转贴现票据： 0 否 1 是
    ,o.is_allopatric -- 是否异地票据： 0 否 1 是
    ,o.is_meet_policy -- 是否符合政策标准： 0 否 1 是
    ,o.is_refuse -- 是否拒绝： 0 否 1 是
    ,o.last_upd_opr -- 最后操作人
    ,o.last_upd_time -- 最后修改时间
    ,o.misc -- 备注
    ,o.reserver1 -- 预留域1
    ,o.reserver2 -- 预留域2
    ,o.process_code -- 处理结果码
    ,o.process_msg -- 处理结果说明
    ,o.cpes_lock_flag -- 票交所锁定标识： 0 未锁定 1 已锁定
    ,o.msg_note -- 报文备注
    ,o.due_pay_interest -- 到期应付利息
    ,o.cd_range -- 子票区间
    ,o.standard_amt -- 标准金额
    ,o.split_range -- 拆前区间
    ,o.cd_split -- 是否允许分包流转： 0 否 1 是
    ,o.draft_number -- 票据（包）号
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
from ${iol_schema}.bdms_cpes_redsct_details_bk o
    left join ${iol_schema}.bdms_cpes_redsct_details_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_cpes_redsct_details_cl d
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
--truncate table ${iol_schema}.bdms_cpes_redsct_details;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_cpes_redsct_details') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_cpes_redsct_details drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_cpes_redsct_details add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_cpes_redsct_details exchange partition p_${batch_date} with table ${iol_schema}.bdms_cpes_redsct_details_cl;
alter table ${iol_schema}.bdms_cpes_redsct_details exchange partition p_20991231 with table ${iol_schema}.bdms_cpes_redsct_details_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cpes_redsct_details to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_redsct_details_op purge;
drop table ${iol_schema}.bdms_cpes_redsct_details_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_cpes_redsct_details_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cpes_redsct_details',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
