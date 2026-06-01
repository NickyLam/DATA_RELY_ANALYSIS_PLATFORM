/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_set_instruction_his
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_set_instruction_his
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_set_instruction_his purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_set_instruction_his(
    inst_id number(16,0) -- 
    ,trade_id varchar2(45) -- 
    ,inst_type number(22) -- 
    ,inst_grp_id number(16,0) -- 
    ,trd_type varchar2(15) -- 
    ,set_type varchar2(30) -- 
    ,theory_set_date varchar2(15) -- 
    ,real_set_date varchar2(15) -- 
    ,h_m_type varchar2(30) -- 
    ,h_a_type varchar2(30) -- 
    ,h_i_code varchar2(75) -- 
    ,party_id number(22) -- 
    ,party_name varchar2(300) -- 
    ,order_id varchar2(75) -- 
    ,is_theory_payment varchar2(2) -- 
    ,bj_market varchar2(30) -- 
    ,bj_state number(22) -- 
    ,ext_ord_id varchar2(75) -- 
    ,exe_market varchar2(45) -- 
    ,create_time varchar2(29) -- 
    ,update_time varchar2(35) -- 
    ,update_user varchar2(150) -- 
    ,account_time varchar2(29) -- 
    ,account_user varchar2(30) -- 
    ,memo varchar2(750) -- 
    ,update_user_id varchar2(45) -- 
    ,cal_date varchar2(15) -- 
    ,ref_cash_inst_id number(16,0) -- 
    ,ref_secu_inst_id number(16,0) -- 
    ,inst_setgrp_id number(16,0) -- 
    ,state number(16,0) -- 
    ,operator_id varchar2(45) -- 
    ,operator_name varchar2(150) -- 
    ,print_times number(22) -- 打印次数
    ,due_order varchar2(2) -- 挂账顺序
    ,due_obj_key number(16,0) -- 挂账序号
    ,generate_type number(22) -- 指令生成类型
    ,ref_inst_id number(16,0) -- 
    ,is_real_acctg varchar2(2) -- 
    ,real_account_inst_id number(16,0) -- 实际核算主指令号
    ,is_unknown_price varchar2(2) -- 是否未知价格 0：已知价格 1：未知价格
    ,his_flag number(16,0) -- 历史交易表示0.普通交易（默认）1.补录 2.撤销 3.反冲 4。修改
    ,cash_acct_id varchar2(45) -- 内部资金账户
    ,his_inst_id number(16,0) -- 调账主指令号
    ,his_ref_inst_id number(16,0) -- 历史关联主指令号
    ,is_operator_checked varchar2(2) -- 是否进行过资金指令编辑金额校验 0:未校验,1:已校验
    ,orddate varchar2(15) -- 交易日
    ,condate varchar2(15) -- 确认日期
    ,is_match varchar2(2) -- 是否是清算流水durable结算指令，1：是，其他：不是
    ,settlemode varchar2(2) -- 结算类型
    ,host_market varchar2(30) -- 托管场所
    ,spv_id number(16,0) -- spv信息id
    ,process_type number(22) -- 
    ,clearing_date varchar2(15) -- 清算日
    ,acctg_estd_completed varchar2(2) -- 理论流程是否完成 0：未完成， 1 已完成
    ,acctg_real_completed varchar2(2) -- 实收流程是否完成 0：未完成， 1 已完成
    ,clearing_completed varchar2(2) -- 清算是否完成 0：未完成， 1 已完成
    ,is_period_inst varchar2(2) -- 0：非存续期指令 1：存续期指令
    ,tsk_id varchar2(45) -- 任务号
    ,approvestatus number(1,0) -- 0：需要检查差额审批；1：不需要检查差额审批；2：周期指令新建状态提交差额审批；3：周期指令新建状态提交差额审批审批通过；4：周期指令自动确认状态提交差额审批；5：周期指令自动确认状态提交差额审批审批通过；-1:差额审批拒绝；
    ,bind_inst_id number(16,0) -- 绑定id
    ,trader varchar2(30) -- 交易员
    ,xcc_limit_type number(4,0) -- 限额指令类型
    ,exh_extordid varchar2(75) -- 委托编号
    ,create_user_id varchar2(45) -- 创建人员id
    ,q_accname varchar2(180) -- 
    ,q_secu_acct_id varchar2(45) -- 
    ,q_party_zzd_acct_code varchar2(150) -- 
    ,q_p_type varchar2(30) -- 
    ,q_p_class varchar2(150) -- 
    ,q_currency varchar2(5) -- 
    ,q_i_name varchar2(383) -- 
    ,q_i_id number(22,0) -- 
    ,q_settle_amount number(31,8) -- 
    ,q_two_effective_contract varchar2(300) -- 
    ,trade_orddate varchar2(15) -- 
    ,trade_ids varchar2(300) -- 
    ,order_ids varchar2(300) -- 
    ,trade_ref_type number(22,0) -- 
    ,q_description varchar2(150) -- 
    ,is_refreshable varchar2(2) -- 
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
grant select on ${iol_schema}.ibms_ttrd_set_instruction_his to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_set_instruction_his to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_set_instruction_his to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_set_instruction_his to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_set_instruction_his is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.inst_id is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.trade_id is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.inst_type is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.inst_grp_id is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.trd_type is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.set_type is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.theory_set_date is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.real_set_date is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.h_m_type is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.h_a_type is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.h_i_code is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.party_id is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.party_name is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.order_id is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.is_theory_payment is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.bj_market is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.bj_state is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.ext_ord_id is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.exe_market is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.create_time is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.update_time is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.update_user is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.account_time is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.account_user is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.memo is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.update_user_id is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.cal_date is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.ref_cash_inst_id is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.ref_secu_inst_id is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.inst_setgrp_id is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.state is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.operator_id is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.operator_name is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.print_times is '打印次数';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.due_order is '挂账顺序';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.due_obj_key is '挂账序号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.generate_type is '指令生成类型';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.ref_inst_id is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.is_real_acctg is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.real_account_inst_id is '实际核算主指令号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.is_unknown_price is '是否未知价格 0：已知价格 1：未知价格';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.his_flag is '历史交易表示0.普通交易（默认）1.补录 2.撤销 3.反冲 4。修改';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.cash_acct_id is '内部资金账户';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.his_inst_id is '调账主指令号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.his_ref_inst_id is '历史关联主指令号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.is_operator_checked is '是否进行过资金指令编辑金额校验 0:未校验,1:已校验';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.orddate is '交易日';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.condate is '确认日期';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.is_match is '是否是清算流水durable结算指令，1：是，其他：不是';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.settlemode is '结算类型';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.host_market is '托管场所';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.spv_id is 'spv信息id';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.process_type is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.clearing_date is '清算日';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.acctg_estd_completed is '理论流程是否完成 0：未完成， 1 已完成';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.acctg_real_completed is '实收流程是否完成 0：未完成， 1 已完成';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.clearing_completed is '清算是否完成 0：未完成， 1 已完成';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.is_period_inst is '0：非存续期指令 1：存续期指令';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.tsk_id is '任务号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.approvestatus is '0：需要检查差额审批；1：不需要检查差额审批；2：周期指令新建状态提交差额审批；3：周期指令新建状态提交差额审批审批通过；4：周期指令自动确认状态提交差额审批；5：周期指令自动确认状态提交差额审批审批通过；-1:差额审批拒绝；';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.bind_inst_id is '绑定id';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.trader is '交易员';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.xcc_limit_type is '限额指令类型';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.exh_extordid is '委托编号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.create_user_id is '创建人员id';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.q_accname is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.q_secu_acct_id is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.q_party_zzd_acct_code is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.q_p_type is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.q_p_class is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.q_currency is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.q_i_name is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.q_i_id is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.q_settle_amount is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.q_two_effective_contract is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.trade_orddate is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.trade_ids is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.order_ids is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.trade_ref_type is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.q_description is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.is_refreshable is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_his.etl_timestamp is 'ETL处理时间戳';
