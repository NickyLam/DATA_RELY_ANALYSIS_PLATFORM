/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_und_asset_01
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_und_asset_01
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_und_asset_01 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_und_asset_01(
    id varchar2(75) -- 主键
    ,und_asset_type varchar2(150) -- 资产证券化业务标识
    ,short_rating varchar2(150) -- 短期评级
    ,long_rating varchar2(150) -- 长期评级
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
grant select on ${iol_schema}.ibms_ttrd_und_asset_01 to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_und_asset_01 to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_und_asset_01 to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_und_asset_01 to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_und_asset_01 is '底层资产扩展表';
comment on column ${iol_schema}.ibms_ttrd_und_asset_01.id is '主键';
comment on column ${iol_schema}.ibms_ttrd_und_asset_01.und_asset_type is '资产证券化业务标识';
comment on column ${iol_schema}.ibms_ttrd_und_asset_01.short_rating is '短期评级';
comment on column ${iol_schema}.ibms_ttrd_und_asset_01.long_rating is '长期评级';
comment on column ${iol_schema}.ibms_ttrd_und_asset_01.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_und_asset_01.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_und_asset_01.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_und_asset_01.etl_timestamp is 'ETL处理时间戳';
