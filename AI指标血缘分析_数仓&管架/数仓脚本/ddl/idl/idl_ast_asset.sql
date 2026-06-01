/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl ast_asset
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.ast_asset
whenever sqlerror continue none;
drop table ${idl_schema}.ast_asset purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.ast_asset(
    etl_dt date -- 数据日期   
    ,asset_id varchar2(60) -- 资产编号   
    ,lp_id varchar2(60) -- 法人编号   
    ,asset_type_cd varchar2(10) -- 资产类型代码   
    ,asset_name varchar2(500) -- 资产名称   
    ,create_dt date -- 创建日期   
    ,update_dt date -- 更新日期   
    ,id_mark varchar2(10) -- 删除标识   
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.ast_asset to ${iel_schema};

-- comment
comment on table ${idl_schema}.ast_asset is '资产';
comment on column ${idl_schema}.ast_asset.etl_dt is '数据日期';
comment on column ${idl_schema}.ast_asset.asset_id is '资产编号';
comment on column ${idl_schema}.ast_asset.lp_id is '法人编号';
comment on column ${idl_schema}.ast_asset.asset_type_cd is '资产类型代码';
comment on column ${idl_schema}.ast_asset.asset_name is '资产名称';
comment on column ${idl_schema}.ast_asset.create_dt is '创建日期';
comment on column ${idl_schema}.ast_asset.update_dt is '更新日期';
comment on column ${idl_schema}.ast_asset.id_mark is '删除标识';