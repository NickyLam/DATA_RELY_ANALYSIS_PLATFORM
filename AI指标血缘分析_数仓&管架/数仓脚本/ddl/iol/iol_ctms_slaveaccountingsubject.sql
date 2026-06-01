/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_slaveaccountingsubject
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_slaveaccountingsubject
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_slaveaccountingsubject purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_slaveaccountingsubject(
    slaveaccountingsubject_id number(22,0) -- 
    ,accountingsubject_id number(22,0) -- 
    ,market varchar2(30) -- 
    ,bondtype varchar2(75) -- 
    ,ratetype varchar2(15) -- 
    ,priority number(22,0) -- 
    ,isincountry varchar2(2) -- 
    ,isbank varchar2(2) -- 
    ,isinsystem varchar2(2) -- 
    ,accountingcode varchar2(150) -- 
    ,accountingdesc varchar2(300) -- 
    ,isdefault varchar2(2) -- 
    ,lastmodified timestamp -- 
    ,aspclient_id number(22,0) -- 
    ,sqlcondition varchar2(3000) -- 
    ,shellprocess varchar2(600) -- 
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
grant select on ${iol_schema}.ctms_slaveaccountingsubject to ${iml_schema};
grant select on ${iol_schema}.ctms_slaveaccountingsubject to ${icl_schema};
grant select on ${iol_schema}.ctms_slaveaccountingsubject to ${idl_schema};
grant select on ${iol_schema}.ctms_slaveaccountingsubject to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_slaveaccountingsubject is '';
comment on column ${iol_schema}.ctms_slaveaccountingsubject.slaveaccountingsubject_id is '';
comment on column ${iol_schema}.ctms_slaveaccountingsubject.accountingsubject_id is '';
comment on column ${iol_schema}.ctms_slaveaccountingsubject.market is '';
comment on column ${iol_schema}.ctms_slaveaccountingsubject.bondtype is '';
comment on column ${iol_schema}.ctms_slaveaccountingsubject.ratetype is '';
comment on column ${iol_schema}.ctms_slaveaccountingsubject.priority is '';
comment on column ${iol_schema}.ctms_slaveaccountingsubject.isincountry is '';
comment on column ${iol_schema}.ctms_slaveaccountingsubject.isbank is '';
comment on column ${iol_schema}.ctms_slaveaccountingsubject.isinsystem is '';
comment on column ${iol_schema}.ctms_slaveaccountingsubject.accountingcode is '';
comment on column ${iol_schema}.ctms_slaveaccountingsubject.accountingdesc is '';
comment on column ${iol_schema}.ctms_slaveaccountingsubject.isdefault is '';
comment on column ${iol_schema}.ctms_slaveaccountingsubject.lastmodified is '';
comment on column ${iol_schema}.ctms_slaveaccountingsubject.aspclient_id is '';
comment on column ${iol_schema}.ctms_slaveaccountingsubject.sqlcondition is '';
comment on column ${iol_schema}.ctms_slaveaccountingsubject.shellprocess is '';
comment on column ${iol_schema}.ctms_slaveaccountingsubject.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_slaveaccountingsubject.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_slaveaccountingsubject.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_slaveaccountingsubject.etl_timestamp is 'ETL处理时间戳';
