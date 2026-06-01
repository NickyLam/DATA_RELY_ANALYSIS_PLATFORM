/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mcyy_dim_index
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mcyy_dim_index
whenever sqlerror continue none;
drop table ${idl_schema}.mcyy_dim_index purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mcyy_dim_index(
  dim_class VARCHAR2(20),
  index_no  VARCHAR2(20)
)

storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.mcyy_dim_index to ${idl_schema};

-- comment
comment on table MCYY_DIM_INDEX
  is '维度-指标关系表';
-- Add comments to the columns 
comment on column MCYY_DIM_INDEX.dim_class
  is '维度种类';
comment on column MCYY_DIM_INDEX.index_no
  is '指标编号';