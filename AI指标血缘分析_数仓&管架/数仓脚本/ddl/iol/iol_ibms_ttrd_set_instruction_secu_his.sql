/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_set_instruction_secu_his
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_set_instruction_secu_his
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_set_instruction_secu_his purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_set_instruction_secu_his(
    secu_inst_id number(16,0) -- 
    ,secu_inst_grp_id number(16,0) -- 
    ,inst_id number(16,0) -- 
    ,biz_type varchar2(45) -- 
    ,direction varchar2(15) -- 
    ,trade_grp_id varchar2(45) -- 
    ,secu_acct_id varchar2(45) -- 
    ,ext_secu_acct_id varchar2(45) -- 
    ,i_code varchar2(75) -- 
    ,a_type varchar2(30) -- 
    ,m_type varchar2(30) -- 
    ,currency varchar2(15) -- 
    ,real_fee number(31,4) -- 
    ,estd_ai number(31,4) -- 
    ,received_ai number(31,4) -- 
    ,estd_cp number(31,4) -- 
    ,real_ai number(31,4) -- 
    ,real_cp number(31,4) -- 
    ,due_ai number(38,4) -- 
    ,due_cp number(38,4) -- 
    ,prft_fee number(38,4) -- 
    ,is_remain_due_ai number(4,0) -- 
    ,is_remain_due_cp number(4,0) -- 
    ,volume number(38,4) -- 
    ,freeze_volume number(38,4) -- 
    ,is_fixed number(22) -- 
    ,cal_date varchar2(15) -- 
    ,set_date varchar2(15) -- 
    ,set_finish_date varchar2(15) -- 
    ,i_name varchar2(300) -- 
    ,p_class varchar2(150) -- 
    ,cost number(31,4) -- 
    ,cost_ai_his_real number(31,4) -- 
    ,zzd_acct_code varchar2(150) -- 
    ,party_zzd_acct_code varchar2(150) -- 
    ,create_time varchar2(29) -- 
    ,update_time varchar2(35) -- 
    ,update_user varchar2(150) -- 
    ,confirm_time varchar2(29) -- 
    ,confirm_user varchar2(30) -- 
    ,account_time varchar2(29) -- 
    ,account_user varchar2(30) -- 
    ,memo varchar2(750) -- 
    ,amount number(31,4) -- 
    ,close_trade_id varchar2(45) -- 
    ,blc_state number(22) -- 
    ,acctg_state number(22) -- 
    ,estd_fee number(31,4) -- 
    ,fee number(31,4) -- 
    ,opr_state number(22) -- 
    ,secu_inst_setgrp_id number(16,0) -- 
    ,his_flag number(22) -- 
    ,his_secu_inst_id number(16,0) -- 
    ,his_set_finish_date varchar2(15) -- 
    ,acctg_inst_id number(16,0) -- 
    ,cancel_flag varchar2(2) -- 
    ,volume_termcur number(31,4) -- 
    ,amount_termcur number(31,4) -- 
    ,estd_cp_termcur number(31,4) -- 
    ,real_cp_termcur number(31,4) -- 
    ,amrt_method number(22) -- 
    ,real_margin number(31,8) -- 
    ,fpml varchar2(4000) -- 
    ,is_impair varchar2(2) -- 
    ,is_theory_acct varchar2(2) -- 是否已做过理论核算
    ,is_theory_blc varchar2(2) -- 是否已做权责业务
    ,cl_status number(3,0) -- 占用状态-20代表冻结或者实占-30代表冻结转实占
    ,party_pset varchar2(17) -- 结算场所代码
    ,party_pset_country varchar2(3) -- 国家代码
    ,party_agent_code_type varchar2(2) -- 代理行代码类型
    ,party_agent_code_dss varchar2(270) -- 代理行代码编码集合名称
    ,party_agent_code varchar2(210) -- 代理行代码
    ,party_agent_account varchar2(75) -- 代理行账号
    ,party_code_type varchar2(2) -- 交易主体代码类型
    ,party_code_dss varchar2(270) -- 交易主体代码编码集合名称
    ,party_code varchar2(210) -- 交易主体代码
    ,party_account varchar2(75) -- 交易主体账号
    ,si_id number(16,0) -- 证券结算要素id
    ,cal_start_date varchar2(15) -- 计息开始日期
    ,ord_limit_secu_inst_id number(31,0) -- 审批单限额券指令号
    ,is_calc_tax_4_prft_trd number(22) -- 卖出时买卖损益是否拆税。枚举值：0此字段无效，向前兼容，老项目使用。1拆税，2不拆税
    ,estd_volume number(38,4) -- 预计数量
    ,estd_amount number(31,4) -- 预计面额
    ,module_type number(22) -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
    ,party_pset_name varchar2(75) -- 结算场所名称
    ,volume_geninst number(31,8) -- 生成指令时持仓数量
    ,custom_dim1 varchar2(300) -- 扩展维度1
    ,xcc_module_type number(22) -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
    ,is_editable varchar2(2) -- 前台是否可修改
    ,memo_secu varchar2(750) -- 理论实收付备注信息
    ,dtl_due_type varchar2(45) -- 明细due类型
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
grant select on ${iol_schema}.ibms_ttrd_set_instruction_secu_his to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_set_instruction_secu_his to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_set_instruction_secu_his to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_set_instruction_secu_his to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_set_instruction_secu_his is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.secu_inst_id is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.secu_inst_grp_id is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.inst_id is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.biz_type is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.direction is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.trade_grp_id is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.secu_acct_id is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.ext_secu_acct_id is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.i_code is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.a_type is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.m_type is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.currency is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.real_fee is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.estd_ai is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.received_ai is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.estd_cp is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.real_ai is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.real_cp is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.due_ai is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.due_cp is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.prft_fee is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.is_remain_due_ai is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.is_remain_due_cp is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.volume is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.freeze_volume is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.is_fixed is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.cal_date is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.set_date is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.set_finish_date is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.i_name is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.p_class is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.cost is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.cost_ai_his_real is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.zzd_acct_code is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.party_zzd_acct_code is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.create_time is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.update_time is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.update_user is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.confirm_time is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.confirm_user is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.account_time is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.account_user is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.memo is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.amount is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.close_trade_id is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.blc_state is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.acctg_state is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.estd_fee is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.fee is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.opr_state is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.secu_inst_setgrp_id is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.his_flag is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.his_secu_inst_id is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.his_set_finish_date is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.acctg_inst_id is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.cancel_flag is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.volume_termcur is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.amount_termcur is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.estd_cp_termcur is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.real_cp_termcur is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.amrt_method is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.real_margin is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.fpml is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.is_impair is '';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.is_theory_acct is '是否已做过理论核算';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.is_theory_blc is '是否已做权责业务';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.cl_status is '占用状态-20代表冻结或者实占-30代表冻结转实占';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.party_pset is '结算场所代码';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.party_pset_country is '国家代码';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.party_agent_code_type is '代理行代码类型';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.party_agent_code_dss is '代理行代码编码集合名称';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.party_agent_code is '代理行代码';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.party_agent_account is '代理行账号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.party_code_type is '交易主体代码类型';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.party_code_dss is '交易主体代码编码集合名称';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.party_code is '交易主体代码';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.party_account is '交易主体账号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.si_id is '证券结算要素id';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.cal_start_date is '计息开始日期';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.ord_limit_secu_inst_id is '审批单限额券指令号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.is_calc_tax_4_prft_trd is '卖出时买卖损益是否拆税。枚举值：0此字段无效，向前兼容，老项目使用。1拆税，2不拆税';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.estd_volume is '预计数量';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.estd_amount is '预计面额';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.module_type is '核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.party_pset_name is '结算场所名称';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.volume_geninst is '生成指令时持仓数量';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.custom_dim1 is '扩展维度1';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.xcc_module_type is '核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.is_editable is '前台是否可修改';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.memo_secu is '理论实收付备注信息';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.dtl_due_type is '明细due类型';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu_his.etl_timestamp is 'ETL处理时间戳';
