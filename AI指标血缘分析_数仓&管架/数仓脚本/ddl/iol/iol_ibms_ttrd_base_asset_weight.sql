/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_base_asset_weight
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_base_asset_weight
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_base_asset_weight purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_base_asset_weight(
    id varchar2(48) -- 主键
    ,i_code varchar2(75) -- 金融工具代码
    ,a_type varchar2(30) -- 资产大类
    ,m_type varchar2(30) -- 市场类型
    ,temp_id varchar2(48) -- 模板id
    ,proportion number(14,4) -- 占资产总额比例
    ,top_ten_pro number(14,4) -- 前10大占比
    ,remark varchar2(300) -- 备注
    ,weight number(14,4) -- 权重
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
grant select on ${iol_schema}.ibms_ttrd_base_asset_weight to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_base_asset_weight to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_base_asset_weight to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_base_asset_weight to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_base_asset_weight is '基础资产权重录入';
comment on column ${iol_schema}.ibms_ttrd_base_asset_weight.id is '主键';
comment on column ${iol_schema}.ibms_ttrd_base_asset_weight.i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_ttrd_base_asset_weight.a_type is '资产大类';
comment on column ${iol_schema}.ibms_ttrd_base_asset_weight.m_type is '市场类型';
comment on column ${iol_schema}.ibms_ttrd_base_asset_weight.temp_id is '模板id';
comment on column ${iol_schema}.ibms_ttrd_base_asset_weight.proportion is '占资产总额比例';
comment on column ${iol_schema}.ibms_ttrd_base_asset_weight.top_ten_pro is '前10大占比';
comment on column ${iol_schema}.ibms_ttrd_base_asset_weight.remark is '备注';
comment on column ${iol_schema}.ibms_ttrd_base_asset_weight.weight is '权重';
comment on column ${iol_schema}.ibms_ttrd_base_asset_weight.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_base_asset_weight.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_base_asset_weight.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_base_asset_weight.etl_timestamp is 'ETL处理时间戳';
