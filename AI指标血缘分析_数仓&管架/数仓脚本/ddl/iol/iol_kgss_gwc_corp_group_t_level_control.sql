/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol kgss_gwc_corp_group_t_level_control
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.kgss_gwc_corp_group_t_level_control
whenever sqlerror continue none;
drop table ${iol_schema}.kgss_gwc_corp_group_t_level_control purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.kgss_gwc_corp_group_t_level_control(
    "_from" varchar2(4000) -- 起点主键
    ,"_to" varchar2(4000) -- 终点主键
    ,depth varchar2(4000) -- 深度
    ,dst_name varchar2(4000) -- 终点名称
    ,ratio varchar2(4000) -- 股东股比
    ,src_name varchar2(4000) -- 起点名称
    ,stock_indeg number(22) -- 股东入度
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
grant select on ${iol_schema}.kgss_gwc_corp_group_t_level_control to ${iml_schema};
grant select on ${iol_schema}.kgss_gwc_corp_group_t_level_control to ${icl_schema};
grant select on ${iol_schema}.kgss_gwc_corp_group_t_level_control to ${idl_schema};
grant select on ${iol_schema}.kgss_gwc_corp_group_t_level_control to ${iel_schema};

-- comment
comment on table ${iol_schema}.kgss_gwc_corp_group_t_level_control is '集团派系层次控股表单';
comment on column ${iol_schema}.kgss_gwc_corp_group_t_level_control."_from" is '起点主键';
comment on column ${iol_schema}.kgss_gwc_corp_group_t_level_control."_to" is '终点主键';
comment on column ${iol_schema}.kgss_gwc_corp_group_t_level_control.depth is '深度';
comment on column ${iol_schema}.kgss_gwc_corp_group_t_level_control.dst_name is '终点名称';
comment on column ${iol_schema}.kgss_gwc_corp_group_t_level_control.ratio is '股东股比';
comment on column ${iol_schema}.kgss_gwc_corp_group_t_level_control.src_name is '起点名称';
comment on column ${iol_schema}.kgss_gwc_corp_group_t_level_control.stock_indeg is '股东入度';
comment on column ${iol_schema}.kgss_gwc_corp_group_t_level_control.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.kgss_gwc_corp_group_t_level_control.etl_timestamp is 'ETL处理时间戳';
