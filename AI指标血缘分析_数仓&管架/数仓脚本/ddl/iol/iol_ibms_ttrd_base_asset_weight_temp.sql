/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_base_asset_weight_temp
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_base_asset_weight_temp
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_base_asset_weight_temp purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_base_asset_weight_temp(
    id varchar2(5) -- 主键
    ,base_asset varchar2(150) -- 基础资产
    ,weight number(10,4) -- 权重
    ,parent_id varchar2(5) -- 父id
    ,style_level varchar2(2) -- 1-父级 2-子级
    ,check_level varchar2(2) -- 1-控制子节点小于父节点  2-控制子节点相加为100
    ,is_readonly_weight varchar2(2) -- 权重是否只读
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
grant select on ${iol_schema}.ibms_ttrd_base_asset_weight_temp to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_base_asset_weight_temp to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_base_asset_weight_temp to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_base_asset_weight_temp to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_base_asset_weight_temp is '基础资产权重录入(模板)';
comment on column ${iol_schema}.ibms_ttrd_base_asset_weight_temp.id is '主键';
comment on column ${iol_schema}.ibms_ttrd_base_asset_weight_temp.base_asset is '基础资产';
comment on column ${iol_schema}.ibms_ttrd_base_asset_weight_temp.weight is '权重';
comment on column ${iol_schema}.ibms_ttrd_base_asset_weight_temp.parent_id is '父id';
comment on column ${iol_schema}.ibms_ttrd_base_asset_weight_temp.style_level is '1-父级 2-子级';
comment on column ${iol_schema}.ibms_ttrd_base_asset_weight_temp.check_level is '1-控制子节点小于父节点  2-控制子节点相加为100';
comment on column ${iol_schema}.ibms_ttrd_base_asset_weight_temp.is_readonly_weight is '权重是否只读';
comment on column ${iol_schema}.ibms_ttrd_base_asset_weight_temp.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_base_asset_weight_temp.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_base_asset_weight_temp.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_base_asset_weight_temp.etl_timestamp is 'ETL处理时间戳';
