/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_account_apply_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_account_apply_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_account_apply_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_account_apply_info(
    id number(22) -- 
    ,account_id number(22) -- 
    ,account_no varchar2(60) -- 
    ,sub_account_no varchar2(60) -- 
    ,txn_type varchar2(2) -- 
    ,old_account_no varchar2(60) -- 
    ,old_sub_account_no varchar2(60) -- 
    ,apply_date varchar2(12) -- 
    ,appno varchar2(45) -- 
    ,traceno varchar2(21) -- 
    ,las_upd_id number(22) -- 
    ,last_upd_time varchar2(21) -- 
    ,misc varchar2(384) -- 
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
grant select on ${iol_schema}.bdps_account_apply_info to ${iml_schema};
grant select on ${iol_schema}.bdps_account_apply_info to ${icl_schema};
grant select on ${iol_schema}.bdps_account_apply_info to ${idl_schema};
grant select on ${iol_schema}.bdps_account_apply_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_account_apply_info is '';
comment on column ${iol_schema}.bdps_account_apply_info.id is '';
comment on column ${iol_schema}.bdps_account_apply_info.account_id is '';
comment on column ${iol_schema}.bdps_account_apply_info.account_no is '';
comment on column ${iol_schema}.bdps_account_apply_info.sub_account_no is '';
comment on column ${iol_schema}.bdps_account_apply_info.txn_type is '';
comment on column ${iol_schema}.bdps_account_apply_info.old_account_no is '';
comment on column ${iol_schema}.bdps_account_apply_info.old_sub_account_no is '';
comment on column ${iol_schema}.bdps_account_apply_info.apply_date is '';
comment on column ${iol_schema}.bdps_account_apply_info.appno is '';
comment on column ${iol_schema}.bdps_account_apply_info.traceno is '';
comment on column ${iol_schema}.bdps_account_apply_info.las_upd_id is '';
comment on column ${iol_schema}.bdps_account_apply_info.last_upd_time is '';
comment on column ${iol_schema}.bdps_account_apply_info.misc is '';
comment on column ${iol_schema}.bdps_account_apply_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdps_account_apply_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdps_account_apply_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdps_account_apply_info.etl_timestamp is 'ETL处理时间戳';
