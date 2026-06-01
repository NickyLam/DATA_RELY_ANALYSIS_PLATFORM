/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_tfnd_ext
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_tfnd_ext
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_tfnd_ext purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_tfnd_ext(
    i_code varchar2(75) -- 金融工具代码
    ,a_type varchar2(30) -- 资产类型
    ,m_type varchar2(30) -- 市场类型
    ,special_purpose_vehicle_type varchar2(75) -- 特定目的载体类型
    ,asset_product_statistics_code varchar2(75) -- 资管产品统计编码
    ,issuer_region_code varchar2(75) -- 发行人地区代码
    ,excute_mode varchar2(75) -- 运行方式
    ,special_purpose_vehicle_code varchar2(75) -- 特定目的载体代码
    ,issuer_code varchar2(75) -- 发行人代码
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
grant select on ${iol_schema}.ibms_tfnd_ext to ${iml_schema};
grant select on ${iol_schema}.ibms_tfnd_ext to ${icl_schema};
grant select on ${iol_schema}.ibms_tfnd_ext to ${idl_schema};
grant select on ${iol_schema}.ibms_tfnd_ext to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_tfnd_ext is '基金信息扩展表';
comment on column ${iol_schema}.ibms_tfnd_ext.i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_tfnd_ext.a_type is '资产类型';
comment on column ${iol_schema}.ibms_tfnd_ext.m_type is '市场类型';
comment on column ${iol_schema}.ibms_tfnd_ext.special_purpose_vehicle_type is '特定目的载体类型';
comment on column ${iol_schema}.ibms_tfnd_ext.asset_product_statistics_code is '资管产品统计编码';
comment on column ${iol_schema}.ibms_tfnd_ext.issuer_region_code is '发行人地区代码';
comment on column ${iol_schema}.ibms_tfnd_ext.excute_mode is '运行方式';
comment on column ${iol_schema}.ibms_tfnd_ext.special_purpose_vehicle_code is '特定目的载体代码';
comment on column ${iol_schema}.ibms_tfnd_ext.issuer_code is '发行人代码';
comment on column ${iol_schema}.ibms_tfnd_ext.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_tfnd_ext.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_tfnd_ext.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_tfnd_ext.etl_timestamp is 'ETL处理时间戳';
