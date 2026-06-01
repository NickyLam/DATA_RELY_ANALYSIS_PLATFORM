/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_set_instruction_his
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_set_instruction_his_ex purge;
alter table ${iol_schema}.ibms_ttrd_set_instruction_his add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ibms_ttrd_set_instruction_his;

-- 2.3 insert data to ex table
create table ${iol_schema}.ibms_ttrd_set_instruction_his_ex nologging
compress
as
select * from ${iol_schema}.ibms_ttrd_set_instruction_his where 0=1;

insert /*+ append */ into ${iol_schema}.ibms_ttrd_set_instruction_his_ex(
    inst_id -- 
    ,trade_id -- 
    ,inst_type -- 
    ,inst_grp_id -- 
    ,trd_type -- 
    ,set_type -- 
    ,theory_set_date -- 
    ,real_set_date -- 
    ,h_m_type -- 
    ,h_a_type -- 
    ,h_i_code -- 
    ,party_id -- 
    ,party_name -- 
    ,order_id -- 
    ,is_theory_payment -- 
    ,bj_market -- 
    ,bj_state -- 
    ,ext_ord_id -- 
    ,exe_market -- 
    ,create_time -- 
    ,update_time -- 
    ,update_user -- 
    ,account_time -- 
    ,account_user -- 
    ,memo -- 
    ,update_user_id -- 
    ,cal_date -- 
    ,ref_cash_inst_id -- 
    ,ref_secu_inst_id -- 
    ,inst_setgrp_id -- 
    ,state -- 
    ,operator_id -- 
    ,operator_name -- 
    ,print_times -- 打印次数
    ,due_order -- 挂账顺序
    ,due_obj_key -- 挂账序号
    ,generate_type -- 指令生成类型
    ,ref_inst_id -- 
    ,is_real_acctg -- 
    ,real_account_inst_id -- 实际核算主指令号
    ,is_unknown_price -- 是否未知价格 0：已知价格 1：未知价格
    ,his_flag -- 历史交易表示0.普通交易（默认）1.补录 2.撤销 3.反冲 4。修改
    ,cash_acct_id -- 内部资金账户
    ,his_inst_id -- 调账主指令号
    ,his_ref_inst_id -- 历史关联主指令号
    ,is_operator_checked -- 是否进行过资金指令编辑金额校验 0:未校验,1:已校验
    ,orddate -- 交易日
    ,condate -- 确认日期
    ,is_match -- 是否是清算流水durable结算指令，1：是，其他：不是
    ,settlemode -- 结算类型
    ,host_market -- 托管场所
    ,spv_id -- spv信息id
    ,process_type -- 
    ,clearing_date -- 清算日
    ,acctg_estd_completed -- 理论流程是否完成 0：未完成， 1 已完成
    ,acctg_real_completed -- 实收流程是否完成 0：未完成， 1 已完成
    ,clearing_completed -- 清算是否完成 0：未完成， 1 已完成
    ,is_period_inst -- 0：非存续期指令 1：存续期指令
    ,tsk_id -- 任务号
    ,approvestatus -- 0：需要检查差额审批；1：不需要检查差额审批；2：周期指令新建状态提交差额审批；3：周期指令新建状态提交差额审批审批通过；4：周期指令自动确认状态提交差额审批；5：周期指令自动确认状态提交差额审批审批通过；-1:差额审批拒绝；
    ,bind_inst_id -- 绑定id
    ,trader -- 交易员
    ,xcc_limit_type -- 限额指令类型
    ,exh_extordid -- 委托编号
    ,create_user_id -- 创建人员id
    ,q_accname -- 
    ,q_secu_acct_id -- 
    ,q_party_zzd_acct_code -- 
    ,q_p_type -- 
    ,q_p_class -- 
    ,q_currency -- 
    ,q_i_name -- 
    ,q_i_id -- 
    ,q_settle_amount -- 
    ,q_two_effective_contract -- 
    ,trade_orddate -- 
    ,trade_ids -- 
    ,order_ids -- 
    ,trade_ref_type -- 
    ,q_description -- 
    ,is_refreshable -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    inst_id -- 
    ,trade_id -- 
    ,inst_type -- 
    ,inst_grp_id -- 
    ,trd_type -- 
    ,set_type -- 
    ,theory_set_date -- 
    ,real_set_date -- 
    ,h_m_type -- 
    ,h_a_type -- 
    ,h_i_code -- 
    ,party_id -- 
    ,party_name -- 
    ,order_id -- 
    ,is_theory_payment -- 
    ,bj_market -- 
    ,bj_state -- 
    ,ext_ord_id -- 
    ,exe_market -- 
    ,create_time -- 
    ,update_time -- 
    ,update_user -- 
    ,account_time -- 
    ,account_user -- 
    ,memo -- 
    ,update_user_id -- 
    ,cal_date -- 
    ,ref_cash_inst_id -- 
    ,ref_secu_inst_id -- 
    ,inst_setgrp_id -- 
    ,state -- 
    ,operator_id -- 
    ,operator_name -- 
    ,print_times -- 打印次数
    ,due_order -- 挂账顺序
    ,due_obj_key -- 挂账序号
    ,generate_type -- 指令生成类型
    ,ref_inst_id -- 
    ,is_real_acctg -- 
    ,real_account_inst_id -- 实际核算主指令号
    ,is_unknown_price -- 是否未知价格 0：已知价格 1：未知价格
    ,his_flag -- 历史交易表示0.普通交易（默认）1.补录 2.撤销 3.反冲 4。修改
    ,cash_acct_id -- 内部资金账户
    ,his_inst_id -- 调账主指令号
    ,his_ref_inst_id -- 历史关联主指令号
    ,is_operator_checked -- 是否进行过资金指令编辑金额校验 0:未校验,1:已校验
    ,orddate -- 交易日
    ,condate -- 确认日期
    ,is_match -- 是否是清算流水durable结算指令，1：是，其他：不是
    ,settlemode -- 结算类型
    ,host_market -- 托管场所
    ,spv_id -- spv信息id
    ,process_type -- 
    ,clearing_date -- 清算日
    ,acctg_estd_completed -- 理论流程是否完成 0：未完成， 1 已完成
    ,acctg_real_completed -- 实收流程是否完成 0：未完成， 1 已完成
    ,clearing_completed -- 清算是否完成 0：未完成， 1 已完成
    ,is_period_inst -- 0：非存续期指令 1：存续期指令
    ,tsk_id -- 任务号
    ,approvestatus -- 0：需要检查差额审批；1：不需要检查差额审批；2：周期指令新建状态提交差额审批；3：周期指令新建状态提交差额审批审批通过；4：周期指令自动确认状态提交差额审批；5：周期指令自动确认状态提交差额审批审批通过；-1:差额审批拒绝；
    ,bind_inst_id -- 绑定id
    ,trader -- 交易员
    ,xcc_limit_type -- 限额指令类型
    ,exh_extordid -- 委托编号
    ,create_user_id -- 创建人员id
    ,q_accname -- 
    ,q_secu_acct_id -- 
    ,q_party_zzd_acct_code -- 
    ,q_p_type -- 
    ,q_p_class -- 
    ,q_currency -- 
    ,q_i_name -- 
    ,q_i_id -- 
    ,q_settle_amount -- 
    ,q_two_effective_contract -- 
    ,trade_orddate -- 
    ,trade_ids -- 
    ,order_ids -- 
    ,trade_ref_type -- 
    ,q_description -- 
    ,is_refreshable -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ibms_ttrd_set_instruction_his
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ibms_ttrd_set_instruction_his exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_set_instruction_his_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_set_instruction_his to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ibms_ttrd_set_instruction_his_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_set_instruction_his',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);