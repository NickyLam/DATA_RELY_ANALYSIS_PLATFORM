/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_vtrd_set_instruction_secu
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_vtrd_set_instruction_secu
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_vtrd_set_instruction_secu purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_vtrd_set_instruction_secu(
    secu_inst_id number(16,0) -- 
    ,secu_inst_grp_id number(16,0) -- 
    ,inst_id number(16,0) -- 
    ,biz_type varchar2(30) -- 
    ,direction varchar2(10) -- 
    ,trade_grp_id varchar2(30) -- 
    ,secu_acct_id varchar2(30) -- 
    ,ext_secu_acct_id varchar2(30) -- 
    ,i_code varchar2(50) -- 
    ,a_type varchar2(20) -- 
    ,m_type varchar2(20) -- 
    ,currency varchar2(10) -- 
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
    ,cal_date varchar2(10) -- 
    ,set_date varchar2(10) -- 
    ,set_finish_date varchar2(10) -- 
    ,i_name varchar2(200) -- 
    ,p_class varchar2(100) -- 
    ,cost number(31,4) -- 
    ,cost_ai_his_real number(31,4) -- 
    ,zzd_acct_code varchar2(100) -- 
    ,party_zzd_acct_code varchar2(100) -- 
    ,create_time varchar2(19) -- 
    ,update_time varchar2(23) -- 
    ,update_user varchar2(100) -- 
    ,confirm_time varchar2(19) -- 
    ,confirm_user varchar2(20) -- 
    ,account_time varchar2(19) -- 
    ,account_user varchar2(20) -- 
    ,memo varchar2(500) -- 
    ,amount number(31,4) -- 
    ,close_trade_id varchar2(30) -- 
    ,blc_state number(22) -- 
    ,acctg_state number(22) -- 
    ,estd_fee number(31,4) -- 
    ,fee number(31,4) -- 
    ,opr_state number(22) -- 
    ,secu_inst_setgrp_id number(16,0) -- 
    ,his_flag number(22) -- 
    ,his_secu_inst_id number(16,0) -- 
    ,his_set_finish_date varchar2(10) -- 
    ,acctg_inst_id number(16,0) -- 
    ,cancel_flag varchar2(1) -- 
    ,volume_termcur number(31,4) -- 
    ,amount_termcur number(31,4) -- 
    ,estd_cp_termcur number(31,4) -- 
    ,real_cp_termcur number(31,4) -- 
    ,amrt_method number(22) -- 
    ,real_margin number(31,8) -- 
    ,fpml varchar2(4000) -- 
    ,is_impair varchar2(1) -- 
    ,is_theory_acct varchar2(1) -- 
    ,is_theory_blc varchar2(1) -- 
    ,cl_status number(3,0) -- 
    ,party_pset varchar2(22) -- 
    ,party_pset_country varchar2(10) -- 
    ,party_agent_code_type varchar2(1) -- 
    ,party_agent_code_dss varchar2(180) -- 
    ,party_agent_code varchar2(280) -- 
    ,party_agent_account varchar2(100) -- 
    ,party_code_type varchar2(1) -- 
    ,party_code_dss varchar2(180) -- 
    ,party_code varchar2(280) -- 
    ,party_account varchar2(100) -- 
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
grant select on ${iol_schema}.ibms_vtrd_set_instruction_secu to ${iml_schema};
grant select on ${iol_schema}.ibms_vtrd_set_instruction_secu to ${icl_schema};
grant select on ${iol_schema}.ibms_vtrd_set_instruction_secu to ${idl_schema};
grant select on ${iol_schema}.ibms_vtrd_set_instruction_secu to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_vtrd_set_instruction_secu is '券指令表(视图)';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.secu_inst_id is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.secu_inst_grp_id is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.inst_id is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.biz_type is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.direction is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.trade_grp_id is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.secu_acct_id is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.ext_secu_acct_id is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.i_code is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.a_type is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.m_type is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.currency is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.real_fee is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.estd_ai is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.received_ai is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.estd_cp is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.real_ai is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.real_cp is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.due_ai is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.due_cp is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.prft_fee is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.is_remain_due_ai is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.is_remain_due_cp is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.volume is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.freeze_volume is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.is_fixed is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.cal_date is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.set_date is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.set_finish_date is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.i_name is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.p_class is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.cost is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.cost_ai_his_real is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.zzd_acct_code is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.party_zzd_acct_code is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.create_time is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.update_time is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.update_user is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.confirm_time is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.confirm_user is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.account_time is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.account_user is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.memo is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.amount is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.close_trade_id is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.blc_state is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.acctg_state is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.estd_fee is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.fee is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.opr_state is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.secu_inst_setgrp_id is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.his_flag is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.his_secu_inst_id is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.his_set_finish_date is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.acctg_inst_id is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.cancel_flag is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.volume_termcur is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.amount_termcur is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.estd_cp_termcur is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.real_cp_termcur is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.amrt_method is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.real_margin is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.fpml is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.is_impair is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.is_theory_acct is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.is_theory_blc is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.cl_status is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.party_pset is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.party_pset_country is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.party_agent_code_type is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.party_agent_code_dss is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.party_agent_code is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.party_agent_account is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.party_code_type is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.party_code_dss is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.party_code is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.party_account is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ibms_vtrd_set_instruction_secu.etl_timestamp is 'ETL处理时间戳';
