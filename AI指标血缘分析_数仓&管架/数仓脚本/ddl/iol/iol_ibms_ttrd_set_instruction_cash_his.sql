/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_set_instruction_cash_his
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_set_instruction_cash_his
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_set_instruction_cash_his purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_set_instruction_cash_his(
    cash_inst_id number(16,0) -- 
    ,inst_id number(16,0) -- 
    ,cash_inst_grp_id number(16,0) -- 
    ,biz_type varchar2(45) -- 
    ,direction varchar2(15) -- 
    ,cash_acct_id varchar2(45) -- 
    ,ext_cash_acct_id varchar2(30) -- 
    ,currency varchar2(15) -- 
    ,amount number(31,4) -- 
    ,freeze_amount number(31,4) -- 
    ,set_date varchar2(15) -- 
    ,set_finish_date varchar2(15) -- 
    ,transfer_type number(22) -- 
    ,acct_code varchar2(150) -- 
    ,acct_name varchar2(150) -- 
    ,bank_code varchar2(150) -- 
    ,bank_name varchar2(150) -- 
    ,party_acct_code varchar2(150) -- 
    ,party_acct_name varchar2(150) -- 
    ,party_bank_code varchar2(150) -- 
    ,party_bank_name varchar2(300) -- 
    ,create_time varchar2(29) -- 
    ,update_time varchar2(35) -- 
    ,update_user varchar2(150) -- 
    ,account_time varchar2(29) -- 
    ,account_user varchar2(30) -- 
    ,memo varchar2(750) -- 
    ,blc_state number(22) -- 
    ,acctg_state number(22) -- 
    ,opr_state number(22) -- 
    ,cash_inst_setgrp_id number(16,0) -- 
    ,acctg_inst_id number(16,0) -- 
    ,cancel_flag varchar2(2) -- 
    ,is_theory_blc varchar2(2) -- 
    ,nostro_ref_cash_inst_id number(16,0) -- 
    ,pending_flow_no varchar2(45) -- 核心收款挂账日期
    ,pending_date varchar2(15) -- 
    ,is_theory_acct varchar2(2) -- 是否已做过理论核算
    ,mid_bank_acct_code varchar2(75) -- 中间行账号
    ,mid_bank_name varchar2(75) -- 中间行名称
    ,mid_swift_code varchar2(75) -- 中间行swift代码
    ,swift_code varchar2(75) -- swift代码
    ,party_swift_code varchar2(75) -- 对手方基础货币swift代码
    ,party_mid_bank_acct_code varchar2(75) -- 对手方中间行账号
    ,party_mid_bank_name varchar2(75) -- 对手方中间行名称
    ,party_mid_swift_code varchar2(75) -- 对手方中间行swift代码
    ,cl_status number(31,0) -- 指令状态
    ,party_i_bank_code varchar2(75) -- 交易对手银行行号
    ,party_i_swift_code varchar2(75) -- 交易对手swiftcode
    ,his_cash_inst_id number(16,0) -- 历史资金指令号
    ,his_flag number(22) -- 0:正常指令;1:补录指令;2:撤销指令;3:反冲指令
    ,ord_limit_cash_inst_id number(31,0) -- 审批单限额资金指令号
    ,hvps_mate_trace_no varchar2(180) -- 邢台银行：已匹配大额来账平台流水号
    ,module_type number(22) -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
    ,xcc_module_type number(22) -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
    ,is_editable varchar2(2) -- 前台是否可修改
    ,check_result_box number(4,0) -- 指令复选框状态
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ibms_ttrd_set_instruction_cash_his to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_set_instruction_cash_his to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_set_instruction_cash_his to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_set_instruction_cash_his to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_set_instruction_cash_his is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.cash_inst_id is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.inst_id is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.cash_inst_grp_id is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.biz_type is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.direction is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.cash_acct_id is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.ext_cash_acct_id is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.currency is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.amount is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.freeze_amount is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.set_date is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.set_finish_date is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.transfer_type is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.acct_code is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.acct_name is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.bank_code is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.bank_name is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.party_acct_code is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.party_acct_name is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.party_bank_code is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.party_bank_name is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.create_time is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.update_time is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.update_user is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.account_time is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.account_user is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.memo is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.blc_state is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.acctg_state is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.opr_state is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.cash_inst_setgrp_id is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.acctg_inst_id is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.cancel_flag is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.is_theory_blc is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.nostro_ref_cash_inst_id is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.pending_flow_no is '核心收款挂账日期';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.pending_date is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.is_theory_acct is '是否已做过理论核算';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.mid_bank_acct_code is '中间行账号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.mid_bank_name is '中间行名称';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.mid_swift_code is '中间行swift代码';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.swift_code is 'swift代码';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.party_swift_code is '对手方基础货币swift代码';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.party_mid_bank_acct_code is '对手方中间行账号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.party_mid_bank_name is '对手方中间行名称';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.party_mid_swift_code is '对手方中间行swift代码';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.cl_status is '指令状态';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.party_i_bank_code is '交易对手银行行号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.party_i_swift_code is '交易对手swiftcode';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.his_cash_inst_id is '历史资金指令号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.his_flag is '0:正常指令;1:补录指令;2:撤销指令;3:反冲指令';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.ord_limit_cash_inst_id is '审批单限额资金指令号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.hvps_mate_trace_no is '邢台银行：已匹配大额来账平台流水号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.module_type is '核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.xcc_module_type is '核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.is_editable is '前台是否可修改';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.check_result_box is '指令复选框状态';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash_his.etl_timestamp is 'ETL处理时间戳';
