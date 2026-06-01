/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_interface_account_mapping
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_interface_account_mapping
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_interface_account_mapping purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_interface_account_mapping(
    aspclient_id varchar2(384) -- 
    ,accountingcode varchar2(384) -- 
    ,core_accountingcode varchar2(384) -- 
    ,debitcredit varchar2(3) -- 
    ,ischeckbalance varchar2(3) -- 
    ,ischeckvalue varchar2(3) -- 
    ,currency_code varchar2(15) -- 
    ,org_id varchar2(30) -- 
    ,keep_type varchar2(30) -- 
    ,departmentid varchar2(30) -- 业务部门编号
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
grant select on ${iol_schema}.ctms_tbs_interface_account_mapping to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_interface_account_mapping to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_interface_account_mapping to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_interface_account_mapping to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_interface_account_mapping is '本币';
comment on column ${iol_schema}.ctms_tbs_interface_account_mapping.aspclient_id is '';
comment on column ${iol_schema}.ctms_tbs_interface_account_mapping.accountingcode is '';
comment on column ${iol_schema}.ctms_tbs_interface_account_mapping.core_accountingcode is '';
comment on column ${iol_schema}.ctms_tbs_interface_account_mapping.debitcredit is '';
comment on column ${iol_schema}.ctms_tbs_interface_account_mapping.ischeckbalance is '';
comment on column ${iol_schema}.ctms_tbs_interface_account_mapping.ischeckvalue is '';
comment on column ${iol_schema}.ctms_tbs_interface_account_mapping.currency_code is '';
comment on column ${iol_schema}.ctms_tbs_interface_account_mapping.org_id is '';
comment on column ${iol_schema}.ctms_tbs_interface_account_mapping.keep_type is '';
comment on column ${iol_schema}.ctms_tbs_interface_account_mapping.departmentid is '业务部门编号';
comment on column ${iol_schema}.ctms_tbs_interface_account_mapping.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ctms_tbs_interface_account_mapping.etl_timestamp is 'ETL处理时间戳';
