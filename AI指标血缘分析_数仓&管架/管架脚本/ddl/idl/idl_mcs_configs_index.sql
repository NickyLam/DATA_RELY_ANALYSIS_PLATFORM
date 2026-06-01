/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mcs_configs_index
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mcs_configs_index
whenever sqlerror continue none;
drop table ${idl_schema}.mcs_configs_index purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mcs_configs_index(
    echarts_code varchar2(100) -- 图表编码
    ,index_no varchar2(637) -- 指标编码
    ,index_name varchar2(637) -- 指标名称
    ,index_alias varchar2(637) -- 指标别名
    ,index_order number(5) -- 指标顺序
    ,parent_no varchar2(637) -- 指标父编码
    ,create_by varchar2(160) -- 创建人
    ,create_time date -- 创建时间
    ,update_by varchar2(160) -- 更新人
    ,update_time date -- 更新时间
    ,remark varchar2(500) -- 备注
	,index_level_no varchar2(20)

)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.mcs_configs_index to ${iel_schema};

-- comment
comment on table ${idl_schema}.mcs_configs_index is '指标配置表';
comment on column ${idl_schema}.mcs_configs_index.echarts_code is '图表编码';
comment on column ${idl_schema}.mcs_configs_index.index_no is '指标编码';
comment on column ${idl_schema}.mcs_configs_index.index_name is '指标名称';
comment on column ${idl_schema}.mcs_configs_index.index_alias is '指标别名';
comment on column ${idl_schema}.mcs_configs_index.index_order is '指标顺序';
comment on column ${idl_schema}.mcs_configs_index.parent_no is '指标父编码';
comment on column ${idl_schema}.mcs_configs_index.create_by is '创建人';
comment on column ${idl_schema}.mcs_configs_index.create_time is '创建时间';
comment on column ${idl_schema}.mcs_configs_index.update_by is '更新人';
comment on column ${idl_schema}.mcs_configs_index.update_time is '更新时间';
comment on column ${idl_schema}.mcs_configs_index.remark is '备注';
comment on column ${idl_schema}.mcs_configs_index.index_level_no is '指标层级编号';