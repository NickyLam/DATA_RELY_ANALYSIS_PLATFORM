/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_under_asset_top_ten
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_under_asset_top_ten
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_under_asset_top_ten purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_under_asset_top_ten(
    id number(22,0) -- 主键
    ,i_code varchar2(75) -- 产品代码
    ,a_type varchar2(30) -- 资产大类
    ,m_type varchar2(30) -- 市场类型
    ,asset_code varchar2(75) -- 资产代码
    ,asset_name varchar2(750) -- 资产名称
    ,asset_type varchar2(5) -- 资产类型
    ,asset_net_per number(8,4) -- 占资产净值比例（%）
    ,map_weight number(34,2) -- 映射权重
    ,g4b_field_no varchar2(150) -- G4B栏位号
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
grant select on ${iol_schema}.ibms_ttrd_under_asset_top_ten to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_under_asset_top_ten to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_under_asset_top_ten to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_under_asset_top_ten to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_under_asset_top_ten is '底层基础资产清单（前10大）';
comment on column ${iol_schema}.ibms_ttrd_under_asset_top_ten.id is '主键';
comment on column ${iol_schema}.ibms_ttrd_under_asset_top_ten.i_code is '产品代码';
comment on column ${iol_schema}.ibms_ttrd_under_asset_top_ten.a_type is '资产大类';
comment on column ${iol_schema}.ibms_ttrd_under_asset_top_ten.m_type is '市场类型';
comment on column ${iol_schema}.ibms_ttrd_under_asset_top_ten.asset_code is '资产代码';
comment on column ${iol_schema}.ibms_ttrd_under_asset_top_ten.asset_name is '资产名称';
comment on column ${iol_schema}.ibms_ttrd_under_asset_top_ten.asset_type is '资产类型';
comment on column ${iol_schema}.ibms_ttrd_under_asset_top_ten.asset_net_per is '占资产净值比例（%）';
comment on column ${iol_schema}.ibms_ttrd_under_asset_top_ten.map_weight is '映射权重';
comment on column ${iol_schema}.ibms_ttrd_under_asset_top_ten.g4b_field_no is 'G4B栏位号';
comment on column ${iol_schema}.ibms_ttrd_under_asset_top_ten.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_under_asset_top_ten.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_under_asset_top_ten.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_under_asset_top_ten.etl_timestamp is 'ETL处理时间戳';
