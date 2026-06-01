/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl orws_a_d_cm_currency_dt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.orws_a_d_cm_currency_dt
whenever sqlerror continue none;
drop table ${idl_schema}.orws_a_d_cm_currency_dt purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.orws_a_d_cm_currency_dt(
    curr_code varchar2(3) -- 币种编码
    ,curr_name varchar2(40) -- 币种名称
    ,curr_sign varchar2(8) -- 币种记帐符号
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp(6) -- ETL处理时间戳
    ,job_cd varchar2(10) -- 任务代码
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.orws_a_d_cm_currency_dt to ${iel_schema};

-- comment
comment on table ${idl_schema}.orws_a_d_cm_currency_dt is '币种表';
comment on column ${idl_schema}.orws_a_d_cm_currency_dt.curr_code is '币种编码';
comment on column ${idl_schema}.orws_a_d_cm_currency_dt.curr_name is '币种名称';
comment on column ${idl_schema}.orws_a_d_cm_currency_dt.curr_sign is '币种记帐符号';
comment on column ${idl_schema}.orws_a_d_cm_currency_dt.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.orws_a_d_cm_currency_dt.etl_timestamp is 'ETL处理时间戳';
comment on column ${idl_schema}.orws_a_d_cm_currency_dt.job_cd is '任务代码';