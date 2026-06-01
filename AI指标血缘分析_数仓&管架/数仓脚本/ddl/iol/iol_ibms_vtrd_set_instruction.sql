/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_vtrd_set_instruction
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_vtrd_set_instruction
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_vtrd_set_instruction purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_vtrd_set_instruction(
    inst_id number(16,0) -- 
    ,trade_id varchar2(30) -- 
    ,inst_type number(22) -- 
    ,inst_grp_id number(16,0) -- 
    ,trd_type varchar2(10) -- 
    ,set_type varchar2(20) -- 
    ,theory_set_date varchar2(10) -- 
    ,real_set_date varchar2(10) -- 
    ,h_m_type varchar2(20) -- 
    ,h_a_type varchar2(20) -- 
    ,h_i_code varchar2(50) -- 
    ,party_id number(22) -- 
    ,party_name varchar2(200) -- 
    ,order_id varchar2(50) -- 
    ,is_theory_payment varchar2(1) -- 
    ,bj_market varchar2(20) -- 
    ,bj_state number(22) -- 
    ,ext_ord_id varchar2(50) -- 
    ,exe_market varchar2(30) -- 
    ,create_time varchar2(19) -- 
    ,update_time varchar2(23) -- 
    ,update_user varchar2(100) -- 
    ,account_time varchar2(19) -- 
    ,account_user varchar2(20) -- 
    ,memo varchar2(500) -- 
    ,update_user_id varchar2(30) -- 
    ,cal_date varchar2(10) -- 
    ,ref_cash_inst_id number(16,0) -- 
    ,ref_secu_inst_id number(16,0) -- 
    ,inst_setgrp_id number(16,0) -- 
    ,state number(16,0) -- 
    ,operator_id varchar2(30) -- 
    ,operator_name varchar2(100) -- 
    ,print_times number(22) -- 
    ,due_order varchar2(1) -- 
    ,due_obj_key number(16,0) -- 
    ,generate_type number(22) -- 
    ,ref_inst_id number(16,0) -- 
    ,is_real_acctg varchar2(1) -- 
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
grant select on ${iol_schema}.ibms_vtrd_set_instruction to ${iml_schema};
grant select on ${iol_schema}.ibms_vtrd_set_instruction to ${icl_schema};
grant select on ${iol_schema}.ibms_vtrd_set_instruction to ${idl_schema};
grant select on ${iol_schema}.ibms_vtrd_set_instruction to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_vtrd_set_instruction is '主指令表(视图)';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.inst_id is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.trade_id is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.inst_type is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.inst_grp_id is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.trd_type is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.set_type is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.theory_set_date is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.real_set_date is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.h_m_type is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.h_a_type is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.h_i_code is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.party_id is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.party_name is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.order_id is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.is_theory_payment is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.bj_market is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.bj_state is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.ext_ord_id is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.exe_market is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.create_time is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.update_time is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.update_user is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.account_time is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.account_user is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.memo is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.update_user_id is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.cal_date is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.ref_cash_inst_id is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.ref_secu_inst_id is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.inst_setgrp_id is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.state is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.operator_id is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.operator_name is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.print_times is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.due_order is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.due_obj_key is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.generate_type is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.ref_inst_id is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.is_real_acctg is '';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ibms_vtrd_set_instruction.etl_timestamp is 'ETL处理时间戳';
