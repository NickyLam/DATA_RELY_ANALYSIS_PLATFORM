/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_prd_model_config
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_prd_model_config
whenever sqlerror continue none;
drop table ${iol_schema}.icms_prd_model_config purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_prd_model_config(
    modelno varchar2(64) -- 模型编号
    ,componentid varchar2(64) -- 组件编号
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,corporgid varchar2(64) -- 法人机构编号
    ,inputorgid varchar2(64) -- 登记机构
    ,inputuserid varchar2(64) -- 登记人
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
grant select on ${iol_schema}.icms_prd_model_config to ${iml_schema};
grant select on ${iol_schema}.icms_prd_model_config to ${icl_schema};
grant select on ${iol_schema}.icms_prd_model_config to ${idl_schema};
grant select on ${iol_schema}.icms_prd_model_config to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_prd_model_config is '产品模型配置产品模型配置';
comment on column ${iol_schema}.icms_prd_model_config.modelno is '模型编号';
comment on column ${iol_schema}.icms_prd_model_config.componentid is '组件编号';
comment on column ${iol_schema}.icms_prd_model_config.updateuserid is '更新人';
comment on column ${iol_schema}.icms_prd_model_config.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_prd_model_config.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_prd_model_config.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_prd_model_config.inputuserid is '登记人';
comment on column ${iol_schema}.icms_prd_model_config.updatedate is '更新日期';
comment on column ${iol_schema}.icms_prd_model_config.inputdate is '登记日期';
comment on column ${iol_schema}.icms_prd_model_config.start_dt is '开始时间';
comment on column ${iol_schema}.icms_prd_model_config.end_dt is '结束时间';
comment on column ${iol_schema}.icms_prd_model_config.id_mark is '增删标志';
comment on column ${iol_schema}.icms_prd_model_config.etl_timestamp is 'ETL处理时间戳';
