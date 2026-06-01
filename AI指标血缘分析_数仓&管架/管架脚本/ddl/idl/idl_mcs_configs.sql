/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mcs_configs
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mcs_configs
whenever sqlerror continue none;
drop table ${idl_schema}.mcs_configs purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mcs_configs(
    echarts_code varchar2(100) -- 图表编码,主键
    ,name varchar2(100) -- 图表名称
    ,title varchar2(200) -- 图表标题
    ,create_by varchar2(160) -- 创建人
    ,create_time date -- 创建时间
    ,update_by varchar2(160) -- 更新人
    ,update_time date -- 更新时间
    ,remark varchar2(500) -- 备注

)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.mcs_configs to ${iel_schema};

-- comment
comment on table ${idl_schema}.mcs_configs is '图表配置表';
comment on column ${idl_schema}.mcs_configs.echarts_code is '图表编码,主键';
comment on column ${idl_schema}.mcs_configs.name is '图表名称';
comment on column ${idl_schema}.mcs_configs.title is '图表标题';
comment on column ${idl_schema}.mcs_configs.create_by is '创建人';
comment on column ${idl_schema}.mcs_configs.create_time is '创建时间';
comment on column ${idl_schema}.mcs_configs.update_by is '更新人';
comment on column ${idl_schema}.mcs_configs.update_time is '更新时间';
comment on column ${idl_schema}.mcs_configs.remark is '备注';