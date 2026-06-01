/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amss_v_all_tran_log
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amss_v_all_tran_log
whenever sqlerror continue none;
drop table ${iol_schema}.amss_v_all_tran_log purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_v_all_tran_log(
    tran_date timestamp -- 
    ,tran_org_id varchar2(96) -- 
    ,emp_code varchar2(96) -- 
    ,emp_name varchar2(192) -- 
    ,authorize_emp_code varchar2(96) -- 
    ,authorize_emp_name varchar2(192) -- 
    ,authorize_org_code varchar2(96) -- 
    ,tran_code varchar2(192) -- 
    ,tran_name varchar2(192) -- 
    ,tran_begin_time timestamp -- 
    ,tran_end_time timestamp -- 
    ,txn_no varchar2(192) -- 
    ,system_code varchar2(192) -- 
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
grant select on ${iol_schema}.amss_v_all_tran_log to ${iml_schema};
grant select on ${iol_schema}.amss_v_all_tran_log to ${icl_schema};
grant select on ${iol_schema}.amss_v_all_tran_log to ${idl_schema};
grant select on ${iol_schema}.amss_v_all_tran_log to ${iel_schema};

-- comment
comment on table ${iol_schema}.amss_v_all_tran_log is '收单及商户服务-业务量';
comment on column ${iol_schema}.amss_v_all_tran_log.tran_date is '';
comment on column ${iol_schema}.amss_v_all_tran_log.tran_org_id is '';
comment on column ${iol_schema}.amss_v_all_tran_log.emp_code is '';
comment on column ${iol_schema}.amss_v_all_tran_log.emp_name is '';
comment on column ${iol_schema}.amss_v_all_tran_log.authorize_emp_code is '';
comment on column ${iol_schema}.amss_v_all_tran_log.authorize_emp_name is '';
comment on column ${iol_schema}.amss_v_all_tran_log.authorize_org_code is '';
comment on column ${iol_schema}.amss_v_all_tran_log.tran_code is '';
comment on column ${iol_schema}.amss_v_all_tran_log.tran_name is '';
comment on column ${iol_schema}.amss_v_all_tran_log.tran_begin_time is '';
comment on column ${iol_schema}.amss_v_all_tran_log.tran_end_time is '';
comment on column ${iol_schema}.amss_v_all_tran_log.txn_no is '';
comment on column ${iol_schema}.amss_v_all_tran_log.system_code is '';
comment on column ${iol_schema}.amss_v_all_tran_log.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.amss_v_all_tran_log.etl_timestamp is 'ETL处理时间戳';
