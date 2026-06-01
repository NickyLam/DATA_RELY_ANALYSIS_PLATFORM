/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amls_t4a_cust_rslt_out_time
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amls_t4a_cust_rslt_out_time
whenever sqlerror continue none;
drop table ${iol_schema}.amls_t4a_cust_rslt_out_time purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t4a_cust_rslt_out_time(
    rslt_id varchar2(288) -- 评级主键
    ,cust_id varchar2(48) -- 客户号
    ,cust_type varchar2(2) -- 客户类型
    ,cust_name varchar2(768) -- 客户名称
    ,org_id varchar2(30) -- 评级任务归属网点
    ,org_id_cl varchar2(30) -- 级任务处理网点
    ,due_dt varchar2(44) -- 业务到期时间
    ,create_dt varchar2(44) -- 任务生成日期
    ,application_dt varchar2(44) -- 申领任务日期
    ,finish_dt varchar2(44) -- 任务完成时间
    ,etl_dt_ora varchar2(44) -- 批次日期
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
grant select on ${iol_schema}.amls_t4a_cust_rslt_out_time to ${iml_schema};
grant select on ${iol_schema}.amls_t4a_cust_rslt_out_time to ${icl_schema};
grant select on ${iol_schema}.amls_t4a_cust_rslt_out_time to ${idl_schema};
grant select on ${iol_schema}.amls_t4a_cust_rslt_out_time to ${iel_schema};

-- comment
comment on table ${iol_schema}.amls_t4a_cust_rslt_out_time is '评级任务未及时处理报表';
comment on column ${iol_schema}.amls_t4a_cust_rslt_out_time.rslt_id is '评级主键';
comment on column ${iol_schema}.amls_t4a_cust_rslt_out_time.cust_id is '客户号';
comment on column ${iol_schema}.amls_t4a_cust_rslt_out_time.cust_type is '客户类型';
comment on column ${iol_schema}.amls_t4a_cust_rslt_out_time.cust_name is '客户名称';
comment on column ${iol_schema}.amls_t4a_cust_rslt_out_time.org_id is '评级任务归属网点';
comment on column ${iol_schema}.amls_t4a_cust_rslt_out_time.org_id_cl is '级任务处理网点';
comment on column ${iol_schema}.amls_t4a_cust_rslt_out_time.due_dt is '业务到期时间';
comment on column ${iol_schema}.amls_t4a_cust_rslt_out_time.create_dt is '任务生成日期';
comment on column ${iol_schema}.amls_t4a_cust_rslt_out_time.application_dt is '申领任务日期';
comment on column ${iol_schema}.amls_t4a_cust_rslt_out_time.finish_dt is '任务完成时间';
comment on column ${iol_schema}.amls_t4a_cust_rslt_out_time.etl_dt_ora is '批次日期';
comment on column ${iol_schema}.amls_t4a_cust_rslt_out_time.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.amls_t4a_cust_rslt_out_time.etl_timestamp is 'ETL处理时间戳';
