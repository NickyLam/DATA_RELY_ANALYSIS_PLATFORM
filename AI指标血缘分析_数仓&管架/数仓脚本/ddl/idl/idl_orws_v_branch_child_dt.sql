/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl orws_v_branch_child_dt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.orws_v_branch_child_dt
whenever sqlerror continue none;
drop table ${idl_schema}.orws_v_branch_child_dt purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.orws_v_branch_child_dt(
    etl_dt date -- ETL处理日期
    ,branch_code varchar2(16) -- 机构编码
    ,child_code varchar2(16) -- 下级机构编码
    ,branch_name varchar2(80) -- 机构名称
    ,up_org varchar2(16) -- 上级机构编码
    ,lev varchar2(1) -- 机构层级
    ,job_cd varchar2(10) -- 任务代码
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
grant select on ${idl_schema}.orws_v_branch_child_dt to ${iel_schema};

-- comment
comment on table ${idl_schema}.orws_v_branch_child_dt is '机构表';
comment on column ${idl_schema}.orws_v_branch_child_dt.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.orws_v_branch_child_dt.branch_code is '机构编码';
comment on column ${idl_schema}.orws_v_branch_child_dt.child_code is '下级机构编码';
comment on column ${idl_schema}.orws_v_branch_child_dt.branch_name is '机构名称';
comment on column ${idl_schema}.orws_v_branch_child_dt.up_org is '上级机构编码';
comment on column ${idl_schema}.orws_v_branch_child_dt.lev is '机构层级';
comment on column ${idl_schema}.orws_v_branch_child_dt.job_cd is '任务代码';
comment on column ${idl_schema}.orws_v_branch_child_dt.etl_timestamp is 'ETL处理时间戳';
