/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tbms_t_yqt_operation_log
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tbms_t_yqt_operation_log
whenever sqlerror continue none;
drop table ${iol_schema}.tbms_t_yqt_operation_log purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbms_t_yqt_operation_log(
    id number(20,0) -- 序号
    ,cpyid number(20,0) -- 企业id
    ,uaid number(20,0) -- 操作人员id
    ,name varchar2(50) -- 应用名字
    ,opertype number(4,0) -- 操作类型
    ,sys_ctime date -- 创建时间
    ,sys_utime date -- 更新时间
    ,sys_valid number(4,0) -- 是否有效
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
grant select on ${iol_schema}.tbms_t_yqt_operation_log to ${iml_schema};
grant select on ${iol_schema}.tbms_t_yqt_operation_log to ${icl_schema};
grant select on ${iol_schema}.tbms_t_yqt_operation_log to ${idl_schema};
grant select on ${iol_schema}.tbms_t_yqt_operation_log to ${iel_schema};

-- comment
comment on table ${iol_schema}.tbms_t_yqt_operation_log is '操作日志';
comment on column ${iol_schema}.tbms_t_yqt_operation_log.id is '序号';
comment on column ${iol_schema}.tbms_t_yqt_operation_log.cpyid is '企业id';
comment on column ${iol_schema}.tbms_t_yqt_operation_log.uaid is '操作人员id';
comment on column ${iol_schema}.tbms_t_yqt_operation_log.name is '应用名字';
comment on column ${iol_schema}.tbms_t_yqt_operation_log.opertype is '操作类型';
comment on column ${iol_schema}.tbms_t_yqt_operation_log.sys_ctime is '创建时间';
comment on column ${iol_schema}.tbms_t_yqt_operation_log.sys_utime is '更新时间';
comment on column ${iol_schema}.tbms_t_yqt_operation_log.sys_valid is '是否有效';
comment on column ${iol_schema}.tbms_t_yqt_operation_log.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tbms_t_yqt_operation_log.etl_timestamp is 'ETL处理时间戳';
