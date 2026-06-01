/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_vtrd_set_instr_for_fdei
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_vtrd_set_instr_for_fdei
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_vtrd_set_instr_for_fdei purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_vtrd_set_instr_for_fdei(
    inst_id number(16) -- 主指令ID
    ,org_id varchar2(18) -- 账务机构
    ,set_date varchar2(15) -- 结算日期
    ,core_customer_id varchar2(24) -- ECIF客户编号
    ,customer_name varchar2(300) -- 客户名称
    ,source_system varchar2(5) -- 来源系统
    ,tax_item varchar2(24) -- 税目
    ,tax_exclu_amount number(32,2) -- 不含税金额
    ,tax_rate number(32,2) -- 税率
    ,tax_amount number(32,2) -- 税额
    ,tax_inclu_amount number(32,2) -- 含税金额
    ,accounting_subject varchar2(345) -- 会计科目
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
grant select on ${iol_schema}.ibms_vtrd_set_instr_for_fdei to ${iml_schema};
grant select on ${iol_schema}.ibms_vtrd_set_instr_for_fdei to ${icl_schema};
grant select on ${iol_schema}.ibms_vtrd_set_instr_for_fdei to ${idl_schema};
grant select on ${iol_schema}.ibms_vtrd_set_instr_for_fdei to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_vtrd_set_instr_for_fdei is '同业涉票指令流水信息';
comment on column ${iol_schema}.ibms_vtrd_set_instr_for_fdei.inst_id is '主指令ID';
comment on column ${iol_schema}.ibms_vtrd_set_instr_for_fdei.org_id is '账务机构';
comment on column ${iol_schema}.ibms_vtrd_set_instr_for_fdei.set_date is '结算日期';
comment on column ${iol_schema}.ibms_vtrd_set_instr_for_fdei.core_customer_id is 'ECIF客户编号';
comment on column ${iol_schema}.ibms_vtrd_set_instr_for_fdei.customer_name is '客户名称';
comment on column ${iol_schema}.ibms_vtrd_set_instr_for_fdei.source_system is '来源系统';
comment on column ${iol_schema}.ibms_vtrd_set_instr_for_fdei.tax_item is '税目';
comment on column ${iol_schema}.ibms_vtrd_set_instr_for_fdei.tax_exclu_amount is '不含税金额';
comment on column ${iol_schema}.ibms_vtrd_set_instr_for_fdei.tax_rate is '税率';
comment on column ${iol_schema}.ibms_vtrd_set_instr_for_fdei.tax_amount is '税额';
comment on column ${iol_schema}.ibms_vtrd_set_instr_for_fdei.tax_inclu_amount is '含税金额';
comment on column ${iol_schema}.ibms_vtrd_set_instr_for_fdei.accounting_subject is '会计科目';
comment on column ${iol_schema}.ibms_vtrd_set_instr_for_fdei.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ibms_vtrd_set_instr_for_fdei.etl_timestamp is 'ETL处理时间戳';
