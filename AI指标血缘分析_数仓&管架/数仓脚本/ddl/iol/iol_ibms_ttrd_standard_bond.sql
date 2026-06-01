/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_standard_bond
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_standard_bond
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_standard_bond purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_standard_bond(
    sysordid number(16) -- 交易序号
    ,i_code varchar2(75) -- 金融工具代码
    ,a_type varchar2(30) -- 
    ,m_type varchar2(30) -- 
    ,i_name varchar2(338) -- 金融工具名称
    ,mtr_date varchar2(15) -- 到期日
    ,secu_acc_id varchar2(45) -- 内部证券账户
    ,secu_acc_name varchar2(338) -- 内部证券账户名称
    ,ext_secu_acc_id varchar2(45) -- 
    ,amount number(31,4) -- 券面总额
    ,discount number(31,4) -- 折价率
    ,disamount number(31,4) -- 折价金额
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
grant select on ${iol_schema}.ibms_ttrd_standard_bond to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_standard_bond to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_standard_bond to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_standard_bond to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_standard_bond is '标准券管理拓展表';
comment on column ${iol_schema}.ibms_ttrd_standard_bond.sysordid is '交易序号';
comment on column ${iol_schema}.ibms_ttrd_standard_bond.i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_ttrd_standard_bond.a_type is '';
comment on column ${iol_schema}.ibms_ttrd_standard_bond.m_type is '';
comment on column ${iol_schema}.ibms_ttrd_standard_bond.i_name is '金融工具名称';
comment on column ${iol_schema}.ibms_ttrd_standard_bond.mtr_date is '到期日';
comment on column ${iol_schema}.ibms_ttrd_standard_bond.secu_acc_id is '内部证券账户';
comment on column ${iol_schema}.ibms_ttrd_standard_bond.secu_acc_name is '内部证券账户名称';
comment on column ${iol_schema}.ibms_ttrd_standard_bond.ext_secu_acc_id is '';
comment on column ${iol_schema}.ibms_ttrd_standard_bond.amount is '券面总额';
comment on column ${iol_schema}.ibms_ttrd_standard_bond.discount is '折价率';
comment on column ${iol_schema}.ibms_ttrd_standard_bond.disamount is '折价金额';
comment on column ${iol_schema}.ibms_ttrd_standard_bond.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ibms_ttrd_standard_bond.etl_timestamp is 'ETL处理时间戳';
