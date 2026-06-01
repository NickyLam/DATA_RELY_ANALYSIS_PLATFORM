/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbclientmanager
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbclientmanager
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbclientmanager purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbclientmanager(
    client_manager varchar2(48) -- 
    ,manager_name varchar2(150) -- 
    ,branch_no varchar2(24) -- 
    ,up_manager varchar2(24) -- 
    ,manager_level varchar2(3) -- 
    ,prd_rights varchar2(75) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
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
grant select on ${iol_schema}.ifms_tbclientmanager to ${iml_schema};
grant select on ${iol_schema}.ifms_tbclientmanager to ${icl_schema};
grant select on ${iol_schema}.ifms_tbclientmanager to ${idl_schema};
grant select on ${iol_schema}.ifms_tbclientmanager to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbclientmanager is '客户经理信息表*';
comment on column ${iol_schema}.ifms_tbclientmanager.client_manager is '';
comment on column ${iol_schema}.ifms_tbclientmanager.manager_name is '';
comment on column ${iol_schema}.ifms_tbclientmanager.branch_no is '';
comment on column ${iol_schema}.ifms_tbclientmanager.up_manager is '';
comment on column ${iol_schema}.ifms_tbclientmanager.manager_level is '';
comment on column ${iol_schema}.ifms_tbclientmanager.prd_rights is '';
comment on column ${iol_schema}.ifms_tbclientmanager.reserve1 is '';
comment on column ${iol_schema}.ifms_tbclientmanager.reserve2 is '';
comment on column ${iol_schema}.ifms_tbclientmanager.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbclientmanager.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbclientmanager.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbclientmanager.etl_timestamp is 'ETL处理时间戳';
