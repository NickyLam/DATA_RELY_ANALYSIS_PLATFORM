/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rtis_sd_cfg_tag
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rtis_sd_cfg_tag
whenever sqlerror continue none;
drop table ${iol_schema}.rtis_sd_cfg_tag purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rtis_sd_cfg_tag(
    id_ varchar2(36) -- 主键
    ,code_ varchar2(100) -- 标签CODE
    ,name_ varchar2(300) -- 标签名称
    ,comment_ varchar2(1500) -- 类型说明
    ,group_id_ varchar2(100) -- 所属标签组
    ,oper_scene_id varchar2(100) -- 操作省
    ,create_by varchar2(150) -- 创建人
    ,update_by varchar2(150) -- 更新人
    ,create_time timestamp -- 创建时间
    ,update_time timestamp -- 更新时间
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.rtis_sd_cfg_tag to ${iml_schema};
grant select on ${iol_schema}.rtis_sd_cfg_tag to ${icl_schema};
grant select on ${iol_schema}.rtis_sd_cfg_tag to ${idl_schema};
grant select on ${iol_schema}.rtis_sd_cfg_tag to ${iel_schema};

-- comment
comment on table ${iol_schema}.rtis_sd_cfg_tag is '标签表';
comment on column ${iol_schema}.rtis_sd_cfg_tag.id_ is '主键';
comment on column ${iol_schema}.rtis_sd_cfg_tag.code_ is '标签CODE';
comment on column ${iol_schema}.rtis_sd_cfg_tag.name_ is '标签名称';
comment on column ${iol_schema}.rtis_sd_cfg_tag.comment_ is '类型说明';
comment on column ${iol_schema}.rtis_sd_cfg_tag.group_id_ is '所属标签组';
comment on column ${iol_schema}.rtis_sd_cfg_tag.oper_scene_id is '操作省';
comment on column ${iol_schema}.rtis_sd_cfg_tag.create_by is '创建人';
comment on column ${iol_schema}.rtis_sd_cfg_tag.update_by is '更新人';
comment on column ${iol_schema}.rtis_sd_cfg_tag.create_time is '创建时间';
comment on column ${iol_schema}.rtis_sd_cfg_tag.update_time is '更新时间';
comment on column ${iol_schema}.rtis_sd_cfg_tag.start_dt is '开始时间';
comment on column ${iol_schema}.rtis_sd_cfg_tag.end_dt is '结束时间';
comment on column ${iol_schema}.rtis_sd_cfg_tag.id_mark is '增删标志';
comment on column ${iol_schema}.rtis_sd_cfg_tag.etl_timestamp is 'ETL处理时间戳';
