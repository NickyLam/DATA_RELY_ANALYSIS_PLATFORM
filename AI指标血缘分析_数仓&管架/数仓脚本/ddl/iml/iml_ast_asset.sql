/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ast_asset
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ast_asset
whenever sqlerror continue none;
drop table ${iml_schema}.ast_asset purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_asset(
    asset_id varchar2(60) -- 资产编号
    ,lp_id varchar2(60) -- 法人编号
    ,asset_type_cd varchar2(10) -- 资产类型代码
    ,asset_name varchar2(300) -- 押品名称
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.ast_asset to ${icl_schema};
grant select on ${iml_schema}.ast_asset to ${idl_schema};
grant select on ${iml_schema}.ast_asset to ${iel_schema};

-- comment
comment on table ${iml_schema}.ast_asset is '资产';
comment on column ${iml_schema}.ast_asset.asset_id is '资产编号';
comment on column ${iml_schema}.ast_asset.lp_id is '法人编号';
comment on column ${iml_schema}.ast_asset.asset_type_cd is '资产类型代码';
comment on column ${iml_schema}.ast_asset.asset_name is '押品名称';
comment on column ${iml_schema}.ast_asset.create_dt is '创建日期';
comment on column ${iml_schema}.ast_asset.update_dt is '更新日期';
comment on column ${iml_schema}.ast_asset.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.ast_asset.id_mark is '增删标志';
comment on column ${iml_schema}.ast_asset.src_table_name is '源表名称';
comment on column ${iml_schema}.ast_asset.job_cd is '任务编码';
comment on column ${iml_schema}.ast_asset.etl_timestamp is 'ETL处理时间戳';
