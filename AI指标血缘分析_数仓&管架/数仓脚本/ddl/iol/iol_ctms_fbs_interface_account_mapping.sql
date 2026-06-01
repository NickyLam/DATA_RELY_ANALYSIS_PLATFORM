/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_fbs_interface_account_mapping
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_fbs_interface_account_mapping
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_fbs_interface_account_mapping purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_fbs_interface_account_mapping(
    cusnumber varchar2(75) -- 
    ,accountingcode varchar2(75) -- 
    ,accountingdesc varchar2(384) -- 
    ,core_accountingcode varchar2(60) -- 
    ,crncy_code varchar2(15) -- 
    ,bic varchar2(384) -- 
    ,debitcredit varchar2(2) -- 
    ,ischeckvalue varchar2(2) -- 
    ,org_id varchar2(30) -- 
    ,keep_type varchar2(30) -- 
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ctms_fbs_interface_account_mapping to ${iml_schema};
grant select on ${iol_schema}.ctms_fbs_interface_account_mapping to ${icl_schema};
grant select on ${iol_schema}.ctms_fbs_interface_account_mapping to ${idl_schema};
grant select on ${iol_schema}.ctms_fbs_interface_account_mapping to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_fbs_interface_account_mapping is '外币';
comment on column ${iol_schema}.ctms_fbs_interface_account_mapping.cusnumber is '';
comment on column ${iol_schema}.ctms_fbs_interface_account_mapping.accountingcode is '';
comment on column ${iol_schema}.ctms_fbs_interface_account_mapping.accountingdesc is '';
comment on column ${iol_schema}.ctms_fbs_interface_account_mapping.core_accountingcode is '';
comment on column ${iol_schema}.ctms_fbs_interface_account_mapping.crncy_code is '';
comment on column ${iol_schema}.ctms_fbs_interface_account_mapping.bic is '';
comment on column ${iol_schema}.ctms_fbs_interface_account_mapping.debitcredit is '';
comment on column ${iol_schema}.ctms_fbs_interface_account_mapping.ischeckvalue is '';
comment on column ${iol_schema}.ctms_fbs_interface_account_mapping.org_id is '';
comment on column ${iol_schema}.ctms_fbs_interface_account_mapping.keep_type is '';
comment on column ${iol_schema}.ctms_fbs_interface_account_mapping.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_fbs_interface_account_mapping.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_fbs_interface_account_mapping.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_fbs_interface_account_mapping.etl_timestamp is 'ETL处理时间戳';
