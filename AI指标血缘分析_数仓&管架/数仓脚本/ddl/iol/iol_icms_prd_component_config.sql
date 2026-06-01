/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_prd_component_config
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_prd_component_config
whenever sqlerror continue none;
drop table ${iol_schema}.icms_prd_component_config purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_prd_component_config(
    componentid varchar2(64) -- 组件编号
    ,termid varchar2(64) -- 条款编号
    ,corporgid varchar2(64) -- 法人机构编号
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,inputdate date -- 登记日期
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
grant select on ${iol_schema}.icms_prd_component_config to ${iml_schema};
grant select on ${iol_schema}.icms_prd_component_config to ${icl_schema};
grant select on ${iol_schema}.icms_prd_component_config to ${idl_schema};
grant select on ${iol_schema}.icms_prd_component_config to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_prd_component_config is '产品组件配置产品组件配置';
comment on column ${iol_schema}.icms_prd_component_config.componentid is '组件编号';
comment on column ${iol_schema}.icms_prd_component_config.termid is '条款编号';
comment on column ${iol_schema}.icms_prd_component_config.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_prd_component_config.inputuserid is '登记人';
comment on column ${iol_schema}.icms_prd_component_config.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_prd_component_config.updateuserid is '更新人';
comment on column ${iol_schema}.icms_prd_component_config.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_prd_component_config.updatedate is '更新日期';
comment on column ${iol_schema}.icms_prd_component_config.inputdate is '登记日期';
comment on column ${iol_schema}.icms_prd_component_config.start_dt is '开始时间';
comment on column ${iol_schema}.icms_prd_component_config.end_dt is '结束时间';
comment on column ${iol_schema}.icms_prd_component_config.id_mark is '增删标志';
comment on column ${iol_schema}.icms_prd_component_config.etl_timestamp is 'ETL处理时间戳';
