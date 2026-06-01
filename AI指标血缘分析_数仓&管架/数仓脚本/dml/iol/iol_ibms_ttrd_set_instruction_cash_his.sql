/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_set_instruction_cash_his
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
drop table ${iol_schema}.ibms_ttrd_set_instruction_cash_his_ex purge;
alter table ${iol_schema}.ibms_ttrd_set_instruction_cash_his add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ibms_ttrd_set_instruction_cash_his truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ibms_ttrd_set_instruction_cash_his_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_set_instruction_cash_his where 0=1;

insert /*+ append */ into ${iol_schema}.ibms_ttrd_set_instruction_cash_his_ex(
    cash_inst_id -- 
    ,inst_id -- 
    ,cash_inst_grp_id -- 
    ,biz_type -- 
    ,direction -- 
    ,cash_acct_id -- 
    ,ext_cash_acct_id -- 
    ,currency -- 
    ,amount -- 
    ,freeze_amount -- 
    ,set_date -- 
    ,set_finish_date -- 
    ,transfer_type -- 
    ,acct_code -- 
    ,acct_name -- 
    ,bank_code -- 
    ,bank_name -- 
    ,party_acct_code -- 
    ,party_acct_name -- 
    ,party_bank_code -- 
    ,party_bank_name -- 
    ,create_time -- 
    ,update_time -- 
    ,update_user -- 
    ,account_time -- 
    ,account_user -- 
    ,memo -- 
    ,blc_state -- 
    ,acctg_state -- 
    ,opr_state -- 
    ,cash_inst_setgrp_id -- 
    ,acctg_inst_id -- 
    ,cancel_flag -- 
    ,is_theory_blc -- 
    ,nostro_ref_cash_inst_id -- 
    ,pending_flow_no -- 核心收款挂账日期
    ,pending_date -- 
    ,is_theory_acct -- 是否已做过理论核算
    ,mid_bank_acct_code -- 中间行账号
    ,mid_bank_name -- 中间行名称
    ,mid_swift_code -- 中间行SWIFT代码
    ,swift_code -- swift代码
    ,party_swift_code -- 对手方基础货币swift代码
    ,party_mid_bank_acct_code -- 对手方中间行账号
    ,party_mid_bank_name -- 对手方中间行名称
    ,party_mid_swift_code -- 对手方中间行SWIFT代码
    ,cl_status -- 指令状态
    ,party_i_bank_code -- 交易对手银行行号
    ,party_i_swift_code -- 交易对手swiftCode
    ,his_cash_inst_id -- 历史资金指令号
    ,his_flag -- 0:正常指令;1:补录指令;2:撤销指令;3:反冲指令
    ,ord_limit_cash_inst_id -- 审批单限额资金指令号
    ,hvps_mate_trace_no -- 邢台银行：已匹配大额来账平台流水号
    ,module_type -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
    ,xcc_module_type -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
    ,is_editable -- 前台是否可修改
    ,check_result_box -- 指令复选框状态
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    cash_inst_id -- 
    ,inst_id -- 
    ,cash_inst_grp_id -- 
    ,biz_type -- 
    ,direction -- 
    ,cash_acct_id -- 
    ,ext_cash_acct_id -- 
    ,currency -- 
    ,amount -- 
    ,freeze_amount -- 
    ,set_date -- 
    ,set_finish_date -- 
    ,transfer_type -- 
    ,acct_code -- 
    ,acct_name -- 
    ,bank_code -- 
    ,bank_name -- 
    ,party_acct_code -- 
    ,party_acct_name -- 
    ,party_bank_code -- 
    ,party_bank_name -- 
    ,create_time -- 
    ,update_time -- 
    ,update_user -- 
    ,account_time -- 
    ,account_user -- 
    ,memo -- 
    ,blc_state -- 
    ,acctg_state -- 
    ,opr_state -- 
    ,cash_inst_setgrp_id -- 
    ,acctg_inst_id -- 
    ,cancel_flag -- 
    ,is_theory_blc -- 
    ,nostro_ref_cash_inst_id -- 
    ,pending_flow_no -- 核心收款挂账日期
    ,pending_date -- 
    ,is_theory_acct -- 是否已做过理论核算
    ,mid_bank_acct_code -- 中间行账号
    ,mid_bank_name -- 中间行名称
    ,mid_swift_code -- 中间行SWIFT代码
    ,swift_code -- swift代码
    ,party_swift_code -- 对手方基础货币swift代码
    ,party_mid_bank_acct_code -- 对手方中间行账号
    ,party_mid_bank_name -- 对手方中间行名称
    ,party_mid_swift_code -- 对手方中间行SWIFT代码
    ,cl_status -- 指令状态
    ,party_i_bank_code -- 交易对手银行行号
    ,party_i_swift_code -- 交易对手swiftCode
    ,his_cash_inst_id -- 历史资金指令号
    ,his_flag -- 0:正常指令;1:补录指令;2:撤销指令;3:反冲指令
    ,ord_limit_cash_inst_id -- 审批单限额资金指令号
    ,hvps_mate_trace_no -- 邢台银行：已匹配大额来账平台流水号
    ,module_type -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
    ,xcc_module_type -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
    ,is_editable -- 前台是否可修改
    ,check_result_box -- 指令复选框状态
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ibms_ttrd_set_instruction_cash_his
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ibms_ttrd_set_instruction_cash_his exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_set_instruction_cash_his_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_set_instruction_cash_his to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ibms_ttrd_set_instruction_cash_his_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_set_instruction_cash_his',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);