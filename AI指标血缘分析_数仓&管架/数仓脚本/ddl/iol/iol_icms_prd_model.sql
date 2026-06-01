/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_prd_model
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_prd_model
whenever sqlerror continue none;
drop table ${iol_schema}.icms_prd_model purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_prd_model(
    serialno varchar2(64) -- 流水号
    ,updateorgid varchar2(64) -- 更新机构
    ,inputdate date -- 登记日期
    ,updatedate date -- 更新日期
    ,modelno varchar2(64) -- 模型编号
    ,remark varchar2(2000) -- 备注
    ,inputuserid varchar2(64) -- 登记人
    ,modelname varchar2(160) -- 模型名称
    ,updateuserid varchar2(64) -- 更新人
    ,deleteflag varchar2(12) -- 删除标识
    ,modeltype varchar2(12) -- 模型类型
    ,inputorgid varchar2(64) -- 登记机构
    ,corporgid varchar2(64) -- 法人机构编号
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
grant select on ${iol_schema}.icms_prd_model to ${iml_schema};
grant select on ${iol_schema}.icms_prd_model to ${icl_schema};
grant select on ${iol_schema}.icms_prd_model to ${idl_schema};
grant select on ${iol_schema}.icms_prd_model to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_prd_model is '产品模型产品模型';
comment on column ${iol_schema}.icms_prd_model.serialno is '流水号';
comment on column ${iol_schema}.icms_prd_model.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_prd_model.inputdate is '登记日期';
comment on column ${iol_schema}.icms_prd_model.updatedate is '更新日期';
comment on column ${iol_schema}.icms_prd_model.modelno is '模型编号';
comment on column ${iol_schema}.icms_prd_model.remark is '备注';
comment on column ${iol_schema}.icms_prd_model.inputuserid is '登记人';
comment on column ${iol_schema}.icms_prd_model.modelname is '模型名称';
comment on column ${iol_schema}.icms_prd_model.updateuserid is '更新人';
comment on column ${iol_schema}.icms_prd_model.deleteflag is '删除标识';
comment on column ${iol_schema}.icms_prd_model.modeltype is '模型类型';
comment on column ${iol_schema}.icms_prd_model.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_prd_model.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_prd_model.start_dt is '开始时间';
comment on column ${iol_schema}.icms_prd_model.end_dt is '结束时间';
comment on column ${iol_schema}.icms_prd_model.id_mark is '增删标志';
comment on column ${iol_schema}.icms_prd_model.etl_timestamp is 'ETL处理时间戳';
