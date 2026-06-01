/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_tag_code_config
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_tag_code_config
whenever sqlerror continue none;
drop table ${iol_schema}.icms_tag_code_config purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_tag_code_config(
    serialno varchar2(32) -- 流水号
    ,tagid varchar2(32) -- 标签编号
    ,sortno varchar2(32) -- 排序号
    ,itemno varchar2(64) -- 码值编码
    ,itemname varchar2(1000) -- 码值名称
    ,isinuse varchar2(10) -- 是否使用
    ,attribute1 varchar2(2000) -- 预留字段1
    ,attribute2 varchar2(2000) -- 预留字段2
    ,attribute3 varchar2(2000) -- 预留字段3
    ,attribute4 varchar2(2000) -- 预留字段4
    ,attribute5 varchar2(2000) -- 预留字段5
    ,attribute6 varchar2(2000) -- 预留字段6
    ,attribute7 varchar2(2000) -- 预留字段7
    ,attribute8 varchar2(2000) -- 预留字段8
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
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
grant select on ${iol_schema}.icms_tag_code_config to ${iml_schema};
grant select on ${iol_schema}.icms_tag_code_config to ${icl_schema};
grant select on ${iol_schema}.icms_tag_code_config to ${idl_schema};
grant select on ${iol_schema}.icms_tag_code_config to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_tag_code_config is '标签码值配置表';
comment on column ${iol_schema}.icms_tag_code_config.serialno is '流水号';
comment on column ${iol_schema}.icms_tag_code_config.tagid is '标签编号';
comment on column ${iol_schema}.icms_tag_code_config.sortno is '排序号';
comment on column ${iol_schema}.icms_tag_code_config.itemno is '码值编码';
comment on column ${iol_schema}.icms_tag_code_config.itemname is '码值名称';
comment on column ${iol_schema}.icms_tag_code_config.isinuse is '是否使用';
comment on column ${iol_schema}.icms_tag_code_config.attribute1 is '预留字段1';
comment on column ${iol_schema}.icms_tag_code_config.attribute2 is '预留字段2';
comment on column ${iol_schema}.icms_tag_code_config.attribute3 is '预留字段3';
comment on column ${iol_schema}.icms_tag_code_config.attribute4 is '预留字段4';
comment on column ${iol_schema}.icms_tag_code_config.attribute5 is '预留字段5';
comment on column ${iol_schema}.icms_tag_code_config.attribute6 is '预留字段6';
comment on column ${iol_schema}.icms_tag_code_config.attribute7 is '预留字段7';
comment on column ${iol_schema}.icms_tag_code_config.attribute8 is '预留字段8';
comment on column ${iol_schema}.icms_tag_code_config.inputuserid is '登记人';
comment on column ${iol_schema}.icms_tag_code_config.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_tag_code_config.inputdate is '登记日期';
comment on column ${iol_schema}.icms_tag_code_config.updateuserid is '更新人';
comment on column ${iol_schema}.icms_tag_code_config.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_tag_code_config.updatedate is '更新日期';
comment on column ${iol_schema}.icms_tag_code_config.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_tag_code_config.etl_timestamp is 'ETL处理时间戳';
