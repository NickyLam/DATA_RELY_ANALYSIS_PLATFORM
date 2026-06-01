/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nrrs_mm_modeldefine
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nrrs_mm_modeldefine
whenever sqlerror continue none;
drop table ${iol_schema}.nrrs_mm_modeldefine purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nrrs_mm_modeldefine(
    lsh number -- 模型标识
    ,modelcode varchar2(8) -- 模型编号
    ,modelname varchar2(100) -- 模型名称
    ,version varchar2(5) -- 版本号
    ,modelstate varchar2(1) -- 模型状态
    ,operatorid varchar2(10) -- 操作员
    ,createdate varchar2(10) -- 创建日期
    ,issuedate varchar2(10) -- 发布日期
    ,adjustflag varchar2(1) -- 调整逻辑标志
    ,constraintflag varchar2(1) -- 约束逻辑标志
    ,modeltype varchar2(1) -- 模型类型
    ,reportid varchar2(10) -- 报告编号
    ,adjustmodelcode varchar2(8) -- 调整模型
    ,mark varchar2(500) -- 备注
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.nrrs_mm_modeldefine to ${iml_schema};
grant select on ${iol_schema}.nrrs_mm_modeldefine to ${icl_schema};
grant select on ${iol_schema}.nrrs_mm_modeldefine to ${idl_schema};

-- comment
comment on table ${iol_schema}.nrrs_mm_modeldefine is '评级模型定义表';
comment on column ${iol_schema}.nrrs_mm_modeldefine.lsh is '模型标识';
comment on column ${iol_schema}.nrrs_mm_modeldefine.modelcode is '模型编号';
comment on column ${iol_schema}.nrrs_mm_modeldefine.modelname is '模型名称';
comment on column ${iol_schema}.nrrs_mm_modeldefine.version is '版本号';
comment on column ${iol_schema}.nrrs_mm_modeldefine.modelstate is '模型状态';
comment on column ${iol_schema}.nrrs_mm_modeldefine.operatorid is '操作员';
comment on column ${iol_schema}.nrrs_mm_modeldefine.createdate is '创建日期';
comment on column ${iol_schema}.nrrs_mm_modeldefine.issuedate is '发布日期';
comment on column ${iol_schema}.nrrs_mm_modeldefine.adjustflag is '调整逻辑标志';
comment on column ${iol_schema}.nrrs_mm_modeldefine.constraintflag is '约束逻辑标志';
comment on column ${iol_schema}.nrrs_mm_modeldefine.modeltype is '模型类型';
comment on column ${iol_schema}.nrrs_mm_modeldefine.reportid is '报告编号';
comment on column ${iol_schema}.nrrs_mm_modeldefine.adjustmodelcode is '调整模型';
comment on column ${iol_schema}.nrrs_mm_modeldefine.mark is '备注';
comment on column ${iol_schema}.nrrs_mm_modeldefine.start_dt is '开始时间';
comment on column ${iol_schema}.nrrs_mm_modeldefine.end_dt is '结束时间';
comment on column ${iol_schema}.nrrs_mm_modeldefine.id_mark is '增删标志';
comment on column ${iol_schema}.nrrs_mm_modeldefine.etl_timestamp is 'ETL处理时间戳';
