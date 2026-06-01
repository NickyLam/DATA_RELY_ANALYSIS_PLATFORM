/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_set_instruction_secu_his
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
drop table ${iol_schema}.ibms_ttrd_set_instruction_secu_his_ex purge;
alter table ${iol_schema}.ibms_ttrd_set_instruction_secu_his add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ibms_ttrd_set_instruction_secu_his;

-- 2.3 insert data to ex table
create table ${iol_schema}.ibms_ttrd_set_instruction_secu_his_ex nologging
compress
as
select * from ${iol_schema}.ibms_ttrd_set_instruction_secu_his where 0=1;

insert /*+ append */ into ${iol_schema}.ibms_ttrd_set_instruction_secu_his_ex(
    secu_inst_id -- 
    ,secu_inst_grp_id -- 
    ,inst_id -- 
    ,biz_type -- 
    ,direction -- 
    ,trade_grp_id -- 
    ,secu_acct_id -- 
    ,ext_secu_acct_id -- 
    ,i_code -- 
    ,a_type -- 
    ,m_type -- 
    ,currency -- 
    ,real_fee -- 
    ,estd_ai -- 
    ,received_ai -- 
    ,estd_cp -- 
    ,real_ai -- 
    ,real_cp -- 
    ,due_ai -- 
    ,due_cp -- 
    ,prft_fee -- 
    ,is_remain_due_ai -- 
    ,is_remain_due_cp -- 
    ,volume -- 
    ,freeze_volume -- 
    ,is_fixed -- 
    ,cal_date -- 
    ,set_date -- 
    ,set_finish_date -- 
    ,i_name -- 
    ,p_class -- 
    ,cost -- 
    ,cost_ai_his_real -- 
    ,zzd_acct_code -- 
    ,party_zzd_acct_code -- 
    ,create_time -- 
    ,update_time -- 
    ,update_user -- 
    ,confirm_time -- 
    ,confirm_user -- 
    ,account_time -- 
    ,account_user -- 
    ,memo -- 
    ,amount -- 
    ,close_trade_id -- 
    ,blc_state -- 
    ,acctg_state -- 
    ,estd_fee -- 
    ,fee -- 
    ,opr_state -- 
    ,secu_inst_setgrp_id -- 
    ,his_flag -- 
    ,his_secu_inst_id -- 
    ,his_set_finish_date -- 
    ,acctg_inst_id -- 
    ,cancel_flag -- 
    ,volume_termcur -- 
    ,amount_termcur -- 
    ,estd_cp_termcur -- 
    ,real_cp_termcur -- 
    ,amrt_method -- 
    ,real_margin -- 
    ,fpml -- 
    ,is_impair -- 
    ,is_theory_acct -- 是否已做过理论核算
    ,is_theory_blc -- 是否已做权责业务
    ,cl_status -- 占用状态-20代表冻结或者实占-30代表冻结转实占
    ,party_pset -- 结算场所代码
    ,party_pset_country -- 国家代码
    ,party_agent_code_type -- 代理行代码类型
    ,party_agent_code_dss -- 代理行代码编码集合名称
    ,party_agent_code -- 代理行代码
    ,party_agent_account -- 代理行账号
    ,party_code_type -- 交易主体代码类型
    ,party_code_dss -- 交易主体代码编码集合名称
    ,party_code -- 交易主体代码
    ,party_account -- 交易主体账号
    ,si_id -- 证券结算要素id
    ,cal_start_date -- 计息开始日期
    ,ord_limit_secu_inst_id -- 审批单限额券指令号
    ,is_calc_tax_4_prft_trd -- 卖出时买卖损益是否拆税。枚举值：0此字段无效，向前兼容，老项目使用。1拆税，2不拆税
    ,estd_volume -- 预计数量
    ,estd_amount -- 预计面额
    ,module_type -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
    ,party_pset_name -- 结算场所名称
    ,volume_geninst -- 生成指令时持仓数量
    ,custom_dim1 -- 扩展维度1
    ,xcc_module_type -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
    ,is_editable -- 前台是否可修改
    ,memo_secu -- 理论实收付备注信息
    ,dtl_due_type -- 明细due类型
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    secu_inst_id -- 
    ,secu_inst_grp_id -- 
    ,inst_id -- 
    ,biz_type -- 
    ,direction -- 
    ,trade_grp_id -- 
    ,secu_acct_id -- 
    ,ext_secu_acct_id -- 
    ,i_code -- 
    ,a_type -- 
    ,m_type -- 
    ,currency -- 
    ,real_fee -- 
    ,estd_ai -- 
    ,received_ai -- 
    ,estd_cp -- 
    ,real_ai -- 
    ,real_cp -- 
    ,due_ai -- 
    ,due_cp -- 
    ,prft_fee -- 
    ,is_remain_due_ai -- 
    ,is_remain_due_cp -- 
    ,volume -- 
    ,freeze_volume -- 
    ,is_fixed -- 
    ,cal_date -- 
    ,set_date -- 
    ,set_finish_date -- 
    ,i_name -- 
    ,p_class -- 
    ,cost -- 
    ,cost_ai_his_real -- 
    ,zzd_acct_code -- 
    ,party_zzd_acct_code -- 
    ,create_time -- 
    ,update_time -- 
    ,update_user -- 
    ,confirm_time -- 
    ,confirm_user -- 
    ,account_time -- 
    ,account_user -- 
    ,memo -- 
    ,amount -- 
    ,close_trade_id -- 
    ,blc_state -- 
    ,acctg_state -- 
    ,estd_fee -- 
    ,fee -- 
    ,opr_state -- 
    ,secu_inst_setgrp_id -- 
    ,his_flag -- 
    ,his_secu_inst_id -- 
    ,his_set_finish_date -- 
    ,acctg_inst_id -- 
    ,cancel_flag -- 
    ,volume_termcur -- 
    ,amount_termcur -- 
    ,estd_cp_termcur -- 
    ,real_cp_termcur -- 
    ,amrt_method -- 
    ,real_margin -- 
    ,fpml -- 
    ,is_impair -- 
    ,is_theory_acct -- 是否已做过理论核算
    ,is_theory_blc -- 是否已做权责业务
    ,cl_status -- 占用状态-20代表冻结或者实占-30代表冻结转实占
    ,party_pset -- 结算场所代码
    ,party_pset_country -- 国家代码
    ,party_agent_code_type -- 代理行代码类型
    ,party_agent_code_dss -- 代理行代码编码集合名称
    ,party_agent_code -- 代理行代码
    ,party_agent_account -- 代理行账号
    ,party_code_type -- 交易主体代码类型
    ,party_code_dss -- 交易主体代码编码集合名称
    ,party_code -- 交易主体代码
    ,party_account -- 交易主体账号
    ,si_id -- 证券结算要素id
    ,cal_start_date -- 计息开始日期
    ,ord_limit_secu_inst_id -- 审批单限额券指令号
    ,is_calc_tax_4_prft_trd -- 卖出时买卖损益是否拆税。枚举值：0此字段无效，向前兼容，老项目使用。1拆税，2不拆税
    ,estd_volume -- 预计数量
    ,estd_amount -- 预计面额
    ,module_type -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
    ,party_pset_name -- 结算场所名称
    ,volume_geninst -- 生成指令时持仓数量
    ,custom_dim1 -- 扩展维度1
    ,xcc_module_type -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
    ,is_editable -- 前台是否可修改
    ,memo_secu -- 理论实收付备注信息
    ,dtl_due_type -- 明细due类型
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ibms_ttrd_set_instruction_secu_his
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ibms_ttrd_set_instruction_secu_his exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_set_instruction_secu_his_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_set_instruction_secu_his to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ibms_ttrd_set_instruction_secu_his_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_set_instruction_secu_his',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);