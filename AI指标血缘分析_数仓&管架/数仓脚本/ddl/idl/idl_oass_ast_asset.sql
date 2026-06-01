/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_ast_asset
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_ast_asset purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_ast_asset(
etl_dt date --ETL处理日期
,asset_type_cd varchar2(10) --资产类型代码
,asset_name varchar2(500) --押品名称
,create_dt date --创建日期
,update_dt date --更新日期
,id_mark varchar2(10) --增删标志
,asset_id varchar2(60) --资产编号
,lp_id varchar2(60) --法人编号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_ast_asset to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_ast_asset is '资产';
comment on column ${idl_schema}.oass_ast_asset.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.oass_ast_asset.asset_type_cd is '资产类型代码';
comment on column ${idl_schema}.oass_ast_asset.asset_name is '押品名称';
comment on column ${idl_schema}.oass_ast_asset.create_dt is '创建日期';
comment on column ${idl_schema}.oass_ast_asset.update_dt is '更新日期';
comment on column ${idl_schema}.oass_ast_asset.id_mark is '增删标志';
comment on column ${idl_schema}.oass_ast_asset.asset_id is '资产编号';
comment on column ${idl_schema}.oass_ast_asset.lp_id is '法人编号';

