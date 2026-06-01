/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rsts_cpr_model_index_map
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rsts_cpr_model_index_map
whenever sqlerror continue none;
drop table ${iol_schema}.rsts_cpr_model_index_map purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rsts_cpr_model_index_map(
    uuid varchar2(128) -- UUID
    ,businessexposure varchar2(128) -- 业务敞口
    ,modelcode varchar2(256) -- 模型标识
    ,modelname varchar2(128) -- 模型名称
    ,indexclass varchar2(128) -- 指标分类
    ,ratename varchar2(128) -- 评级维度
    ,indexcode varchar2(256) -- 指标标识
    ,indexname varchar2(256) -- 指标名称
    ,indexexplain varchar2(512) -- 指标说明
    ,source varchar2(128) -- 数据来源
    ,grad varchar2(1500) -- 分档
    ,score varchar2(10) -- 得分
    ,weight varchar2(10) -- 权重
    ,commonlycalculationnew varchar2(512) -- 一般计算公式(新)
    ,commonlycalculationold varchar2(512) -- 一般计算公式(旧)
    ,specialcalculationnew varchar2(512) -- 特殊计算公式(新)
    ,specialcalculationold varchar2(512) -- 特殊计算公式(旧)
    ,accountfieldnew varchar2(512) -- 科目号校验字段(新)
    ,accountfieldold varchar2(512) -- 科目号校验字段(旧)
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
grant select on ${iol_schema}.rsts_cpr_model_index_map to ${iml_schema};
grant select on ${iol_schema}.rsts_cpr_model_index_map to ${icl_schema};
grant select on ${iol_schema}.rsts_cpr_model_index_map to ${idl_schema};
grant select on ${iol_schema}.rsts_cpr_model_index_map to ${iel_schema};

-- comment
comment on table ${iol_schema}.rsts_cpr_model_index_map is '模型指标映射表';
comment on column ${iol_schema}.rsts_cpr_model_index_map.uuid is 'UUID';
comment on column ${iol_schema}.rsts_cpr_model_index_map.businessexposure is '业务敞口';
comment on column ${iol_schema}.rsts_cpr_model_index_map.modelcode is '模型标识';
comment on column ${iol_schema}.rsts_cpr_model_index_map.modelname is '模型名称';
comment on column ${iol_schema}.rsts_cpr_model_index_map.indexclass is '指标分类';
comment on column ${iol_schema}.rsts_cpr_model_index_map.ratename is '评级维度';
comment on column ${iol_schema}.rsts_cpr_model_index_map.indexcode is '指标标识';
comment on column ${iol_schema}.rsts_cpr_model_index_map.indexname is '指标名称';
comment on column ${iol_schema}.rsts_cpr_model_index_map.indexexplain is '指标说明';
comment on column ${iol_schema}.rsts_cpr_model_index_map.source is '数据来源';
comment on column ${iol_schema}.rsts_cpr_model_index_map.grad is '分档';
comment on column ${iol_schema}.rsts_cpr_model_index_map.score is '得分';
comment on column ${iol_schema}.rsts_cpr_model_index_map.weight is '权重';
comment on column ${iol_schema}.rsts_cpr_model_index_map.commonlycalculationnew is '一般计算公式(新)';
comment on column ${iol_schema}.rsts_cpr_model_index_map.commonlycalculationold is '一般计算公式(旧)';
comment on column ${iol_schema}.rsts_cpr_model_index_map.specialcalculationnew is '特殊计算公式(新)';
comment on column ${iol_schema}.rsts_cpr_model_index_map.specialcalculationold is '特殊计算公式(旧)';
comment on column ${iol_schema}.rsts_cpr_model_index_map.accountfieldnew is '科目号校验字段(新)';
comment on column ${iol_schema}.rsts_cpr_model_index_map.accountfieldold is '科目号校验字段(旧)';
comment on column ${iol_schema}.rsts_cpr_model_index_map.start_dt is '开始时间';
comment on column ${iol_schema}.rsts_cpr_model_index_map.end_dt is '结束时间';
comment on column ${iol_schema}.rsts_cpr_model_index_map.id_mark is '增删标志';
comment on column ${iol_schema}.rsts_cpr_model_index_map.etl_timestamp is 'ETL处理时间戳';
