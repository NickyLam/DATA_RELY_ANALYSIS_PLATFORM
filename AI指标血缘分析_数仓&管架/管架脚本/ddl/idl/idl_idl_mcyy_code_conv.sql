/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mcyy_code_conv
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mcyy_code_conv
whenever sqlerror continue none;
drop table ${idl_schema}.mcyy_code_conv purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mcyy_code_conv(
 source_code VARCHAR2(200),
  source_name VARCHAR2(200),
  mcyy_code   VARCHAR2(200),
  mcyy_name   VARCHAR2(200),
  code_type   VARCHAR2(200)
)

storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.mcyy_code_conv to ${idl_schema};

-- comment
comment on table mcyy_code_conv
  is '营运管驾码值转换表';
-- Add comments to the columns 
comment on column mcyy_code_conv.source_code
  is '源系统码值';
comment on column mcyy_code_conv.source_name
  is '源系统代码名称';
comment on column mcyy_code_conv.mcyy_code
  is '营运码值';
comment on column mcyy_code_conv.mcyy_name
  is '营运代码名称';
comment on column mcyy_code_conv.code_type
  is '码值类型';