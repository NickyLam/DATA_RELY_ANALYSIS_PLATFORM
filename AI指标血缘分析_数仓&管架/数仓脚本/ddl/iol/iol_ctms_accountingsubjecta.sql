/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_accountingsubjecta
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_accountingsubjecta
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_accountingsubjecta purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_accountingsubjecta(
    accountingsubjecta_id number(22,0) -- 
    ,aspclient_id number(22,0) -- 
    ,accountingcode varchar2(150) -- 
    ,accountingdesc varchar2(300) -- 
    ,iseditable varchar2(2) -- 
    ,accountingsubjecta_id_parent number(22,0) -- 
    ,lastmodified timestamp -- 
    ,controlfactor varchar2(15) -- 
    ,tax_rate number(22,0) -- 
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
grant select on ${iol_schema}.ctms_accountingsubjecta to ${iml_schema};
grant select on ${iol_schema}.ctms_accountingsubjecta to ${icl_schema};
grant select on ${iol_schema}.ctms_accountingsubjecta to ${idl_schema};
grant select on ${iol_schema}.ctms_accountingsubjecta to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_accountingsubjecta is '';
comment on column ${iol_schema}.ctms_accountingsubjecta.accountingsubjecta_id is '';
comment on column ${iol_schema}.ctms_accountingsubjecta.aspclient_id is '';
comment on column ${iol_schema}.ctms_accountingsubjecta.accountingcode is '';
comment on column ${iol_schema}.ctms_accountingsubjecta.accountingdesc is '';
comment on column ${iol_schema}.ctms_accountingsubjecta.iseditable is '';
comment on column ${iol_schema}.ctms_accountingsubjecta.accountingsubjecta_id_parent is '';
comment on column ${iol_schema}.ctms_accountingsubjecta.lastmodified is '';
comment on column ${iol_schema}.ctms_accountingsubjecta.controlfactor is '';
comment on column ${iol_schema}.ctms_accountingsubjecta.tax_rate is '';
comment on column ${iol_schema}.ctms_accountingsubjecta.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_accountingsubjecta.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_accountingsubjecta.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_accountingsubjecta.etl_timestamp is 'ETL处理时间戳';
