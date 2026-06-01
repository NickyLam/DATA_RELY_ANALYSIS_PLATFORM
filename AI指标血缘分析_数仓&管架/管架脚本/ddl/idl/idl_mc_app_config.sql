/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mc_app_config
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mc_app_config
whenever sqlerror continue none;
drop table ${idl_schema}.mc_app_config purge;

whenever sqlerror exit sql.sqlcode;
create table mc_app_config (
  config_name       VARCHAR2(500),
  config_type       varchar2(64),
  config_content    clob,
  create_by         VARCHAR2(160) default '',
  create_time       DATE,
  update_by         VARCHAR2(160) default '',
  update_time       DATE,
  remark            VARCHAR2(500)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.mc_app_config to ${idl_schema};

-- comment
comment on table MC_APP_CONFIG
  is '管驾APP配置表';
-- Add comments to the columns
comment on column MC_APP_CONFIG.config_name
  is '配置名称';
comment on column MC_APP_CONFIG.config_type
  is '配置类型';
comment on column MC_APP_CONFIG.config_content
  is '配置内容';
comment on column MC_APP_CONFIG.create_by
  is '创建者';
comment on column MC_APP_CONFIG.create_time
  is '创建时间';
comment on column MC_APP_CONFIG.update_by
  is '更新者';
comment on column MC_APP_CONFIG.update_time
  is '更新时间';
comment on column MC_APP_CONFIG.remark
  is '备注';

-- 新增零售信贷banner初始化配置
insert into mc_app_config (CONFIG_NAME, CONFIG_TYPE, CONFIG_CONTENT, CREATE_BY, CREATE_TIME, UPDATE_BY, UPDATE_TIME, REMARK)
values ('零售信贷首页banner图', 'credit_main_banner', '', 'admin', sysdate, 'admin', sysdate, null);
commit;