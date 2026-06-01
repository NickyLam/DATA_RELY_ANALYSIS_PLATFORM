/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mcyy_dim_define
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mcyy_dim_define
whenever sqlerror continue none;
drop table ${idl_schema}.mcyy_dim_define purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mcyy_dim_define(
 dim_class      VARCHAR2(20),
  dim_no         VARCHAR2(20),
  dim_name       VARCHAR2(60),
  dim_state      VARCHAR2(2) default 1,
  dim_class_name VARCHAR2(60)
)

storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.mcyy_dim_define to ${idl_schema};

-- comment
comment on table MCYY_DIM_DEFINE
  is '维度定义表';
-- Add comments to the columns 
comment on column MCYY_DIM_DEFINE.dim_class
  is '维度种类';
comment on column MCYY_DIM_DEFINE.dim_no
  is '维度编号';
comment on column MCYY_DIM_DEFINE.dim_name
  is '维度名称';
comment on column MCYY_DIM_DEFINE.dim_state
  is '启用状态';
comment on column MCYY_DIM_DEFINE.dim_class_name
  is '维度种类名称';