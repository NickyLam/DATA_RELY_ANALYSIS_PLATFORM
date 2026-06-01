/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_asharecompanyholdshares
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_asharecompanyholdshares
whenever sqlerror continue none;
drop table ${iol_schema}.wind_asharecompanyholdshares purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_asharecompanyholdshares(
    object_id varchar2(150) -- 对象ID
    ,s_info_windcode varchar2(60) -- 
    ,ann_dt varchar2(12) -- 
    ,enddate varchar2(12) -- 
    ,s_capitaloperation_companyname varchar2(300) -- 
    ,s_capitaloperation_companyid varchar2(15) -- 
    ,s_capitaloperation_comainbus varchar2(3000) -- 
    ,relations_code varchar2(60) -- 
    ,s_capitaloperation_pct number(20,4) -- 
    ,voting_rights number(20,4) -- 
    ,s_capitaloperation_amount number(20,4) -- 
    ,operationcrncy_code varchar2(15) -- 
    ,s_capitaloperation_coregcap number(20,4) -- 
    ,capitalcrncy_code varchar2(15) -- 
    ,is_consolidate number(5,0) -- 
    ,notconsolidate_reason varchar2(1500) -- 
    ,opdate date -- 
    ,opmode varchar2(2) -- 
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
grant select on ${iol_schema}.wind_asharecompanyholdshares to ${iml_schema};
grant select on ${iol_schema}.wind_asharecompanyholdshares to ${icl_schema};
grant select on ${iol_schema}.wind_asharecompanyholdshares to ${idl_schema};
grant select on ${iol_schema}.wind_asharecompanyholdshares to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_asharecompanyholdshares is '中国a股控股参股';
comment on column ${iol_schema}.wind_asharecompanyholdshares.object_id is '对象ID';
comment on column ${iol_schema}.wind_asharecompanyholdshares.s_info_windcode is '';
comment on column ${iol_schema}.wind_asharecompanyholdshares.ann_dt is '';
comment on column ${iol_schema}.wind_asharecompanyholdshares.enddate is '';
comment on column ${iol_schema}.wind_asharecompanyholdshares.s_capitaloperation_companyname is '';
comment on column ${iol_schema}.wind_asharecompanyholdshares.s_capitaloperation_companyid is '';
comment on column ${iol_schema}.wind_asharecompanyholdshares.s_capitaloperation_comainbus is '';
comment on column ${iol_schema}.wind_asharecompanyholdshares.relations_code is '';
comment on column ${iol_schema}.wind_asharecompanyholdshares.s_capitaloperation_pct is '';
comment on column ${iol_schema}.wind_asharecompanyholdshares.voting_rights is '';
comment on column ${iol_schema}.wind_asharecompanyholdshares.s_capitaloperation_amount is '';
comment on column ${iol_schema}.wind_asharecompanyholdshares.operationcrncy_code is '';
comment on column ${iol_schema}.wind_asharecompanyholdshares.s_capitaloperation_coregcap is '';
comment on column ${iol_schema}.wind_asharecompanyholdshares.capitalcrncy_code is '';
comment on column ${iol_schema}.wind_asharecompanyholdshares.is_consolidate is '';
comment on column ${iol_schema}.wind_asharecompanyholdshares.notconsolidate_reason is '';
comment on column ${iol_schema}.wind_asharecompanyholdshares.opdate is '';
comment on column ${iol_schema}.wind_asharecompanyholdshares.opmode is '';
comment on column ${iol_schema}.wind_asharecompanyholdshares.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_asharecompanyholdshares.etl_timestamp is 'ETL处理时间戳';
