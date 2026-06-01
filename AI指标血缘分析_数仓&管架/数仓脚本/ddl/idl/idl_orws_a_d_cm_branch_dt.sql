/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl orws_a_d_cm_branch_dt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.orws_a_d_cm_branch_dt
whenever sqlerror continue none;
drop table ${idl_schema}.orws_a_d_cm_branch_dt purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.orws_a_d_cm_branch_dt(
    date_id varchar2(8) -- 会计日期
    ,branch_code varchar2(16) -- 机构编码
    ,branch_name varchar2(80) -- 机构名称
    ,short_name varchar2(80) -- 机构简称
    ,branch_tp varchar2(80) -- 机构类型
    ,branch_level integer -- 机构级别
    ,parent_id varchar2(10) -- 父级机构编码
    ,start_date varchar2(8) -- 启用日期
    ,end_date varchar2(8) -- 禁用日期
    ,city_code varchar2(40) -- 分行行号
    ,brch_level varchar2(40) -- 部门级别
    ,bak_1 varchar2(100) -- 备用字段1
    ,bak_2 varchar2(100) -- 备用字段2
    ,bak_3 varchar2(100) -- 备用字段3
    ,oth_brch_tg varchar2(20) -- 他行标志
    ,corp_code varchar2(20) -- 法人行号
    ,brch_acct_tg varchar2(1) -- 是否账务部门
    ,job_cd varchar2(10) -- 任务代码
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp(6) -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.orws_a_d_cm_branch_dt to ${iel_schema};

-- comment
comment on table ${idl_schema}.orws_a_d_cm_branch_dt is '机构表';
comment on column ${idl_schema}.orws_a_d_cm_branch_dt.date_id is '会计日期';
comment on column ${idl_schema}.orws_a_d_cm_branch_dt.branch_code is '机构编码';
comment on column ${idl_schema}.orws_a_d_cm_branch_dt.branch_name is '机构名称';
comment on column ${idl_schema}.orws_a_d_cm_branch_dt.short_name is '机构简称';
comment on column ${idl_schema}.orws_a_d_cm_branch_dt.branch_tp is '机构类型';
comment on column ${idl_schema}.orws_a_d_cm_branch_dt.branch_level is '机构级别';
comment on column ${idl_schema}.orws_a_d_cm_branch_dt.parent_id is '父级机构编码';
comment on column ${idl_schema}.orws_a_d_cm_branch_dt.start_date is '启用日期';
comment on column ${idl_schema}.orws_a_d_cm_branch_dt.end_date is '禁用日期';
comment on column ${idl_schema}.orws_a_d_cm_branch_dt.city_code is '分行行号';
comment on column ${idl_schema}.orws_a_d_cm_branch_dt.brch_level is '部门级别';
comment on column ${idl_schema}.orws_a_d_cm_branch_dt.bak_1 is '备用字段1';
comment on column ${idl_schema}.orws_a_d_cm_branch_dt.bak_2 is '备用字段2';
comment on column ${idl_schema}.orws_a_d_cm_branch_dt.bak_3 is '备用字段3';
comment on column ${idl_schema}.orws_a_d_cm_branch_dt.oth_brch_tg is '他行标志';
comment on column ${idl_schema}.orws_a_d_cm_branch_dt.corp_code is '法人行号';
comment on column ${idl_schema}.orws_a_d_cm_branch_dt.brch_acct_tg is '是否账务部门';
comment on column ${idl_schema}.orws_a_d_cm_branch_dt.job_cd is '任务代码';
comment on column ${idl_schema}.orws_a_d_cm_branch_dt.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.orws_a_d_cm_branch_dt.etl_timestamp is 'ETL处理时间戳';