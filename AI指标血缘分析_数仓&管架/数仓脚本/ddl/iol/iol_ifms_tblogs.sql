/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tblogs
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tblogs
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tblogs purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tblogs(
    log_serial varchar2(48) -- 
    ,user_id varchar2(48) -- 
    ,trans_code varchar2(48) -- 
    ,sub_trans_code varchar2(48) -- 
    ,branch_no varchar2(24) -- 
    ,op_date number(22,0) -- 
    ,op_time number(22,0) -- 
    ,ip varchar2(128) -- 
    ,summary varchar2(375) -- 
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
grant select on ${iol_schema}.ifms_tblogs to ${iml_schema};
grant select on ${iol_schema}.ifms_tblogs to ${icl_schema};
grant select on ${iol_schema}.ifms_tblogs to ${idl_schema};
grant select on ${iol_schema}.ifms_tblogs to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tblogs is '操作记录表';
comment on column ${iol_schema}.ifms_tblogs.log_serial is '';
comment on column ${iol_schema}.ifms_tblogs.user_id is '';
comment on column ${iol_schema}.ifms_tblogs.trans_code is '';
comment on column ${iol_schema}.ifms_tblogs.sub_trans_code is '';
comment on column ${iol_schema}.ifms_tblogs.branch_no is '';
comment on column ${iol_schema}.ifms_tblogs.op_date is '';
comment on column ${iol_schema}.ifms_tblogs.op_time is '';
comment on column ${iol_schema}.ifms_tblogs.ip is '';
comment on column ${iol_schema}.ifms_tblogs.summary is '';
comment on column ${iol_schema}.ifms_tblogs.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifms_tblogs.etl_timestamp is 'ETL处理时间戳';
