/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_accountingsubject
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_accountingsubject
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_accountingsubject purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_accountingsubject(
    accountingsubject_id number(22,0) -- 
    ,aspclient_id number(22,0) -- 
    ,accountingcode varchar2(30) -- 
    ,accountingdesc varchar2(150) -- 
    ,iseditable varchar2(2) -- 
    ,accountingsubject_id_parent number(22,0) -- 
    ,lastmodified timestamp -- 
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
grant select on ${iol_schema}.ctms_accountingsubject to ${iml_schema};
grant select on ${iol_schema}.ctms_accountingsubject to ${icl_schema};
grant select on ${iol_schema}.ctms_accountingsubject to ${idl_schema};
grant select on ${iol_schema}.ctms_accountingsubject to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_accountingsubject is '';
comment on column ${iol_schema}.ctms_accountingsubject.accountingsubject_id is '';
comment on column ${iol_schema}.ctms_accountingsubject.aspclient_id is '';
comment on column ${iol_schema}.ctms_accountingsubject.accountingcode is '';
comment on column ${iol_schema}.ctms_accountingsubject.accountingdesc is '';
comment on column ${iol_schema}.ctms_accountingsubject.iseditable is '';
comment on column ${iol_schema}.ctms_accountingsubject.accountingsubject_id_parent is '';
comment on column ${iol_schema}.ctms_accountingsubject.lastmodified is '';
comment on column ${iol_schema}.ctms_accountingsubject.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_accountingsubject.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_accountingsubject.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_accountingsubject.etl_timestamp is 'ETL处理时间戳';
